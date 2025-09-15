
class RetencionResponse {
  final int presupuesto;
  final String organismo;
  final String codUnidadAdministradora;
  final String descUnidadAdministradora;
  final int orden;
  final String beneficiario;
  final String denominacion;
  final String rif;
  final double montoOrdenAnt;
  final double montoOrden;
  final double monto1X500Ant;
  final double monto1X500;
  final String fechaPago;
  final String fechaModificacion;

  RetencionResponse({
    required this.presupuesto,
    required this.organismo,
    required this.codUnidadAdministradora,
    required this.descUnidadAdministradora,
    required this.orden,
    required this.beneficiario,
    required this.denominacion,
    required this.rif,
    required this.montoOrdenAnt,
    required this.montoOrden,
    required this.monto1X500Ant,
    required this.monto1X500,
    required this.fechaPago,
    required this.fechaModificacion,
  });

  factory RetencionResponse.fromJson(Map<String, dynamic> json) {
    return RetencionResponse(
      presupuesto: int.tryParse(json['PRESUPUESTO'].toString()) ?? 0,
      organismo: json['ORGANISMO']?.toString() ?? '',
      codUnidadAdministradora: json['COD_UNIDAD_ADMINISTRADORA']?.toString() ?? '',
      descUnidadAdministradora: json['DESC_UNIDAD_ADMINISTRADORA']?.toString() ?? '',
      orden: int.tryParse(json['ORDEN'].toString()) ?? 0,
      beneficiario: json['BENEFICIARIO']?.toString() ?? '',
      denominacion: json['DENOMINACION']?.toString() ?? '',
      rif: json['RIF']?.toString() ?? '',
      montoOrdenAnt: double.tryParse(json['MONTO_ORDEN_ANT'].toString()) ?? 0.0,
      montoOrden: double.tryParse(json['MONTO_ORDEN'].toString()) ?? 0.0,
      monto1X500Ant: double.tryParse(json['MONTO_1_X_500_ANT'].toString()) ?? 0.0,
      monto1X500: double.tryParse(json['MONTO_1_X_500'].toString()) ?? 0.0,
      fechaPago: json['FECHA_PAGO']?.toString() ?? '',
      fechaModificacion: json['FECHA_MODIFICACION']?.toString() ?? '',
    );
  }


}

