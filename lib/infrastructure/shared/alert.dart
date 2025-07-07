


import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
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
*/

class SnackbarAlert {
  static void show({
    String title = 'Título',
    String message = 'Mensaje',
    int durationSeconds = 3,
    Color backgroundColor = Colors.grey,
    Color textColor = Colors.white,
    IconData? icon,
    SnackPosition position = SnackPosition.TOP,
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: textColor,
      duration: Duration(seconds: durationSeconds),
      icon: icon != null ? Icon(icon, color: textColor) : null,
      snackPosition: position,
      borderRadius: 8,
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 3),
        )
      ],
    );
  }

  // Métodos predefinidos para tipos comunes

  static void success({
    String title = '¡Éxito!',
    String message = 'Operación completada correctamente',
    int durationSeconds = 1,
  }) {
    show(
      title: title,
      message: message,
      durationSeconds: durationSeconds,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      icon: Icons.check_circle,
    );
  }

  static void error({
    String title = 'Error',
    String message = 'Ha ocurrido un error',
    int durationSeconds = 4,
  }) {
    show(
      title: title,
      message: message,
      durationSeconds: durationSeconds,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      icon: Icons.error,
    );
  }

  static void warning({
    String title = 'Advertencia',
    String message = 'Esto es una advertencia',
    int durationSeconds = 3,
  }) {
    show(
      title: title,
      message: message,
      durationSeconds: durationSeconds,
      backgroundColor: Colors.orange,
      textColor: Colors.white,
      icon: Icons.warning,
    );
  }

  static void info({
    String title = 'Información',
    String message = 'Este es un mensaje informativo',
    int durationSeconds = 3,
  }) {
    show(
      title: title,
      message: message,
      durationSeconds: durationSeconds,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      icon: Icons.info,
    );
  }
}

/*

SnackbarAlert.show(
  title: "Bienvenido",
  message: "Has iniciado sesión correctamente.",
  backgroundColor: Colors.teal,
  textColor: Colors.white,
  icon: Icons.person,
  durationSeconds: 2,
);


SnackbarAlert.success(message: "Datos guardados");

SnackbarAlert.error(title: "Oops!", message: "Algo salió mal", durationSeconds: 5);

SnackbarAlert.warning();

SnackbarAlert.info();
 */