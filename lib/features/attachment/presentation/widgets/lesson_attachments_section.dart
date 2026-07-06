import 'package:flutter/material.dart';
import 'package:project1/features/attachment/presentation/widgets/lesson_attachment_card.dart';
import 'package:project1/features/lesson/presentation/pages/create_lesson_screen.dart';
import 'package:project1/l10n/app_localizations.dart';

class LessonAttachmentsSection extends StatelessWidget {
  final List<LessonAttachment> attachments;
  final VoidCallback onAdd;
  final Function(LessonAttachment) onEdit;
  final Function(LessonAttachment) onDelete;

  const LessonAttachmentsSection({
    super.key,
    required this.attachments,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l.lessonAttachments,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: Text(l.addAttachment),
            )
          ],
        ),

        const SizedBox(height: 10),

        if (attachments.isEmpty)
          Text(
            l.noAttachments,
            style: const TextStyle(color: Colors.grey),
          ),

        ...attachments.map(
          (e) => LessonAttachmentCard(
            attachment: e,
            onEdit: () => onEdit(e),
            onDelete: () => onDelete(e),
          ),
        ),
      ],
    );
  }
}