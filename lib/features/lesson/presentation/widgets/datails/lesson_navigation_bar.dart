import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/lesson/presentation/widgets/datails/lesson_navigation_button.dart';

class LessonNavigationBar extends StatelessWidget {
  final int currentLesson;
  final int totalLessons;
  final String previousLabel;
  final String nextLabel;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const LessonNavigationBar({
    required this.currentLesson,
    required this.totalLessons,
    required this.previousLabel,
    required this.nextLabel,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.78),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: LessonNavigationButton(
              label: previousLabel,
              icon: Icons.arrow_back_rounded,
              onPressed: onPrevious,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            decoration: BoxDecoration(
              color: AppColors.primaryOf(context).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$currentLesson/$totalLessons',
              style: AppTextStyles.label.copyWith(
                color: AppColors.primaryOf(context),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: LessonNavigationButton(
              label: nextLabel,
              icon: Icons.arrow_forward_rounded,
              iconAtEnd: true,
              isPrimary: true,
              onPressed: onNext,
            ),
          ),
        ],
      ),
    );
  }
}