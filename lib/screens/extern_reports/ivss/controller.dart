import 'package:core_system/screens/extern_reports/ivss/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import './constant.dart';
import 'child/pagadas/pagadas.dart';
import 'child/pendientes/pendientes.dart';


class ControllerScreenIvss extends GetxController {
  final sections = <String>[
    "Pagadas",
    "Pendientes",
  ].obs;

  final String Titulo="IVSS";
  var addTitle="".obs;

  var currentScreen = AppScreen.pagadas.obs;
  var hasConnection = false.obs;


  final Map<AppScreen, Widget> screenMap = {
    AppScreen.pagadas: Pagadas(),
    AppScreen.pendientes: PendientesIvss()
    /*AppScreen.comprobante_de_retenciones: ComprobanteRetencion(),
    AppScreen.parafiscales_banavih: Banavih(),
    AppScreen.parafiscales_inces:Inces(),
    AppScreen.parafiscales_ivss:Ivss(),
    AppScreen.retenciones:Retencion(),
    AppScreen.islr:Islr(),
    AppScreen.formato_iva_seniat: IvaSeniat(),
    AppScreen.ordenes_devueltas:OrdenesDevueltas()*/
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
      final res = await ServiceIvss.get("api/query/connection");
      hasConnection.value = res['status'] ?? false;
    } catch (e) {
      hasConnection.value = false;
    }
    super.onInit();
  }

  Future<bool> connection() async{
    bool connection =false;
    try {
      final res = await ServiceIvss.get("api/query/connection");
      connection = res['status'] ?? false;
    } catch (e) {
      connection = false;
    }
    return connection;
  }

}


