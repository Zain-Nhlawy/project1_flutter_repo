import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/faq/domain/entities/course_faq_entity.dart';

class FaqTile extends StatelessWidget {
  final CourseFaqEntity faq;
  final VoidCallback onDelete;

  const FaqTile({required this.faq, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.help_outline_rounded,
              color: AppColors.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq.question,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  faq.answer,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.red,
              size: 20,
            ),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
