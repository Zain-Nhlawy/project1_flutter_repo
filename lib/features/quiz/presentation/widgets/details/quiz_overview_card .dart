import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/quiz/presentation/widgets/details/quiz_progress_header.dart';
import 'package:project1/features/quiz/presentation/widgets/details/quiz_timer.dart';

class QuizOverviewCard extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final double progress;
  final int remainingSeconds;

  const QuizOverviewCard({
    required this.currentQuestion,
    required this.totalQuestions,
    required this.progress,
    required this.remainingSeconds,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.78),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: Theme.of(context).brightness == Brightness.dark
                  ? 0.16
                  : 0.045,
            ),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: QuizProgressHeader(
              currentQuestion: currentQuestion,
              totalQuestions: totalQuestions,
              progress: progress,
            ),
          ),
          const SizedBox(width: 14),
          QuizTimer(remainingSeconds: remainingSeconds),
        ],
      ),
    );
  }
}
