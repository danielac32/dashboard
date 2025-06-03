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
     this.tap,
  });
  //final VoidCallback? onPress;
  final Color colors;
  final String text;
  //final MenuController? menuController;
  final IconData icon;
  final VoidCallback? tap;
  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: colors),
      title: Text(text),
      // onTap: onPress,
      onTap: tap,
    );
  }
}