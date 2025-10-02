import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../child/xmltxt/xmltxt.dart';
import '../constant/constant.dart';


class ControllerDgtic extends GetxController {
  final sections = <String>[
    "XML TXT",
  ].obs;

  final String Titulo="Direccion General de Tecnologia";
  var addTitle="".obs;


  var currentScreen = AppScreen.XmlTxt.obs;
  var hasConnection = false.obs;
  final Map<AppScreen, Widget> screenMap = {
    AppScreen.XmlTxt: XmlTxt()
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