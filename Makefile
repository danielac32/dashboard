
#python3 -m http.server 8080
#npm install -g http-server
#http-server http-server -p 3000
#cloudflared tunnel --url http://0.0.0.0:8080
#<script src="https://cdn.sheetjs.com/xlsx-0.19.3/package/dist/xlsx.full.min.js"></script>
# <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
#  <meta http-equiv="Pragma" content="no-cache">
#  <meta http-equiv="Expires" content="0">
run:
	flutter run -d linux

compile:
		flutter build web
runweb:
		@echo "Building Flutter web app..."
		flutter build web
		@echo "\nStarting HTTP server on port 8080..."
		cd build/web &&  http-server -p 8080 --rewrite "/.* /index.html" -c-1 #cd build/web && python3 -m http.server 8080

start:
	  cd build/web &&  python3 -m http.server 8080 #http-server -p 8080 --rewrite "/.* /index.html"