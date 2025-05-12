

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/dashboard_menu.dart';

class ItemsUser extends StatelessWidget {
   ItemsUser({super.key});
  final  menuControllerScreen = Get.find<MenuControllerScreen>();
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ExpansionTile(
      leading: Icon(Icons.add, color: colors.primary),
      title: Text('Usuarios'),
      children: [
        ListTile(
          title: Text('Lista de Usuarios'),
          leading: Icon(Icons.people, color: colors.primary),
          onTap: () {
            menuControllerScreen.currentIndex(1);
            Get.back(); // Cierra el Drawer
          },
        ),
        ListTile(
          title: Text('Registro'),
          leading: Icon(Icons.account_circle, color: colors.primary),
          onTap: () {
            menuControllerScreen.currentIndex(2);
            Get.back(); // Cierra el Drawer
          },
        ),
        ListTile(
          title: Text('Permisos'),
          leading: Icon(Icons.lock, color: colors.primary),
          onTap: () {
            menuControllerScreen.currentIndex(3);
            Get.back(); // Cierra el Drawer
          },
        ),

      ],
    );
  }
}