import 'package:flutter/material.dart';
import 'package:get/get.dart';



/*
class ContentWidget extends StatelessWidget {
   ContentWidget({
    super.key,
    required this.colors,
  });
  final ColorScheme colors;
  final  menuController = Get.find<MenuControllerScreen>();

  @override
  Widget build(BuildContext context) {
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
            title: Text('Páginas'),
            leading: Icon(Icons.settings_applications_outlined, color: colors.primary),
             children: [
               ListTile(
                 title: Text(Directorate.direccionGeneralTecnologiaInformacion.label),
                 leading: Icon(Icons.group, color: colors.primary),
                 onTap: () {
                   menuController.changeScreen(2);
                   Get.back(); // Cierra el Drawer
                 },
               ),
               ListTile(
                 title: Text(Directorate.direccionGeneralCuentaUnica.label),
                 leading: Icon(Icons.group, color: colors.primary),
                 onTap: () {
                   menuController.changeScreen(2);
                   Get.back(); // Cierra el Drawer
                 },
               ),
               ListTile(
                 title: Text(Directorate.direccionGeneralPlanificacionAnalisisFinanciero.label),
                 leading: Icon(Icons.group, color: colors.primary),
                 onTap: () {
                   menuController.changeScreen(2);
                   Get.back(); // Cierra el Drawer
                 },
               ),
               ListTile(
                 title: Text(Directorate.direccionGeneralIngreso.label),
                 leading: Icon(Icons.group, color: colors.primary),
                 onTap: () {
                   menuController.changeScreen(2);
                   Get.back(); // Cierra el Drawer
                 },
               ),
             ],
        ),
        ListTile(
          title: Text('Publicaciones'),
          onTap: () {
            menuController.changeScreen(2);
            Get.back(); // Cierra el Drawer
          },
        ),
        ListTile(
          title: Text('Media'),
          onTap: () {
            menuController.changeScreen(2);
            Get.back(); // Cierra el Drawer
          },
        ),
        ListTile(
          title: Text('Menús'),
          onTap: () {
            menuController.changeScreen(2);
            Get.back(); // Cierra el Drawer
          },
        ),
      ],
    );
  }
}*/