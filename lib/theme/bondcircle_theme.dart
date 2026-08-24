import 'package:flutter/material.dart';

abstract final class BondCircleColors {
  static const ink = Color(0xFF231C24);
  static const muted = Color(0xFF756D75);
  static const background = Color(0xFFFFF9F6);
  static const surface = Color(0xFFFFFFFF);
  static const primary = Color(0xFFD94F76);
  static const lavender = Color(0xFFEEE7FF);
  static const purple = Color(0xFF6D4DD6);
  static const border = Color(0xFFE7DDE1);
}

abstract final class BondCircleTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: BondCircleColors.primary,
      surface: BondCircleColors.surface,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(
        primary: BondCircleColors.primary,
        secondary: BondCircleColors.purple,
      ),
      scaffoldBackgroundColor: BondCircleColors.background,
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          color: BondCircleColors.ink,
          fontSize: 36,
          height: 1.08,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.2,
        ),
        headlineSmall: TextStyle(
          color: BondCircleColors.ink,
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
        bodyLarge: TextStyle(
          color: BondCircleColors.muted,
          fontSize: 16,
          height: 1.45,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: BondCircleColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: BondCircleColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: BondCircleColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: BondCircleColors.primary,
            width: 1.6,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
