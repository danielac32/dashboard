


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;

import '../controller/resumen_controller.dart';




class ResumenView1 extends StatelessWidget {
  const ResumenView1({
    super.key,
    required this.controller,
    required this.theme,
  });

  final ResumenController controller;
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