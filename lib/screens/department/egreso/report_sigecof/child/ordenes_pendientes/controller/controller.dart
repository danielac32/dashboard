

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../model/pendiente.dart';
import '../service/service.dart';

import 'package:excel/excel.dart';
import 'package:file_saver/file_saver.dart'; // Para FileSaver
import 'package:path_provider/path_provider.dart'; // Para getDownloadsDirectory
import 'package:universal_html/html.dart' as html;


class EgresoPendienteController extends GetxController {
  var filtro = ''.obs;
  var datos = <Pendiente>[].obs;
  var resultados = <Pendiente>[].obs;
  var cargando = false.obs;
  final currentPage = 0.obs;
  final itemsPerPage = 20.obs;
  final paginatedResults = <Pendiente>[].obs;
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


  Future<void> cargarPendientes(DateTime desde, DateTime hasta) async {
    cargando(true);
    try {
      final queryParams = {
        'desde': DateFormat('dd/MM/yyyy').format(desde),
        'hasta': DateFormat('dd/MM/yyyy').format(hasta),
      };
      final jsonData = await PendienteService.post('api/query/pendientes', {}, queryParams: queryParams);
      final List<Pendiente> datosLista = (jsonData as List).cast<Map<String, dynamic>>().map((item) => Pendiente.fromJson(item)).toList();
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
      await Future.delayed(Duration(milliseconds: 50));

      final excel = Excel.createExcel();
      final sheet = excel['Sheet1'];

      // Encabezados con TextCellValue
      sheet.appendRow([
        TextCellValue("FECHA"),
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
      for (var pendiente in resultados) {
        sheet.appendRow([
          TextCellValue(formatDate(pendiente.fechaModificacion)?? ""),
          IntCellValue(pendiente.estado?? 0 ),
          IntCellValue(pendiente.orden?? 0),
          DoubleCellValue(pendiente.monto?? 0.0),
          TextCellValue(pendiente.fuente?? ""),
          IntCellValue(pendiente.anho?? 0),
          TextCellValue(pendiente.partida?? ""),
          TextCellValue(pendiente.cuenta?? ""),
          TextCellValue(pendiente.organismo?? ""),
          TextCellValue(pendiente.beneficiario?? ""),
          TextCellValue(pendiente.observacion?? ""),
          TextCellValue(pendiente.fondo?? ""),
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
      final fileName = 'reporte_pendientes_${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx';

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