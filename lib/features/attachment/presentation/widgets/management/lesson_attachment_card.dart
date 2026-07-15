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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Icon(_iconFor(attachment.path), color: Colors.white),
        ),
        title: Text(
          attachment.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
            ),
            IconButton(
              onPressed: onDelete,
              icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
            ),
          ],
        ),
      ),
    );
  }
}



