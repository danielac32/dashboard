class Permission {
  final String section;
  bool canCreate;
  bool canEdit;
  bool canDelete;
  bool canPublish;

  Permission({
    required this.section,
    this.canCreate = false,
    this.canEdit = false,
    this.canDelete = false,
    this.canPublish = false,
  });

  // Para convertir desde JSON si es necesario
  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      section: json['section'] ?? '',
      canCreate: json['canCreate'] ?? false,
      canEdit: json['canEdit'] ?? false,
      canDelete: json['canDelete'] ?? false,
      canPublish: json['canPublish'] ?? false,
    );
  }
}