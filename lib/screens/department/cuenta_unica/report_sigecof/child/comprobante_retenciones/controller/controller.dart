

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../../../infrastructure/shared/alert.dart';
import '../../../service/service.dart';
import '../model/ComprobanteResponse.dart';
import 'package:universal_html/html.dart' as html;


class ComprobanteRetencionController extends GetxController {
  var filtro = ''.obs;
  var datos = <ComprobanteRetencion>[].obs;
  var resultados = <ComprobanteRetencion>[].obs;
  var cargando = false.obs;
  final currentPage = 0.obs;
  final itemsPerPage = 20.obs;
  final paginatedResults = <ComprobanteRetencion>[].obs;
  final horizontalScrollController = ScrollController();
  final verticalScrollController = ScrollController();
  var botonCargando = false.obs;
  var fechaDesde = DateTime.now().obs;
  var fechaHasta = DateTime.now().obs;
  var selected = ''.obs;
  var jsonDataAlmacenado = <dynamic>[].obs;//RxList<dynamic> jsonDataAlmacenado = <dynamic>[].obs;//List<dynamic> jsonDataAlmacenado=[];

  @override
  void onInit() {
    jsonDataAlmacenado.clear();
    super.onInit();
  }

  @override
  void onClose() {
    horizontalScrollController.dispose();
    verticalScrollController.dispose();
    super.onClose();
  }



  Future<void> cargarComprobante(DateTime desde, DateTime hasta) async {
    cargando(true);
    try {

      final fileName = 'comprobante_de_retencion_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx';
      await ServiceCuentaUnica.downloadExcelReport(
        url: 'api/query/comprobante_de_retencion/excel',
        startDate: DateFormat('dd/MM/yyyy').format(desde),
        endDate: DateFormat('dd/MM/yyyy').format(hasta.add(Duration(days: 1))),
        fileName: fileName,
      );
    } catch (e) {
      SnackbarAlert.error(message: "${e}",durationSeconds: 5);
    }
    cargando(false);
  }


  Future<void> cargarComprobante2(DateTime desde, DateTime hasta) async {
    cargando(true);
    try {
      final queryParams = {
        'desde': DateFormat('dd/MM/yyyy').format(desde),
        'hasta': DateFormat('dd/MM/yyyy').format(hasta.add(Duration(days: 1))), // Sumar 1 día
      };
      jsonDataAlmacenado.clear();
      final jsonData = await ServiceCuentaUnica.post('api/query/comprobante_de_retencion', {}, queryParams: queryParams);
      jsonDataAlmacenado.assignAll(jsonData);//jsonDataAlmacenado = jsonData as RxList<dynamic>;
      //final List<ComprobanteRetencion> datosLista = (jsonData).cast<Map<String, dynamic>>().map((item) => ComprobanteRetencion.fromJson(item)).toList();
     // resultados(datosLista);
      //updatePagination();
    } catch (e) {
      print(e);
      SnackbarAlert.error(message: "error mientras se cargaba la lista",durationSeconds: 5);
      //resultados([]);
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



/*
  void updatePagination() {
    final startIndex = currentPage.value * itemsPerPage.value;
    final endIndex = min(startIndex + itemsPerPage.value, resultados.length);
    paginatedResults(resultados.sublist(startIndex, endIndex));
  }

  void nextPage() {
    if ((currentPage.value + 1) * itemsPerPage.value < resultados.length) {
      currentPage(currentPage.value + 1);
      updatePagination();
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage(currentPage.value - 1);
      updatePagination();
    }
  }
*/




  Future<void> descargarReporte() async {
    cargando(true);

    if (jsonDataAlmacenado.isEmpty) {
      SnackbarAlert.warning(title: "Advertencia", message: "No hay datos para generar el reporte", durationSeconds: 1);
      return;
    }
    //await Future.microtask(() {});
    //await Future.delayed(Duration(seconds: 2));
    //await Future.delayed(Duration.zero);
    try {
      // Crear el worker
      final completer = Completer<void>();
      final worker = html.Worker('worker.js');


      // Nombre del archivo
      final fileName = 'comprobante_retenciones_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx';

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


  //int get totalPages => (resultados.length / itemsPerPage.value).ceil();
}