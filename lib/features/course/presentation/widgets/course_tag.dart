import 'package:flutter/material.dart';

class CourseTag extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback? onTap;

  const CourseTag({
    super.key,
    required this.text,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected ? primaryColor : primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? primaryColor : primaryColor.withOpacity(0.15),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                color: selected ? Colors.white : primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}