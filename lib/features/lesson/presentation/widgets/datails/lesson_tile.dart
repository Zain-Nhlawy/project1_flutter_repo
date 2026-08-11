import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';

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
    final primary = AppColors.primaryOf(context);
    final accent = locked ? AppColors.textSecondaryOf(context) : primary;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundOf(context),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: locked
              ? AppColors.borderOf(context).withValues(alpha: 0.70)
              : primary.withValues(alpha: 0.10),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${num.toString().padLeft(2, '0')}',
                  style: AppTextStyles.caption.copyWith(
                    color: accent.withValues(alpha: 0.72),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: locked
                        ? AppColors.textSecondaryOf(context)
                        : AppColors.textPrimaryOf(context),
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              locked ? Icons.lock_outline_rounded : Icons.play_arrow_rounded,
              color: accent,
              size: 21,
            ),
          ),
        ],
      ),
    );
  }
}
