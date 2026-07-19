import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';


class FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const FaqItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.borderOf(context),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 6,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            20,
            0,
            20,
            20,
          ),

          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          expandedAlignment: Alignment.centerLeft,

          iconColor: AppColors.primaryOf(context),
          collapsedIconColor: AppColors.primaryOf(context),

          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              question,
              textAlign: TextAlign.left,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.primaryOf(context),
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
          ),

          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                answer,
                textAlign: TextAlign.left,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondaryOf(context),
                  height: 1.7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}