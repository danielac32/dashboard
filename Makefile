
#python3 -m http.server 8080
#npm install -g http-server
#http-server http-server -p 3000
#cloudflared tunnel --url http://0.0.0.0:8080
#<script src="https://cdn.sheetjs.com/xlsx-0.19.3/package/dist/xlsx.full.min.js"></script>
# <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
#  <meta http-equiv="Pragma" content="no-cache">
#  <meta http-equiv="Expires" content="0">

EMULATOR_NAME = Pixel_4_API_33
ANDROID_API = 33
SYSTEM_IMAGE = system-images;android-$(ANDROID_API);google_apis;x86_64
DEVICE_TYPE = pixel_4
APK_PATH = build/app/outputs/flutter-apk/app-release.apk
FLUTTER_CMD = flutter



run:
	flutter run -d linux

compile:
		flutter build web
runweb:
		@echo "Building Flutter web app..."
		flutter build web
		@echo "\nStarting HTTP server on port 8080..."
		cd build/web &&  http-server -p 8050 --rewrite "/.* /index.html" -c-1 #cd build/web && python3 -m http.server 8080


#http-server -p 8080 --rewrite "/.* /index.html"
start:
	  cd build/web &&  python3 -m http.server 8050 & \
	  cloudflared tunnel --url http://0.0.0.0:8050



################################################################################

help:
	@echo "Makefile para gestión de emulador Android y APK Flutter"
	@echo "Comandos disponibles:"
	@echo "  make installemulator - Instala y crea el emulador Android"
	@echo "  make runemulator     - Ejecuta el emulador"
	@echo "  make installapk      - Instala el APK en el emulador"
	@echo "  make runapk          - Ejecuta la app instalada"
	@echo "  make cleanemulator   - Detiene y elimina el emulador"
	@echo "  make all             - Ejecuta installemulator + runemulator + installapk + runapk"

installemulator:
	@echo "Instalando imagen del sistema Android $(ANDROID_API)..."
	sdkmanager "$(SYSTEM_IMAGE)"
	@echo "Creando emulador $(EMULATOR_NAME)..."
	avdmanager create avd -n $(EMULATOR_NAME) -k "$(SYSTEM_IMAGE)" -d $(DEVICE_TYPE) --force
	@echo "Emulador $(EMULATOR_NAME) creado exitosamente!"

runemulator:
	@echo "Iniciando emulador $(EMULATOR_NAME)..."
	emulator -avd $(EMULATOR_NAME) -no-audio -no-boot-anim -no-snapshot &
	@echo "Esperando a que el emulador esté listo..."
	sleep 30
	adb wait-for-device
	@echo "Emulador listo!"

installapk:
	@echo "Compilando APK de release..."
	$(FLUTTER_CMD) build apk --release
	@echo "Instalando APK en el emulador..."
	adb install -r $(APK_PATH)
	@echo "APK instalado exitosamente!"

runapk:
	@echo "Ejecutando aplicación en el emulador..."
	@# Extraer el nombre del paquete del APK
	$(eval PACKAGE_NAME := $(shell aapt dump badging $(APK_PATH) 2>/dev/null | grep package | awk '{print $$2}' | cut -d"'" -f2))
	@if [ -z "$(PACKAGE_NAME)" ]; then \
		echo "No se pudo obtener el nombre del paquete, compilando APK..."; \
		$(FLUTTER_CMD) build apk --release; \
		$(eval PACKAGE_NAME := $(shell aapt dump badging $(APK_PATH) 2>/dev/null | grep package | awk '{print $$2}' | cut -d"'" -f2)); \
	fi
	@if [ -n "$(PACKAGE_NAME)" ]; then \
		echo "Iniciando aplicación: $(PACKAGE_NAME)"; \
		adb shell am start -n $(PACKAGE_NAME)/.MainActivity; \
	else \
		echo "Error: No se pudo determinar el nombre del paquete"; \
		exit 1; \
	fi

cleanemulator:
	@echo "Deteniendo emulador y limpiando..."
	@-adb emu kill
	@-avdmanager delete avd -n $(EMULATOR_NAME)
	@echo "Emulador $(EMULATOR_NAME) eliminado"

listemulators:
	@echo "Emuladores disponibles:"
	emulator -list-avds

listdevices:
	@echo "Dispositivos conectados:"
	adb devices -l

buildapk:
	@echo "Compilando APK..."
	$(FLUTTER_CMD) build apk --release
	@echo "APK compilado en: $(APK_PATH)"

uninstallapk:
	@echo "Desinstalando aplicación..."
	@$(eval PACKAGE_NAME := $(shell aapt dump badging $(APK_PATH) 2>/dev/null | grep package | awk '{print $$2}' | cut -d"'" -f2))
	@if [ -n "$(PACKAGE_NAME)" ]; then \
		adb uninstall $(PACKAGE_NAME); \
		echo "Aplicación $(PACKAGE_NAME) desinstalada"; \
	else \
		echo "No se pudo determinar el nombre del paquete para desinstalar"; \
	fi

all: installemulator runemulator installapk runapk

# Verificar estado del emulador
status:
	@echo "Estado del emulador:"
	@adb get-state 2>/dev/null || echo "No hay emulador/dispositivo conectado"

# Reiniciar emulador
restartemulator: cleanemulator runemulator