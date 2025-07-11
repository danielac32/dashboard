
import 'dart:io';
import 'package:core_system/screens/admin/child/user/user_list/interface/user_permission.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../core/utils/enum.dart';
import '../../../../../../infrastructure/entities/update_response.dart';
import '../../../../../../infrastructure/entities/user_response.dart';
import '../../../../../../infrastructure/shared/alert.dart';
import '../../../../../../infrastructure/shared/interface/cargo_response.dart';
import '../../../../../../infrastructure/shared/interface/direccion_response.dart';
import '../../../../../../infrastructure/shared/interface/role_response.dart';
import '../interface/user_list_response.dart';
import '../service/user_list_service.dart';



enum FilterStatus { all, active, inactive }


class UserListController extends GetxController {
  var users = <User>[].obs;
  var filteredUsers = <User>[].obs;
  var searchQuery = ''.obs;
  var currentPage = 1.obs;
  final int pageSize = 8; // Número de elementos por página


  final RxMap<int, List<Permission>> userPermissions = <int, List<Permission>>{}.obs;
  final isLoadingPermissions = <int, bool>{}.obs;

  final isLoading = false.obs;
  final filterStatus = FilterStatus.all.obs;

  Future<void> toggleFilter() async {
    try {
      isLoading.value = true;

      // Cambiar el estado del filtro
      filterStatus.value = FilterStatus.values[
      (filterStatus.value.index + 1) % FilterStatus.values.length
      ];

      // Hacer la petición a la API según el filtro

      Map<String, dynamic> params = {};

      switch(filterStatus.value) {
        case FilterStatus.active:
          params['status'] = 'active';
          break;
        case FilterStatus.inactive:
          params['status'] = 'inactive';
          break;
        case FilterStatus.all:
          params['status'] = 'all';
          break;
      }

      final apiResponse = await UserListService.getFilterUser('user','filter', queryParams: params);
      final res = UserListResponse.fromJson(apiResponse);

      users.value = res.users ?? [];
      filteredUsers.value = users;
      currentPage.value = 1;

      print('Usuarios filtrados cargados: ${users.length}');

    } catch (e) {
      print('Error al filtrar usuarios: $e');
      users.value = [];
      //Get.snackbar('Error', 'No se pudo aplicar el filtro');
    } finally {
      isLoading.value = false;
    }
  }


  String get filterText {
    switch(filterStatus.value) {
      case FilterStatus.all: return 'Todos';
      case FilterStatus.active: return 'Activos';
      case FilterStatus.inactive: return 'Inactivos';
    }
  }

  Color get filterColor {
    switch(filterStatus.value) {
      case FilterStatus.all: return Colors.blue;
      case FilterStatus.active: return Colors.green;
      case FilterStatus.inactive: return Colors.red;
    }
  }

  String get filterTooltip {
    switch(filterStatus.value) {
      case FilterStatus.all: return 'Mostrando todos - Click para filtrar activos';
      case FilterStatus.active: return 'Mostrando activos - Click para filtrar inactivos';
      case FilterStatus.inactive: return 'Mostrando inactivos - Click para mostrar todos';
    }
  }

  Future<void> loadPermissionsForUser(int userId) async {
    try {
      isLoadingPermissions[userId] = true;
      final permissions = await UserListService.getUserPermissions(
          'user',
          'permissions',
          userId: userId
      );
      final resPermissions = ResponsePermission.fromJson(permissions);
      userPermissions[userId] = resPermissions.permissions as List<Permission>;
    } catch (e) {
      //Get.snackbar('Error', 'No se pudieron cargar los permisos para el usuario $userId');
    } finally {
      isLoadingPermissions[userId] = false;
    }
  }




  @override
  Future<void> onInit() async {
    super.onInit();

    // Obtener datos de la API a través de  UserListService
    try {
      final apiResponse = await UserListService.get("user");
      final res = UserListResponse.fromJson(apiResponse);

      // Asignar los usuarios obtenidos de la API
      users.value = res.users ?? [];
      filteredUsers.value = users;

      print('Usuarios cargados: ${users.length}');
    } catch (e) {
      print('Error al cargar usuarios: $e');
      users.value = [];
      filteredUsers.value = [];
    }
  }

  void search(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredUsers.value = users;
    } else {
      filteredUsers.value = users
          .where((user) => user.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    currentPage.value = 1; // Reiniciamos la página al buscar
  }

  List<User> getPaginatedUsers() {
    if (filteredUsers.isEmpty) return [];

    final start = (currentPage.value - 1) * pageSize;
    final end = start + pageSize;
    return filteredUsers.sublist(
      start,
      end > filteredUsers.length ? filteredUsers.length : end,
    );
  }

  void nextPage() {
    if (currentPage.value * pageSize < filteredUsers.length) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      // Primero intentamos eliminar en el servidor
      await UserListService.delete("user",id: id);
      // Si tiene éxito, eliminamos localmente
      users.removeWhere((user) => user.id == id);
      filteredUsers.removeWhere((user) => user.id == id);

      // Si hemos eliminado todos los usuarios de la página actual y no es la primera
      if (getPaginatedUsers().isEmpty && currentPage.value > 1) {
        previousPage();
      }
    } catch (e) {
      print('Error al eliminar usuario: $e');
      // Podrías mostrar un mensaje de error al usuario aquí
      rethrow;
    }
  }

  // Método para refrescar los datos desde la API
  Future<void> refreshUsers() async {
    try {
      final apiResponse = await UserListService.get("user");
      final res = UserListResponse.fromJson(apiResponse);

      users.value = res.users ?? [];
      filteredUsers.value = users;
      currentPage.value = 1;

      print('Usuarios actualizados: ${users.length}');
    } catch (e) {
      print('Error al actualizar usuarios: $e');
      rethrow;
    }
  }
}



class UserEditController extends GetxController {
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





  late TextEditingController nameController;
  late TextEditingController emailController;



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
      final apiGetDirecciones = await UserListService.get("direccion");
      final resDir = DireccionResponse.fromJson(apiGetDirecciones);
      departments.assignAll(resDir.direcciones as Iterable<Direcciones>);

      // Cargar roles
      final apiGetRoles = await UserListService.get("role");
      final resRole = RoleResponse.fromJson(apiGetRoles);
      roles.assignAll(resRole.roles as Iterable<Roles>);

      // Cargar cargos
      final apiGetCargos = await UserListService.get("cargo");
      final resCargo = CargoResponse.fromJson(apiGetCargos);
      positions.assignAll(resCargo.cargos as Iterable<Cargos>);

      isLoading.value = false;

      nameController = TextEditingController();
      emailController = TextEditingController();

      // Escuchar cambios en los controladores y sincronizar con las variables reactivas
      nameController.addListener(() => name.value = nameController.text);
      emailController.addListener(() => email.value = emailController.text);


      /*final permissions = await UserListService.getUserPermissions('user','permissions', userId: 52);
      final resPermissions = ResponsePermission.fromJson(permissions);
      permissionUser.assignAll(resPermissions.permissions as Iterable<Permission>);*/



    } catch (e) {
      isLoading.value = false;
      errorLoadingData.value = true;
      //print('Error al cargar datos iniciales: $e');
      SnackbarAlert.error(title: "Oops!", message: 'Error al cargar datos iniciales: $e', durationSeconds: 2);//Get.snackbar('Error', 'Usuario no Actualizado');
    }
  }



  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  // Método para inicializar los valores del usuario
  void initialize(User user) {
    name.value = user.name!;
    email.value = user.email!;
    isActive.value = user.isActive!;

    // Asignar rol directamente
    rol.value = user.role ?? '';

    // Asignar departamento directamente
    department.value = user.department ?? '';

    // Asignar posición directamente
    position.value = user.position ?? '';

    profileImage.value = null;
    // Actualizar los controladores con los valores iniciales
    nameController.text = name.value;
    emailController.text = email.value;
  }

  // Método para obtener el usuario actualizado

  User updateUser(User originalUser) {
    return originalUser.copyWith(
      name: name.value,
      email: email.value,
      isActive: isActive.value,
      role: rol.value.isNotEmpty ? rol.value : null,
      department: department.value.isNotEmpty ? department.value : null,
      position: position.value.isNotEmpty ? position.value : null,
      profileImage: profileImage.value?.path,
    );
  }

  // Método para seleccionar imagen
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  // Método para reintentar carga de datos
  Future<void> retryLoadingData() async {
    await loadInitialData();
  }

  Future<void> updateService(User user)async {
    print(user.toString());
    final apiResponse = await UserListService.update("user",id: user.id!,data: user.toJson());
    final res = UpdateResponse.fromJson(apiResponse);
    if(res.success == true){
      SnackbarAlert.success(message:"OK Usuario Actualizado");//Get.snackbar('Ok', 'Usuario Actualizado');
      await Get.find<UserListController>().refreshUsers();
      Get.back();
    }else {
      SnackbarAlert.error(title: "Oops!", message: "Usuario no Actualizado", durationSeconds: 2);//Get.snackbar('Error', 'Usuario no Actualizado');
    }
  }
}