import 'package:flutter/material.dart';
import 'package:get/get.dart';



class ItemWidget extends StatelessWidget {
   ItemWidget({
    super.key,
    required this.colors,
    //required this.onPress,
    required this.text,
    //this.menuController,
    required this.icon,
  });
  //final VoidCallback? onPress;
  final Color colors;
  final String text;
  //final MenuController? menuController;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: colors),
      title: Text(text),
      // onTap: onPress,
      onTap: () {
        Get.back(); // Cierra el Drawer
      },
    );
  }
}