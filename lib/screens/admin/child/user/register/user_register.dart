import 'package:flutter/material.dart';


import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
  final roles = <String>[].obs;
  final departments = <String>[].obs;
  final positions = <String>[].obs;

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

      // Simulación de llamadas a la API
      roles.assignAll(['Admin', 'Editor', 'Viewer']);
      departments.assignAll(['Ventas', 'Marketing', 'Desarrollo']);
      positions.assignAll(['Gerente', 'Supervisor', 'Asistente']);

      isLoading.value = false;

      nameController = TextEditingController();
      emailController = TextEditingController();

      // Escuchar cambios en los controladores y sincronizar con las variables reactivas
      nameController.addListener(() => name.value = nameController.text);
      emailController.addListener(() => email.value = emailController.text);

    } catch (e) {
      isLoading.value = false;
      errorLoadingData.value = true;
      print('Error al cargar datos iniciales: $e');
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
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

  // Método para crear un nuevo usuario
  Map<String, dynamic> createUser() {
    return {
      'name': name.value,
      'email': email.value,
      'isActive': isActive.value,
      'role': rol.value.isNotEmpty ? rol.value : null,
      'department': department.value.isNotEmpty ? department.value : null,
      'position': position.value.isNotEmpty ? position.value : null,
      'profileImage': profileImage.value?.path,
    };
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
                constraints: const BoxConstraints(maxWidth: 500),
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
                        TextField(
                          keyboardType: TextInputType.text,
                          controller: controller.nameController,
                          decoration: InputDecoration(
                            labelText: 'Nombre completo',
                            prefixIcon: const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: controller.emailController,
                          decoration: InputDecoration(
                            labelText: 'Correo electrónico',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
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
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: controller.rol.value.isEmpty ? null : controller.rol.value,
                          items: controller.roles.isEmpty
                              ? [const DropdownMenuItem(value: null, child: Text('Cargando roles...'))]
                              : controller.roles.map((role) {
                            return DropdownMenuItem<String>(
                              value: role,
                              child: Text(role),
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
                              value: dept,
                              child: Text(dept),
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
                              value: cargo,
                              child: Text(cargo),
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
                          onPressed: () {
                            final newUser = controller.createUser();
                            print('Nuevo usuario registrado: $newUser');
                            Get.back(result: newUser);
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