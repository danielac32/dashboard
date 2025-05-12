

class DireccionResponse {
  bool? success;
  List<Direcciones>? direcciones;

  DireccionResponse({this.success, this.direcciones});

  DireccionResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['direcciones'] != null) {
      direcciones = <Direcciones>[];
      json['direcciones'].forEach((v) {
        direcciones!.add(Direcciones.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (direcciones != null) {
      data['direcciones'] = direcciones!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Direcciones {
  String? name;

  Direcciones({this.name});

  Direcciones.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name':name
    };
  }
  @override
  String toString() => '$name';
}