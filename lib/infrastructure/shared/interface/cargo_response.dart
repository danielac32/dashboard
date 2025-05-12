class CargoResponse {
  bool? success;
  List<Cargos>? cargos;

  CargoResponse({this.success, this.cargos});

  CargoResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['cargos'] != null) {
      cargos = <Cargos>[];
      json['cargos'].forEach((v) {
        cargos!.add(Cargos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (cargos != null) {
      data['cargos'] = cargos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cargos {
  String? name;

  Cargos({this.name});

  Cargos.fromJson(Map<String, dynamic> json) {
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
