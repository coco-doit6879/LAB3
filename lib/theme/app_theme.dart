import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const primary = Color(0xFF183D47);
  static const mint = Color(0xFFD7F3E8);
  static const background = Color(0xFFF5F7F5);
  static const gap = 16.0;
  static const wideGap = 24.0;
  static const maxWidth = 640.0;
  static const heroIcon = 48.0;
  static const smallGap = 8.0;
  static const radius = 20.0;
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: primary)
        .copyWith(primary: primary, secondaryContainer: mint),
    scaffoldBackgroundColor: background,
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
    ),
  );
}
