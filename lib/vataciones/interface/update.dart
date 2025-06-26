class UpdateVotoStatus {
  final int empleadoId;
  final bool voto;
  final String votostr;

  UpdateVotoStatus({
    required this.empleadoId,
    required this.voto,
    String? votostr,  // Hacemos el parámetro opcional
  }) : votostr = votostr ?? (voto ? 'VOTÓ' : 'NO VOTO');  // Usamos operador ?? para el valor por defecto

  // Convertir a Map para enviar a la API
  Map<String, dynamic> toJson() {
    return {
      'empleado_id': empleadoId,
      'voto': voto,
      'votostr': votostr,
    };
  }

  // Factory para crear desde un Map
  factory UpdateVotoStatus.fromJson(Map<String, dynamic> json) {
    return UpdateVotoStatus(
      empleadoId: json['empleado_id'],
      voto: json['voto'],
      votostr: json['votostr'],
    );
  }
}