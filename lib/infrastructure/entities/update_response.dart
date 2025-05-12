

import 'package:core_system/infrastructure/entities/user_response.dart';

class UpdateResponse {
  bool? success;
  User? user;

  UpdateResponse({this.success, this.user});

  UpdateResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    user = json['user'] != null ?  User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
