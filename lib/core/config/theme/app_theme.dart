import 'package:flutter/material.dart';

//const Color _customColor=Color.fromARGB(255, 255, 0, 0);
const List<Color> _colorThemes=[
  Colors.black,
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.yellow,
  Colors.orange,
  Colors.pink,
  Colors.red,
];


class AppTheme {
  final int selectedColor;
  final bool isDarkMode;

  AppTheme({
    this.selectedColor = 0,
    this.isDarkMode = false,
  }) : assert(selectedColor >= 0 && selectedColor <= _colorThemes.length - 1,
  'Color must be between 0 and ${_colorThemes.length}');


  static const Color goldColor = Color.fromARGB(255, 174, 155, 61);
  static const Color ColorVotacion = Color.fromARGB(255, 32, 125, 194);
  static const Color ColorLetrasCard = Color.fromARGB(255, 255, 255, 255);
  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _colorThemes[selectedColor],
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
    );
  }
}