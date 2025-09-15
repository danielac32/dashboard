


class ComprobanteRetencion {
  String? rifContribuyente;
  String? periodoImpositivo;
  String? fechaDocumento;
  String? tipoOperacion;
  String? tipoDocumento;
  String? organismo;
  String? rifOrganismo;
  String? codUnidadAdministradora;
  String? descUnidadAdministradora;
  String? tipoRetencion;
  String? beneficiario;
  String? rifBeneficiario;
  String? autorizado;
  String? rifAutorizado;
  String? rifVendedor;
  String? numeroDocumento;
  String? numeroControlDocumento;
  double? montoTotalDocumento;
  double? baseImponible;
  double? alicuota;
  String? fechaFactura;
  String? numFactura;
  String? numControl;
  double? montoIva;
  String? numeroDocumentoAfectado;
  String? numeroComprobante;
  String? montoExentoIva;
  String? numeroExpediente;

  ComprobanteRetencion({
    this.rifContribuyente,
    this.periodoImpositivo,
    this.fechaDocumento,
    this.tipoOperacion,
    this.tipoDocumento,
    this.organismo,
    this.rifOrganismo,
    this.codUnidadAdministradora,
    this.descUnidadAdministradora,
    this.tipoRetencion,
    this.beneficiario,
    this.rifBeneficiario,
    this.autorizado,
    this.rifAutorizado,
    this.rifVendedor,
    this.numeroDocumento,
    this.numeroControlDocumento,
    this.montoTotalDocumento,
    this.baseImponible,
    this.alicuota,
    this.fechaFactura,
    this.numFactura,
    this.numControl,
    this.montoIva,
    this.numeroDocumentoAfectado,
    this.numeroComprobante,
    this.montoExentoIva,
    this.numeroExpediente,
  });

  factory ComprobanteRetencion.fromJson(Map<String, dynamic> json) => ComprobanteRetencion(
    rifContribuyente: json["RIF_CONTRIBUYENTE"] ?? '',
    periodoImpositivo: json["PERIODO_IMPOSITIVO"] ?? '',
    fechaDocumento: json["FECHA_DOCUMENTO"] ?? '',
    tipoOperacion: json["TIPO_OPERACION"] ?? '',
    tipoDocumento: json["TIPO_DOCUMENTO"] ?? '',
    organismo: json["ORGANISMO"] ?? '',
    rifOrganismo: json["RIF_ORGANISMO"] ?? '',
    codUnidadAdministradora: json["COD_UNIDAD_ADMINISTRADORA"] ?? '',
    descUnidadAdministradora: json["DESC_UNIDAD_ADMINISTRADORA"] ?? '',
    tipoRetencion: json["TIPO_RETENCION"] ?? '',
    beneficiario: json["BENEFICIARIO"] ?? '',
    rifBeneficiario: json["RIF_BENEFICIARIO"] ?? '',
    autorizado: json["AUTORIZADO"] ?? '',
    rifAutorizado: json["RIF_AUTORIZADO"] ?? '',
    rifVendedor: json["RIF_VENDEDOR"] ?? '',
    numeroDocumento: json["NUMERO_DOCUMENTO"] ?? '',
    numeroControlDocumento: json["NUMERO_CONTROL_DOCUMENTO"] ?? '',
    montoTotalDocumento: double.tryParse(json['MONTO_TOTAL_DOCUMENTO'].toString()) ?? 0.0,//(json["MONTO_TOTAL_DOCUMENTO"] as num?)?.toDouble(),
    baseImponible: double.tryParse(json['BASE_IMPONIBLE'].toString()) ?? 0.0,//(json["BASE_IMPONIBLE"] as num?)?.toDouble(),
    alicuota:  double.tryParse(json['ALICUOTA'].toString()) ?? 0.0,//(json["ALICUOTA"] as int)  ?? 0,
    fechaFactura: json["FECHA_FACTURA"] ?? '',
    numFactura: json["NUM_FACTURA"] ?? '',
    numControl: json["NUM_CONTROL"] ?? '',
    montoIva: double.tryParse(json['MONTO_IVA'].toString()) ?? 0.0,
    numeroDocumentoAfectado: json["NUMERO_DOCUMENTO_AFECTADO"] ?? '',
    numeroComprobante: json["NUMERO_COMPROBANTE"] ?? '',
    montoExentoIva: json["MONTO_EXCENTO_IVA"] ?? '',
    numeroExpediente: json["NUMERO_EXPEDIENTE"] ?? '',
  );


}