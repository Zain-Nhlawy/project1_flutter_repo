import 'package:flutter/material.dart';

class LessonTile extends StatelessWidget {
  final int num;
  final String title;
  final bool locked;

  const LessonTile({
    super.key,
    required this.num,
    required this.title,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: locked ? Colors.grey : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            locked ? Icons.lock_outline : Icons.play_circle_outline,
            size: 20,
            color: locked ? Colors.grey : null,
          ),
        ],
      ),
    );
  }
}