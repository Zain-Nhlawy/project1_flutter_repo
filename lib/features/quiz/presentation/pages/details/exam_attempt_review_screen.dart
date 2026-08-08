import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/quiz/domain/entities/generated_exam_entity.dart';
import 'package:project1/features/quiz/presentation/widgets/details/quiz_app_bar.dart';
import 'package:project1/features/quiz/presentation/widgets/details/quiz_progress_header.dart';
import 'package:project1/features/quiz/presentation/widgets/details/quiz_question_card.dart';
import 'package:project1/features/quiz/presentation/widgets/details/quiz_review_bottom_bar.dart';
import 'package:project1/features/quiz/presentation/widgets/details/quiz_review_choice_tile.dart';
import 'package:project1/features/quiz/presentation/widgets/details/quiz_review_note_card.dart';
import 'package:project1/l10n/app_localizations.dart';

class ExamAttemptReviewScreen extends StatefulWidget {
  final GeneratedExamEntity exam;
  final Map<String, Set<String>> selectedAnswers;

  const ExamAttemptReviewScreen({
    super.key,
    required this.exam,
    required this.selectedAnswers,
  });

  @override
  State<ExamAttemptReviewScreen> createState() =>
      _ExamAttemptReviewScreenState();
}

class _ExamAttemptReviewScreenState
    extends State<ExamAttemptReviewScreen> {
  int _currentIndex = 0;

  void _goToPrevious() {
    if (_currentIndex <= 0) return;
    setState(() => _currentIndex--);
  }

  void _goToNext() {
    final lastIndex = widget.exam.questions.length - 1;
    if (_currentIndex >= lastIndex) return;
    setState(() => _currentIndex++);
  }

  // Review is pushed on top of the Result screen, and the Result screen
  // itself replaced the Quiz screen. So to land back on the course screen
  // (same destination as "Exit Quiz"), we close both Review and Result.
  void _onDone() {
    final navigator = Navigator.of(context);
    navigator.pop();
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final questions = widget.exam.questions;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: QuizAppBar(
        title: localizations.reviewAnswers,
      ),
      body: SafeArea(
        child: questions.isEmpty
            ? Center(
                child: Text(
                  localizations.noQuestionsAvailable,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            : _ReviewContent(
                exam: widget.exam,
                selectedAnswers: widget.selectedAnswers,
                currentIndex: _currentIndex,
                onPrevious: _goToPrevious,
                onNext: _goToNext,
                onDone: _onDone,
              ),
      ),
    );
  }
}

class _ReviewContent extends StatelessWidget {
  final GeneratedExamEntity exam;
  final Map<String, Set<String>> selectedAnswers;
  final int currentIndex;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onDone;

  const _ReviewContent({
    required this.exam,
    required this.selectedAnswers,
    required this.currentIndex,
    required this.onPrevious,
    required this.onNext,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final questions = exam.questions;
    final question = questions[currentIndex];

    final selectedChoices =
        selectedAnswers[question.id] ?? <String>{};

    final totalQuestions = questions.length;
    final progress = (currentIndex + 1) / totalQuestions;
    final isFirstQuestion = currentIndex == 0;
    final isLastQuestion = currentIndex == totalQuestions - 1;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuizProgressHeader(
                  currentQuestion: currentIndex + 1,
                  totalQuestions: totalQuestions,
                  progress: progress,
                ),

                const SizedBox(height: 24),

                QuizQuestionCard(
                  questionNumber: currentIndex + 1,
                  question: question.question,
                ),

                const SizedBox(height: 20),

                Text(
                  localizations.selectAnswer,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                ...question.choices.map(
                  (choice) {
                    final isSelected =
                        selectedChoices.contains(choice.id);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: QuizReviewChoiceTile(
                        choice: choice.choice,
                        isSelected: isSelected,
                        isCorrect: choice.isCorrect ?? false,
                      ),
                    );
                  },
                ),

                if (question.note.trim().isNotEmpty) ...[
                  const SizedBox(height: 16),
                  QuizReviewNoteCard(note: question.note),
                ],
              ],
            ),
          ),
        ),

        QuizReviewBottomBar(
          isFirst: isFirstQuestion,
          isLast: isLastQuestion,
          onPrevious: onPrevious,
          onNext: onNext,
          onDone: onDone,
        ),
      ],
    );
  }
}