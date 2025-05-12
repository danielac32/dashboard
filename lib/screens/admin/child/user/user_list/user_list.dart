import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../infrastructure/entities/user_response.dart';
import 'controller/user_list_controller.dart';


class UserList extends StatelessWidget {
  UserList({super.key});


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

            // Lista de usuarios paginada
            Expanded(
              child: Obx(() {
                final paginatedUsers = userListController.getPaginatedUsers();
                return ListView.builder(
                  itemCount: paginatedUsers.length,
                  itemBuilder: (context, index) {
                    final user = paginatedUsers[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: colors.surface, // Fondo diferenciado
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: colors.outline.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child:InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => ShowUserDetails(context, user),
                            child: Padding(
                                 padding: const EdgeInsets.all(12.0),
                                 child: Row(
                                   children: [
                                     // Contenido alineado a la izquierda
                                     Expanded(
                                       child: Align(
                                         alignment: Alignment.centerLeft,
                                         child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start, // Alineación izquierda para textos
                                           mainAxisSize: MainAxisSize.min, // Ocupa solo el espacio necesario
                                           children: [
                                             Text(
                                               user.name ?? 'Nombre no disponible',
                                               style: textTheme.bodyLarge?.copyWith(
                                                 fontWeight: FontWeight.w600,
                                                 color: colors.onSurface,
                                               ),
                                             ),
                                             const SizedBox(height: 4),
                                             Text(
                                               user.position ?? 'Sin cargo',
                                               style: textTheme.bodyMedium?.copyWith(
                                                 color: colors.onSurface.withOpacity(0.8),
                                               ),
                                             ),
                                             Text(
                                               user.department ?? 'Sin departamento',
                                               style: textTheme.bodySmall?.copyWith(
                                                 color: colors.onSurface.withOpacity(0.6),
                                               ),
                                             ),
                                             Text(
                                               user.role ?? 'Sin rol',
                                               style: textTheme.bodySmall?.copyWith(
                                                 color: colors.onSurface.withOpacity(0.6),
                                               ),
                                             ),
                                           ],
                                         ),
                                       ),
                                     ),

                                     // Espaciador para empujar los botones a la derecha
                                     const Spacer(),

                                     // Botones alineados a la derecha
                                     Row(
                                       mainAxisSize: MainAxisSize.min,
                                       children: [
                                         IconButton(
                                           icon: Icon(Icons.edit, color: colors.primary),
                                           onPressed: () async {
                                             User? updatedUser = await Get.dialog<User?>(
                                               UserEditDialog(user: user),
                                             );

                                             if (updatedUser != null) {
                                               print('Usuario actualizado: ${updatedUser.toString()}');
                                               userEditController.updateService(updatedUser);
                                             } else {
                                               print('Edición cancelada.');
                                             }
                                           },
                                         ),
                                         IconButton(
                                           icon: Icon(Icons.delete, color: colors.error),
                                           onPressed: () async {
                                             final isConfirmed = await showConfirmationDialog(
                                               context,
                                               '¿Estás seguro de eliminar a ${user.name}?',
                                             );
                                             if (isConfirmed == true) {
                                               userListController.deleteUser(user.id!);
                                             }
                                           },
                                         ),
                                       ],
                                     ),
                                   ],
                                 )
                            )
                      )
                    );
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
    controller.initialize(user);

    return AlertDialog(
      title: const Text('Editar Usuario'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              keyboardType: TextInputType.text,
              controller: controller.nameController,
              onChanged: (value) => controller.name.value = value,
              decoration:  InputDecoration(labelText: 'Nombre',/*hintText: controller.name.value*/),
            ),
             TextField(
              keyboardType: TextInputType.emailAddress,
              controller: controller.emailController,//TextEditingController(text: controller.email.value),
              onChanged: (value) => controller.email.value = value,
              decoration: const InputDecoration(labelText: 'Correo Electrónico'),
            ),
            Obx(() => SwitchListTile(
              title: const Text('Activo'),
              value: controller.isActive.value,
              onChanged: (value) => controller.isActive.value = value,
            )),
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
                decoration: const InputDecoration(labelText: 'Rol'),
                hint:  Text(controller.rol.value.isNotEmpty ? controller.rol.value : 'Selecciona un rol'),
              );
            }),
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
              decoration: const InputDecoration(labelText: 'Departamento'),
              hint:  Text(controller.department.value.isNotEmpty ? controller.department.value : 'Selecciona un departamento'),
            )),
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
              decoration: const InputDecoration(labelText: 'Cargo'),
              hint:  Text(controller.position.value.isNotEmpty ? controller.position.value : 'Selecciona un cargo'),
            )),
            Obx(() => Column(
              children: [
                if (controller.profileImage.value != null)
                  Image.file(
                    controller.profileImage.value!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => controller.pickImage(),
                  child: const Text('Cargar Imagen de Perfil'),
                ),
              ],
            )),
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

