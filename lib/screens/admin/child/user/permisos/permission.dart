

import 'package:core_system/screens/admin/child/user/permisos/service/permission_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//import 'interface/permission.dart';
import '../user_list/interface/user_permission.dart';
import 'interface/permission_response.dart';
import 'interface/sections_response.dart';





class PermissionController extends GetxController {
  final int id;
  PermissionController(this.id);

  final RxList<Permission> allPermissions = <Permission>[].obs; // Todos los permisos posibles
  final RxList<Permission> userPermissions = <Permission>[].obs; // Permisos actuales del usuario

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadAllSections(); // Cargar todas las secciones posibles
    await loadUserPermissions(); // Cargar permisos del usuario
    mergePermissions(); // Combinar ambos
  }

  Future<void> loadAllSections() async {
    try {
      final sections = await PermissionService.get("sections");
      final resSections = Sections.fromJson(sections);

      // Inicializa todos los permisos posibles en false
      allPermissions.assignAll(
          resSections.sections.map((section) => Permission(
            section: section,
            canCreate: false,
            canDelete: false,
            canEdit: false,
            canPublish: false,
          )).toList()
      );
    } catch (e) {
      print('Error cargando secciones: $e');
    }
  }

  Future<void> loadUserPermissions() async {
    try {
      final response = await PermissionService.getUserPermissions(
          'user',
          'permissions',
          userId: id
      );
      final resPermissions = ResponsePermission.fromJson(response);

      userPermissions.clear();
      if (resPermissions.permissions != null) {
        userPermissions.addAll(resPermissions.permissions!);
      }

      // Debug
      print("Permisos del usuario:");
      for(final p in userPermissions) {
        print(p);
      }
    } catch (e) {
      print('Error cargando permisos del usuario: $e');
    }
  }

  void mergePermissions() {
    // Para cada permiso disponible
    for (var i = 0; i < allPermissions.length; i++) {
      final section = allPermissions[i].section;

      // Busca si el usuario tiene permisos para esta sección
      final userPermission = userPermissions.firstWhereOrNull(
              (perm) => perm.section == section
      );

      // Si existe, actualiza los valores
      if (userPermission != null) {
        allPermissions[i] = allPermissions[i].copyWith(
          canCreate: userPermission.canCreate,
          canEdit: userPermission.canEdit,
          canDelete: userPermission.canDelete,
          canPublish: userPermission.canPublish,
        );
      }
    }
    allPermissions.refresh();
  }

  void togglePermission(int index, String permissionType, bool value) {
    final perm = allPermissions[index];
    switch (permissionType) {
      case 'create':
        perm.canCreate = value;
        break;
      case 'edit':
        perm.canEdit = value;
        break;
      case 'delete':
        perm.canDelete = value;
        break;
      case 'publish':
        perm.canPublish = value;
        break;
    }
    allPermissions.refresh();
  }

  List<Permission> getSelectedPermissions() {
    return allPermissions
        .where((perm) =>
    perm.canCreate == true ||
        perm.canEdit == true ||
        perm.canDelete == true ||
        perm.canPublish == true)
        .map((perm) => Permission(
      section: perm.section,
      canCreate: perm.canCreate,
      canEdit: perm.canEdit,
      canDelete: perm.canDelete,
      canPublish: perm.canPublish,
    ))
        .toList();
  }


  Future<bool> updatePermission(List<Permission> permissions) async {
    try {
      bool allSuccess = true;
      for (final perm in permissions) {
        final apiResponse = await PermissionService.update(
            "user",
            id: id,
            endpoint2: "permissions",
            data: perm.toJson()
        );

        final res = PermissionResponse.fromJson(apiResponse);
        if (res.success != true) {
          allSuccess = false;
          // Opcional: puedes registrar qué permiso falló
          debugPrint('Error al actualizar permiso para sección: ${perm.section}');
          // Opcional: puedes decidir si continuar con los demás o salir
           break; // Si quieres detenerte en el primer error
        }
      }
      return allSuccess;

    } catch (e) {
      debugPrint('Error en updatePermission: $e');
      return false;
    }
  }
}


class DialogAddPermission extends StatelessWidget {
  final int id;
  const DialogAddPermission({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GetBuilder<PermissionController>(
      init: PermissionController(id),
      builder: (controller) {
        return AlertDialog(
          title: const Text('Asignar Permisos'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,//double.maxFinite,
            child: SingleChildScrollView(
              child: Obx(
                    () => Column(
                  children: controller.allPermissions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final perm = entry.value;
                    return ExpansionTile(
                      title: Text(
                        _getDisplayName(perm.section),
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        _buildPermissionSwitch(
                          title: 'Crear',
                          value: perm.canCreate!,
                          onChanged: (value) {
                            controller.togglePermission(index, 'create', value);
                          },
                        ),
                        _buildPermissionSwitch(
                          title: 'Editar',
                          value: perm.canEdit!,
                          onChanged: (value) {
                            controller.togglePermission(index, 'edit', value);
                          },
                        ),
                        _buildPermissionSwitch(
                          title: 'Eliminar',
                          value: perm.canDelete!,
                          onChanged: (value) {
                            controller.togglePermission(index, 'delete', value);
                          },
                        ),

                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {

                final permissions = controller.getSelectedPermissions();
                final success = await controller.updatePermission(permissions);
                Get.back(result: success); // Cerramos el diálogo y pasamos el resultado


                /*final permissions = controller.getSelectedPermissions();
                final result = permissions.map((p) => Permission(
                  section: p.section,
                  canCreate: p.canCreate,
                  canEdit: p.canEdit,
                  canDelete: p.canDelete,
                  canPublish: p.canPublish,
                )).toList();
                await controller.updatePermission(result);
                Get.back(result: result);

                 */
              },
              child: const Text('Guardar Permisos'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPermissionSwitch({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.only(left: 32),
    );
  }

  String _getDisplayName(String? section) {
    if (section == null) {
      return 'Sin nombre'; // O algún valor predeterminado
    }
    return section
        .toLowerCase()
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}