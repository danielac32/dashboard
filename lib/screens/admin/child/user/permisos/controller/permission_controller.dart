



import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../user_list/interface/user_permission.dart';
import '../interface/permission_response.dart';
import '../interface/sections_response.dart';
import '../service/permission_service.dart';


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