import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/presentation/widgets/gradient_action_button.dart';
import 'package:project1/features/rag/data/models/quiz_question_model.dart';
import 'package:project1/l10n/app_localizations.dart';

class QuizCard extends StatefulWidget {
  final QuizQuestionModel question;
  final int index;

  const QuizCard({super.key, required this.question, required this.index});

  @override
  State<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  String? _selectedOption;
  bool _submitted = false;

  bool _isCorrectOption(String option) {
    return option.trim().startsWith(widget.question.correctAnswer);
  }

  bool get _isSelectedCorrect =>
      _selectedOption != null && _isCorrectOption(_selectedOption!);

  void _selectOption(String option) {
    if (_submitted) return;
    setState(() => _selectedOption = option);
  }

  void _submit() {
    if (_selectedOption == null) return;
    setState(() => _submitted = true);
  }

  void _reset() {
    setState(() {
      _selectedOption = null;
      _submitted = false;
    });
  }

  Color _optionBorderColor(BuildContext context, String option) {
    if (!_submitted) {
      return _selectedOption == option
          ? AppColors.primaryOf(context)
          : AppColors.borderOf(context);
    }
    if (_isCorrectOption(option)) return AppColors.success;
    if (option == _selectedOption) return AppColors.error;
    return AppColors.borderOf(context);
  }

  Color _optionBackgroundColor(BuildContext context, String option) {
    if (!_submitted) {
      return _selectedOption == option
          ? AppColors.primaryOf(context).withValues(alpha: 0.08)
          : AppColors.surfaceOf(context);
    }
    if (_isCorrectOption(option)) {
      return AppColors.success.withValues(alpha: 0.08);
    }
    if (option == _selectedOption) {
      return AppColors.error.withValues(alpha: 0.07);
    }
    return AppColors.surfaceOf(context);
  }

  Widget _optionIndicator(BuildContext context, String option) {
    final selected = option == _selectedOption;

    if (_submitted && _isCorrectOption(option)) {
      return const Icon(
        Icons.check_circle_rounded,
        color: AppColors.success,
        size: 22,
      );
    }

    if (_submitted && selected) {
      return const Icon(Icons.cancel_rounded, color: AppColors.error, size: 22);
    }

    final primary = AppColors.primaryOf(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 21,
      height: 21,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? primary : Colors.transparent,
        border: Border.all(
          color: selected ? primary : AppColors.borderOf(context),
          width: 1.5,
        ),
      ),
      child: selected
          ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final border = AppColors.borderOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.backgroundOf(context).withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: border.withValues(alpha: 0.82)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: AppColors.buttonGradientOf(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${widget.index}',
                  style: AppTextStyles.label.copyWith(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    widget.question.question,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: textPrimary,
                      fontSize: 15,
                      height: 1.45,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...widget.question.options.map((option) {
            final selected = option == _selectedOption;
            final highlighted =
                selected || (_submitted && _isCorrectOption(option));

            return Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: _submitted ? null : () => _selectOption(option),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 13,
                    ),
                    decoration: BoxDecoration(
                      color: _optionBackgroundColor(context, option),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _optionBorderColor(context, option),
                        width: highlighted ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        _optionIndicator(context, option),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Text(
                            option,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: textPrimary,
                              height: 1.4,
                              fontWeight: highlighted
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 5),
          if (!_submitted)
            GradientActionButton(
              label: localizations.checkAnswer,
              icon: Icons.fact_check_outlined,
              expand: true,
              onPressed: _selectedOption == null ? null : _submit,
            )
          else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color:
                    (_isSelectedCorrect ? AppColors.success : AppColors.error)
                        .withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color:
                      (_isSelectedCorrect ? AppColors.success : AppColors.error)
                          .withValues(alpha: 0.18),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _isSelectedCorrect
                            ? Icons.check_circle_rounded
                            : Icons.cancel_rounded,
                        size: 20,
                        color: _isSelectedCorrect
                            ? AppColors.success
                            : AppColors.error,
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          _isSelectedCorrect
                              ? localizations.correctAnswerFeedback
                              : localizations.incorrectAnswerFeedback,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: _isSelectedCorrect
                                ? AppColors.success
                                : AppColors.error,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.question.explanation.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      widget.question.explanation,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: textSecondary,
                        fontSize: 12.5,
                        height: 1.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: OutlinedButton.icon(
                onPressed: _reset,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(localizations.tryAgain),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryOf(context),
                  side: BorderSide(color: border),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 11,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
