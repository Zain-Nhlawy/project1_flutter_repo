import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/core/dummy/dummy_entities.dart';
import 'package:project1/core/presentation/widgets/app_skeletonizer.dart';
import 'package:project1/features/quiz/presentation/cubit/exam_taking_cubit.dart';
import 'package:project1/features/quiz/presentation/cubit/exam_taking_state.dart';
import 'package:project1/features/quiz/presentation/pages/details/quiz_result_screen.dart';
import 'package:project1/features/quiz/presentation/widgets/details/answer_section_title.dart';
import 'package:project1/features/quiz/presentation/widgets/details/quiz_app_bar.dart';
import 'package:project1/features/quiz/presentation/widgets/details/quiz_bottom_button.dart';
import 'package:project1/features/quiz/presentation/widgets/details/quiz_choice_tile.dart';
import 'package:project1/features/quiz/presentation/widgets/details/quiz_overview_card%20.dart';
import 'package:project1/features/quiz/presentation/widgets/details/quiz_question_card.dart';
import 'package:project1/l10n/app_localizations.dart';

class QuizScreen extends StatefulWidget {
  final String examId;
  final String demoId;

  const QuizScreen({super.key, required this.examId, required this.demoId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final ExamTakingCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ExamTakingCubit>();
    _cubit.startExam(examId: widget.examId, demoId: widget.demoId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<bool> _confirmExit(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            localizations.leaveQuiz,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            localizations.leaveQuizMessage,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondaryOf(context),
              height: 1.45,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(localizations.stay),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(
                localizations.leaveAnyway,
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );

    return confirm ?? false;
  }

  void _openResultScreen(ExamTakingSubmitted state) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => QuizResultScreen(
          score: state.result.examAttempt.score,
          total: state.result.exam.numberOfQuestions,
          exam: state.result.exam,
          selectedAnswers: state.selectedAnswers,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;

          final state = _cubit.state;

          if (state is ExamTakingSubmitted) {
            Navigator.pop(context);
            return;
          }

          final shouldExit = await _confirmExit(context);

          if (shouldExit && context.mounted) {
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.backgroundOf(context),
          appBar: const QuizAppBar(),
          body: SafeArea(
            child: BlocConsumer<ExamTakingCubit, ExamTakingState>(
              listener: (context, state) {
                if (state is ExamTakingSubmitted) {
                  _openResultScreen(state);
                }
              },
              builder: (context, state) {
                if (state is ExamTakingLoading || state is ExamTakingInitial) {
                  return const _LoadingView();
                }

                if (state is ExamTakingError) {
                  return _ErrorView(message: state.message);
                }

                if (state is ExamTakingInProgress) {
                  return _QuizContent(
                    state: state,
                    examId: widget.examId,
                    demoId: widget.demoId,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _QuizContent extends StatelessWidget {
  final ExamTakingInProgress state;
  final String examId;
  final String demoId;

  const _QuizContent({
    required this.state,
    required this.examId,
    required this.demoId,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final questions = state.exam.questions;

    if (questions.isEmpty) {
      return _EmptyView(message: localizations.noQuestionsAvailable);
    }

    final currentIndex = state.currentQuestionIndex;
    final question = questions[currentIndex];
    final selectedChoices = state.selectedAnswers[question.id] ?? <String>{};
    final totalQuestions = questions.length;
    final progress = (currentIndex + 1) / totalQuestions;
    final isLastQuestion = currentIndex == totalQuestions - 1;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(18, 22, 18, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    QuizOverviewCard(
                      currentQuestion: currentIndex + 1,
                      totalQuestions: totalQuestions,
                      progress: progress,
                      remainingSeconds: state.remainingSeconds,
                    ),
                    const SizedBox(height: 20),
                    QuizQuestionCard(
                      questionNumber: currentIndex + 1,
                      question: question.question,
                    ),
                    const SizedBox(height: 24),
                    AnswerSectionTitle(title: localizations.selectAnswer),
                    const SizedBox(height: 12),
                    ...question.choices.map((choice) {
                      final isSelected = selectedChoices.contains(choice.id);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 11),
                        child: QuizChoiceTile(
                          choice: choice.choice,
                          isSelected: isSelected,
                          onTap: () {
                            context.read<ExamTakingCubit>().toggleAnswer(
                              questionId: question.id,
                              choiceId: choice.id,
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            QuizBottomButton(
              text: isLastQuestion
                  ? localizations.submitQuiz
                  : localizations.confirmAnswer,
              isLoading: state.isSubmitting,
              enabled: selectedChoices.isNotEmpty,
              onPressed: () {
                final cubit = context.read<ExamTakingCubit>();

                if (isLastQuestion) {
                  cubit.submitExam(examId: examId, demoId: demoId);
                } else {
                  cubit.nextQuestion();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return AppSkeletonizer(
      child: _QuizContent(
        state: ExamTakingInProgress(
          exam: dummyGeneratedExam,
          selectedAnswers: const {},
          currentQuestionIndex: 0,
          remainingSeconds: dummyGeneratedExam.durationMinutes * 60,
        ),
        examId: dummyGeneratedExam.id,
        demoId: 'demo-placeholder',
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final String message;

  const _EmptyView({required this.message});

  @override
  Widget build(BuildContext context) {
    return _StatusCard(
      icon: Icons.quiz_outlined,
      iconColor: AppColors.primaryOf(context),
      message: message,
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return _StatusCard(
      icon: Icons.error_outline_rounded,
      iconColor: AppColors.error,
      message: message,
    );
  }
}

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String message;

  const _StatusCard({
    required this.icon,
    required this.iconColor,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(28),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
        decoration: BoxDecoration(
          color: AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.borderOf(context)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(19),
              ),
              child: Icon(icon, color: iconColor, size: 29),
            ),
            const SizedBox(height: 15),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondaryOf(context),
                fontWeight: FontWeight.w600,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
