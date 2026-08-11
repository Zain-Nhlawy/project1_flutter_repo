import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/attachment/domain/entities/lesson_attachment_entity.dart';

class LessonAttachmentCard extends StatelessWidget {
  final LessonAttachmentEntity attachment;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LessonAttachmentCard({
    super.key,
    required this.attachment,
    required this.onEdit,
    required this.onDelete,
  });

  IconData _iconFor(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'zip':
        return Icons.folder_zip;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'doc':
      case 'docx':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _accentFor(BuildContext context, String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return AppColors.error;
      case 'zip':
        return AppColors.warning;
      case 'ppt':
      case 'pptx':
        return const Color(0xFFEA6B35);
      default:
        return AppColors.primaryOf(context);
    }
  }

  String _extensionFor(String path) {
    final parts = path.split('.');
    return parts.length > 1 ? parts.last.toUpperCase() : 'FILE';
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);
    final accent = _accentFor(context, attachment.path);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundOf(context),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.78),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(_iconFor(attachment.path), color: accent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textPrimaryOf(context),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    _extensionFor(attachment.path),
                    style: TextStyle(
                      color: accent,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(11),
            ),
            child: IconButton(
              onPressed: onEdit,
              padding: EdgeInsets.zero,
              icon: Icon(Icons.edit_outlined, color: primary, size: 18),
            ),
          ),
          const SizedBox(width: 7),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(11),
            ),
            child: IconButton(
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
