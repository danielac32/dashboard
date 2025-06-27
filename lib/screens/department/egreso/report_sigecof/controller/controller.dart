


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../child/home/home.dart';
import '../child/ordenes_pagadas/ordenes_pagadas.dart';
import '../child/ordenes_pagadas_retenciones/ordenes_pagadas_retenciones.dart';
import '../child/ordenes_pendientes/ordenes_pendientes.dart';
import '../constant/enum_screen_egreso.dart';



class ControllerScreenEgreso extends GetxController {

  var currentScreen = AppScreen.home.obs;
  final Map<AppScreen, Widget> screenMap = {
    AppScreen.home: Home(),
    AppScreen.ordenes_pagadas: OrdenesPagadas(),
    AppScreen.ordenes_pagadas_retenciones: OrdenesPagadasRetenciones(),
    AppScreen.ordenes_pendientes: OrdenesPendientes(),
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
    "ORDENES PAGADAS",
    "ORDENES PENDIENTES",
    "ORDENES PAGADAS RETENCIONES",
  ].obs;


}

