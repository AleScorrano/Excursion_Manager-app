import 'package:flutter/material.dart';

class CustomTheme {
  static const primaryColor = Color(0xFF04588c);
  static const primaryColorDark = Color.fromARGB(255, 6, 53, 77);
  static const primaryColorlight = Color(0xFF4b84bc);
  static const seconadaryColorLight = Color.fromARGB(255, 114, 195, 207);
  static const secondaryColorDark = Color(0xFF007d8f);
  static const complementaryColor1 = Color(0xFFD99A4E);
  static const complementaryColor1Light = Color(0xFFF2D0A7);
  static const complementaryColor2 = Color(0xFFF2F2F0);
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color(0xFF4588c),
  primaryColorLight: Color(0xFF4b84bc),
  primaryColorDark: Color(0xFF002f5e),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
);
