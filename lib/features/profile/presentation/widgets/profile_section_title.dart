import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';

class ProfileSectionTitle extends StatelessWidget {
  final String title;

  const ProfileSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12, top: 24),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.label.copyWith(
          color: AppColors.textSecondaryOf(context).withValues(alpha: 0.7),
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          fontSize: 12 * textScale,
        ),
      ),
    );
  }
}
