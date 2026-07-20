import 'package:flutter/material.dart';
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

    return Column(
      children: [
        CustomTextField(
          controller: titleController,
          hintText: l.enterLessonTitle,
          icon: Icons.title,
          enabled: enabled,
        ),
        const SizedBox(height: 24),
        CustomTextField(
          controller: descriptionController,
          hintText: l.enterLessonDescription,
          icon: Icons.description,
          maxLines: 6,
          enabled: enabled,
        ),
      ],
    );
  }
}
