/*
class Empleado {
  final String nombre;
  final int cedula;
  final int direccionId;
  final String centroVotacion;
  final bool voto;
  final String votostr;

  Empleado({
    required this.nombre,
    required this.cedula,
    required this.direccionId,
    required this.centroVotacion,
    this.voto = false,
    this.votostr = 'NO VOTO',
  });

  // Convertir a Map para enviar a la API
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'cedula': cedula,
      'direccion_id': direccionId,
      'centro_votacion': centroVotacion,
      'voto': voto,
      'votostr': votostr,
    };
  }

  // Factory para crear desde un Map
  factory Empleado.fromJson(Map<String, dynamic> json) {
    return Empleado(
      nombre: json['nombre'],
      cedula: json['cedula'],
      direccionId: json['direccion_id'],
      centroVotacion: json['centro_votacion'],
      voto: json['voto'] ?? false,
      votostr: json['votostr'] ?? 'NO VOTO',
    );
  }
}
*/


class CreateEmpleado {
  final String nombre;
  final int cedula;
  final int direccionId;
  final String centroVotacion;
  final bool voto;
  final String votostr;

  CreateEmpleado({
    required this.nombre,
    required this.cedula,
    required this.direccionId,
    required this.centroVotacion,
    this.voto = false,
    this.votostr = 'NO VOTO',
  });

  // Convertir a Map para enviar a la API
  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'cedula': cedula,
      'direccion_id': direccionId,
      'centro_votacion': centroVotacion,
      'voto': voto,
      'votostr': votostr,
    };
  }

  // Factory para crear desde un Map
  factory CreateEmpleado.fromJson(Map<String, dynamic> json) {
    return CreateEmpleado(
      nombre: json['nombre'],
      cedula: json['cedula'],
      direccionId: json['direccion_id'],
      centroVotacion: json['centro_votacion'],
      voto: json['voto'] ?? false,
      votostr: json['votostr'] ?? 'NO VOTO',
    );
  }
}

class EmpleadoResponse {
  List<Empleado>? empleado;

  EmpleadoResponse({this.empleado});

  EmpleadoResponse.fromJson(Map<String, dynamic> json) {
    if (json['empleado'] != null) {
      empleado = <Empleado>[];
      json['empleado'].forEach((v) {
        empleado!.add(new Empleado.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.empleado != null) {
      data['empleado'] = this.empleado!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Empleado {
  int? id;
  String? nombre;
  int? cedula;
  int? direccionId;
  String? centroVotacion;
  bool? voto;
  String? votostr;
  Direccion? direccion;

  Empleado(
      {this.id,
        this.nombre,
        this.cedula,
        this.direccionId,
        this.centroVotacion,
        this.voto,
        this.votostr,
        this.direccion});

  Empleado.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombre = json['nombre'];
    cedula = json['cedula'];
    direccionId = json['direccion_id'];
    centroVotacion = json['centro_votacion'];
    voto = json['voto'];
    votostr = json['votostr'];
    direccion = json['direccion'] != null
        ? new Direccion.fromJson(json['direccion'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nombre'] = this.nombre;
    data['cedula'] = this.cedula;
    data['direccion_id'] = this.direccionId;
    data['centro_votacion'] = this.centroVotacion;
    data['voto'] = this.voto;
    data['votostr'] = this.votostr;
    if (this.direccion != null) {
      data['direccion'] = this.direccion!.toJson();
    }
    return data;
  }

  Empleado copyWith({
    int? id,
    String? nombre,
    int? cedula,
    int? direccionId,
    String? centroVotacion,
    bool? voto,
    String? votostr,
    Direccion? direccion,
  }) {
    return Empleado(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      cedula: cedula ?? this.cedula,
      direccionId: direccionId ?? this.direccionId,
      centroVotacion: centroVotacion ?? this.centroVotacion,
      voto: voto ?? this.voto,
      votostr: votostr ?? this.votostr,
      direccion: direccion ?? this.direccion,
    );
  }

}

class Direccion {
  int? id;
  String? direccion;

  Direccion({this.id, this.direccion});

  Direccion.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    direccion = json['direccion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['direccion'] = direccion;
    return data;
  }
  @override
  String toString() {
    return 'Direccion{id: $id, direccion: $direccion}';
  }
}
