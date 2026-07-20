import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:project1/features/lesson/presentation/widgets/custom_text_field.dart';

class LessonInfoForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final bool enabled;

  const LessonInfoForm({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(localizations.lessonTitle),
        CustomTextField(
          controller: titleController,
          hintText: localizations.enterLessonTitle,
          icon: Icons.title_rounded,
          enabled: enabled,
        ),
        const SizedBox(height: 24),
        _sectionTitle(localizations.lessonDescription),
        CustomTextField(
          controller: descriptionController,
          hintText: localizations.enterLessonDescription,
          icon: Icons.description_outlined,
          maxLines: 6,
          enabled: enabled,
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
