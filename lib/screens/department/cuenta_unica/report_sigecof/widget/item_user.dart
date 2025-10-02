




import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/config/theme/app_theme.dart';
import '../../../../admin/controller/dashboard_menu.dart';
import '../constant/enum_screen_cuenta_unica.dart';
import '../controller/controller.dart';
import '../shared/controller_shared.dart';




class ItemsUser extends StatelessWidget {
  ItemsUser({super.key});

  //final controller = Get.put(ControllerUser());
  final screenController = Get.find<ControllerScreenCuentaUnica>();
  // Mapa que relaciona cada sección con su pantalla correspondiente
  final Map<int, AppScreen> _sectionScreens = {
    0: AppScreen.comprobante_de_retenciones,
    1: AppScreen.parafiscales_banavih,
    2: AppScreen.parafiscales_inces,
    3: AppScreen.parafiscales_ivss,
    4: AppScreen.retenciones,
    5: AppScreen.islr,
  };

  // Método reutilizable para manejar el tap
  void _onItemTap(int index) {
    //final screenController = Get.find<ControllerScreenCuentaUnica>();
    screenController.goToScreen(_sectionScreens[index]!);
    screenController.addTitle.value = "- ${screenController.sections[index]}";
    Get.back(); // Cierra el Drawer
  }

  @override
  Widget build(BuildContext context) {
    //final screenController = Get.find<ControllerScreenCuentaUnica>();
    return ExpansionTile(
      leading: const Icon(Icons.add, color: AppTheme.goldColor),
      title: const Text('Sigecof'),
      children: List.generate(
        screenController.sections.length,
            (index) => ListTile(
          title: Text(screenController.sections[index]),
          leading: const Icon(Icons.report, color: AppTheme.goldColor),
          onTap: () => _onItemTap(index),
        ),
      ),
    );
  }
}