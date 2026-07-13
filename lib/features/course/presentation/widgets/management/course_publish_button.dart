import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/course/presentation/cubit/course_cubit.dart';
import 'package:project1/l10n/app_localizations.dart';

class CoursePublishButton extends StatelessWidget {
  final String courseId;

  const CoursePublishButton({
    super.key,
    required this.courseId,
  });

  Future<void> _showConfirmDialog(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(localizations.publishCourse),
          content: Text(localizations.publishCourseConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(localizations.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(localizations.publish),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      context.read<CourseCubit>().publishCourse(courseId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () => _showConfirmDialog(context),
        icon: const Icon(Icons.publish, color: Colors.white),
        label: Text(localizations.publish),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}