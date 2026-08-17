import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';

class CourseStatsCard extends StatelessWidget {
  final IconData firstIcon;
  final String firstLabel;
  final String firstValue;
  final IconData secondIcon;
  final String secondLabel;
  final String secondValue;

  const CourseStatsCard({
    super.key,
    required this.firstIcon,
    required this.firstLabel,
    required this.firstValue,
    required this.secondIcon,
    required this.secondLabel,
    required this.secondValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.borderOf(context), width: 1.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _StatTile(icon: firstIcon, label: firstLabel, value: firstValue),
          Container(
            width: 1,
            height: 34,
            color: AppColors.borderOf(context),
          ),
          _StatTile(icon: secondIcon, label: secondLabel, value: secondValue),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);

    return Column(
      children: [
        Icon(icon, color: primary, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: AppColors.textPrimaryOf(context),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondaryOf(context).withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}