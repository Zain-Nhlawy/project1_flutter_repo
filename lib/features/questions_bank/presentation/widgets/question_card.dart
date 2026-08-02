import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/questions_bank/data/models/question_bank_model.dart';

class QuestionCard extends StatelessWidget {
  final QuestionBankModel question;
  final VoidCallback onDelete;

  const QuestionCard({required this.question, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  question.question,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: onDelete,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    size: 20,
                    color: Colors.red.shade400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final choice in question.choices)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(
                    choice.isCorrect
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    size: 16,
                    color: choice.isCorrect
                        ? AppColors.success
                        : AppColors.textSecondary.withOpacity(.5),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      choice.choice,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: choice.isCorrect
                            ? AppColors.success
                            : AppColors.textSecondary,
                        fontWeight: choice.isCorrect
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}