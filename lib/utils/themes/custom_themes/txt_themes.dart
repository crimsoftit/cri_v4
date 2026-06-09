import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';

class CTextTheme {
  CTextTheme._();

  static TextTheme ligtTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      color: Colors.brown,
    ),
    headlineMedium: const TextStyle().copyWith(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Colors.brown,
    ),
    headlineSmall: const TextStyle().copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Colors.brown,
    ),
    titleLarge: const TextStyle().copyWith(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.brown,
    ),
    titleMedium: const TextStyle().copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Colors.brown,
    ),
    titleSmall: const TextStyle().copyWith(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      color: Colors.brown,
    ),
    bodyLarge: const TextStyle().copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: Colors.brown,
    ),
    bodyMedium: const TextStyle().copyWith(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Colors.brown,
    ),
    bodySmall: const TextStyle().copyWith(
      fontSize: 10.0,
      fontWeight: FontWeight.w400,
      color: Colors.brown,
    ),
    labelLarge: const TextStyle().copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: Colors.brown,
    ),
    labelMedium: const TextStyle().copyWith(
      fontSize: 11.0,
      fontWeight: FontWeight.normal,
      color: Colors.brown,
    ),
    labelSmall: const TextStyle().copyWith(
      fontSize: 9.0,
      fontWeight: FontWeight.normal,
      color: Colors.brown,
    ),
  );

  // -- dark mode theme
  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: const TextStyle().copyWith(
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    headlineSmall: const TextStyle().copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    titleLarge: const TextStyle().copyWith(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleMedium: const TextStyle().copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    titleSmall: const TextStyle().copyWith(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    bodyLarge: const TextStyle().copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    bodyMedium: const TextStyle().copyWith(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    bodySmall: const TextStyle().copyWith(
      fontSize: 10.0,
      fontWeight: FontWeight.w400,
      color: Colors.white,
    ),
    labelLarge: const TextStyle().copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    labelMedium: const TextStyle().copyWith(
      fontSize: 11.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    labelSmall: const TextStyle().copyWith(
      fontSize: 9.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
  );
}
