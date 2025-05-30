

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