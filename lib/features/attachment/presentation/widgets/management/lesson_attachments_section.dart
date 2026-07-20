import 'package:flutter/material.dart';
import 'package:project1/features/attachment/domain/entities/lesson_attachment_entity.dart';
import 'package:project1/features/attachment/presentation/widgets/management/lesson_attachment_card.dart';
import 'package:project1/l10n/app_localizations.dart';

class LessonAttachmentsSection extends StatelessWidget {
  final List<LessonAttachmentEntity> attachments;

  final VoidCallback onAdd;

  final void Function(LessonAttachmentEntity) onEdit;
  final void Function(LessonAttachmentEntity) onDelete;

  final bool enabled;
  final bool isUploading;

  const LessonAttachmentsSection({
    super.key,
    required this.attachments,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    this.enabled = true,
    this.isUploading = false,
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

            if (enabled)
              FilledButton.icon(
                onPressed: isUploading ? null : onAdd,

                icon: isUploading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add),

                label: Text(l.addAttachment),
              ),
          ],
        ),

        const SizedBox(height: 10),

        if (attachments.isEmpty && !isUploading)
          Text(l.noAttachments, style: const TextStyle(color: Colors.grey)),

        IgnorePointer(
          ignoring: !enabled,

          child: Opacity(
            opacity: enabled ? 1 : 0.6,

            child: Column(
              children: attachments.map((attachment) {
                return LessonAttachmentCard(
                  attachment: attachment,

                  onEdit: () {
                    onEdit(attachment);
                  },

                  onDelete: () {
                    onDelete(attachment);
                  },
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
