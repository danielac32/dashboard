

class VotoDireccion {
  final String nombre;
  final int votos;
  VotoDireccion({required this.nombre, required this.votos});

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'votos': votos,
    };
  }

  // Factory para crear desde un Map
  factory VotoDireccion.fromJson(Map<String, dynamic> json) {
    return VotoDireccion(
      nombre: json['nombre'],
      votos: (json['votos'] as num?)?.toInt() ?? 0,
    );
  }
}

