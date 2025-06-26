class DolarBolivar {
  final String pagada;
  final int estado;
  final double montoPagado;
  final int estado2;
  final int orden;
  final int anho;
  final String observacion;
  final String organismo;
  final String beneficiario;

  DolarBolivar({
    required this.pagada,
    required this.estado,
    required this.montoPagado,
    required this.estado2,
    required this.orden,
    required this.anho,
    required this.observacion,
    required this.organismo,
    required this.beneficiario,
  });

  factory DolarBolivar.fromJson(Map<String, dynamic> json) {
    return DolarBolivar(
      pagada: json['PAGADA'] ?? '',
      estado: json['ESTADO'] ?? 0,
      montoPagado: double.tryParse(json['MONTO_PAGADO'].toString()) ?? 0.0,
      estado2: json['ESTADO2'] ?? 0,
      orden: json['ORDEN'] ?? 0,
      anho: json['ANHO'] ?? 0,
      observacion: json['OBSERVACION'] ?? '',
      organismo: json['ORGANISMO'] ?? '',
      beneficiario: json['BENEFICIARIO']?.toString().trim() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PAGADA': pagada,
      'ESTADO': estado,
      'MONTO_PAGADO': montoPagado,
      'ESTADO2': estado2,
      'ORDEN': orden,
      'ANHO': anho,
      'OBSERVACION': observacion,
      'ORGANISMO': organismo,
      'BENEFICIARIO': beneficiario,
    };
  }
}