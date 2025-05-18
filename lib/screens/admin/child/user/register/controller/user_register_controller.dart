import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../infrastructure/entities/user_response.dart';
import '../../../../../../infrastructure/shared/alert.dart';
import '../../../../../../infrastructure/shared/interface/cargo_response.dart';
import '../../../../../../infrastructure/shared/interface/direccion_response.dart';
import '../../../../../../infrastructure/shared/interface/role_response.dart';
import '../../../../constat/enum_screen.dart';
import '../../../../controller/dashboard_menu.dart';
import '../../user_list/controller/user_list_controller.dart';
import '../service/register_service.dart';

class UserRegisterController extends GetxController {
  // Variables observables para los campos del formulario
  final name = ''.obs;
  final email = ''.obs;
  final isActive = true.obs;
  final rol = ''.obs;
  final department = ''.obs;
  final position = ''.obs;
  final profileImage = Rxn<File>();

  // Listas de opciones cargadas desde API
  final roles = <Roles>[].obs;
  final departments = <Direcciones>[].obs;
  final positions = <Cargos>[].obs;

  // Estados de carga
  final isLoading = true.obs;
  final errorLoadingData = false.obs;





  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final direccionController = TextEditingController();
  final rolController = TextEditingController();
  final cargoController = TextEditingController();


  /*var opcionDir = Rx<String?>(null);
  var opcionCargo = Rx<String?>(null);
  var opcionRol = Rx<String?>(null);

  void cambiarRol(String? nuevaSeleccion) {
    opcionRol.value = nuevaSeleccion;
  }
  // Método para actualizar la selección
  void cambiarDir(String? nuevaSeleccion) {
    opcionDir.value = nuevaSeleccion;
  }
  void cambiarCargo(String? nuevaSeleccion) {
    opcionCargo.value = nuevaSeleccion;
  }*/

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadInitialData();
  }

  // Método para cargar datos iniciales
  Future<void> loadInitialData() async {
    try {
      isLoading.value = true;
      errorLoadingData.value = false;

      // Cargar direcciones
      final apiGetDirecciones = await RegisterService.get("direccion");
      final resDir = DireccionResponse.fromJson(apiGetDirecciones);
      departments.assignAll(resDir.direcciones as Iterable<Direcciones>);

      // Cargar roles
      final apiGetRoles = await RegisterService.get("role");
      final resRole = RoleResponse.fromJson(apiGetRoles);
      roles.assignAll(resRole.roles as Iterable<Roles>);

      // Cargar cargos
      final apiGetCargos = await RegisterService.get("cargo");
      final resCargo = CargoResponse.fromJson(apiGetCargos);
      positions.assignAll(resCargo.cargos as Iterable<Cargos>);

      isLoading.value = false;

    } catch (e) {
      isLoading.value = false;
      errorLoadingData.value = true;
      print('Error al cargar datos iniciales: $e');
    }
  }


  String? validateName(String? value) {
    // Verifica si el valor es null o está vacío
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, ingresa tu nombre';
    }

    // Verifica si el texto tiene al menos un número mínimo de caracteres (ejemplo: 5)
    if (value.trim().length < 5) {
      return 'El nombre debe tener al menos 5 caracteres';
    }

    // Verifica si el texto contiene exactamente dos palabras
    final words = value.trim().split(RegExp(r'\s+')); // Divide el texto por espacios
    if (words.length != 2) {
      return 'El nombre debe contener exactamente dos palabras';
    }

    // Si pasa todas las validaciones, retorna null (sin errores)
    return null;
  }

  // Validación del formulario
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa tu email';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Ingresa un email válido';
    }
    return null;
  }

  String? validateDropdown(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Por favor selecciona un $fieldName';
    }
    return null;
  }


  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, ingresa tu contraseña';
    } else if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }



  @override
  void onClose() {
    super.onClose();
  }


  void clearForm() {
    nameController.clear();
    emailController.clear();

    rol.value = ''; // Asumiendo que 'rol' es un RxString
    department.value = ''; // Asumiendo que 'department' es un RxString
    position.value = ''; // Asumiendo que 'position' es un RxString

    isActive.value = true; // Valor por defecto si lo deseas

    profileImage.value = null; // Si profileImage es un File o similar

    // Opcional: si tienes otros campos reactivos, también los reinicias aquí
  }


  // Método para seleccionar imagen
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  Future<void> createUser() async {
    final emailError = validateEmail(emailController.text);
    final nameError = validateName(nameController.text);
    final roleError=validateDropdown(rol.value, "Role");
    final direccionError = validateDropdown(department.value, "Direccion");
    final cargoError = validateDropdown(position.value, "Cargo");

    if(nameError != null){
      Get.snackbar('Error', '${nameError}',
        backgroundColor: Colors.orange[800],
        colorText: Colors.white,
        icon: Icon(Icons.person_off, color: Colors.white),
      );
      return;
    }

    if(emailError != null){
      Get.snackbar('Error', '${emailError}',
        backgroundColor: Colors.orange[800],
        colorText: Colors.white,
        icon: Icon(Icons.person_off, color: Colors.white),
      );
      return;
    }

    if(roleError != null){
      Get.snackbar('Error', '${roleError}',
        backgroundColor: Colors.orange[800],
        colorText: Colors.white,
        icon: Icon(Icons.person_off, color: Colors.white),
      );
      return;
    }
    if(direccionError != null){
      Get.snackbar('Error', '${direccionError}',
        backgroundColor: Colors.orange[800],
        colorText: Colors.white,
        icon: Icon(Icons.person_off, color: Colors.white),
      );
      return;
    }
    if(cargoError != null){
      Get.snackbar('Error', '${cargoError}',
        backgroundColor: Colors.orange[800],
        colorText: Colors.white,
        icon: Icon(Icons.person_off, color: Colors.white),
      );
      return;
    }

    final User user=User(
        name: nameController.text,
        email: emailController.text,
        isActive: isActive.value,
        role: rol.value.isNotEmpty ? rol.value : null,
        department: department.value.isNotEmpty ? department.value : null,
        position: position.value.isNotEmpty ? position.value : null,
        profileImage: profileImage.value?.path,
        password: '123456'
    );
    print(user.toJson());

    try {
      final response = await RegisterService.post("auth/register", user.toJson());
      SnackbarAlert.Success(title: "OK",durationSeconds: 2,message:"Usuario Registrado" );
      clearForm();
     // await Get.find<MenuControllerScreen>().currentIndex(1);
      await Get.find<UserListController>().refreshUsers();//refrescar lista de usuarios --- consultar la api de nuevo y crear la lista y la paginacion
      Get.find<MenuControllerScreen>().goToScreen(AppScreen.userList);
      return response;
    } catch (e) {
      throw Exception('Error de red: $e');
    }
  }

  // Método para reintentar carga de datos
  Future<void> retryLoadingData() async {
    await loadInitialData();
  }
}
