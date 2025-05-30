import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/user_register_controller.dart';


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