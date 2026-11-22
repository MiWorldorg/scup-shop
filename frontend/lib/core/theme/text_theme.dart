import 'package:flutter/material.dart';

class TextThemes {
  static TextTheme get textTheme => const TextTheme(
    titleLarge: TextStyle(
      fontSize: 30,
      fontFamily: 'NotoSerifDisplay',
      fontWeight: FontWeight.w600,
      height: 1.2,
    ),
    titleMedium: TextStyle(
      fontSize: 17,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w500,
      height: 1.35,
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    bodyLarge: TextStyle(
      fontSize: 40,
      fontFamily: 'NotoSerifDisplay',
      fontWeight: FontWeight.w600,
      height: 1.14,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w300,
      height: 1.65,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w200,
      height: 1.6,
    ),
  );
}
