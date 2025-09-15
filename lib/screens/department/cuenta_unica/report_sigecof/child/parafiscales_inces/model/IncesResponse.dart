class Incesresponse {
  int? anho;
  String? organismo;
  String? fuente;
  String? partida;
  String? fondo;
  int? orden;
  int? estado;
  String? montoLey;
  String? creditoAdicional;
  String? beneficiario;
  String? autorizado;
  String? pagada; // Puede ser null o de otro tipo, no especificado
  String? fechaModificacion;
  String? cuenta;
  String? observacion;
  double? monto;

  Incesresponse({
    this.anho,
    this.organismo,
    this.fuente,
    this.partida,
    this.fondo,
    this.orden,
    this.estado,
    this.montoLey,
    this.creditoAdicional,
    this.beneficiario,
    this.autorizado,
    this.pagada,
    this.fechaModificacion,
    this.cuenta,
    this.observacion,
    this.monto,
  });

  factory Incesresponse.fromJson(Map<String, dynamic> json) =>
      Incesresponse(
        anho: (json["ANHO"] as int?)?? 0,
        organismo: json["ORGANISMO"] ?? '',
        fuente: json["FUENTE"] ?? '',
        partida: json["PARTIDA"] ?? '',
        fondo: json["FONDO"] ?? '',
        orden: (json["ORDEN"] as int?)?? 0,
        estado: (json["ESTADO"] as int?)?? 0,
        montoLey: json["MONTO_LEY"] ?? '',
        creditoAdicional: json["CREDITO_ADICIONAL"] ?? '',
        beneficiario: json["BENEFICIARIO"] ?? '',
        autorizado: json["AUTORIZADO"] ?? '',
        pagada: json["PAGADA"] ?? '',
        fechaModificacion: json["FECHA_MODIFICACION"] ?? '' ,
        cuenta: json["CUENTA"] ?? '',
        observacion: json["OBSERVACION"] ?? '',
        monto: double.tryParse(json['MONTO'].toString()) ?? 0.0,
      );



}
