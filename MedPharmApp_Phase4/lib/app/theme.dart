// ============================================================================
// APP THEME - Students can customize colors here
// ============================================================================

import 'package:flutter/material.dart';

/// App theme configuration
///
/// Students: You can customize the app colors and styles here
class AppTheme {
  // Primary color - main app color
  static const Color primaryColor = Colors.blue;

  // Accent color - for highlights and important elements
  static const Color accentColor = Colors.blueAccent;

  // Text colors
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;

  /// Light theme (default)
  static ThemeData get lightTheme {
    return ThemeData(
      // Color scheme
      primarySwatch: Colors.blue,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),

      // App bar theme
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 2,
      ),

      // Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),

      // Card theme
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }
}
