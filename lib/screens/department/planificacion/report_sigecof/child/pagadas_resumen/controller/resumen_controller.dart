

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../../../../infrastructure/shared/alert.dart';
import '../../../service/service.dart';




import 'package:universal_html/html.dart' as html;

import '../model/resumen_model.dart';




class PagadasResumenController extends GetxController {
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
  late String jsonString;


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




  Future<void> cargarPagadasResumen(DateTime desde, DateTime hasta) async {
    cargando(true);
    try {

      final queryParams = {
        'desde': DateFormat('dd/MM/yyyy').format(desde),
        'hasta': DateFormat('dd/MM/yyyy').format(hasta),
      };
      final jsonData = await ServicePlanificacion.post('api/query/pagadas_resumen', {}, queryParams: queryParams);
      final List<PagadasResumen> datosLista = (jsonData as List).cast<Map<String, dynamic>>().map((item) => PagadasResumen.fromJson(item)).toList();
      res(datosLista);
      final listaJson = res.map((item) => item.toJson()).toList();
      jsonDataAlmacenado = listaJson;
    } catch (e) {
      //print('Error aqui: $e');
      SnackbarAlert.error(message: "error mientras se cargaba la lista",durationSeconds: 5);
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
      final fileName = 'resumen_pagadas${DateFormat('yyyyMMdd').format(DateTime.now())}.xlsx';

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