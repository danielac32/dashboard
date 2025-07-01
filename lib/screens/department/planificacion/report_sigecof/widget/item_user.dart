


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/config/theme/app_theme.dart';
import '../constant/enum_screen_planificacion.dart';
import '../controller/controller_screen.dart';
import '../shared/controller_shared.dart';



class ItemsUser extends StatelessWidget {
  ItemsUser({super.key});
  //final  menuControllerScreen = Get.find<MenuControllerScreen>();
  final controller = Get.put(ControllerUser());

  @override
  Widget build(BuildContext context) {
    //final colors = Theme.of(context).colorScheme;
    return ExpansionTile(
      leading: Icon(Icons.add, color: AppTheme.goldColor),
      title: Text('Sigecof'),
      children: [
        ListTile(
          title: Text(controller.sections[0]),
          leading: Icon(Icons.report, color: AppTheme.goldColor),
          onTap: () {
            //menuControllerScreen.currentIndex(1);
            Get.find<ControllerScreenPlanificacion>().goToScreen(AppScreen.ordenes_trasmitidas_bcv);
            Get.find<SharedController>().addTitle.value = "- Ordenes Transmitidas BCV";
            Get.back(); // Cierra el Drawer
          },
        ),
        ListTile(
          title: Text(controller.sections[1]),
          leading: Icon(Icons.report, color: AppTheme.goldColor),
          onTap: () {
            Get.find<ControllerScreenPlanificacion>().goToScreen(AppScreen.ordenes_pagadas);
            Get.find<SharedController>().addTitle.value = "- Ordenes Pagadas";
            Get.back(); // Cierra el Drawer
          },
        ),
        ListTile(
          title: Text(controller.sections[2]),
          leading: Icon(Icons.report, color: AppTheme.goldColor),
          onTap: () {
            Get.find<ControllerScreenPlanificacion>().goToScreen(AppScreen.ordenes_pendientes);
            Get.find<SharedController>().addTitle.value = "- Ordenes Pendientes";
            Get.back(); // Cierra el Drawer
          },
        ),
        ListTile(
          title: Text(controller.sections[3]),
          leading: Icon(Icons.report, color: AppTheme.goldColor),
          onTap: () {
            Get.find<ControllerScreenPlanificacion>().goToScreen(AppScreen.dolares_a_blivares);
            Get.find<SharedController>().addTitle.value = "- Ordenes Dolares a Bolivares";
            Get.back(); // Cierra el Drawer
          },
        ),
        /*ListTile(
          title: Text('Permisos'),
          leading: Icon(Icons.lock, color: colors.primary),
          onTap: () {
            menuControllerScreen.currentIndex(3);
            Get.back(); // Cierra el Drawer
          },
        ),*/

      ],
    );
  }
}