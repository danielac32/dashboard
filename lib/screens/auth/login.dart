import 'package:core_system/screens/auth/widget/background.dart';
import 'package:core_system/screens/auth/widget/button_submit.dart';
import 'package:core_system/screens/auth/widget/text_field_email.dart';
import 'package:core_system/screens/auth/widget/text_field_password.dart';
import 'package:core_system/screens/auth/widget/text_title.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/login_controller.dart';


class LoginScreen extends StatelessWidget {
  // Instancia del controlador
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
     // backgroundColor: colors.primary,
      body: Stack(
        children: [
          // Imagen de fondo
          BackGround(background: 'assets/fondo.jpeg'),
          // Contenido encima del fondo
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: 350,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextTitle(),
                    const SizedBox(height: 20),

                    TextFieldEmail(controller: loginController.emailController),
                    const SizedBox(height: 16),

                    Obx(() =>TextFieldPassword(
                      controller: loginController.passwordController,
                      isPasswordVisible: loginController.isPasswordVisible.value,
                      togglePasswordVisibility: loginController.togglePasswordVisibility,
                    )),
                    const SizedBox(height: 24),

                    SizedBox(
                        height: 30,
                        width: 170,
                        child: ButtonSubmit(onPressed: loginController.submitForm)
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget para el título


// Widget para el campo de correo electrónico


// Widget para el campo de contraseña


// Widget para el botón de envío


