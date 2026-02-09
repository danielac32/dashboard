

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../../infrastructure/shared/alert.dart';
import '../../../service/service.dart';
import '../model/dolar_bolivar.dart';
//import '../service/service.dart';

import 'package:excel/excel.dart';

import 'package:file_saver/file_saver.dart'; // Para FileSaver
import 'package:path_provider/path_provider.dart'; // Para getDownloadsDirectory
import 'package:universal_html/html.dart' as html;




class DolarBolivarController extends GetxController {
  var filtro = ''.obs;
  var datos = <DolarBolivar>[].obs;
  var resultados = <DolarBolivar>[].obs;
  var cargando = false.obs;
  final currentPage = 0.obs;
  final itemsPerPage = 20.obs;
  final paginatedResults = <DolarBolivar>[].obs;
  final horizontalScrollController = ScrollController();
  final verticalScrollController = ScrollController();
  var botonCargando = false.obs;
  var fechaDesde = DateTime.now().obs;
  var fechaHasta = DateTime.now().obs;
  var selected = ''.obs;
  List<dynamic> jsonDataAlmacenado=[];//late List<dynamic> jsonDataAlmacenado;


  void clearValue(){
    paginatedResults.clear();
    resultados.clear();
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



  Future<void> cargar(DateTime desde, DateTime hasta) async {
    cargando(true);
    try {

      final fileName = 'ordenes-divisas-bolivares_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx';
      await ServicePlanificacion.downloadExcelReport(
        url: 'api/query/ordenes-divisas-bolivares/excel',
        startDate: DateFormat('dd/MM/yyyy').format(desde),
        endDate: DateFormat('dd/MM/yyyy').format(hasta.add(Duration(days: 1))),
        fileName: fileName,
      );
    } catch (e) {
      SnackbarAlert.error(message: "${e}",durationSeconds: 5);
    }
    cargando(false);
  }

  Future<void> cargar2(DateTime desde, DateTime hasta) async {
    cargando(true);
    try {
      final queryParams = {
        'desde': DateFormat('dd/MM/yyyy').format(desde),
        'hasta': DateFormat('dd/MM/yyyy').format(hasta.add(Duration(days: 1))), // Sumar 1 día
      };
      jsonDataAlmacenado.clear();
      final jsonData = await ServicePlanificacion.post('api/query/ordenes-divisas-bolivares', {}, queryParams: queryParams);
      jsonDataAlmacenado = jsonData as List<dynamic>;

    } catch (e) {
      SnackbarAlert.error(message: "error mientras se cargaba la lista",durationSeconds: 5);

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
      final fileName = 'reporte_dolar_bolivar_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx';

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



  /*
  Future<void> descargarReporte() async {
    if (resultados.isEmpty) {
      SnackbarAlert.error(title: "Advertencia", message: "No hay datos para generar el reporte", durationSeconds: 1);
      return;
    }
    try {
      cargando(true);
      await Future.delayed(Duration(milliseconds: 100));

      final excel = Excel.createExcel();
      final sheet = excel['Sheet1'];

      // Encabezados
      sheet.appendRow([
        TextCellValue("FECHA PAGO"),
        TextCellValue("ESTADO"),
        TextCellValue("MONTO PAGADO"),
        TextCellValue("ESTADO2"),
        TextCellValue("ORDEN"),
        TextCellValue("AÑO"),
        TextCellValue("OBSERVACIÓN"),
        TextCellValue("ORGANISMO"),
        TextCellValue("BENEFICIARIO"),
      ]);

      // Datos
      for (var row in resultados) {
        sheet.appendRow([
          TextCellValue(formatDate(row.pagada) ?? ""),
          IntCellValue(row.estado?? 0),
          DoubleCellValue(row.montoPagado?? 0.0),
          IntCellValue(row.estado2?? 0),
          IntCellValue(row.orden?? 0),
          IntCellValue(row.anho?? 0),
          TextCellValue(row.observacion?? ""),
          TextCellValue(row.organismo?? ""),
          TextCellValue(row.beneficiario?? ""),
        ]);
      }

      // Ancho de columnas
      final columnWidths = {
        0: 15.0, // FECHA PAGO
        1: 10.0, // ESTADO
        2: 14.0, // MONTO PAGADO
        3: 10.0, // ESTADO2
        4: 10.0, // ORDEN
        5: 8.0,  // AÑO
        6: 25.0, // OBSERVACIÓN
        7: 20.0, // ORGANISMO
        8: 30.0, // BENEFICIARIO
      };

      columnWidths.forEach((colIndex, width) {
        sheet.setColumnWidth(colIndex, width);
      });

      // Descargar archivo
      final bytes = excel.encode()!;
      final fileName = 'reporte_dolar_bolivar_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx';

      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();

      html.Url.revokeObjectUrl(url);
      Get.snackbar('Éxito', 'Reporte generado correctamente');

    } catch (e) {
      print('Error al generar Excel: $e');
      Get.snackbar('Error', 'No se pudo generar el reporte en Excel');
    } finally {
      cargando(false);
    }
  }
*/
  int get totalPages => (resultados.length / itemsPerPage.value).ceil();
}