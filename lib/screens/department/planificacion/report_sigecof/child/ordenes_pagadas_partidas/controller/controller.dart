

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../../infrastructure/shared/alert.dart';
import '../../../service/service.dart';




import 'package:universal_html/html.dart' as html;

import '../../ordenes_pagadas/model/pagadas.dart';
import '../model/resumen.dart';


class PagadasPartidasController extends GetxController {
  var filtro = ''.obs;
  var cargando = false.obs;
  final horizontalScrollController = ScrollController();
  final verticalScrollController = ScrollController();
  var botonCargando = false.obs;
  var fechaDesde = DateTime.now().obs;
  var fechaHasta = DateTime.now().obs;
  var selected = ''.obs;
  List<dynamic> jsonDataAlmacenado=[];//late List<dynamic> jsonDataAlmacenado;
  var res=[].obs;

  final Map<int, String> ministerios = {
     1:	'Asamblea Nacional',
     2:	'Contraloría General de la República',
     3:	'Consejo Nacional Electoral',
     6:	'Ministerio del Poder Popular para Relaciones Exteriores',
     8:	'Ministerio del Poder Popular para la Defensa',
    10:	'Ministerio del Poder Popular para la Educacion',
    13:	'Ministerio del Poder Popular para el Proceso Social de Trabajo',
    21:	'Tribunal Supremo de Justicia',
    23:	'Ministerio Público',
    25:	'Procuraduría General de la República',
    26:	'Ministerio del Poder Popular para Relaciones Interiores, Justicia y Paz',
    32:	'Defensoría del Pueblo',
    33:	'Vicepresidencia de la República',
    34:	'Ministerio del Poder Popular para la Agricultura Productiva y Tierras',
    36:	'Ministerio del Poder Popular para la Comunicación e Información',
    37:	'Ministerio del Poder Popular del Despacho de la Presidencia y Seguimiento de la Gestión de Gobierno',
    38:	'Consejo Moral Republicano',
    39: 'Superintendencia Nacional de Auditoría Interna',
    41: 'Ministerio del Poder Popular para la Alimentación',
    44: 'Ministerio del Poder Popular para el Turismo',
    45: 'Ministerio del Poder Popular de Hidrocarburos',
    46: 'Ministerio del Poder Popular para la Cultura',
    52: 'Ministerio del Poder Popular Para Los Pueblos Indígenas',
    54: 'Ministerio del Poder Popular para la Salud',
    57: 'Ministerio del Poder Popular para las Comunas, Movimientos Sociales y Agricultura Urbana',
    58: 'Ministerio del Poder Popular para la Mujer y la Igualdad de Género',
    59: 'Ministerio del Poder Popular para la Energía Eléctrica',
    63: 'Consejo Federal de Gobierno',
    65: 'Ministerio del Poder Popular para el Servicio Penitenciario',
    69: 'Defensa Pública',
    71: 'Ministerio del Poder Popular de Planificación',
    72: 'Ministerio del Poder Popular para la Educación Universitaria',
    74: 'Ministerio del Poder Popular para la Juventud y el Deporte',
    75: 'Ministerio del Poder Popular para el Ecosocialismo',
    76: 'Ministerio del Poder Popular para Hábitat y Vivienda',
    79: 'Ministerio del Poder Popular para el Comercio Exterior e Inversión Internacional',
    80: 'Ministerio del Poder Popular de Pesca y Acuicultura',
    82: 'Ministerio del Poder Popular de Agricultura Urbana',
    84: 'Vicepresidencia Sectorial del Socialismo Social y Territorial',
    85: 'Ministerio del Poder Popular de Industrias y Producción Nacional',
    86: 'Ministerio del Poder Popular de Desarrollo Minero Ecológico',
    87: 'Vicepresidencia Sectorial de Economía',
    88: 'Vicepresidencia Sectorial de Defensa y Soberanía',
    90: 'Vicepresidencia Sectorial de Obras Públicas y Servicios',
    91: 'Ministerio del Poder Popular para el Transporte',
    92: 'Ministerio del Poder Popular de Obras Públicas',
    93: 'Ministerio del Poder Popular de Economía y Finanzas',
    94: 'Asamblea Nacional Constituyente',
    96: 'Comisión para la Verdad, la Justicia, la Paz y la Tranquilidad Pública',
    97: 'Ministerio del Poder Popular de Atención de las Aguas',
    100: 'Ministerio del Poder Popular de Comercio Nacional',
    101: 'Ministerio del Poder Popular para la Ciencia y Tecnología',
    102: 'Ministerio del Poder Popular Para el Turismo',
    104: 'Vicepresidencia Sectorial de Política, Seguridad Ciudadana y Paz',
    105: 'Vicepresidencia Sectorial de Ciencia, Tecnología, Educación y Salud',
    106: 'Ministerio del Poder Popular para los Adultos y Adultas Mayores, Abuelos y Abuelas de la Patria',
    107: 'Ministerio del Poder Popular para el Deporte',
    108: 'Ministerio del Poder Popular para la Juventud',
  };

  void clearValue(){
    jsonDataAlmacenado.clear();
  }

  @override
  void onInit() {
    clearValue();
    super.onInit();
  }

  @override
  void onClose() {
    clearValue();
    horizontalScrollController.dispose();
    verticalScrollController.dispose();
    super.onClose();
  }



  int get_alias_partida(int num){
    List<int> list = [401,402,403,404,405,406,407,408,409,410,411];
    for (int i=0;i<list.length;i++ ) {
      if(list[i]==num)return i;
    }
    return -1;
  }

  List<ResumenOrganismoPartida> process_pagadas_partidas(List<PagoPagadas> list){

    int count=0;
    List<double> partidas = List.filled(11, 0.0);
    List<ResumenOrganismoPartida> resumen=[];

    for(var org in ministerios.entries) //recorrer los organismos
    {
      for (final pago in list) {
        if (org.key == int.parse(pago.organismo)) {
          int index = get_alias_partida(int.parse(pago.partida));
          if (index != -1 && pago.montoNeto.isFinite) {
            partidas[index] += pago.montoNeto;
          }
          count++;
        }
      }

      if(count > 0){
        //print('${org.value} - $count');
        double total=0;
        for (int i = 0; i < partidas.length; i++) {
            //if(partidas[i] > 0) print('Partida ${400 + i*1}: ${partidas[i]}');
          if (partidas[i].isFinite) {
            total += partidas[i];
          }
        }

        final orga=ResumenOrganismoPartida( organismo: org.key.toString(),
                                            partida401: partidas[0].isFinite ? partidas[0] : 0.0,
                                            partida402: partidas[1].isFinite ? partidas[1] : 0.0,
                                            partida403: partidas[2].isFinite ? partidas[2] : 0.0,
                                            partida404: partidas[3].isFinite ? partidas[3] : 0.0,
                                            partida405: partidas[4].isFinite ? partidas[4] : 0.0,
                                            partida406: partidas[5].isFinite ? partidas[5] : 0.0,
                                            partida407: partidas[6].isFinite ? partidas[6] : 0.0,
                                            partida408: partidas[7].isFinite ? partidas[7] : 0.0,
                                            partida409: partidas[8].isFinite ? partidas[8] : 0.0,
                                            partida410: partidas[9].isFinite ? partidas[9] : 0.0,
                                            partida411: partidas[10].isFinite ? partidas[10] : 0.0,
                                            total: total.isFinite ? total : 0.0);
        resumen.add(orga);
      }
      //borrar variables
      for(int i = 0; i < partidas.length; i++) {
          partidas[i] = 0.0;
      }
      count=0;
    }
    return resumen;
  }


  Future<void> cargarPagadasPartidas(DateTime desde, DateTime hasta) async {
    cargando(true);
    try {

      final queryParams = {
        'desde': DateFormat('dd/MM/yyyy').format(desde),
        'hasta': DateFormat('dd/MM/yyyy').format(hasta),
      };
      final jsonData = await ServicePlanificacion.post('api/query/pagadas2', {}, queryParams: queryParams);
      final List<PagoPagadas> datosLista = (jsonData as List).cast<Map<String, dynamic>>().map((item) => PagoPagadas.fromJson(item)).toList();

      /*List<ResumenOrganismoPartida>*/
      res(process_pagadas_partidas(datosLista));
      res.forEach((org) {
         print('-> $org');
      });

    } catch (e) {
      print('Error aqui: $e');
      res([]);
    }
    cargando(false);
  }


  String formatDate(String dateStr) {
    try {
      DateTime date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date); // Ejemplo: 15/07/2024
    } catch (e) {
      return dateStr; // Si falla el parseo, devuelve el original
    }
  }


  Future<void> descargarReporte() async {
    cargando(true);

    if (res.isEmpty) {
      SnackbarAlert.warning(title: "Advertencia", message: "No hay datos para generar el reporte", durationSeconds: 1);
      return;
    }
    await Future.microtask(() {});
    await Future.delayed(Duration(seconds: 2));
    //await Future.delayed(Duration.zero);
    try {
      // Crear el worker
      final completer = Completer<void>();
      final worker = html.Worker('worker.js');


      // Nombre del archivo
      final fileName = 'ordenes_pagadas_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx';

      // Escuchar respuesta del worker
      worker.onMessage.listen((event) {
        try {
          final response = event.data as Map;
          final blob = response['blob'] as html.Blob;
          final filename = response['filename'] as String;

          final url = html.Url.createObjectUrlFromBlob(blob);
          final anchor = html.AnchorElement()
            ..href = url
            ..download = filename
            ..click();
          html.Url.revokeObjectUrl(url);

          SnackbarAlert.success(message: "Reporte generado correctamente");
          completer.complete(); // Indicar que el proceso ha terminado
        } catch (e) {
          completer.completeError(e); // Pasar cualquier error
        }
      });
      worker.onError.listen((error) {
        completer.completeError(error);
      });
      // Enviar mensaje al worker
      worker.postMessage(<String, dynamic>{
        'data': jsonDataAlmacenado,
        'filename': fileName,
      });
      await completer.future;
    } catch (e, stackTrace) {
      print('Error generando reporte: $e\n$stackTrace');
      SnackbarAlert.error(title: "Oops!", message: "No se pudo generar el reporte en Excel", durationSeconds: 1);
    }finally{
      cargando(false);
    }
  }
}