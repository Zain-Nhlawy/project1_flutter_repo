
import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';

class ExamFormField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final bool hasError;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String> onChanged;

  const ExamFormField({
    required this.label,
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.hasError,
    required this.onChanged,
    this.keyboardType,
    this.textInputAction,
  });

  OutlineInputBorder _border(BuildContext context, {bool focused = false}) {
    final color = hasError
        ? AppColors.error
        : focused
        ? AppColors.primaryOf(context)
        : AppColors.borderOf(context);

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: color,
        width: hasError || focused ? 1.7 : 1.1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimaryOf(context),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: TextStyle(color: AppColors.textPrimaryOf(context)),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.textSecondaryOf(context).withValues(alpha: 0.72),
            ),
            filled: true,
            fillColor: AppColors.backgroundOf(context),
            prefixIcon: Icon(icon, color: primary, size: 21),
            border: _border(context),
            enabledBorder: _border(context),
            focusedBorder: _border(context, focused: true),
            errorBorder: _border(context),
            focusedErrorBorder: _border(context, focused: true),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}