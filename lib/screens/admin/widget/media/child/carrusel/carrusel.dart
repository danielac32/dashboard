import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'dart:io';

class CarruselController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var selectedImages = <XFile>[].obs;
  var uploadedImages = <String>[].obs;

  Future<void> pickImages() async {
    final List<XFile>? pickedImages = await _picker.pickMultiImage();
    if (pickedImages != null && pickedImages.isNotEmpty) {
      selectedImages.addAll(pickedImages);
    }
  }

  void removeSelectedImage(int index) {
    selectedImages.removeAt(index);
  }

  Future<void> uploadImages() async {
    // Aquí iría tu lógica para subir las imágenes al servidor
    // Ejemplo simulando la subida:
    for (var image in selectedImages) {
      await Future.delayed(Duration(milliseconds: 300)); // Simular tiempo de subida
      uploadedImages.add('Imagen subida: ${image.name}');
    }
    selectedImages.clear();
    Get.snackbar('Éxito', 'Imágenes subidas correctamente');
  }

  // Método para cargar las imágenes ya existentes del servidor
  void loadUploadedImages() {
    // Simulando carga de imágenes existentes
    uploadedImages.value = [
      'imagen1.jpg',
      'imagen2.png',
      'banner_principal.webp'
    ];
  }

  @override
  void onInit() {
    super.onInit();
    loadUploadedImages();
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                   // const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: controller.pickImages,
                        icon: const Icon(Icons.add_a_photo),
                        label: const Text('Seleccionar imágenes'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(() => controller.selectedImages.isEmpty
                        ? const Center(child: Text('No hay imágenes seleccionadas'))
                        : SizedBox(
                      height: 200,
                      child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: controller.selectedImages.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            alignment: Alignment.topRight,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(controller.selectedImages[index].path),
                                  fit: BoxFit.cover,
                                  width: 150,
                                  height: 150,
                                ),
                              ),
                              IconButton(
                                onPressed: () => controller.removeSelectedImage(index),
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    ),
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
            ),

            const SizedBox(height: 20),

            // Sección 2: Imágenes ya subidas
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Imágenes en el Carrusel',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(() => controller.uploadedImages.isEmpty
                        ? const Center(child: Text('No hay imágenes en el carrusel'))
                        : SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: controller.uploadedImages.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.image),
                            title: Text(controller.uploadedImages[index]),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                controller.uploadedImages.removeAt(index);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}