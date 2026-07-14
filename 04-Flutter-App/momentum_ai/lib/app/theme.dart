import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryBlue = Color(0xFF2764FF);
  static const Color primaryViolet = Color(0xFF9B3DFF);
  static const Color primaryCyan = Color(0xFF20C7C9);

  static const Color background = Color(0xFFF8FAFF);
  static const Color textDark = Color(0xFF111827);
  static const Color textMuted = Color(0xFF6B7280);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.light,
      primary: primaryBlue,
      secondary: primaryViolet,
      tertiary: primaryCyan,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      colorScheme: colorScheme,
      fontFamily: 'Manrope',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        foregroundColor: textDark,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.2,
          color: textDark,
          fontFamily: 'SpaceGrotesk',
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
          color: textDark,
          fontFamily: 'SpaceGrotesk',
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: textDark,
          fontFamily: 'SpaceGrotesk',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textDark,
          fontFamily: 'Manrope',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textMuted,
          fontFamily: 'Manrope',
        ),
      ),
    );
  }
}


