import 'package:flutter/material.dart';


class AppColors {
  AppColors._();

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

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      primary,
      tertiary,
    ],
  );

  static const BoxShadow primaryShadow = BoxShadow(
  color: Color(0xFFAECFFF),
  blurRadius: 20,
  offset: Offset(0, 10),
  );
}