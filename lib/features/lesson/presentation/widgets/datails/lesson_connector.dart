import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';

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
    final primary = AppColors.primaryOf(context);
    final lineColor = primary.withValues(alpha: 0.18);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (showTopLine) Container(width: 2, height: 9, color: lineColor),
            Container(
              width: 31,
              height: 31,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: AppColors.buttonGradientOf(context),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primary.withValues(alpha: 0.16),
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                num.toString(),
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Container(
              width: 2,
              height: hasExam ? 68 : (isLast ? 0 : 68),
              color: lineColor,
            ),
            if (hasExam)
              Container(
                width: 31,
                height: 31,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                  border: Border.all(color: primary.withValues(alpha: 0.18)),
                ),
                child: Icon(Icons.quiz_rounded, color: primary, size: 16),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(child: child),
      ],
    );
  }
}
