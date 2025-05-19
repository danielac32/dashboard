import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/enum.dart';
import '../../constant/enum_screen.dart';
import '../../controller/dashboard_menu.dart';




class ItemsContent extends StatelessWidget {
  ItemsContent({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ExpansionTile(
      leading: Icon(Icons.pages, color: colors.primary),
      title: Text('Contenido'),
      children: [
        /*ListTile(
          title: Text('Páginas'),
          onTap: () {
            menuController.changeScreen(2);
            Get.back(); // Cierra el Drawer
          },
        ),*/
        ExpansionTile(
          title: Text('Dirección'),
          leading: Icon(Icons.settings_applications_outlined, color: colors.primary),
          children: [
            ListTile(
              title: Text(Directorate.direccionGeneralTecnologiaInformacion.label),
              leading: Icon(Icons.group, color: colors.primary),
              onTap: () {
                Get.back(); // Cierra el Drawer
              },
            ),
            ListTile(
              title: Text(Directorate.direccionGeneralCuentaUnica.label),
              leading: Icon(Icons.group, color: colors.primary),
              onTap: () {

                Get.back(); // Cierra el Drawer
              },
            ),
            ListTile(
              title: Text(Directorate.direccionGeneralPlanificacionAnalisisFinanciero.label),
              leading: Icon(Icons.group, color: colors.primary),
              onTap: () {

                Get.back(); // Cierra el Drawer
              },
            ),
            ListTile(
              title: Text(Directorate.direccionGeneralIngreso.label),
              leading: Icon(Icons.group, color: colors.primary),
              onTap: () {

                Get.back(); // Cierra el Drawer
              },
            ),
          ],
        ),
        ListTile(
          title: Text('Publicaciones'),
          leading: Icon(Icons.image, color: colors.primary),
          onTap: () {

            Get.back(); // Cierra el Drawer
          },
        ),
        ListTile(
          title: Text('Media'),
          leading: Icon(Icons.file_upload, color: colors.primary),
          onTap: () {
            Get.back(); // Cierra el Drawer
            Get.find<MenuControllerScreen>().goToScreen(AppScreen.mediaScreen);
          },
        ),
        /*ListTile(
          title: Text('Menús'),
          leading: Icon(Icons.image, color: colors.primary),
          onTap: () {

            Get.back(); // Cierra el Drawer
          },
        ),*/
      ],
    );
  }
}