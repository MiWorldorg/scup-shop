import 'package:flutter/material.dart';

class TextThemes {
  TextThemes._();

  static const String displayFont = 'NotoSerifDisplay';
  static const String bodyFont = 'Roboto';

  static TextTheme get textTheme => const TextTheme(
    displayLarge: TextStyle(
      fontFamily: displayFont,
      fontSize: 56,
      fontWeight: FontWeight.w600,
      height: 1.12,
      letterSpacing: -1.1,
    ),
    displayMedium: TextStyle(
      fontFamily: displayFont,
      fontSize: 44,
      fontWeight: FontWeight.w600,
      height: 1.16,
      letterSpacing: -0.7,
    ),
    headlineLarge: TextStyle(
      fontFamily: displayFont,
      fontSize: 36,
      fontWeight: FontWeight.w600,
      height: 1.2,
    ),
    headlineMedium: TextStyle(
      fontFamily: displayFont,
      fontSize: 30,
      fontWeight: FontWeight.w600,
      height: 1.22,
    ),
    headlineSmall: TextStyle(
      fontFamily: displayFont,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.25,
    ),
    titleLarge: TextStyle(
      fontFamily: displayFont,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),
    titleMedium: TextStyle(
      fontFamily: bodyFont,
      fontSize: 17,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    titleSmall: TextStyle(
      fontFamily: bodyFont,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    bodyLarge: TextStyle(
      fontFamily: bodyFont,
      fontSize: 17,
      fontWeight: FontWeight.w400,
      height: 1.65,
    ),
    bodyMedium: TextStyle(
      fontFamily: bodyFont,
      fontSize: 15,
      fontWeight: FontWeight.w400,
      height: 1.6,
    ),
    bodySmall: TextStyle(
      fontFamily: bodyFont,
      fontSize: 13,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    labelLarge: TextStyle(
      fontFamily: bodyFont,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.35,
    ),
    labelMedium: TextStyle(
      fontFamily: bodyFont,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.35,
      letterSpacing: 0.2,
    ),
  );
}