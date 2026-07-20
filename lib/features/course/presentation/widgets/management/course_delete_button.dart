import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/course/presentation/cubit/course_cubit.dart';
import 'package:project1/l10n/app_localizations.dart';

class CourseDeleteButton extends StatelessWidget {
  final String courseId;

  const CourseDeleteButton({super.key, required this.courseId});

  Future<void> _showConfirmDialog(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(localizations.deleteCourseTitle),
          content: Text(localizations.deleteCourseConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(localizations.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(
                localizations.delete,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true && context.mounted) {
      context.read<CourseCubit>().deleteCourse(courseId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () => _showConfirmDialog(context),
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        label: Text(
          localizations.deleteCourseTitle,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
