import 'package:flutter/material.dart';


class AppColors {
  AppColors._();

  // ─── Light Mode ───
  static const Color primary = Color(0xFF0A2A54);

  static const Color secondary = Color(0xFF1E4E8C);
  static const Color tertiary = Color(0xFF2F6FB3);

  static const Color dark = Color(0xFF081A33);

  static const Color background = Color(0xFFF4F7FB);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF0B1220);
  static const Color textSecondary = Color(0xFF5B6B7C);

  static const Color border = Color(0xFFD9E2EF);

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // ─── Dark Mode ───
  static const Color darkPrimary = Color(0xFF4A90D9);

  static const Color darkSecondary = Color(0xFF3A7BD5);
  static const Color darkTertiary = Color(0xFF5BA3E6);

  static const Color darkBackground = Color(0xFF0F1923);
  static const Color darkSurface = Color(0xFF1A2733);

  static const Color darkTextPrimary = Color(0xFFE8EDF3);
  static const Color darkTextSecondary = Color(0xFF8899AA);

  static const Color darkBorder = Color(0xFF2A3A4A);

  // ─── Gradients ───
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
      secondary,
      tertiary,
    ],
  );

  static const LinearGradient darkHeaderGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF152A3E),
      Color(0xFF1D3A52),
    ],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      primary,
      tertiary,
    ],
  );

  static const LinearGradient darkButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      darkSecondary,
      darkTertiary,
    ],
  );

  static const BoxShadow primaryShadow = BoxShadow(
    color: Color(0xFFAECFFF),
    blurRadius: 20,
    offset: Offset(0, 10),
  );

  static const BoxShadow darkPrimaryShadow = BoxShadow(
    color: Color(0x40000000),
    blurRadius: 20,
    offset: Offset(0, 10),
  );

  // ─── Context-aware color helpers ───
  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color backgroundOf(BuildContext context) =>
      _isDark(context) ? darkBackground : background;

  static Color surfaceOf(BuildContext context) =>
      _isDark(context) ? darkSurface : surface;

  static Color textPrimaryOf(BuildContext context) =>
      _isDark(context) ? darkTextPrimary : textPrimary;

  static Color textSecondaryOf(BuildContext context) =>
      _isDark(context) ? darkTextSecondary : textSecondary;

  static Color borderOf(BuildContext context) =>
      _isDark(context) ? darkBorder : border;

  static Color primaryOf(BuildContext context) =>
      _isDark(context) ? darkPrimary : primary;

  static LinearGradient headerGradientOf(BuildContext context) =>
      _isDark(context) ? darkHeaderGradient : headerGradient;

  static LinearGradient buttonGradientOf(BuildContext context) =>
      _isDark(context) ? darkButtonGradient : buttonGradient;

  static BoxShadow primaryShadowOf(BuildContext context) =>
      _isDark(context) ? darkPrimaryShadow : primaryShadow;
}