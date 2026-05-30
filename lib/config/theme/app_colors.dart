import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF4DB8FF);

  static const Color secondary = Color(0xFF00E5FF);

  static const Color tertiary = Color(0xFF2CC9C9);

  static const Color dark = Color(0xFF1A1C1E);

  static const Color background = Color(0xFFF8FAFC);

  static const Color surface = Colors.white;

  static const Color textPrimary = Color(0xFF1A1C1E);

  static const Color textSecondary = Color(0xFF6B7280);

  static const Color border = Color(0xFFE5E7EB);

  static const Color success = Color(0xFF22C55E);

  static const Color warning = Color(0xFFF59E0B);

  static const Color error = Color(0xFFEF4444);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primary,
      secondary,
    ],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      primary,
      tertiary,
    ],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      primary,
      secondary,
    ],
  );
}