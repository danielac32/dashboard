
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/enum.dart';
import '../../../infrastructure/entities/user.dart';


class LoginController extends GetxController {
  // Controladores de texto para los campos
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Estado para mostrar/ocultar la contraseña
  var isPasswordVisible = false.obs;

  // Método para alternar la visibilidad de la contraseña
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Validación del correo electrónico
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa tu email';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Ingresa un email válido';
    }
    return null;
  }

  // Validación de la contraseña
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa tu contraseña';
    } else if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  // Método para registrar un nuevo usuario
  void register() {
    Get.toNamed("/register"); // Navega a la pantalla de registro
  }

  // Método para enviar el formulario
  void submitForm() {
    final emailError = validateEmail(emailController.text);
    final passwordError = validatePassword(passwordController.text);

    if(emailError != null){
      //Get.snackbar('Error', '${emailError}');
      //return;
    }
    if(passwordError != null){
      //Get.snackbar('Error', '${passwordError}');
      //return;
    }

    final newUser = UserEntity(
        id: 1,
        name: 'Astrid Quintero',
        email: 'danielquinteroac32@gmail.com',
        password: 'ac32mqn42',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        department: Directorate.direccionGeneralTecnologiaInformacion.label,
        profileImage: 'https://example.com/profile.jpg',
        position: Position.COORDINADOR.label,//'Coordinador',
        rol: Role.ADMIN.label
    );

    Get.toNamed("/admin", arguments: newUser); // Navega al dashboard de admin
  }
}
