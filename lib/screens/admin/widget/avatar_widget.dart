import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    super.key,
    required this.colors, required this.urlImage,
  });

  final ColorScheme colors;
  final String urlImage;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: AssetImage('assets/1.jpeg'),
      radius: 30,
      backgroundColor: colors.secondary,
      //child: Icon(Icons.person, size: 40, color: colors.onSecondary),
    );
  }
}