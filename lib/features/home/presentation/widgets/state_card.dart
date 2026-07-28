import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String count;
  final String label;

  const StatCard({
    super.key,
    required this.icon,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20 * textScale),
          ),
          const SizedBox(height: 12),
          Text(
            count,
            style: AppTextStyles.h2.copyWith(
              color: AppColors.surface,
              fontWeight: FontWeight.bold,
              fontSize: 22 * textScale,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: AppColors.surface,
              fontSize: 12 * textScale,
            ),
          ),
        ],
      ),
    );
  }
}
