import 'package:flutter/material.dart';

class BackGround extends StatelessWidget {
  const BackGround({
    super.key, required this.background,
  });
  final String background;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(background), // Ruta de la imagen
          fit: BoxFit.cover, // Ajusta la imagen al tamaño de la pantalla
        ),
      ),
    );
  }
}