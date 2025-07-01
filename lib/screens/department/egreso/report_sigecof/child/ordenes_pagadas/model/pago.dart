class Pago {
  final String pagada;
  final int estado;
  final int orden;
  final double monto;
  final String fuente;
  final int anho;
  final String partida;
  final String cuenta;
  final String observacion;
  final String organismo;
  final String beneficiario;
  final String? fondo;

  Pago({
    required this.pagada,
    required this.estado,
    required this.orden,
    required this.monto,
    required this.fuente,
    required this.anho,
    required this.partida,
    required this.cuenta,
    required this.observacion,
    required this.organismo,
    required this.beneficiario,
    this.fondo,
  });
  factory Pago.fromJson(Map<String, dynamic> json) {
    return Pago(
      pagada: json['PAGADA'] ?? '',
      estado: json['ESTADO'] ?? 0,
      orden: json['ORDEN'] ?? 0,
      monto: double.tryParse(json['MONTO'].toString()) ?? 0.0,
      fuente: json['FUENTE'] ?? '',
      anho: json['ANHO'] ?? 0,
      partida: json['PARTIDA'] ?? '',
      cuenta: json['CUENTA'] ?? '',
      observacion: json['OBSERVACION'] ?? '',
      organismo: json['ORGANISMO'] ?? '',
      beneficiario: json['BENEFICIARIO'] ?? '',
      fondo: json['FONDO'],
    );
  }
}
