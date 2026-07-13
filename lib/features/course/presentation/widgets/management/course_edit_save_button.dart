import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/l10n/app_localizations.dart';

class CourseEditSaveButton extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onPressed;

  const CourseEditSaveButton({
    super.key,
    required this.isEditing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          isEditing ? Icons.check_circle_outline : Icons.edit_outlined,
          color: isEditing ? Colors.white : AppColors.primary,
        ),
        label: Text(
          isEditing ? localizations.saveChanges : localizations.editCourse,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isEditing ? Colors.white : AppColors.primary,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: isEditing ? Colors.green.shade600 : Colors.transparent,
          side: BorderSide(
            color: isEditing ? Colors.green.shade600 : AppColors.primary,
            width: 1.6,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}