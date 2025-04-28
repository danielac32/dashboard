

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemsUser extends StatelessWidget {
  const ItemsUser({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ExpansionTile(
      leading: Icon(Icons.add, color: colors.primary),
      title: Text('Usuarios'),
      children: [
        ListTile(
          title: Text('Lista de Usuarios'),
          onTap: () {

            Get.back(); // Cierra el Drawer
          },
        ),
        ListTile(
          title: Text('Registro'),
          onTap: () {

            Get.back(); // Cierra el Drawer
          },
        ),

      ],
    );
  }
}