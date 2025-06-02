import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb, Uint8List, defaultTargetPlatform;

import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';


import '../../../service/media_service.dart';
import '../interface/carrusel_responde.dart';


class CarruselController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var selectedImages = <XFile>[].obs;
  var uploadedImages = <String>[].obs;
  var imageBytesList = <Uint8List>[].obs;// esto se usa para la previsualizacion

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
    imageBytesList.removeAt(index);
    /* if (kIsWeb && imageBytesList.isNotEmpty && index < imageBytesList.length) {
      imageBytesList.removeAt(index);
    }*/
  }

  Future<void> uploadImages() async {
    if (selectedImages.isEmpty) {
      Get.snackbar("Advertencia", "No hay imágenes seleccionadas");
      return;
    }
    for (var image in selectedImages) {
      try {
        // Leer los bytes de la imagen
        final fileBytes = await image.readAsBytes();
        // Codificar a base64
        final base64Image = base64Encode(fileBytes);
        // Preparar cuerpo del request
        final body = {
          'file': {
            'filename': image.name,
            'content': base64Image,
          }
        };
        // Usamos el método postImage del MediaService
        final response = await MediaService.postImage("media/carrusel/upload", body: body);
        final uploadResponse = CarruselUploadResponse.fromJson(response);
        //uploadedImages.add(uploadResponse.path);
        print(uploadResponse.path);
      } catch (e) {
        print("Error subiendo imagen: $e");
        Get.snackbar("Error", "Fallo al subir: ${image.name}");
      }
    }
    await loadUploadedImages();
    selectedImages.clear();
    //if (kIsWeb)
    imageBytesList.clear();

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

  Future<void> remove(String index)async {
    try {
      final apiResponse = await MediaService.delete("media/carrusel/",queryParams: {
        "name": index
      });
      final carruselResponse = CarruselDeleteResponse.fromJson(apiResponse);
      print(carruselResponse.success);
      await loadUploadedImages();
    } catch (e) {
      print('Error al cargar imágenes: $e');
      Get.snackbar("Error", "No se pudo eliminar la imagen");
    }
  }
}