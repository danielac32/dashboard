

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:io'; // Para trabajar con File
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:cross_file/cross_file.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:convert'; // Para codificar/decodificar JSON

/*
class CarouselController extends GetxController {
  // Índice actual del carrusel
  var currentIndex = 0.obs;
  var cover = true.obs;

  // Lista de imágenes locales
  final List<String> items = [
    "assets/1.jpeg",
    "assets/2.jpeg",
    "assets/3.jpeg",
    "assets/4.jpeg",
    "assets/5.jpeg",
  ];



  // Método para cambiar el índice actual
  void changeIndex(int index) {
    currentIndex.value = index;
  }
  void transform(){
    cover.value ^=true ;
  }

  void addImage(String path) {
    items.add(path);
    update();
  }

}*/

class CarouselController extends GetxController {
  // Índice actual del carrusel
  var currentIndex = 0.obs;
  var cover = true.obs;

  // Lista de rutas de imágenes locales
  final List<String> items = [];

  // Bandera para verificar si el controlador está inicializado
  var isInitialized = false.obs;

  // Método de inicialización segura
  Future<void> initialize() async {
    try {
      await loadSavedImages();
      isInitialized.value = true; // Marca como inicializado
    } catch (e) {
      print('Error al inicializar el controlador: $e');
      isInitialized.value = false; // Marca como no inicializado en caso de error
    }
  }

  // Método para cargar imágenes guardadas previamente
  Future<void> loadSavedImages() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/carousel_images.json');

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> savedPaths = json.decode(jsonString);
        items.clear();
        items.addAll(savedPaths.map((path) => path.toString()));
      }
    } catch (e) {
      print('Error al cargar imágenes guardadas: $e');
    }
  }

  // Método para guardar las rutas de las imágenes
  Future<void> saveImages() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/carousel_images.json');
      await file.writeAsString(json.encode(items));
    } catch (e) {
      print('Error al guardar imágenes: $e');
    }
  }

  // Método para agregar una nueva imagen
  void addImage(String path) {
    items.add(path); // Agrega la nueva imagen a la lista
    saveImages(); // Guarda las rutas actualizadas
    update(); // Notifica cambios a los widgets observables
  }

  // Método para cambiar el índice actual
  void changeIndex(int index) {
    currentIndex.value = index;
  }

  // Método para alternar entre BoxFit.cover y BoxFit.contain
  void transform() {
    cover.value ^= true; // Alterna entre true y false
  }
}


class CarouselView extends StatelessWidget {
  final CarouselController controller = Get.put(CarouselController());

  @override
  Widget build(BuildContext context) {
    // Obtener el tamaño de la pantalla
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor:colors.onSecondary,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              onPressed: () async {
                // Usa FilePicker para seleccionar una imagen
                final result = await FilePicker.platform.pickFiles(type: FileType.image);

                if (result != null && result.files.isNotEmpty) {
                  final filePath = result.files.single.path!;
                  controller.addImage(filePath); // Agrega la imagen al controlador
                }
              },
              child: Text('Subir nuevas imágenes'),
            ),
          ),

          // Espaciador para separar el carrusel de la parte superior
          SizedBox(height: 20),
          // Carrusel (limitado al 80% del ancho de la pantalla)
          Center(
            child: Container(
              width: screenWidth * 0.7, // 80% del ancho de la pantalla
              height: screenHeight * 0.3, // 30% del alto de la pantalla
              child: Obx(() {
                return CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 16 / 9,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    initialPage: 2,
                    autoPlay: true,
                  ),
                  items: controller.items.map((item) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Stack(
                          children: <Widget>[
                            // Imagen local con ajuste dinámico
                            Image.asset(
                              item,
                              fit: controller.cover.value ? BoxFit.cover : BoxFit.contain, // Alternar entre cover y contain
                              width: double.infinity,
                            ),
                            // Capa con degradado y botón
                            Positioned(
                              bottom: 0.0,
                              left: 0.0,
                              right: 0.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color.fromARGB(100, 0, 0, 0),
                                      Color.fromARGB(0, 0, 0, 0)
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Botón con ícono en la esquina inferior izquierda
                                    IconButton(
                                      icon: Icon(Icons.transform, color: Colors.white, size: 24),
                                      onPressed: () {
                                        // Alternar el estado de cover
                                        print(controller.cover.value);
                                        controller.transform();
                                      },
                                    ),
                                    // Espacio vacío para centrar el botón a la izquierda
                                    SizedBox(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
            ),
          ),

          // Cuadro inferior (70% del alto de la pantalla)
          Content(screenWidth: screenWidth),
        ],
      ),
    );
  }
}

class Content extends StatelessWidget {
  const Content({
    super.key,
    required this.screenWidth,
  });

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: screenWidth * 0.9, // 90% del ancho de la pantalla
        margin: EdgeInsets.all(20.0), // Margen reducido
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor, // Color del cuadro basado en el tema
          borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Sombra ligera
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Contenido aquí',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              //color: Theme.of(context).textTheme.bodyText1!.color, // Color de texto basado en el tema
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CarouselView(),
    );
  }
}
