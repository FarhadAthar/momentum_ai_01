import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // --- ACCENT COLORS (SAME FOR BOTH THEMES) ---
  static const Color primaryBlue = Color(0xFF2764FF);
  static const Color primaryViolet = Color(0xFF9B3DFF);
  static const Color primaryCyan = Color(0xFF20C7C9);

  // --- BACKWARD COMPATIBILITY & LIGHT THEME COLORS ---
  static const Color background = Color(
    0xFFF3F4F6,
  ); // 👈 Isko update kar diya hai
  static const Color textDark = Color(0xFF111827);
  static const Color textMuted = Color(0xFF6B7280);

  // --- NEW FINE-GRAINED LIGHT THEME COLORS ---
  // 👇 YAHAN BACKGROUND COLOR CHANGE KIYA HAI (0xFFF3F4F6)
  static const Color backgroundLight = Color(0xFFF3F4F6);
  static const Color textDarkLight = Color(0xFF111827);
  static const Color textMutedLight = Color(0xFF6B7280);

  // --- DARK THEME COLORS ---
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textLight = Color(0xFFF3F4F6);
  static const Color textMutedDark = Color(0xFF9CA3AF);

  // ==========================================
  // LIGHT THEME
  // ==========================================
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.light,
      primary: primaryBlue,
      secondary: primaryViolet,
      tertiary: primaryCyan,
      surface: Colors.white, // Cards pure white rahenge
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: colorScheme,
      fontFamily: 'Manrope',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        foregroundColor: textDarkLight,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.2,
          color: textDarkLight,
          fontFamily: 'SpaceGrotesk',
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
          color: textDarkLight,
          fontFamily: 'SpaceGrotesk',
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: textDarkLight,
          fontFamily: 'SpaceGrotesk',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textDarkLight,
          fontFamily: 'Manrope',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textMutedLight,
          fontFamily: 'Manrope',
        ),
      ),
    );
  }

  // ==========================================
  // DARK THEME
  // ==========================================
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.dark,
      primary: primaryBlue,
      secondary: primaryViolet,
      tertiary: primaryCyan,
      surface: surfaceDark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: colorScheme,
      fontFamily: 'Manrope',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        foregroundColor: textLight,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w900,
          letterSpacing: -1.2,
          color: textLight,
          fontFamily: 'SpaceGrotesk',
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
          color: textLight,
          fontFamily: 'SpaceGrotesk',
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: textLight,
          fontFamily: 'SpaceGrotesk',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textLight,
          fontFamily: 'Manrope',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textMutedDark,
          fontFamily: 'Manrope',
        ),
      ),
    );
  }
}
