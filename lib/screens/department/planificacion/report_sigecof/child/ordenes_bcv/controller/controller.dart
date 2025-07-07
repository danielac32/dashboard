

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


import '../../../service/service.dart';
import '../model/bcv.dart';


import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart'; // Para FileSaver
import 'package:path_provider/path_provider.dart'; // Para getDownloadsDirectory
import 'package:universal_html/html.dart' as html;


class BCVController extends GetxController {
  var filtro = ''.obs;
  var datos = <Bcv>[].obs;
  var resultados = <Bcv>[].obs;
  var cargando = false.obs;
  final currentPage = 0.obs;
  final itemsPerPage = 20.obs;
  final paginatedResults = <Bcv>[].obs;
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
      final jsonData = await ServicePlanificacion.post('api/query/transmisiones', {}, queryParams: queryParams);
      final List<Bcv> datosLista = (jsonData as List).cast<Map<String, dynamic>>().map((item) => Bcv.fromJson(item)).toList();
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
        TextCellValue("FECHA VALOR"),
        TextCellValue("MONTO TOTAL"),
        TextCellValue("DENOMINACIÓN"),
        TextCellValue("PAGO ID"),
        TextCellValue("ORGA ID"),
      ]);

      // Datos
      for (var row in resultados) {
        sheet.appendRow([
          TextCellValue(formatDate(row.fechaValor?? "") ?? ""),
          DoubleCellValue(row.montoTotal ?? 0.0),
          TextCellValue(row.denominacion ?? ""),
          IntCellValue(row.pagoId ?? 0),
          TextCellValue(row.orgaId ?? ""),
        ]);
      }

      // Ancho de columnas
      final columnWidths = {
        0: 15.0, // FECHA VALOR
        1: 12.0, // MONTO TOTAL
        2: 25.0, // DENOMINACIÓN
        3: 10.0, // PAGO ID
        4: 12.0, // ORGA ID
      };

      columnWidths.forEach((colIndex, width) {
        sheet.setColumnWidth(colIndex, width);
      });

      // Descargar archivo
      final bytes = excel.encode()!;
      final fileName = 'reporte_bcv_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx';

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