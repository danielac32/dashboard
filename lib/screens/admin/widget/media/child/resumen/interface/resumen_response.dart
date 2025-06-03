

class ResumenListResponse {
  bool? success;
  int? count;
  List<String>? list;
  String? timestamp;

  ResumenListResponse({this.success, this.count, this.list, this.timestamp});

  ResumenListResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    count = json['count'];
    list = json['list'].cast<String>();
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['count'] = count;
    data['list'] = list;
    data['timestamp'] = timestamp;
    return data;
  }
}

class ResumenUploadResponse {
  final String status;
  final String path;

  ResumenUploadResponse({
    required this.status,
    required this.path,
  });

  factory ResumenUploadResponse.fromJson(Map<String, dynamic> json) {
    return ResumenUploadResponse(
      status: json['status'],
      path: json['path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'path': path,
    };
  }
}

class ResumenDeleteResponse {
  final bool success;
  final String message;

  ResumenDeleteResponse({
    required this.success,
    required this.message,
  });

  // Opcional: constructor desde JSON
  factory ResumenDeleteResponse.fromJson(Map<String, dynamic> json) {
    return ResumenDeleteResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  // Opcional: convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}