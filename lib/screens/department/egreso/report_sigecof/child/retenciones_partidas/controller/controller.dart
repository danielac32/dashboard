

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';



import 'package:excel/excel.dart';

import 'package:file_saver/file_saver.dart'; // Para FileSaver
import 'package:path_provider/path_provider.dart'; // Para getDownloadsDirectory
import 'package:universal_html/html.dart' as html;

import '../../../../../../../infrastructure/shared/alert.dart';
import '../../../service/service.dart';
import '../model/retencionesPartidas.dart';
//import '../service/service.dart';





class EgresoRetencionesPartidasController extends GetxController {
  var filtro = ''.obs;
  var datos = <RetencionesPartidas>[].obs;
  var resultados = <RetencionesPartidas>[].obs;
  var cargando = false.obs;
  final currentPage = 0.obs;
  final itemsPerPage = 20.obs;
  final paginatedResults = <RetencionesPartidas>[].obs;
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


  Future<void> cargarRetencionesPartidas(DateTime desde, DateTime hasta) async {
    cargando(true);
    try {
      final queryParams = {
        'desde': DateFormat('dd/MM/yyyy').format(desde),
        'hasta': DateFormat('dd/MM/yyyy').format(hasta),
      };
      final jsonData = await ServiceEgreso.post('api/query/retenciones-partidas', {}, queryParams: queryParams);
      final List<RetencionesPartidas> datosLista = (jsonData as List).cast<Map<String, dynamic>>().map((item) => RetencionesPartidas.fromJson(item)).toList();
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
    if (resultados.isEmpty) {
      SnackbarAlert.error(title: "Advertencia", message: "No hay datos para generar el reporte", durationSeconds: 1);
      return;
    }
    try {
      cargando(true);
      await Future.delayed(Duration(milliseconds: 100));

      final excel = Excel.createExcel();
      final sheet = excel['Sheet1'];

      // Encabezados con TextCellValue
      sheet.appendRow([
        TextCellValue("PRESUPUESTO"),
        TextCellValue("MONTO_1_X_500_ANT"),
        TextCellValue("FUENTE"),
        TextCellValue("MONTO_ORDEN"),
        TextCellValue("MONTO_1_X_500"),
        TextCellValue("OBSERVACION"),
        TextCellValue("ORGANISMO"),
        TextCellValue("MONTO_ORDEN_ANT"),
        TextCellValue("BENEFICIARIO"),
        TextCellValue("RIF"),
        TextCellValue("ORDEN"),
        TextCellValue("DENOMINACION"),
        TextCellValue("FECHA_PAGO"),
        TextCellValue("PARTIDA"),
      ]);

      // Datos con tipos correctos
      for (var row in resultados) {
        sheet.appendRow([
          IntCellValue(row.presupuesto ?? 0),         // int? presupuesto
          DoubleCellValue(row.monto1x500Ant ?? 0.0),  // double? monto1x500Ant
          TextCellValue(row.fuente ?? ""),            // String? fuente
          DoubleCellValue(row.montoOrden ?? 0.0),     // double? montoOrden
          DoubleCellValue(row.monto1x500 ?? 0.0),     // double? monto1x500
          TextCellValue(row.observacion ?? ""),       // String? observacion
          TextCellValue(row.organismo ?? ""),         // String? organismo
          DoubleCellValue(row.montoOrdenAnt ?? 0.0),  // double? montoOrdenAnt
          TextCellValue(row.beneficiario ?? ""),      // String? beneficiario
          TextCellValue(row.rif ?? ""),               // String? rif
          IntCellValue(row.orden ?? 0),               // int? orden
          TextCellValue(row.denominacion ?? ""),      // String? denominacion
          TextCellValue(row.fechaPago ?? ""),         // String? fechaPago
          TextCellValue(row.partida ?? ""),           // String? partida
        ]);
      }

      // Ancho de columnas
      final columnWidths = {
        0: 8.0,
        1: 10.0,
        2: 15.0,
        3: 15.0,
        4: 15.0,
        5: 20.0,
        6: 25.0,
        7: 30.0,
        8: 15.0,
        9: 15.0,
        10: 18.0,
        11: 18.0,
        12: 25.0,
        13: 15.0,
      };

      columnWidths.forEach((colIndex, width) {
        sheet.setColumnWidth(colIndex, width);
      });

      final bytes = excel.encode()!;
      final fileName = 'reporte_rentenciones_pagadas_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx';

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