
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class ItemsConfig extends StatelessWidget {
  ItemsConfig({
    super.key
  });


  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ExpansionTile(
      leading: Icon(Icons.settings, color: colors.primary),
      title: Text('Configuración'),
      children: [
        ListTile(
          title: Text('Cambiar título'),
          onTap: () {

            Get.back(); // Cierra el Drawer
          },
        ),
        ListTile(
          title: Text('Cambiar tema'),
          onTap: () {

            Get.back(); // Cierra el Drawer
          },
        ),
        ListTile(
          title: Text('Configurar APIs'),
          onTap: () {

            Get.back(); // Cierra el Drawer
          },
        ),
        ListTile(
          title: Text('Ver registros'),
          onTap: () {

            Get.back(); // Cierra el Drawer
          },
        ),
      ],
    );
  }
}