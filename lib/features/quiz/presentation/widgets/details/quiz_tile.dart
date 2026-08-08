import 'package:flutter/material.dart';
import 'package:project1/features/quiz/presentation/pages/details/quiz_screen.dart';
import 'package:project1/l10n/app_localizations.dart';

class QuizTile extends StatelessWidget {
  final String examId;
  final String demoId;

  const QuizTile({
    super.key,
    required this.examId,
    required this.demoId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuizScreen(
              demoId: demoId,
              examId: examId,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 25),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.quiz,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.quiz_outlined,
              size: 20,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}