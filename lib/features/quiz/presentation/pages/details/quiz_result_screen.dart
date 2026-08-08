import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/quiz/domain/entities/generated_exam_entity.dart';
import 'package:project1/features/quiz/presentation/pages/details/exam_attempt_review_screen.dart';
import 'package:project1/l10n/app_localizations.dart';

class QuizResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final GeneratedExamEntity exam;
  final Map<String, Set<String>> selectedAnswers;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.exam,
    required this.selectedAnswers,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final percent = score / 100;

    final isGreat = percent >= 0.8;
    final isGood = percent >= 0.5;

    final title = isGreat
        ? localizations.excellent
        : isGood
            ? localizations.goodJob
            : localizations.keepPracticing;

    final subtitle = percent >= 0.6
        ? localizations.youDidGreat
        : localizations.keepPracticingYoullImprove;

    final image = percent >= 0.6
        ? "assets/images/celebrating3.png"
        : "assets/images/sad3.png";

    final accentColor = percent >= 0.6
        ? AppColors.primaryOf(context)
        : AppColors.error;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          child: Column(
            children: [
              const SizedBox(height: 12),

              Image.asset(
                image,
                height: 190,
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceOf(context),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: AppColors.borderOf(context),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(.10),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$score',
                        style: AppTextStyles.h1.copyWith(
                          fontFamily: AppTextStyles.fontFamily,
                          color: accentColor,
                        ),
                      ),
                      TextSpan(
                        text: ' / 100',
                        style: AppTextStyles.titleLarge.copyWith(
                          fontFamily: AppTextStyles.fontFamily,
                          color: AppColors.textSecondaryOf(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.h3.copyWith(
                  fontFamily: AppTextStyles.fontFamily,
                  color: AppColors.textPrimaryOf(context),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontFamily: AppTextStyles.fontFamily,
                  color: AppColors.textSecondaryOf(context),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 36),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.buttonGradientOf(context),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ExamAttemptReviewScreen(
                            exam: exam,
                            selectedAnswers: selectedAnswers,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      localizations.reviewAnswers,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontFamily: AppTextStyles.fontFamily,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryOf(context),
                    side: BorderSide(
                      color: AppColors.primaryOf(context),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    localizations.exitQuiz,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontFamily: AppTextStyles.fontFamily,
                      fontWeight: FontWeight.w700,
                    ),
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