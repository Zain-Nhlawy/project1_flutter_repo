import 'package:flutter/material.dart';
import 'package:project1/features/quiz/presentation/pages/details/quiz_screen.dart';
import 'package:project1/l10n/app_localizations.dart';

class QuizTile extends StatelessWidget {
  final String examId;
  final String? demoId;
  final bool locked;
  final String courseId;

  const QuizTile({
    super.key,
    required this.examId,
    this.demoId,
    this.locked = false,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: locked
          ? null
          : () {
              if (demoId == null) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuizScreen(demoId: demoId!, examId: examId, courseId: courseId,),
                ),
              );
            },
      child: Container(
        margin: const EdgeInsets.only(bottom: 25),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.quiz,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: locked ? Colors.grey : null,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              locked ? Icons.lock_outline : Icons.quiz_outlined,
              size: 20,
              color: locked ? Colors.grey : theme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
