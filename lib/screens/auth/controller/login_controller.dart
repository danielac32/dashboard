
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../core/app/routes.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/enum.dart';
import '../../../infrastructure/shared/storage.dart';
import '../service/user_service.dart';


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
  Future<void> submitForm() async {
    final emailError = validateEmail(emailController.text);
    final passwordError = validatePassword(passwordController.text);

    if(emailError != null){
      Get.snackbar('Error', '${emailError}');
      return;
    }
    if(passwordError != null){
      Get.snackbar('Error', '${passwordError}');
      return;
    }

    try {
      final apiResponse = await AuthService.login(emailController.text, passwordController.text);
      await LocalStorage.saveToken(apiResponse.token!);
      await LocalStorage.saveUser(apiResponse.user!);
      print(apiResponse.token);

      //definir que layout mostrar
      final userRole = apiResponse.user!.role;
      final userDepartment = apiResponse.user!.department;

      if(userRole==Role.SUPER_ADMIN.label){
        Get.offNamed(AppRoutes.dashboardSuperAdmin, arguments: { 'user': apiResponse.user});// este layout aunque dice admin es el superadmin global
      }else{
        switch (userDepartment) {
          case AppStrings.dgTecnologiaInformacion:
            Get.offAllNamed(AppRoutes.dashboardTecnologia, arguments: {'role': userRole});
            break;
          case AppStrings.dgAdministracion:
            Get.offAllNamed(AppRoutes.dashboardAdministracion, arguments: {'role': userRole});
            break;
          case AppStrings.dgEgreso:
            Get.offAllNamed(AppRoutes.dashboardEgreso, arguments: {'role': userRole});
            break;
          case AppStrings.dgIngreso:
            Get.offAllNamed(AppRoutes.dashboardIngreso, arguments: {'role': userRole});
            break;
          case AppStrings.dgCuentaUnica:
            Get.offAllNamed(AppRoutes.dashboardCuentaUnica, arguments: {'role': userRole});
            break;
          case AppStrings.dgPlanificacionAnalisisFinanciero:
            Get.offAllNamed(AppRoutes.dashboardPlanificacionAnalisisFinanciero, arguments: {'role': userRole});
            break;
         /* case AppStrings.dgRecaudacionIngreso:
            Get.offAllNamed(AppRoutes.dashboardRecaudacionIngreso, arguments: {'role': userRole});
            break;
          */
          case AppStrings.dgRecursosHumanos:
            Get.offAllNamed(AppRoutes.dashboardRecursosHumanos, arguments: {'role': userRole});
            break;
          case AppStrings.dgInversionesYValores:
            Get.offAllNamed(AppRoutes.dashboardInversionesValores, arguments: {'role': userRole});
            break;
          case AppStrings.dgConsultoriaJuridica:
            Get.offAllNamed(AppRoutes.dashboardConsultoriaJuridica, arguments: {'role': userRole});
            break;
          default:
            Get.snackbar('Error', 'Dirección no reconocida');
            return;
        }
      }

    } catch (e) {
      Get.snackbar('error al iniciar sesion','');
      print(e);
      return;
    }
  }
}
