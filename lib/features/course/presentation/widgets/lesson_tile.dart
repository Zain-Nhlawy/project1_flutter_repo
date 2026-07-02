import 'package:flutter/material.dart';

class LessonTile extends StatelessWidget {
  final int num;

  const LessonTile({
    super.key,
    required this.num,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
        ),
      ),
      child: Text(
        "Deep Sea Logic Lesson $num",
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}