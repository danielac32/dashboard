

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../model/dolar_bolivar.dart';
import '../service/service.dart';

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

  @override
  void onInit() {

    super.onInit();
  }

  @override
  void onClose() {
    horizontalScrollController.dispose();
    verticalScrollController.dispose();
    super.onClose();
  }


  Future<void> cargar(DateTime desde, DateTime hasta) async {
    cargando(true);
    try {
      final queryParams = {
        'desde': DateFormat('dd/MM/yyyy').format(desde),
        'hasta': DateFormat('dd/MM/yyyy').format(hasta),
      };
      final jsonData = await DolarBolivarService.post('api/query/ordenes-divisas-bolivares', {}, queryParams: queryParams);
      final List<DolarBolivar> datosLista = (jsonData as List).cast<Map<String, dynamic>>().map((item) => DolarBolivar.fromJson(item)).toList();
      resultados(datosLista);
      updatePagination();
    } catch (e) {
      print('Error: $e');
      resultados([]);
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
    try {
      cargando(true);
      await Future.delayed(Duration(microseconds: 50));

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

  int get totalPages => (resultados.length / itemsPerPage.value).ceil();
}