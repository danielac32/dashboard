

import 'empleado.dart';

class DireccionResponse {
  List<Direccion>? direcciones;

  DireccionResponse({this.direcciones});

  DireccionResponse.fromJson(Map<String, dynamic> json) {
    if (json['direcciones'] != null) {
      direcciones = <Direccion>[];
      json['direcciones'].forEach((v) {
        direcciones!.add(Direccion.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (direcciones != null) {
      data['direcciones'] = direcciones!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

