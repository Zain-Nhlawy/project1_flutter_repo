import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';

class QuizChoiceTile extends StatelessWidget {
  final String choice;
  final bool isSelected;
  final VoidCallback onTap;

  const QuizChoiceTile({
    super.key,
    required this.choice,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
          decoration: BoxDecoration(
            color: isSelected
                ? primary.withValues(alpha: 0.09)
                : AppColors.surfaceOf(context),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected ? primary : AppColors.borderOf(context),
              width: isSelected ? 1.6 : 1,
            ),
            boxShadow: [
              if (!isSelected)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.035),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? primary : AppColors.backgroundOf(context),
                  border: Border.all(
                    color: isSelected ? primary : AppColors.borderOf(context),
                    width: 1.5,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, size: 15, color: Colors.white)
                    : null,
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  choice,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimaryOf(context),
                    height: 1.45,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
