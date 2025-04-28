import 'package:flutter/material.dart';

class TextDrawerDashboard extends StatelessWidget {
  const TextDrawerDashboard({
    super.key,
    required this.text,
    required this.colors,
    required this.size,
  });

  final String text;
  final Color colors;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: colors,
        fontSize: size,
      ),
    );
  }
}