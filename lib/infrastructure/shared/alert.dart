


import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackbarAlert{
  SnackbarAlert();

static Success({
  String title = '¡Éxito!',
  String message = 'Operación completada correctamente',
  int durationSeconds = 3,
}) {
  Get.snackbar(
    title,
    message,
    backgroundColor: Colors.green,
    colorText: Colors.white,
    duration: Duration(seconds: durationSeconds),
    icon: const Icon(Icons.check_circle, color: Colors.white),
    snackPosition: SnackPosition.TOP,
  );
}

}

