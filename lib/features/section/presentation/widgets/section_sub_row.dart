import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';

class SectionSubRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onEdit;

  const SectionSubRow({
    required this.icon,
    required this.label,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(
              Icons.edit_outlined,
              size: 18,
              color: AppColors.textSecondary,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: 18,
          ),
        ],
      ),
    );
  }
}
