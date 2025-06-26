

class Bcv {
  final double? montoTotal;
  final String? denominacion;
  final int? pagoId;
  final String? orgaId;
  final String? fechaValor;

  Bcv({
    this.montoTotal,
    this.denominacion,
    this.pagoId,
    this.orgaId,
    this.fechaValor,
  });

  factory Bcv.fromJson(Map<String, dynamic> json) {
    return Bcv(
      montoTotal: json['MONTO_TOTAL'] != null
          ? double.tryParse(json['MONTO_TOTAL'].toString())
          : null,
      denominacion: json['DENOMINACION'],
      pagoId: json['PAGO_ID'],
      orgaId: json['ORGA_ID'],
      fechaValor: json['FECHA_VALOR'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MONTO_TOTAL': montoTotal,
      'DENOMINACION': denominacion,
      'PAGO_ID': pagoId,
      'ORGA_ID': orgaId,
      'FECHA_VALOR': fechaValor,
    };
  }
}