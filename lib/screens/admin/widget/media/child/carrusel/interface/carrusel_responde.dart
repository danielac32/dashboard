

class CarruselListResponse {
  bool? success;
  int? count;
  List<String>? list;
  String? timestamp;

  CarruselListResponse({this.success, this.count, this.list, this.timestamp});

  CarruselListResponse.fromJson(Map<String, dynamic> json) {
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

class CarruselUploadResponse {
  final String status;
  final String path;

  CarruselUploadResponse({
    required this.status,
    required this.path,
  });

  factory CarruselUploadResponse.fromJson(Map<String, dynamic> json) {
    return CarruselUploadResponse(
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

class CarruselDeleteResponse {
  final bool success;
  final String message;

  CarruselDeleteResponse({
    required this.success,
    required this.message,
  });

  // Opcional: constructor desde JSON
  factory CarruselDeleteResponse.fromJson(Map<String, dynamic> json) {
    return CarruselDeleteResponse(
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