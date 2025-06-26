
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../child/dolares_bolivares/dolares_bolivares.dart';
import '../child/home/home.dart';
import '../child/ordenes_bcv/ordenes_bcv.dart';
import '../child/ordenes_pagadas/ordenes_pagadas.dart';
import '../child/ordenes_pendientes/ordenes_pendientes.dart';
import '../constant/enum_screen_planificacion.dart';



class ControllerScreenPlanificacion extends GetxController {

  var currentScreen = AppScreen.home.obs;
  final Map<AppScreen, Widget> screenMap = {
    AppScreen.home: Home(),
    AppScreen.ordenes_pagadas: OrdenesPagadas(),
    AppScreen.dolares_a_blivares: DolaresBolivares(),
    AppScreen.ordenes_pendientes: OrdenesPendientes(),
    AppScreen.ordenes_trasmitidas_bcv: OrdenesBcv(),//ordenes_bcv
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
}


class ControllerUser extends GetxController {
  final sections = <String>[
    "ORDENES TRANSMITIDAS BCV",
    "ORDENES PAGADAS",
    "ORDENES PENDIENTES",
    "DOLARES A BOLIVARES",
  ].obs;


}

