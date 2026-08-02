import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/rag/data/models/quiz_question_model.dart';

Widget buildQuizCard(
    QuizQuestionModel q,
    int index,
    Color textPrimaryColor,
    Color textSecondaryColor,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$index. ${q.question}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: textPrimaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          for (final option in q.options)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                option,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: option.trim().startsWith(q.correctAnswer)
                      ? AppColors.success
                      : textSecondaryColor,
                  fontWeight: option.trim().startsWith(q.correctAnswer)
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),
          if (q.explanation.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              q.explanation,
              style: AppTextStyles.bodyMedium.copyWith(
                color: textSecondaryColor,
                fontStyle: FontStyle.italic,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
