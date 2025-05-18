import '../../user_list/interface/user_permission.dart';

class PermissionResponse {
  bool? success;
  String? message;
  Permission? permission;

  PermissionResponse({
    this.success,
    this.message,
    this.permission,
  });

  PermissionResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    permission = json['permission'] != null
        ? Permission.fromJson(json['permission'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (permission != null) {
      data['permission'] = permission!.toJson();
    }
    return data;
  }
}