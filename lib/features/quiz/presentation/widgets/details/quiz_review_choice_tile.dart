import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/l10n/app_localizations.dart';

class QuizReviewChoiceTile extends StatelessWidget {
  final String choice;
  final bool isSelected;
  final bool isCorrect;

  const QuizReviewChoiceTile({
    super.key,
    required this.choice,
    required this.isSelected,
    required this.isCorrect,
  });

  static const _correctColor = Color(0xFF2E7D32);
  static const _wrongColor = Color(0xFFC62828);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final isWrongSelected = isSelected && !isCorrect;

    final Color accentColor = isCorrect
        ? _correctColor
        : isWrongSelected
            ? _wrongColor
            : AppColors.border;

    final Color backgroundColor = isCorrect
        ? _correctColor.withOpacity(.08)
        : isWrongSelected
            ? _wrongColor.withOpacity(.08)
            : AppColors.surface;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 17,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: accentColor,
          width: isCorrect || isWrongSelected ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCorrect
                  ? _correctColor
                  : isWrongSelected
                      ? _wrongColor
                      : AppColors.background,
              border: Border.all(
                color: accentColor,
                width: 1.5,
              ),
            ),
            child: isCorrect
                ? const Icon(
                    Icons.check,
                    size: 15,
                    color: Colors.white,
                  )
                : isWrongSelected
                    ? const Icon(
                        Icons.close,
                        size: 15,
                        color: Colors.white,
                      )
                    : null,
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              choice,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: isCorrect || isWrongSelected
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
            ),
          ),

          if (isCorrect || isWrongSelected) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                isCorrect
                    ? localizations.correctAnswerLabel
                    : localizations.yourAnswerLabel,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}