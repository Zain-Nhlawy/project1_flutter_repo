import 'package:flutter/material.dart';

class LessonConnector extends StatelessWidget {
  final Widget child;
  final bool isLast;
  final bool showTopLine;
  final int num;

  const LessonConnector({
    super.key,
    required this.child,
    required this.num,
    this.isLast = false,
    this.showTopLine = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (showTopLine)
              Container(
                width: 2,
                height: 10,
                color: Theme.of(context).primaryColor.withOpacity(0.3),
              ),
            CircleAvatar(
              radius: 15,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                "$num",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: Theme.of(context).primaryColor.withOpacity(0.3),
              ),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(child: child),
      ],
    );
  }
}