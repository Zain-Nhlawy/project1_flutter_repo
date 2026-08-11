import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';

InputDecoration inputDecoration({
  required BuildContext context,
  required String hint,
  required IconData icon,
  String? label,
}) {
  final border = AppColors.borderOf(context);
  final primary = AppColors.primaryOf(context);
  final textSecondary = AppColors.textSecondaryOf(context);

  OutlineInputBorder outline(Color color, [double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  return InputDecoration(
    labelText: label,
    floatingLabelBehavior: label == null
        ? FloatingLabelBehavior.auto
        : FloatingLabelBehavior.always,
    floatingLabelAlignment: FloatingLabelAlignment.start,
    labelStyle: AppTextStyles.label.copyWith(
      color: textSecondary,
      height: 1.25,
      fontWeight: FontWeight.w700,
    ),
    floatingLabelStyle: AppTextStyles.label.copyWith(
      color: primary,
      height: 1.25,
      fontWeight: FontWeight.w800,
    ),
    hintText: hint,
    hintStyle: AppTextStyles.bodyMedium.copyWith(
      color: textSecondary,
      height: 1.35,
    ),
    prefixIcon: Icon(icon, color: primary, size: 20),
    filled: true,
    fillColor: AppColors.backgroundOf(context).withValues(alpha: 0.72),
    contentPadding: label == null
        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 16)
        : const EdgeInsets.fromLTRB(16, 21, 16, 14),
    border: outline(border),
    enabledBorder: outline(border),
    focusedBorder: outline(primary, 1.6),
    errorBorder: outline(AppColors.error),
    focusedErrorBorder: outline(AppColors.error, 1.6),
  );
}
