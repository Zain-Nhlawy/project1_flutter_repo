import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';

class GradientActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool expand;

  const GradientActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    final canTap = onPressed != null && !isLoading;
    final active = onPressed != null || isLoading;
    final primary = AppColors.primaryOf(context);

    final button = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: 54,
      decoration: BoxDecoration(
        gradient: active ? AppColors.buttonGradientOf(context) : null,
        color: active
            ? null
            : AppColors.borderOf(context).withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(18),
        boxShadow: active
            ? [
                BoxShadow(
                  color: primary.withValues(alpha: 0.24),
                  blurRadius: 16,
                  offset: const Offset(0, 7),
                ),
              ]
            : const [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canTap ? onPressed : null,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.2,
                      color: Colors.white,
                    ),
                  )
                else if (icon != null)
                  Icon(icon, color: Colors.white, size: 20),
                if ((icon != null && !isLoading) || isLoading)
                  const SizedBox(width: 9),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: active
                          ? Colors.white
                          : AppColors.textSecondaryOf(context),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
