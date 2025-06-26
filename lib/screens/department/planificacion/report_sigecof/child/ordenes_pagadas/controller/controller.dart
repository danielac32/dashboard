

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../../shared/excel_export_service.dart';
import '../model/pago.dart';
import '../service/Service.dart';


import 'package:excel/excel.dart';

import 'package:file_saver/file_saver.dart'; // Para FileSaver
import 'package:path_provider/path_provider.dart'; // Para getDownloadsDirectory
import 'package:universal_html/html.dart' as html;




class ReportsController extends GetxController {
  final RxList<String> list = <String>[].obs;

  /*Future<void> loadListReports() async {
    try {
      final jsonData = await PlanificacionService.get('api/query/available-reports');
      final res = AvailableReports.fromJson(jsonData);
      list.assignAll(res.availableReports ?? []);
    } catch (e) {
      list.assignAll([]); // Asigna lista vacía en caso de error
      print('Error loading reports: $e');
    }
  }*/

  @override
  Future<void> onInit() async {
    //await loadListReports();
    super.onInit();
  }
}

class PagoController extends GetxController {
  var filtro = ''.obs;
  var datos = <Pago>[].obs;
  var resultados = <Pago>[].obs;
  var cargando = false.obs;
  final currentPage = 0.obs;
  final itemsPerPage = 20.obs;
  final paginatedResults = <Pago>[].obs;
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
      final jsonData = await PlanificacionService.post('api/query/pagadas', {}, queryParams: queryParams);
      final List<Pago> datosLista = (jsonData as List).cast<Map<String, dynamic>>().map((item) => Pago.fromJson(item)).toList();
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



  void aplicarFiltro(String nuevoFiltro) async {
    cargando(true);
    await Future.delayed(const Duration(milliseconds: 300));

    filtro(nuevoFiltro);
    List<Pago> resultadosFiltrados = [];

    if (nuevoFiltro.isEmpty) {
      resultadosFiltrados = datos;
    } else {
      switch (nuevoFiltro.toLowerCase()) {
        case 'pendientes':
          resultadosFiltrados = datos.where((p) => p.estado.toString().toLowerCase().contains('pendiente')).toList();
          break;
        case 'pagadas':
          resultadosFiltrados = datos.where((p) => p.estado.toString().toLowerCase().contains('pagada')).toList();
          break;
        case 'retenciones':
          resultadosFiltrados = datos.where((p) => p.monto > 1000).toList();
          break;
        default:
        // Búsqueda flexible si no coincide con los casos anteriores
          resultadosFiltrados = datos.where((p) =>
          p.organismo.toLowerCase().contains(nuevoFiltro.toLowerCase()) ||
              p.beneficiario.toLowerCase().contains(nuevoFiltro.toLowerCase()) ||
              p.observacion.toLowerCase().contains(nuevoFiltro.toLowerCase())
          ).toList();
      }
    }

    resultados(resultadosFiltrados);
    currentPage(0);
    updatePagination();
    cargando(false);
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

      // Encabezados con TextCellValue
      sheet.appendRow([
        TextCellValue("FECHA PAGO"),
        TextCellValue("ESTADO"),
        TextCellValue("ORDEN"),
        TextCellValue("MONTO"),
        TextCellValue("FUENTE"),
        TextCellValue("AÑO"),
        TextCellValue("PARTIDA"),
        TextCellValue("CUENTA"),
        TextCellValue("ORGANISMO"),
        TextCellValue("BENEFICIARIO"),
        TextCellValue("OBSERVACIÓN"),
        TextCellValue("FONDO"),
      ]);

      // Datos con tipos correctos
      for (var row in resultados) {
        sheet.appendRow([
          TextCellValue(formatDate(row.pagada) ?? ""),
          IntCellValue(row.estado ?? 0),
          IntCellValue(row.orden ?? 0),
          DoubleCellValue(row.monto ?? 0.0),
          TextCellValue(row.fuente ?? ""),
          IntCellValue(row.anho ?? 0),
          TextCellValue(row.partida ?? ""),
          TextCellValue(row.cuenta ?? ""),
          TextCellValue(row.organismo ?? ""),
          TextCellValue(row.beneficiario ?? ""),
          TextCellValue(row.observacion ?? ""),
          TextCellValue(row.fondo ?? "") ,
        ]);
      }

      // Ancho de columnas
      final columnWidths = {
        0: 15.0,
        1: 10.0,
        2: 10.0,
        3: 12.0,
        4: 15.0,
        5: 8.0,
        6: 10.0,
        7: 12.0,
        8: 20.0,
        9: 25.0,
        10: 30.0,
        11: 15.0,
      };

      columnWidths.forEach((colIndex, width) {
        sheet.setColumnWidth(colIndex, width);
      });

      final bytes = excel.encode()!;
      final fileName = 'reporte_pagadas_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx';

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