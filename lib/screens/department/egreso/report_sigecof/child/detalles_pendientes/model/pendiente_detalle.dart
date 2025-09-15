class DetallePendiente {
  final int anho;
  final String organismo;
  final int orden;
  final String cuenta;
  final String codBco;
  final String banco;
  final double monto;
  final String fechaModificacion;
  final String estado;
  final String beneficiario;
  final String rif;
  final String observacion;

  DetallePendiente({
    required this.anho,
    required this.organismo,
    required this.orden,
    required this.cuenta,
    required this.codBco,
    required this.banco,
    required this.monto,
    required this.fechaModificacion,
    required this.estado,
    required this.beneficiario,
    required this.rif,
    required this.observacion,
  });

  // Método para crear una instancia desde un mapa (JSON)
  factory DetallePendiente.fromJson(Map<String, dynamic> json) {
    return DetallePendiente(
      anho: (json['ANHO'] as int) ?? 0,
      organismo: (json['ORGANISMO'] as String) ?? '',
      orden: (json['ORDEN'] as int) ?? 0,
      cuenta: (json['CUENTA'] as String) ?? '',
      codBco: (json['COD_BCO'] as String) ?? '',
      banco: (json['BANCO'] as String) ?? '',
      monto: double.tryParse(json['MONTO'].toString()) ?? 0.0,
      fechaModificacion: (json['FECHA_MODIFICACION'] as String) ?? '',
      estado: (json['ESTADO'] as String) ?? '',
      beneficiario: (json['BENEFICIARIO'] as String) ?? '',
      rif: (json['RIF'] as String) ?? '',
      observacion: (json['OBSERVACION'] as String) ?? '',
    );
  }

  // Método para convertir el objeto a un mapa (útil para debugging o envío)
  Map<String, dynamic> toJson() {
    return {
      'ANHO': anho,
      'ORGANISMO': organismo,
      'ORDEN': orden,
      'CUENTA': cuenta,
      'COD_BCO': codBco,
      'BANCO': banco,
      'MONTO': monto,
      'FECHA_MODIFICACION': fechaModificacion,
      'ESTADO': estado,
      'BENEFICIARIO': beneficiario,
      'RIF': rif,
      'OBSERVACION': observacion,
    };
  }

  @override
  String toString() {
    return 'DetallePendiente(AÑO: $anho, ORGANISMO: $organismo, ORDEN: $orden, MONTO: $monto, ESTADO: $estado, BENEFICIARIO: $beneficiario)';
  }
}