import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/lesson/presentation/pages/create_lesson_screen.dart';

class LessonAttachmentCard extends StatelessWidget {
  final LessonAttachment attachment;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LessonAttachmentCard({
    super.key,
    required this.attachment,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Icon(
            Icons.attach_file,
            color: Colors.white,
          ),
        ),
        title: Text(
          attachment.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onEdit,
              icon: const Icon(
                Icons.edit_outlined,
                color: AppColors.primary,
              ),
            ),
            IconButton(
              onPressed: onDelete,
              icon: Icon(
                Icons.delete_outline,
                color: Colors.red.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}