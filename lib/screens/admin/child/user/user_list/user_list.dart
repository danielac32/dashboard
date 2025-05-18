import 'package:core_system/screens/admin/child/user/user_list/widget/card_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../infrastructure/entities/user_response.dart';
import 'controller/user_list_controller.dart';


class UserList extends StatelessWidget {
  UserList({super.key});



  Widget _buildPermissionIcon({
    required bool hasPermission,
    required IconData icon,
    required String tooltip,
    required Color activeColor,
  }) {
    return IconButton(
      onPressed: hasPermission ? () {} : null,
      icon: Icon(icon, color: hasPermission ? activeColor : Colors.grey),
      tooltip: tooltip,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final userListController = Get.put(UserListController());
    final userEditController = Get.put(UserEditController());

    return Center(
      child: Container(

        width: MediaQuery.of(context).size.width * 0.8,
       // height: MediaQuery.of(context).size.height * 0.1,
        child: Column(
         //mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Barra de búsqueda
                SizedBox(
                  height: 60,
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Buscar usuario',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.search),
                      ),
                      onChanged: (query) {
                        userListController.search(query);
                      },
                    ),
                  ),
                ),
                Obx(() {
                  final controller = Get.find<UserListController>();
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        onPressed: controller.isLoading.value ? null : controller.toggleFilter,
                        icon: Badge(
                          backgroundColor: controller.filterColor,
                          label: controller.isLoading.value
                              ? SizedBox(
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : Text(
                            controller.filterStatus.value == FilterStatus.all
                                ? 'T'
                                : controller.filterStatus.value == FilterStatus.active
                                ? 'A'
                                : 'I',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: controller.isLoading.value
                              ? CircularProgressIndicator(strokeWidth: 2)
                              : Icon(
                            Icons.filter_list,
                            color: controller.filterColor,
                          ),
                        ),
                        tooltip: controller.filterTooltip,
                      ),
                      if (controller.isLoading.value)
                        Positioned.fill(
                          child: Container(
                            color: Colors.transparent,
                          ),
                        ),
                    ],
                  );
                })

              ]
            ),

            // Lista de usuarios paginada
            Expanded(
              child: Obx(() {
                final paginatedUsers = userListController.getPaginatedUsers();

                return ListView.builder(
                  itemCount: paginatedUsers.length,
                  itemBuilder: (context, index) {
                    final user = paginatedUsers[index];
                    if (!userListController.userPermissions.containsKey(user.id)) {
                      userListController.loadPermissionsForUser(user.id!);
                    }
                    return CardWidgetUser(colors: colors, user: user, textTheme: textTheme, userListController: userListController, userEditController: userEditController);
                  },
                );
              }),
            ),

            // Paginación
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: userListController.currentPage.value > 1
                        ? () => userListController.previousPage()
                        : null,
                  ),
                  Text(
                    'Página ${userListController.currentPage.value}',
                    style: TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: userListController.currentPage.value * userListController.pageSize <
                        userListController.filteredUsers.length
                        ? () => userListController.nextPage()
                        : null,
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}




void ShowUserDetails(BuildContext context,User user) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(user.name!),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('http://localhost:8080/avatar'),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              user.isActive == true ? 'ACTIVO' : user.isActive == false ? 'INACTIVO' : 'DESCONOCIDO',
              style: TextStyle(
                fontSize: 20,
                color: user.isActive == true
                    ? Colors.green
                    : user.isActive == false
                    ? Colors.red
                    : Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Text('Email: ${user.email}'),
            const SizedBox(height: 5),
            Text('Departamento: ${user.department}'),
            const SizedBox(height: 5),
            Text('Posición: ${user.position}'),
            const SizedBox(height: 5),
            Text('Creado: ${user.createdAt.toString()}'),
            const SizedBox(height: 5),
            Text('Última actualización: ${user.updatedAt.toString()}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar el modal
            },
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
}






Future<bool> showConfirmationDialog(BuildContext context, String message) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmación'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Retorna false para "No"
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Retorna true para "Sí"
            },
            child: const Text('Sí'),
          ),
        ],
      );
    },
  ) ?? false; // Si se cierra el diálogo sin acción, retorna false por defecto
}




class UserEditDialog extends StatelessWidget {
  final User user;

  const UserEditDialog({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inicializamos el controlador y le pasamos el usuario
    final UserEditController controller = Get.put(UserEditController());
    final colors = Theme.of(context).colorScheme;
    controller.initialize(user);

    return AlertDialog(
      title: Text('Editar Usuario'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              keyboardType: TextInputType.text,
              controller: controller.nameController,
              onChanged: (value) => controller.name.value = value,
              decoration:  InputDecoration(
                labelText: 'Nombre',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                /*hintText: controller.name.value*/
              ),
            ),
            const SizedBox(height: 16),
             TextField(
              keyboardType: TextInputType.emailAddress,
              controller: controller.emailController,//TextEditingController(text: controller.email.value),
              onChanged: (value) => controller.email.value = value,
              decoration: InputDecoration(labelText: 'Correo Electrónico',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => Container(
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
            ),),
            const SizedBox(height: 16),
            Obx(() {
              return DropdownButtonFormField<String>(
                //value: controller.rol.value.isNotEmpty ? controller.rol.value : null,
                items: controller.roles.isEmpty
                    ? [const DropdownMenuItem(child: Text('Cargando roles...'))]
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
                decoration:  InputDecoration(
                  labelText: 'Rol',
                  prefixIcon:  Icon(Icons.assignment_ind_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                hint:  Text(controller.rol.value.isNotEmpty ? controller.rol.value : 'Selecciona un rol'),
              );
            }),
            const SizedBox(height: 16),
            Obx(() => DropdownButtonFormField<String>(
              //value: controller.department.value.isNotEmpty ? controller.department.value : null,
              items: controller.departments.isEmpty
                  ? [const DropdownMenuItem(child: Text('Cargando departamentos...'))]
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
              decoration:  InputDecoration(
                labelText: 'Departamento',
                prefixIcon: const Icon(Icons.business_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              hint:  Text(controller.department.value.isNotEmpty ? controller.department.value : 'Selecciona un departamento'),
            )),
            const SizedBox(height: 16),
            Obx(() => DropdownButtonFormField<String>(
              //value: controller.position.value.isNotEmpty ? controller.position.value : null,
              items: controller.positions.isEmpty
                  ? [const DropdownMenuItem(child: Text('Cargando cargos...'))]
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
              hint:  Text(controller.position.value.isNotEmpty ? controller.position.value : 'Selecciona un cargo'),
            )),
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
            const SizedBox(height: 16),
          ],
        ),
      ),
      actions: <Widget>[

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Obtiene el usuario actualizado y cierra el diálogo
                User updatedUser = controller.updateUser(user);
                Get.back(result: updatedUser); // Retorna el usuario actualizado
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ],
    );
  }
}

