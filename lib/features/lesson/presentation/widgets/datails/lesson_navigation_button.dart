import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';

class LessonNavigationButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool iconAtEnd;
  final bool isPrimary;

  const LessonNavigationButton({super.key, 
    required this.label,
    required this.icon,
    required this.onPressed,
    this.iconAtEnd = false,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final primary = AppColors.primaryOf(context);

    final children = [
      Icon(
        icon,
        size: 16,
        color: enabled
            ? (isPrimary ? Colors.white : primary)
            : AppColors.textSecondaryOf(context).withValues(alpha: 0.45),
      ),
      const SizedBox(width: 6),
      Flexible(
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: enabled
                ? (isPrimary ? Colors.white : primary)
                : AppColors.textSecondaryOf(context).withValues(alpha: 0.45),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ];

    return Container(
      height: 40,
      decoration: BoxDecoration(
        gradient: enabled && isPrimary
            ? AppColors.buttonGradientOf(context)
            : null,
        color: enabled && isPrimary
            ? null
            : primary.withValues(alpha: enabled ? 0.07 : 0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: iconAtEnd ? children.reversed.toList() : children,
            ),
          ),
        ),
      ),
    );
  }
}