


import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';


import '../../../../../../../infrastructure/shared/alert.dart';
import '../../../service/service.dart';
import '../model/pago_retenciones.dart';
//import '../service/Service.dart';


import 'package:excel/excel.dart';

import 'package:file_saver/file_saver.dart'; // Para FileSaver
import 'package:path_provider/path_provider.dart'; // Para getDownloadsDirectory
import 'package:universal_html/html.dart' as html;




class EgresoOrdenesPagadasRetencionesController extends GetxController {
  var filtro = ''.obs;
  var datos = <PagoRetenciones>[].obs;
  var resultados = <PagoRetenciones>[].obs;
  var cargando = false.obs;
  final currentPage = 0.obs;
  final itemsPerPage = 20.obs;
  final paginatedResults = <PagoRetenciones>[].obs;
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


  Future<void> cargarPagadas(DateTime desde, DateTime hasta) async {
    cargando(true);
    try {

      final queryParams = {
        'desde': DateFormat('dd/MM/yyyy').format(desde),
        'hasta': DateFormat('dd/MM/yyyy').format(hasta),
      };
      final jsonData = await ServiceEgreso.post('api/query/pagadas-retenciones', {}, queryParams: queryParams);
      final List<PagoRetenciones> datosLista = (jsonData as List).cast<Map<String, dynamic>>().map((item) => PagoRetenciones.fromJson(item)).toList();
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
      await Future.delayed(Duration( milliseconds: 100));

      final excel = Excel.createExcel();
      final sheet = excel['Sheet1'];

      sheet.appendRow([
        TextCellValue("PRESUPUESTO"),
        TextCellValue("MONTO 1X500 ANT"),
        TextCellValue("MONTO ORDEN"),
        TextCellValue("MONTO 1X500"),
        TextCellValue("ORGANISMO"),
        TextCellValue("MONTO ORDEN ANT"),
        TextCellValue("BENEFICIARIO"),
        TextCellValue("RIF"),
        TextCellValue("DESC. UNIDAD ADMIN"),
        TextCellValue("ORDEN"),
        TextCellValue("DENOMINACIÓN"),
        TextCellValue("COD. UNIDAD ADMIN"),
        TextCellValue("FECHA PAGO"),
        TextCellValue("OBSERVACIÓN"),
      ]);

// Datos con tipos correctos para todos los campos
      for (var row in resultados) {
        sheet.appendRow([
          IntCellValue(row.presupuesto ?? 0),
          DoubleCellValue(row.monto1x500Ant ?? 0.0),
          IntCellValue(row.montoOrden ?? 0),
          DoubleCellValue(row.monto1x500 ?? 0.0),
          TextCellValue(row.organismo ?? ""),
          IntCellValue(row.montoOrdenAnt ?? 0),
          TextCellValue(row.beneficiario ?? ""),
          TextCellValue(row.rif ?? ""),
          TextCellValue(row.descUnidadAdministradora ?? ""),
          IntCellValue(row.orden ?? 0),
          TextCellValue(row.denominacion ?? ""),
          TextCellValue(row.codUnidadAdministradora ?? ""),
          TextCellValue(row.fechaPago ?? ""),
          TextCellValue(row.observacion ?? ""),
        ]);
      }

// Ajuste de anchos de columnas para todos los campos
      final columnWidths = {
        0: 12.0,   // PRESUPUESTO
        1: 15.0,   // MONTO 1X500 ANT
        2: 12.0,   // MONTO ORDEN
        3: 12.0,   // MONTO 1X500
        4: 25.0,   // ORGANISMO
        5: 15.0,   // MONTO ORDEN ANT
        6: 30.0,   // BENEFICIARIO
        7: 15.0,   // RIF
        8: 25.0,   // DESC. UNIDAD ADMIN
        9: 10.0,   // ORDEN
        10: 40.0,  // DENOMINACIÓN
        11: 15.0,  // COD. UNIDAD ADMIN
        12: 15.0,  // FECHA PAGO
        13: 15.0,  // FECHA PAGO
      };

      columnWidths.forEach((colIndex, width) {
        sheet.setColumnWidth(colIndex, width);
      });

      final bytes = excel.encode()!;
      final fileName = 'reporte_pagadas_retencion${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx';

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