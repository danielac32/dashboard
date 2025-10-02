
import 'package:core_system/screens/department/planificacion/report_sigecof/service/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../child/dolares_bolivares/dolares_bolivares.dart';
import '../child/home/home.dart';
import '../child/ordenes_bcv/ordenes_bcv.dart';
import '../child/ordenes_pagadas/ordenes_pagadas.dart';
import '../child/ordenes_pagadas_partidas/ordenes_pagadas_partidas.dart';
import '../child/ordenes_pendientes/ordenes_pendientes.dart';
import '../child/pagadas_resumen/model/resumen_model.dart';
import '../child/pagadas_resumen/pagadas_resumen.dart';
import '../constant/enum_screen_planificacion.dart';



class ControllerScreenPlanificacion extends GetxController {


  final sections = <String>[
    //"HOME",
    "ORDENES TRANSMITIDAS BCV",
    "ORDENES PAGADAS",
    "ORDENES PENDIENTES",
    "DOLARES A BOLIVARES",
    "ORDENES PAGADAS POR PARTIDAS",
    "PAGADAS RESUMEN"
  ].obs;

  final String Titulo="Direccion de Planificacion";
  var addTitle="".obs;


  var hasConnection = false.obs;
  var currentScreen = AppScreen.home.obs;
  final Map<AppScreen, Widget> screenMap = {
    AppScreen.home: Home(),
    AppScreen.ordenes_pagadas: OrdenesPagadas(),
    AppScreen.dolares_a_blivares: DolaresBolivares(),
    AppScreen.ordenes_pendientes: OrdenesPendientes(),
    AppScreen.ordenes_trasmitidas_bcv: OrdenesBcv(),//ordenes_bcv
    //AppScreen.ordenes_pagadas_partidas: OrdenesPagadasPartidas(),
    AppScreen.pagadas_resumen:ResumenPagadas()
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
      final res = await ServicePlanificacion.get("api/query/connection");
      hasConnection.value = res['status'] ?? false;
    } catch (e) {
      print("no se pudo conectar");
      hasConnection.value = false;
    }
    super.onInit();
  }

}

