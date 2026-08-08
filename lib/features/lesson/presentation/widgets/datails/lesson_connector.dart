import 'package:flutter/material.dart';

class LessonConnector extends StatelessWidget {
  final Widget child;
  final bool isLast;
  final bool showTopLine;
  final int num;
  final bool hasExam;

  const LessonConnector({
    super.key,
    required this.child,
    required this.num,
    this.isLast = false,
    this.showTopLine = true,
    this.hasExam = false,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (showTopLine)
              Container(
                width: 2,
                height: 10,
                color: primaryColor.withOpacity(0.3),
              ),
            CircleAvatar(
              radius: 15,
              backgroundColor: primaryColor,
              child: Text(
                "$num",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
            Container(
              width: 2,
              height: hasExam ? 60 : (isLast ? 0 : 60),
              color: primaryColor.withOpacity(0.3),
            ),
            if (hasExam)
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                ),
                child: const Icon(
                  Icons.quiz_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(child: child),
      ],
    );
  }
}