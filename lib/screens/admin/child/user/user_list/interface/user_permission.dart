

class ResponsePermission {
  bool? success;
  List<Permission>? permissions;

  ResponsePermission({this.success, this.permissions});

  ResponsePermission.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['permissions'] != null) {
      permissions = <Permission>[];
      json['permissions'].forEach((v) {
        permissions!.add(Permission.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (permissions != null) {
      data['permissions'] = permissions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Permission {
  String? section;
  bool? canCreate;
  bool? canEdit;
  bool? canDelete;
  bool? canPublish;

  Permission({
    this.section,
    this.canCreate,
    this.canEdit,
    this.canDelete,
    this.canPublish,
  });

  Permission.fromJson(Map<String, dynamic> json) {
    section = json['section'];
    canCreate = json['canCreate'];
    canEdit = json['canEdit'];
    canDelete = json['canDelete'];
    canPublish = json['canPublish'];
  }

  Map<String, dynamic> toJson() {
    return {
      'section': section,
      'canCreate': canCreate,
      'canEdit': canEdit,
      'canDelete': canDelete,
      'canPublish': canPublish,
    };
  }

  @override
  String toString() {
    return 'Permission(section: $section, canCreate: $canCreate, canEdit: $canEdit, canDelete: $canDelete, canPublish: $canPublish)';
  }
}