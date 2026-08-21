import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/certification/presentation/cubit/certification_cubit.dart';
import 'package:project1/features/certification/presentation/cubit/certification_state.dart';
import 'package:project1/features/certification/domain/entities/certification_entity.dart';
import 'package:project1/features/quiz/domain/entities/generated_exam_entity.dart';
import 'package:project1/features/quiz/presentation/pages/details/exam_attempt_review_screen.dart';
import 'package:project1/l10n/app_localizations.dart';

class QuizResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final GeneratedExamEntity exam;
  final Map<String, Set<String>> selectedAnswers;
  final String courseId;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.exam,
    required this.selectedAnswers,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    final passed = score >= exam.passingScore;

    if (!passed) {
      return _QuizResultView(
        score: score,
        exam: exam,
        selectedAnswers: selectedAnswers,
        passed: false,
      );
    }

    return BlocProvider(
      create: (_) => getIt<CertificationCubit>(),
      child: _QuizResultView(
        score: score,
        exam: exam,
        selectedAnswers: selectedAnswers,
        passed: true,
        courseId: courseId,
      ),
    );
  }
}

class _QuizResultView extends StatefulWidget {
  final int score;
  final GeneratedExamEntity exam;
  final Map<String, Set<String>> selectedAnswers;
  final bool passed;
  final String? courseId;

  const _QuizResultView({
    required this.score,
    required this.exam,
    required this.selectedAnswers,
    required this.passed,
    this.courseId,
  });

  @override
  State<_QuizResultView> createState() => _QuizResultViewState();
}

class _QuizResultViewState extends State<_QuizResultView> {
  CertificationEntity? _earnedCertificate;

  @override
  void initState() {
    super.initState();
    if (widget.passed && widget.courseId != null) {
      _checkForCertificate();
    }
  }

  Future<void> _checkForCertificate({int attempt = 0}) async {
    final cubit = context.read<CertificationCubit>();
    await cubit.fetchMyCertifications();

    if (!mounted) return;

    final state = cubit.state;
    if (state is MyCertificationsLoaded) {
      final match = state.certifications
          .where((c) => c.courseId == widget.courseId)
          .toList();

      if (match.isNotEmpty) {
        setState(() => _earnedCertificate = match.first);
        return;
      }
    }

    if (attempt < 1) {
      await Future.delayed(const Duration(milliseconds: 1500));
      if (!mounted) return;
      _checkForCertificate(attempt: attempt + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final exam = widget.exam;
    final score = widget.score;
    final passed = widget.passed;

    final title = passed
        ? localizations.excellent
        : localizations.keepPracticing;

    final subtitle = passed
        ? localizations.youDidGreat
        : localizations.keepPracticingYoullImprove;

    final image = passed
        ? "assets/images/celebrating3.png"
        : "assets/images/sad3.png";

    final accentColor = passed
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

              Image.asset(image, height: 190),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceOf(context),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.borderOf(context)),
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
                        text: ' / ${localizations.outOf100}',
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

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accentColor.withOpacity(0.2)),
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: passed
    ? '✓ ${localizations.passed} '
    : '✗ ${localizations.failed} ',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontFamily: AppTextStyles.fontFamily,
                          color: accentColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: '(${localizations.required}: ${exam.passingScore}%)',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontFamily: AppTextStyles.fontFamily,
                          color: AppColors.textSecondaryOf(context),
                          fontWeight: FontWeight.w500,
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

              if (_earnedCertificate != null) ...[
                const SizedBox(height: 22),
                _CertificateEarnedBanner(
                  certification: _earnedCertificate!,
                ),
              ],

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
                            selectedAnswers: widget.selectedAnswers,
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
                    side: BorderSide(color: AppColors.primaryOf(context)),
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

class _CertificateEarnedBanner extends StatelessWidget {
  final CertificationEntity certification;

  const _CertificateEarnedBanner({required this.certification});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final primary = AppColors.primaryOf(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradientOf(context),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.certificateEarnedTitle,
                  style: AppTextStyles.label.copyWith(
                    fontFamily: AppTextStyles.fontFamily,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  localizations.certificateEarnedSubtitle,
                  style: AppTextStyles.caption.copyWith(
                    fontFamily: AppTextStyles.fontFamily,
                    color: Colors.white.withOpacity(0.9),
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