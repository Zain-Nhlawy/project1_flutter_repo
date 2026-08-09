import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/lesson/presentation/widgets/custom_text_field.dart';
import 'package:project1/l10n/app_localizations.dart';

class LessonFormSection extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final bool enabled;

  const LessonFormSection({
    super.key,
    required this.titleController,
    required this.descriptionController,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    final primary = AppColors.primaryOf(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.78),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(Icons.edit_note_rounded, color: primary, size: 21),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  l.lessonTitle,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimaryOf(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: titleController,
            hintText: l.enterLessonTitle,
            icon: Icons.title_rounded,
            enabled: enabled,
          ),
          const SizedBox(height: 14),
          CustomTextField(
            controller: descriptionController,
            hintText: l.enterLessonDescription,
            icon: Icons.description_outlined,
            maxLines: 6,
            enabled: enabled,
          ),
        ],
      ),
    );
  }
}
