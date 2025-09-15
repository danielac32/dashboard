/*class PagoPagadas {
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
      montoNeto: double.tryParse(json['MONTO_NETO'].toString()) ?? 0.0,//(json['MONTO_NETO'] as num?)?.toDouble() ?? 0.0,
      estado: (json['ESTADO'] as int?) ?? 0,
      moneda: (json['MONEDA'] as String?) ?? "-",
      orden: (json['ORDEN'] as int?) ?? 0,
      presupuesto: (json['PRESUPUESTO'] as int?) ?? 0,
      lugar: (json['LUGAR'] as String?) ?? "-",
      fechaPago: (json['FECHA_PAGO'] as String?) ?? "-",
      partida: (json['PARTIDA'] as String?) ?? "0",//este caso es si la partida viene nula
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
  @override
  String toString() {
    // TODO: implement toString
    return "$organismo - $partida - $montoNeto";
  }
}*/



class PagoPagadas {
  final double monto;
  final int estado;
  final int orden;
  final int anho;
  final String fuente;
  final String partida; // Ej: "407010201 - DONACIONES..."
  final String cuenta;
  final String observacion;
  final String organismo; // Ej: "025 - PROCURADURÍA GENERAL DE LA REPÚBLICA"
  final String beneficiario;
  final String fechaPago; // Viene como String en formato "2025-08-15 00:00:00.0"
  final String? fondo; // Puede ser null

  PagoPagadas({
    required this.monto,
    required this.estado,
    required this.orden,
    required this.anho,
    required this.fuente,
    required this.partida,
    required this.cuenta,
    required this.observacion,
    required this.organismo,
    required this.beneficiario,
    required this.fechaPago,
    this.fondo,
  });

  factory PagoPagadas.fromJson(Map<String, dynamic> json) {
    return PagoPagadas(
      monto: double.tryParse(json['MONTO'].toString()) ?? 0.0,//monto: (json['MONTO'] as num?)?.toDouble() ?? 0.0,
      estado: (json['ESTADO'] as int?) ?? 0,
      orden: (json['ORDEN'] as int?) ?? 0,
      anho: (json['ANHO'] as int?) ?? 0,
      fuente: (json['FUENTE'] as String?) ?? "-",
      partida: (json['PARTIDA'] as String?) ?? "0",
      cuenta: (json['CUENTA'] as String?) ?? "-",
      observacion: (json['OBSERVACION'] as String?) ?? "-",
      organismo: (json['ORGANISMO'] as String?) ?? "-",
      beneficiario: (json['BENEFICIARIO'] as String?) ?? "-",
      fechaPago: (json['PAGADA'] as String?)?.isNotEmpty == true
          ? json['PAGADA'] as String
          : "-",
      fondo: (json['FONDO'] as String?) ?? "-",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monto': monto,
      'estado': estado,
      'orden': orden,
      'anho': anho,
      'fuente': fuente,
      'partida': partida,
      'cuenta': cuenta,
      'observacion': observacion,
      'organismo': organismo,
      'beneficiario': beneficiario,
      'fechaPago': fechaPago,
      'fondo': fondo,
    };
  }

  /// Devuelve solo los primeros 3 caracteres de la partida (categoría)
  String get PartidaCorto {
    if (partida.isEmpty) return "0";
    final codigo = partida.split(' - ').first;
    return codigo.length >= 3 ? codigo.substring(0, 3) : codigo;
  }

  /// Devuelve solo el ID del organismo (ej: "025" de "025 - PROCURADURÍA...")
  String get organismoId {
    if (organismo.isEmpty) return "0";
    final match = RegExp(r'^(\d+)').firstMatch(organismo);
    return match?.group(1) ?? "0";
  }

  @override
  String toString() {
    return "$organismo - $partida - \$${monto.toStringAsFixed(2)}";
  }
}