class PagoRetenciones {
  int? presupuesto;
  double? monto1x500Ant;
  int? montoOrden;
  double? monto1x500;
  String? organismo;
  int? montoOrdenAnt;
  String? beneficiario;
  String? rif;
  String? descUnidadAdministradora;
  int? orden;
  String? denominacion;
  String? codUnidadAdministradora;
  String? fechaPago;

  PagoRetenciones({
    this.presupuesto,
    this.monto1x500Ant,
    this.montoOrden,
    this.monto1x500,
    this.organismo,
    this.montoOrdenAnt,
    this.beneficiario,
    this.rif,
    this.descUnidadAdministradora,
    this.orden,
    this.denominacion,
    this.codUnidadAdministradora,
    this.fechaPago,
  });

  factory PagoRetenciones.fromJson(Map<String, dynamic> json) {
    return PagoRetenciones(
      presupuesto: json['PRESUPUESTO'] != null ? int.tryParse(json['PRESUPUESTO'].toString()) : null,
      monto1x500Ant: json['MONTO_1_X_500_ANT'] != null ? double.tryParse(json['MONTO_1_X_500_ANT'].toString()) : null,
      montoOrden: json['MONTO_ORDEN'] != null ? int.tryParse(json['MONTO_ORDEN'].toString()) : null,
      monto1x500: json['MONTO_1_X_500'] != null ? double.tryParse(json['MONTO_1_X_500'].toString()) : null,
      organismo: json['ORGANISMO']?.toString(),
      montoOrdenAnt: json['MONTO_ORDEN_ANT'] != null ? int.tryParse(json['MONTO_ORDEN_ANT'].toString()) : null,
      beneficiario: json['BENEFICIARIO']?.toString(),
      rif: json['RIF']?.toString(),
      descUnidadAdministradora: json['DESC_UNIDAD_ADMINISTRADORA']?.toString(),
      orden: json['ORDEN'] != null ? int.tryParse(json['ORDEN'].toString()) : null,
      denominacion: json['DENOMINACION']?.toString(),
      codUnidadAdministradora: json['COD_UNIDAD_ADMINISTRADORA']?.toString(),
      fechaPago: json['FECHA_PAGO']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PRESUPUESTO'] = presupuesto;
    data['MONTO_1_X_500_ANT'] = monto1x500Ant;
    data['MONTO_ORDEN'] = montoOrden;
    data['MONTO_1_X_500'] = monto1x500;
    data['ORGANISMO'] = organismo;
    data['MONTO_ORDEN_ANT'] = montoOrdenAnt;
    data['BENEFICIARIO'] = beneficiario;
    data['RIF'] = rif;
    data['DESC_UNIDAD_ADMINISTRADORA'] = descUnidadAdministradora;
    data['ORDEN'] = orden;
    data['DENOMINACION'] = denominacion;
    data['COD_UNIDAD_ADMINISTRADORA'] = codUnidadAdministradora;
    data['FECHA_PAGO'] = fechaPago;
    return data;
  }
}