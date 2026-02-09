

import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';


import '../../../../../../../infrastructure/shared/alert.dart';
import '../../../service/service.dart';
import '../model/IncesResponse.dart';
//import '../service/Service.dart';


import 'package:excel/excel.dart';

import 'package:file_saver/file_saver.dart'; // Para FileSaver
import 'package:path_provider/path_provider.dart'; // Para getDownloadsDirectory
import 'package:universal_html/html.dart' as html;





class ParafiscalesIncesController extends GetxController {
  var filtro = ''.obs;
  var datos = <Incesresponse>[].obs;
  //var resultados = <Incesresponse>[].obs;
  var cargando = false.obs;
  final currentPage = 0.obs;
  final itemsPerPage = 20.obs;
  final paginatedResults = <Incesresponse>[].obs;
  final horizontalScrollController = ScrollController();
  final verticalScrollController = ScrollController();
  var botonCargando = false.obs;
  var fechaDesde = DateTime.now().obs;
  var fechaHasta = DateTime.now().obs;
  var selected = ''.obs;
  var jsonDataAlmacenado = <dynamic>[].obs;//List<dynamic> jsonDataAlmacenado=[];//late List<dynamic> jsonDataAlmacenado;




  @override
  void onInit() {
    super.onInit();
    jsonDataAlmacenado.clear();
  }

  @override
  void onClose() {
    horizontalScrollController.dispose();
    verticalScrollController.dispose();
    super.onClose();
  }

  Future<void> cargarInces(DateTime desde, DateTime hasta) async {

    cargando(true);
    try {

      final fileName = 'parafiscales_inces_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx';
      await ServiceCuentaUnica.downloadExcelReport(
        url: 'api/query/parafiscales_inces/excel',
        startDate: DateFormat('dd/MM/yyyy').format(desde),
        endDate: DateFormat('dd/MM/yyyy').format(hasta.add(Duration(days: 1))),
        fileName: fileName,
      );
    } catch (e) {
      SnackbarAlert.error(message: "${e}",durationSeconds: 5);
    }
    cargando(false);
  }


  Future<void> cargarInces2(DateTime desde, DateTime hasta) async {
    cargando(true);
    try {
      final queryParams = {
        'desde': DateFormat('dd/MM/yyyy').format(desde),
        'hasta': DateFormat('dd/MM/yyyy').format(hasta.add(Duration(days: 1))), // Sumar 1 día
      };
      jsonDataAlmacenado.clear();
      final jsonData = await ServiceCuentaUnica.post('api/query/parafiscales_inces', {}, queryParams: queryParams);
      // 👇 Procesar cada item para formatear FECHA_MODIFICACION
      final List<dynamic> datosProcesados = [];
      for (var item in jsonData) {
        if (item is Map<String, dynamic>) {
          final fechaMod = item['FECHA_MODIFICACION'] as String?;
          if (fechaMod != null) {
            item['FECHA_MODIFICACION'] = formatDate(fechaMod);
          }
          // Formatear PAGADAS (asumiendo que también es una cadena de fecha)
          final fechaPagadas = item['PAGADA'] as String?;
          if (fechaPagadas != null) {
            item['PAGADA'] = formatDate(fechaPagadas);
          }

          datosProcesados.add(item);
        } else {
          datosProcesados.add(item);
        }
      }

      jsonDataAlmacenado.assignAll(datosProcesados);

    } catch (e) {
      SnackbarAlert.error(message: "error mientras se cargaba la lista",durationSeconds: 5);
      print(e);
    }
    cargando(false);
  }

/*
  String formatDate(String dateStr) {
    try {
      DateTime date = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(date); // Ejemplo: 15/07/2024
    } catch (e) {
      return dateStr; // Si falla el parseo, devuelve el original
    }
  }
*/

  String formatDate(String dateStr) {
    try {
      DateTime date = DateTime.parse(dateStr);
      return DateFormat('d/M/yyyy').format(date); // Sin ceros iniciales
    } catch (e) {
      return dateStr;
    }
  }



  Future<void> descargarReporte() async {
    cargando(true);

    if (jsonDataAlmacenado.isEmpty) {
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
      final fileName = 'parafiscales_inces_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx';

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