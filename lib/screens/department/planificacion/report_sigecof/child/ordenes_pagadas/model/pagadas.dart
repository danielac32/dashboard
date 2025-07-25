class PagoPagadas {
  final double montoNeto;
  final int estado;
  final String moneda;
  final int orden;
  final int presupuesto;
  final String lugar;
  final String fechaPago;
  final String partida;
  final String observacion;
  final String organismo;
  final String beneficiario;

  PagoPagadas({
    required this.montoNeto,
    required this.estado,
    required this.moneda,
    required this.orden,
    required this.presupuesto,
    required this.lugar,
    required this.fechaPago,
    required this.partida,
    required this.observacion,
    required this.organismo,
    required this.beneficiario,
  });

  factory PagoPagadas.fromJson(Map<String, dynamic> json) {
    return PagoPagadas(
      montoNeto: (json['MONTO_NETO'] as num?)?.toDouble() ?? 0.0,
      estado: (json['ESTADO'] as int?) ?? 0,
      moneda: (json['MONEDA'] as String?) ?? "-",
      orden: (json['ORDEN'] as int?) ?? 0,
      presupuesto: (json['PRESUPUESTO'] as int?) ?? 0,
      lugar: (json['LUGAR'] as String?) ?? "-",
      fechaPago: (json['FECHA_PAGO'] as String?) ?? "-",
      partida: (json['PARTIDA'] as String?) ?? "-",
      observacion: (json['OBSERVACION'] as String?) ?? "-",
      organismo: (json['ORGANISMO'] as String?) ?? "-",
      beneficiario: (json['BENEFICIARIO'] as String?) ?? "-",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MONTO_NETO': montoNeto,
      'ESTADO': estado,
      'MONEDA': moneda,
      'ORDEN': orden,
      'PRESUPUESTO': presupuesto,
      'LUGAR': lugar,
      'FECHA_PAGO': fechaPago,
      'PARTIDA': partida,
      'OBSERVACION': observacion,
      'ORGANISMO': organismo,
      'BENEFICIARIO': beneficiario,
    };
  }
}