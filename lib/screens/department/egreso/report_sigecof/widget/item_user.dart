




import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/config/theme/app_theme.dart';
import '../constant/enum_screen_egreso.dart';
import '../controller/controller.dart';
import '../shared/controller_shared.dart';




class ItemsUser extends StatelessWidget {
  ItemsUser({super.key});
  //final  menuControllerScreen = Get.find<MenuControllerScreen>();
  final controller = Get.put(ControllerUser());

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ExpansionTile(
      leading: Icon(Icons.add, color: AppTheme.goldColor),
      title: Text('Sigecof'),
      children: [
        ListTile(
          title: Text(controller.sections[0]),
          leading: Icon(Icons.report, color: AppTheme.goldColor),
          onTap: () {
            Get.find<ControllerScreenEgreso>().goToScreen(AppScreen.ordenes_pagadas);
            Get.find<SharedEgresoController>().addTitle.value = "- Ordenes Pagadas";
            Get.back(); // Cierra el Drawer
          },
        ),
        ListTile(
          title: Text(controller.sections[1]),
          leading: Icon(Icons.report, color: AppTheme.goldColor),
          onTap: () {
            Get.find<ControllerScreenEgreso>().goToScreen(AppScreen.ordenes_pendientes);
            Get.find<SharedEgresoController>().addTitle.value = "- Ordenes Pendientes";
            Get.back(); // Cierra el Drawer
          },
        ),
        ListTile(
          title: Text(controller.sections[2]),
          leading: Icon(Icons.report, color: AppTheme.goldColor),
          onTap: () {
            Get.find<ControllerScreenEgreso>().goToScreen(AppScreen.ordenes_pagadas_retenciones);
            Get.find<SharedEgresoController>().addTitle.value = "- Ordenes Pagadas con Retenciones";
            Get.back(); // Cierra el Drawer
          },
        ),
        ListTile(
          title: Text(controller.sections[3]),
          leading: Icon(Icons.report, color: AppTheme.goldColor),
          onTap: () {
            Get.find<ControllerScreenEgreso>().goToScreen(AppScreen.retenciones_partidas);
            Get.find<SharedEgresoController>().addTitle.value = "- Retenciones por Partidas";
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