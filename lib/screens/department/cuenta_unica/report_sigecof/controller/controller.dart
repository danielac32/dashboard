


import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../child/comprobante_retenciones/comprobante_retencion.dart';
import '../child/home/home.dart';
import '../child/islr/islr.dart';
import '../child/parafiscales_banavih/banavih.dart';
import '../child/parafiscales_inces/inces.dart';
import '../child/parafiscales_ivss/ivss.dart';
import '../child/retenciones/retencion.dart';
import '../constant/enum_screen_cuenta_unica.dart';
import '../service/service.dart';



class ControllerScreenCuentaUnica extends GetxController {
  final sections = <String>[
    "COMPROBANTES DE RETENCIONES",
    "PARAFISCALES BANAVIH",
    "PARAFISCALES INCES",
    "PARAFISCALES IVSS",
    "RETENCIONES",
    "ISLR"
  ].obs;

  final String Titulo="Direccion General de Cuenta Unica";
  var addTitle="".obs;


  var currentScreen = AppScreen.home.obs;
  var hasConnection = false.obs;
  

  final Map<AppScreen, Widget> screenMap = {
    AppScreen.home: Home(),
    AppScreen.comprobante_de_retenciones: ComprobanteRetencion(),
    AppScreen.parafiscales_banavih: Banavih(),
    AppScreen.parafiscales_inces:Inces(),
    AppScreen.parafiscales_ivss:Ivss(),
    AppScreen.retenciones:Retencion(),
    AppScreen.islr:Islr()
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
      final res = await ServiceCuentaUnica.get("api/query/connection");
      hasConnection.value = res['status'] ?? false;
    } catch (e) {
      hasConnection.value = false;
    }
    super.onInit();
  }

  Future<bool> connection() async{
    bool connection =false;
    try {
      final res = await ServiceCuentaUnica.get("api/query/connection");
      connection = res['status'] ?? false;
    } catch (e) {
      connection = false;
    }
    return connection;
  }

}



 
