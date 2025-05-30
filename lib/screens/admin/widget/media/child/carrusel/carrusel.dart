import 'dart:convert';

import 'package:core_system/screens/admin/widget/media/child/carrusel/interface/carrusel_responde.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../../service/media_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List, defaultTargetPlatform;




class CarruselController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var selectedImages = <XFile>[].obs;
  var uploadedImages = <String>[].obs;
  var imageBytesList = <Uint8List>[].obs;

  Future<void> pickImages() async {
    try {
      if (kIsWeb) {
        final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
        if (file != null) {
          Uint8List bytes = await file.readAsBytes();
          selectedImages.add(file);
          imageBytesList.add(bytes);
        }
      } else {
        final List<XFile> files = await _picker.pickMultiImage();
        if (files.isNotEmpty) {
          for (var f in files) {
            Uint8List bytes = await f.readAsBytes();
            selectedImages.add(f);
            imageBytesList.add(bytes);
          }
        }
      }

      update(); // O usa GetX reactividad automática
    } catch (e) {
      print("Error al seleccionar imagen: $e");
      Get.snackbar("Error", "No se pudo cargar la imagen");
    }
  }
  void removeSelectedImage(int index) {
    selectedImages.removeAt(index);
    if (kIsWeb && imageBytesList.isNotEmpty && index < imageBytesList.length) {
      imageBytesList.removeAt(index);
    }
  }

  Future<void> uploadImages() async {
    uploadedImages.clear();

    // Simulación de subida
    for (var image in selectedImages) {
      await Future.delayed(const Duration(milliseconds: 300));
      uploadedImages.add('Imagen subida: ${image.name}');
    }

    selectedImages.clear();
    if (kIsWeb) imageBytesList.clear();

    Get.snackbar('Éxito', 'Imágenes subidas correctamente');
  }

  Future<void> loadUploadedImages() async {
    try {
      final apiResponse = await MediaService.get("media/carrusel/list");
      final carruselResponse = CarruselListResponse.fromJson(apiResponse);
      uploadedImages.assignAll(carruselResponse.list ?? []);
    } catch (e) {
      print('Error al cargar imágenes: $e');
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadUploadedImages();
  }
}

class CarruselContent extends StatelessWidget {
  final CarruselController controller = Get.put(CarruselController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),

            // Sección 1: Subir nuevas imágenes
            CarruselView1(controller: controller, theme: theme),

            const SizedBox(height: 20),
            CarruselPreview(controller: controller,),
          ],
        ),
      ),
    );
  }
}

class CarruselView1 extends StatelessWidget {
  const CarruselView1({
    super.key,
    required this.controller,
    required this.theme,
  });

  final CarruselController controller;
  final ThemeData theme;




  @override
  Widget build(BuildContext context) {
    // Creamos el ScrollController fuera del build para reutilizarlo
    final ScrollController scrollController = ScrollController();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await controller.pickImages();
                  } catch (e) {
                    Get.snackbar("Error", "No se pueden seleccionar múltiples imágenes en esta plataforma");
                  }
                },
                icon: const Icon(Icons.add_a_photo),
                label: const Text('Seleccionar imágenes'),
              ),
            ),
            const SizedBox(height: 10),
            Obx(() {
              if (controller.selectedImages.isEmpty) {
                return const Center(child: Text('No hay imágenes seleccionadas'));
              }

              return Column(
                children: [
                  SizedBox(
                    height: 180,
                    child: ListView.builder(
                      controller: scrollController, // 👈 Asignamos el controlador
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.selectedImages.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: Builder(
                                    builder: (context) {
                                      if (kIsWeb && index < controller.imageBytesList.length) {
                                        try {
                                          return Image.memory(
                                            controller.imageBytesList[index],
                                            fit: BoxFit.cover,
                                            gaplessPlayback: true,
                                            errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.error_outline)),
                                          );
                                        } catch (e) {
                                          return const Center(child: Icon(Icons.image, color: Colors.grey));
                                        }
                                      } else if (!kIsWeb && index < controller.selectedImages.length) {
                                        try {
                                          return Image.file(
                                            File(controller.selectedImages[index].path),
                                            fit: BoxFit.cover,
                                          );
                                        } catch (e) {
                                          return const Center(child: Icon(Icons.image, color: Colors.grey));
                                        }
                                      } else {
                                        return const Center(child: CircularProgressIndicator());
                                      }
                                    },
                                  ),
                                ),
                              ),
                              /*ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: Builder(
                                    builder: (context) {

                                      print('Índice: $index');
                                      print('Es Web: ${kIsWeb}');
                                      print('imageBase64List length: ${controller.imageBase64List.length}');
                                      print('selectedImages length: ${controller.selectedImages.length}');
                                      // Validación para evitar errores de índice
                                      if (kIsWeb) {
                                        if (controller.imageBase64List.isNotEmpty && index < controller.imageBase64List.length) {
                                          try {
                                            final bytes = base64Decode(controller.imageBase64List[index]);
                                            return Image.memory(
                                              bytes,
                                              fit: BoxFit.cover,
                                              gaplessPlayback: true,
                                              errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.error_outline)),
                                            );
                                          } catch (e) {
                                            return const Center(child: Icon(Icons.error_outline, color: Colors.red));
                                          }
                                        } else {
                                          return const Center(child: Icon(Icons.image, color: Colors.grey));
                                        }
                                      } else {
                                        if (controller.selectedImages.isNotEmpty && index < controller.selectedImages.length) {
                                          final path = controller.selectedImages[index].path;
                                          return Image.file(
                                            File(path),
                                            fit: BoxFit.cover,
                                          );
                                        } else {
                                          return const Center(child: Icon(Icons.image, color: Colors.grey));
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),*/
                              IconButton(
                                onPressed: () => controller.removeSelectedImage(index),
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                        onPressed: () {
                          double offset = scrollController.offset - 200;
                          if (offset < 0) offset = 0;
                          scrollController.animateTo(
                            offset,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        onPressed: () {
                          double offset = scrollController.offset + 200;
                          if (offset > scrollController.position.maxScrollExtent) {
                            offset = scrollController.position.maxScrollExtent;
                          }
                          scrollController.animateTo(
                            offset,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              );
            }),
            const SizedBox(height: 10),
            Obx(() => controller.selectedImages.isNotEmpty
                ? ElevatedButton.icon(
              onPressed: controller.uploadImages,
              icon: const Icon(Icons.upload),
              label: const Text('Subir imágenes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
              ),
            )
                : const SizedBox()),
          ],
        ),
      ),
    );
  }
}



class CarruselPreview extends StatelessWidget {
  final CarruselController controller;
  final ScrollController _scrollController = ScrollController();

  CarruselPreview({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Imágenes en el Carrusel',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Obx(() {
              if (controller.uploadedImages.isEmpty) {
                return const Center(child: Text('No hay imágenes en el carrusel'));
              }

              return Column(
                children: [
                  SizedBox(
                    height: 500,
                    child: ListView.separated(
                      controller: _scrollController, // 👈 Controlador asignado
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.uploadedImages.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final String imageName = controller.uploadedImages[index];
                        final String imageUrl = "http://localhost:8085/media/carrusel/?name=$imageName";

                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                imageUrl,
                                width: 500,
                                height: 500,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error_outline, color: Colors.red);
                                },
                              ),
                            ),
                            Positioned(
                              top: -4,
                              right: -4,
                              child: GestureDetector(
                                onTap: () => controller.uploadedImages.removeAt(index),
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.delete,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          _scrollController.animateTo(
                            _scrollController.offset - 200,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          _scrollController.animateTo(
                            _scrollController.offset + 200,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}