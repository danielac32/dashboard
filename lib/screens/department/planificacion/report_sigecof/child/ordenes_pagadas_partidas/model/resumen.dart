class ResumenOrganismoPartida {
  final String organismo;
  final double? partida401;
  final double? partida402;
  final double? partida403;
  final double? partida404;
  final double? partida405;
  final double? partida406;
  final double? partida407;
  final double? partida408;
  final double? partida409;
  final double? partida410;
  final double? partida411;
  final double total;

  ResumenOrganismoPartida({
    required this.organismo,
    this.partida401,
    this.partida402,
    this.partida403,
    this.partida404,
    this.partida405,
    this.partida406,
    this.partida407,
    this.partida408,
    this.partida409,
    this.partida410,
    this.partida411,
    required this.total,
  });

  // Método toString() para representación legible
  @override
  String toString() {
    return '''
ResumenOrganismoPartida(
  organismo: $organismo,
  partida401: ${partida401 ?? 'null'},
  partida402: ${partida402 ?? 'null'},
  partida403: ${partida403 ?? 'null'},
  partida404: ${partida404 ?? 'null'},
  partida405: ${partida405 ?? 'null'},
  partida406: ${partida406 ?? 'null'},
  partida407: ${partida407 ?? 'null'},
  partida408: ${partida408 ?? 'null'},
  partida409: ${partida409 ?? 'null'},
  partida410: ${partida410 ?? 'null'},
  partida411: ${partida411 ?? 'null'},
  total: $total,
)''';
  }

  // Método toJson() para serialización a JSON
  Map<String, dynamic> toJson() {
    return {
      'organismo': organismo,
      'partida401': partida401,
      'partida402': partida402,
      'partida403': partida403,
      'partida404': partida404,
      'partida405': partida405,
      'partida406': partida406,
      'partida407': partida407,
      'partida408': partida408,
      'partida409': partida409,
      'partida410': partida410,
      'partida411': partida411,
      'total': total,
    }/*..removeWhere((key, value) => value == null)*/;
  }

  // Constructor fromJson para deserialización desde JSON
  factory ResumenOrganismoPartida.fromJson(Map<String, dynamic> json) {
    return ResumenOrganismoPartida(
      organismo: json['organismo'] as String,
      partida401: json['partida401'] as double?,
      partida402: json['partida402'] as double?,
      partida403: json['partida403'] as double?,
      partida404: json['partida404'] as double?,
      partida405: json['partida405'] as double?,
      partida406: json['partida406'] as double?,
      partida407: json['partida407'] as double?,
      partida408: json['partida408'] as double?,
      partida409: json['partida409'] as double?,
      partida410: json['partida410'] as double?,
      partida411: json['partida411'] as double?,
      total: json['total'] as double,
    );
  }
}