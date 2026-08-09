import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';

class CourseTag extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback? onTap;

  const CourseTag({
    super.key,
    required this.text,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryOf(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? primaryColor : primaryColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? primaryColor
                : primaryColor.withValues(alpha: 0.14),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.label.copyWith(
            color: selected ? Colors.white : primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
