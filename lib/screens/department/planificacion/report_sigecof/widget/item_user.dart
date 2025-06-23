


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/enum_screen_planificacion.dart';
import '../controller/controller_screen.dart';



class ItemsUser extends StatelessWidget {
  ItemsUser({super.key});
  //final  menuControllerScreen = Get.find<MenuControllerScreen>();
  final controller = Get.put(ControllerUser());

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ExpansionTile(
      leading: Icon(Icons.add, color: colors.primary),
      title: Text('Sigecof'),
      children: [
        ListTile(
          title: Text(controller.sections[0]),
          leading: Icon(Icons.report, color: colors.primary),
          onTap: () {
            //menuControllerScreen.currentIndex(1);
            Get.find<ControllerScreenPlanificacion>().goToScreen(AppScreen.ordenes_trasmitidas_bcv);

            Get.back(); // Cierra el Drawer
          },
        ),
        ListTile(
          title: Text(controller.sections[1]),
          leading: Icon(Icons.report, color: colors.primary),
          onTap: () {
            Get.find<ControllerScreenPlanificacion>().goToScreen(AppScreen.ordenes_pagadas);
            Get.back(); // Cierra el Drawer
          },
        ),
        ListTile(
          title: Text(controller.sections[2]),
          leading: Icon(Icons.report, color: colors.primary),
          onTap: () {
            Get.find<ControllerScreenPlanificacion>().goToScreen(AppScreen.ordenes_pendientes);
            Get.back(); // Cierra el Drawer
          },
        ),
        ListTile(
          title: Text(controller.sections[3]),
          leading: Icon(Icons.report, color: colors.primary),
          onTap: () {
            Get.find<ControllerScreenPlanificacion>().goToScreen(AppScreen.dolares_a_blivares);
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