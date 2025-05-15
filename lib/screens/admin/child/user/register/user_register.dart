import 'package:core_system/screens/admin/child/user/register/service/register_service.dart';
import 'package:flutter/material.dart';


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../infrastructure/entities/user_response.dart';
import '../../../../../infrastructure/shared/alert.dart';
import '../../../../../infrastructure/shared/interface/cargo_response.dart';
import '../../../../../infrastructure/shared/interface/direccion_response.dart';
import '../../../../../infrastructure/shared/interface/role_response.dart';
import '../../../controller/dashboard_menu.dart';

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
      await Get.find<MenuControllerScreen>().currentIndex(1);
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



class UserRegister extends StatelessWidget {
  const UserRegister({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserRegisterController());
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(strokeWidth: 2),
                SizedBox(height: 16),
                Text('Cargando datos...', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        } else if (controller.errorLoadingData.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: colors.error),
                const SizedBox(height: 16),
                Text('Error al cargar datos', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('Por favor intente nuevamente', style: TextStyle(color: colors.onSurface.withOpacity(0.6))),
                const SizedBox(height: 24),
                FilledButton.tonal(
                  onPressed: () => controller.retryLoadingData(),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        } else {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Crear nuevo usuario',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: controller.nameController,
                          //onChanged: (value) => controller.name.value = value,
                          validator: controller.validateName,
                          decoration: InputDecoration(
                            labelText: 'Nombre completo',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: controller.emailController,
                         // onChanged: (value) => controller.email.value = value,
                          validator: controller.validateEmail,
                          decoration: InputDecoration(
                            labelText: 'Correo electrónico',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        /*Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: SwitchListTile(
                            title: const Text('Usuario activo'),
                            secondary: Icon(
                              controller.isActive.value
                                  ? Icons.check_circle_outline
                                  : Icons.remove_circle_outline,
                              color: controller.isActive.value
                                  ? colors.primary
                                  : colors.error,
                            ),
                            value: controller.isActive.value,
                            onChanged: (value) => controller.isActive.value = value,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),*/
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: controller.rol.value.isEmpty ? null : controller.rol.value,
                          items: controller.roles.isEmpty
                              ? [const DropdownMenuItem(value: null, child: Text('Cargando roles...'))]
                              : controller.roles.map((role) {
                            return DropdownMenuItem<String>(
                              value: role.name,
                              child: Text(role.name!),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.rol.value = value;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Rol',
                            prefixIcon: const Icon(Icons.assignment_ind_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          hint: const Text('Selecciona un rol'),
                          borderRadius: BorderRadius.circular(12),
                          icon: const Icon(Icons.arrow_drop_down),

                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: controller.department.value.isEmpty ? null : controller.department.value,
                          items: controller.departments.isEmpty
                              ? [const DropdownMenuItem(value: null, child: Text('Cargando departamentos...'))]
                              : controller.departments.map((dept) {
                            return DropdownMenuItem<String>(
                              value: dept.name,
                              child: Text(dept.name!),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.department.value = value;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Departamento',
                            prefixIcon: const Icon(Icons.business_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          hint: const Text('Selecciona un departamento'),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: controller.position.value.isEmpty ? null : controller.position.value,
                          items: controller.positions.isEmpty
                              ? [const DropdownMenuItem(value: null, child: Text('Cargando cargos...'))]
                              : controller.positions.map((cargo) {
                            return DropdownMenuItem<String>(
                              value: cargo.name,
                              child: Text(cargo.name!),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.position.value = value;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Cargo',
                            prefixIcon: const Icon(Icons.work_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          hint: const Text('Selecciona un cargo'),
                        ),
                        const SizedBox(height: 16),
                        Obx(() => Column(
                          children: [
                            if (controller.profileImage.value != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  controller.profileImage.value!,
                                  height: 120,
                                  width: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            const SizedBox(height: 16),
                            FilledButton.tonal(
                              onPressed: () => controller.pickImage(),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.camera_alt_outlined, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    controller.profileImage.value == null
                                        ? 'Agregar foto de perfil'
                                        : 'Cambiar foto',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                        const SizedBox(height: 32),
                        FilledButton(
                          onPressed: () async {
                            await controller.createUser();
                          },
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Registrar usuario',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}