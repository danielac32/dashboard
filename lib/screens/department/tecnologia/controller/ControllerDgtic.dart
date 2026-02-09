import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../intranet/intranet.dart';
import '../child/soporte/soporte.dart';
import '../child/xmltxt/xmltxt.dart';
import '../constant/constant.dart';


class ControllerDgtic extends GetxController {
  final sections = <String>[
    "XML TXT",
    "INTRANET",
    "SOPORTE"
  ].obs;

  final String Titulo="Direccion General de Tecnologia";
  var addTitle="".obs;


  var currentScreen = AppScreen.Soporte.obs;
  var hasConnection = false.obs;
  final Map<AppScreen, Widget> screenMap = {
    AppScreen.XmlTxt: XmlTxt(),
    AppScreen.Intranet : Intranet(),
    AppScreen.Soporte: Soporte()
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