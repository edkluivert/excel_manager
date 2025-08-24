import 'package:flutter/material.dart';
class AppTheme {
  static ThemeData get light => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
    ),
    useMaterial3: true,
  );
  static ThemeData get dark => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB69DF8), brightness: Brightness.dark),
    scaffoldBackgroundColor: const Color(0xFF121212),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
    ),
    useMaterial3: true,
  );
}
