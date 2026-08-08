import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/l10n/app_localizations.dart';

class QuizReviewNoteCard extends StatelessWidget {
  final String note;

  const QuizReviewNoteCard({
    super.key,
    required this.note,
  });

  static const _noteColor = Color(0xFFB78103);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _noteColor.withOpacity(.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _noteColor.withOpacity(.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                size: 18,
                color: _noteColor,
              ),
              const SizedBox(width: 8),
              Text(
                localizations.questionNote,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: _noteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            note,
            style: AppTextStyles.bodyMedium.copyWith(
              color: _noteColor,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}