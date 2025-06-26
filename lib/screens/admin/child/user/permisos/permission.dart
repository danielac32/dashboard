

import 'package:core_system/screens/admin/child/user/permisos/service/permission_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//import 'interface/permission.dart';
import '../../../../../core/utils/get_name.dart';
import '../user_list/interface/user_permission.dart';
import 'controller/permission_controller.dart';
import 'interface/permission_response.dart';
import 'interface/sections_response.dart';








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
                        getDisplayName(perm.section),
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

  /*String _getDisplayName(String? section) {
    if (section == null) {
      return 'Sin nombre'; // O algún valor predeterminado
    }
    return section
        .toLowerCase()
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }*/
}