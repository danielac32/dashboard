




import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/config/theme/app_theme.dart';
import '../constant/enum_screen_cuenta_unica.dart';
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
            Get.find<ControllerScreenCuentaUnica>().goToScreen(AppScreen.comprobante_de_retenciones);
            Get.find<SharedCuentaUnicaController>().addTitle.value = "- ${controller.sections[0]}";
            Get.back(); // Cierra el Drawer
          },
        ),
        ListTile(
          title: Text(controller.sections[1]),
          leading: Icon(Icons.report, color: AppTheme.goldColor),
          onTap: () {
            Get.find<ControllerScreenCuentaUnica>().goToScreen(AppScreen.parafiscales_banavih);
            Get.find<SharedCuentaUnicaController>().addTitle.value = "- ${controller.sections[1]}";
            Get.back(); // Cierra el Drawer
          },
        ),
        ListTile(
          title: Text(controller.sections[2]),
          leading: Icon(Icons.report, color: AppTheme.goldColor),
          onTap: () {
            Get.find<ControllerScreenCuentaUnica>().goToScreen(AppScreen.parafiscales_inces);
            Get.find<SharedCuentaUnicaController>().addTitle.value = "- ${controller.sections[2]}";
            Get.back(); // Cierra el Drawer
          },
        ),
        ListTile(
          title: Text(controller.sections[3]),
          leading: Icon(Icons.report, color: AppTheme.goldColor),
          onTap: () {
            Get.find<ControllerScreenCuentaUnica>().goToScreen(AppScreen.parafiscales_ivss);
            Get.find<SharedCuentaUnicaController>().addTitle.value = "- ${controller.sections[3]}";
            Get.back(); // Cierra el Drawer
          },
        ),
        ListTile(
          title: Text(controller.sections[4]),
          leading: Icon(Icons.report, color: AppTheme.goldColor),
          onTap: () {
            Get.find<ControllerScreenCuentaUnica>().goToScreen(AppScreen.retenciones);
            Get.find<SharedCuentaUnicaController>().addTitle.value = "- ${controller.sections[4]}";
            Get.back(); // Cierra el Drawer
          },
        ),
        ListTile(
          title: Text(controller.sections[5]),
          leading: Icon(Icons.report, color: AppTheme.goldColor),
          onTap: () {
            Get.find<ControllerScreenCuentaUnica>().goToScreen(AppScreen.islr);
            Get.find<SharedCuentaUnicaController>().addTitle.value = "- ${controller.sections[5]}";
            Get.back(); // Cierra el Drawer
          },
        ),
      ],
    );
  }
}