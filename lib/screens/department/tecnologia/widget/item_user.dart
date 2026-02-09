


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/config/theme/app_theme.dart';
import '../constant/constant.dart';
import '../controller/ControllerDgtic.dart';


class ItemsUser extends StatelessWidget {
  ItemsUser({super.key});

  //final controller = Get.put(ControllerUser());
  final screenController = Get.find<ControllerDgtic>();
  // Mapa que relaciona cada sección con su pantalla correspondiente
  final Map<int, AppScreen> _sectionScreens = {
    0: AppScreen.XmlTxt,
    1: AppScreen.Intranet,
    2: AppScreen.Soporte,
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
      title: const Text(' '),
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

