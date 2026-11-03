import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const primary = Color(0xFF183D47);
  static const mint = Color(0xFFD7F3E8);
  static const background = Color(0xFFF5F7F5);
  static const surface = Color(0xFFFFFFFF);
  static const text = Color(0xFF152D35);
  static const secondaryText = Color(0xFF4C6269);
  static const error = Color(0xFFBA1A1A);
  static const fieldRadius = 12.0;
  static const minTarget = 48.0;
  // Keep the last list row reachable above an extended floating action button.
  static const floatingActionClearance = 96.0;
  static const gap = 16.0;
  static const wideGap = 24.0;
  static const maxWidth = 640.0;
  static const heroIcon = 48.0;
  static const smallGap = 8.0;
  static const radius = 20.0;
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: primary).copyWith(
      primary: primary,
      onPrimary: surface,
      secondaryContainer: mint,
      onSecondaryContainer: text,
      surface: surface,
      onSurface: text,
      onSurfaceVariant: secondaryText,
      error: error,
    ),
    scaffoldBackgroundColor: background,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        height: 34 / 28,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        height: 34 / 28,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        height: 28 / 22,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        height: 24 / 18,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(fontSize: 16, height: 24 / 16),
      bodyMedium: TextStyle(fontSize: 16, height: 24 / 16),
      bodySmall: TextStyle(fontSize: 14, height: 20 / 14),
      labelLarge: TextStyle(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(fieldRadius),
      ),
      contentPadding: const EdgeInsets.all(gap),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        minimumSize: const Size(minTarget, minTarget),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(minTarget, minTarget),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(minTarget, minTarget),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(fieldRadius),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(minTarget, minTarget),
      ),
    ),
  );
}
