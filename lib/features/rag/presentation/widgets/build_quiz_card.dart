import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/rag/data/models/quiz_question_model.dart';
import 'package:project1/l10n/app_localizations.dart';

class QuizCard extends StatefulWidget {
  final QuizQuestionModel question;
  final int index;

  const QuizCard({
    super.key,
    required this.question,
    required this.index,
  });

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

  Color _optionBorderColor(String option, bool isDark) {
    if (!_submitted) {
      return _selectedOption == option
          ? AppColors.primary
          : AppColors.border;
    }
    if (_isCorrectOption(option)) return AppColors.success;
    if (option == _selectedOption) return Colors.red.shade400;
    return AppColors.border;
  }

  Color _optionBackgroundColor(String option, bool isDark) {
    if (!_submitted) {
      return _selectedOption == option
          ? AppColors.primary.withOpacity(.08)
          : (isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.02));
    }
    if (_isCorrectOption(option)) {
      return AppColors.success.withOpacity(.1);
    }
    if (option == _selectedOption) {
      return Colors.red.shade400.withOpacity(.08);
    }
    return isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.02);
  }

  IconData? _optionTrailingIcon(String option) {
    if (!_submitted) return null;
    if (_isCorrectOption(option)) return Icons.check_circle_rounded;
    if (option == _selectedOption) return Icons.cancel_rounded;
    return null;
  }

  Color _optionTrailingIconColor(String option) {
    if (_isCorrectOption(option)) return AppColors.success;
    return Colors.red.shade400;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimaryColor = AppColors.textPrimaryOf(context);
    final textSecondaryColor = AppColors.textSecondaryOf(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.index}. ${widget.question.question}',
            style: AppTextStyles.bodyMedium.copyWith(
              color: textPrimaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          for (final option in widget.question.options)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => _selectOption(option),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: _optionBackgroundColor(option, isDark),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _optionBorderColor(option, isDark),
                      width: _selectedOption == option || (_submitted && _isCorrectOption(option))
                          ? 1.6
                          : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          option,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: textPrimaryColor,
                            fontWeight: (_selectedOption == option || (_submitted && _isCorrectOption(option)))
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                      if (_optionTrailingIcon(option) != null)
                        Icon(
                          _optionTrailingIcon(option),
                          size: 20,
                          color: _optionTrailingIconColor(option),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 4),
          if (!_submitted)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _selectedOption == null ? AppColors.border : AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _selectedOption == null ? null : _submit,
                child: Text(
                  localizations.checkAnswer,
                  style: TextStyle(
                    color: _selectedOption == null ? textSecondaryColor : Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (_isSelectedCorrect ? AppColors.success : Colors.red.shade400)
                    .withOpacity(.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _isSelectedCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                        size: 18,
                        color: _isSelectedCorrect ? AppColors.success : Colors.red.shade400,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isSelectedCorrect
                            ? localizations.correctAnswerFeedback
                            : localizations.incorrectAnswerFeedback,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: _isSelectedCorrect ? AppColors.success : Colors.red.shade400,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (widget.question.explanation.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      widget.question.explanation,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: textSecondaryColor,
                        fontStyle: FontStyle.italic,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _reset,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(localizations.tryAgain),
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              ),
            ),
          ],
        ],
      ),
    );
  }
}