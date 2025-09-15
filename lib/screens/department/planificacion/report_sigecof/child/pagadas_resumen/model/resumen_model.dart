// archivo: response_item.dart

class PagadasResumen {
  final String organismo;
  final String partidas;
  final double anhoAnterior;
  final double anhoActual;
  final double montoTotal;

  PagadasResumen({
    required this.organismo,
    required this.partidas,
    required this.anhoAnterior,
    required this.anhoActual,
    required this.montoTotal,
  });


  // Método para crear una instancia desde un mapa (JSON)
  factory PagadasResumen.fromJson(Map<String, dynamic> json) {
    return PagadasResumen(
        organismo: json['ORGANISMO'] as String? ?? '-',
        partidas: json['PARTIDAS'] as String? ?? '-',
        anhoAnterior: double.tryParse(json['ANHO_ANTERIOR'].toString()) ?? 0.0,//(json['ANHO_ANTERIOR'] as num?)?.toDouble() ?? 0.0,
        anhoActual: double.tryParse(json['ANHO_ACTUAL'].toString()) ?? 0.0,//(json['ANHO_ACTUAL'] as num?)?.toDouble() ?? 0.0,
        montoTotal: double.tryParse(json['MONTO_TOTAL'].toString()) ?? 0.0,//(json['MONTO_TOTAL'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Método para convertir a Map (útil si necesitas enviarlo de vuelta)
  Map<String, dynamic> toJson() {
    return {
      'ORGANISMO': organismo,
      'PARTIDAS': partidas,
      'ANHO_ANTERIOR': anhoAnterior,
      'ANHO_ACTUAL': anhoActual,
      'MONTO_TOTAL': montoTotal,
    };
  }

  @override
  String toString() {
    return 'ResponseItem(organismo: $organismo, partidas: $partidas, añoAnterior: $anhoAnterior, añoActual: $anhoActual, montoTotal: $montoTotal)';
  }
}