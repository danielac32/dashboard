
import 'package:flutter/material.dart';

import '../../../../../../infrastructure/entities/user_response.dart';
//import '../../permisos/interface/permission.dart';
import '../../../../../../infrastructure/shared/constants.dart';
import '../../permisos/permission.dart';
import '../controller/user_list_controller.dart';
import '../interface/user_permission.dart' show Permission;
import '../user_list.dart';
import 'package:get/get.dart';

class CardWidgetUser extends StatelessWidget {
  const CardWidgetUser({
    super.key,
    required this.colors,
    required this.user,
    required this.textTheme,
    required this.userListController,
    required this.userEditController,
  });

  final ColorScheme colors;
  final User user;
  final TextTheme textTheme;
  final UserListController userListController;
  final UserEditController userEditController;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 4),
        color: colors.inversePrimary, // Fondo diferenciado
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
                    SizedBox(
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Obx(() {
                            final isLoading = userListController.isLoadingPermissions[user.id] ?? true;
                            final permissions = userListController.userPermissions[user.id] ?? [];

                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Botón para gestionar permisos
                                IconButton(
                                  onPressed: ()async {
                                    final success = await Get.dialog<bool>(
                                      DialogAddPermission(id: user.id!),
                                    );

                                    if (success == true) {
                                      Get.snackbar(
                                        'Éxito',
                                        'Permisos actualizados correctamente',
                                        snackPosition: SnackPosition.BOTTOM,
                                        duration: Duration(seconds: 2),
                                        backgroundColor: Colors.green[100],
                                      );
                                    } else if (success == false) {
                                      Get.snackbar(
                                        'Error',
                                        'No se pudieron actualizar todos los permisos',
                                        snackPosition: SnackPosition.BOTTOM,
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Colors.red[100],
                                      );
                                    }
                                    /*final permissions = await Get.dialog<List<Permission>>(
                                      DialogAddPermission(id: user.id!),
                                    );

                                     */

                                    /*if (permissions != null) {
                                      // Procesar los permisos seleccionados
                                      print(user.id);
                                      for (var perm in permissions) {
                                        print('Sección: ${perm.section}');
                                        print(' - Crear: ${perm.canCreate}');
                                        print(' - Editar: ${perm.canEdit}');
                                        print(' - Eliminar: ${perm.canDelete}');
                                        print(' - Publicar: ${perm.canPublish}');
                                      }
                                    }*/
                                  },
                                  icon: Icon(Icons.screen_lock_landscape, color: Color.fromRGBO(10, 200, 10, 1)),
                                  tooltip: 'Gestionar permisos',
                                ),

                                // Espaciador opcional
                                const SizedBox(width: 8),
                                /*if (!isLoading) ...[
                                  if(permissions.isNotEmpty) ...[
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.30,
                                      child: Card(
                                        elevation: 4,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: ExpansionTile(
                                            title: Text('Ver permisos (${permissions.length})'),
                                            children: [
                                              ...permissions.map((permission) => ListTile(
                                                title: Text(permission.section ?? ''),
                                                subtitle: Wrap(
                                                  spacing: 8,
                                                  children: [
                                                    if (permission.canCreate ?? false)
                                                      Chip(label: Text('Crear'), backgroundColor: Colors.blue[50]),
                                                    if (permission.canEdit ?? false)
                                                      Chip(label: Text('Editar'), backgroundColor: Colors.blue[50]),
                                                    if (permission.canDelete ?? false)
                                                      Chip(label: Text('Eliminar'), backgroundColor: Colors.red[50]),
                                                    if (permission.canPublish ?? false)
                                                      Chip(label: Text('Publicar'), backgroundColor: Colors.green[50]),
                                                  ],
                                                ),
                                              )).toList(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ]
                                ] else ...[
                                  const CircularProgressIndicator(strokeWidth: 2),
                                ],*/

                                // Botones de acciones
                                IconButton(
                                  icon: Icon(Icons.edit, color: colors.primary),
                                  onPressed: () async {
                                    User? updatedUser = await Get.dialog<User?>(
                                      UserEditDialog(user: user),
                                    );
                                    if (updatedUser != null) {
                                      userEditController.updateService(updatedUser);
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
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(DefaultUrl.avatarUrl),///*${user.id}*/
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                )
            )
        )
    );
  }
}