


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../child/detalles_pendientes/detalles_pendientes.dart';
import '../child/home/home.dart';
import '../child/ordenes_pagadas/ordenes_pagadas.dart';
import '../child/ordenes_pagadas_retenciones/ordenes_pagadas_retenciones.dart';
import '../child/ordenes_pendientes/ordenes_pendientes.dart';

import '../child/retenciones_partidas/retenciones_partidas.dart';
import '../constant/enum_screen_egreso.dart';
import '../service/service.dart';



class ControllerScreenEgreso extends GetxController {

  final sections = <String>[
    "ORDENES PAGADAS",
    "ORDENES PENDIENTES",
    "ORDENES PAGADAS RETENCIONES",
    "RETENCIONES POR PARTIDAS",
    "DETALLES PENDIENTES"
  ].obs;

  final String Titulo="Direccion General de Egreso";
  var addTitle="".obs;


  var currentScreen = AppScreen.home.obs;
  var hasConnection = false.obs;


  final Map<AppScreen, Widget> screenMap = {
    AppScreen.home: Home(),
    AppScreen.ordenes_pagadas: OrdenesPagadas(),
    AppScreen.ordenes_pagadas_retenciones: OrdenesPagadasRetenciones(),
    AppScreen.ordenes_pendientes: OrdenesPendientes(),
    AppScreen.retenciones_partidas:RetencionesPartidas(),
    AppScreen.detalles_pendientes:DetallesPendientes()
  };
  // Cambia la pantalla de forma segura
  void goToScreen(AppScreen screen) {
    if (screenMap.containsKey(screen)) {
      currentScreen.value = screen;
    } else {
      throw Exception("Screen not found in screen map: $screen");
    }
  }
  // Retorna el widget actual según el screen seleccionado
  Widget get currentView => screenMap[currentScreen.value]!;


  @override
  Future<void> onInit() async {
    try {
      final res = await ServiceEgreso.get("api/query/connection");
      hasConnection.value = res['status'] ?? false;
    } catch (e) {
      hasConnection.value = false;
    }
    super.onInit();
  }


}



