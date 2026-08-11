import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/course/presentation/cubit/course_cubit.dart';
import 'package:project1/features/course/presentation/cubit/course_state.dart';
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
          backgroundColor: AppColors.surfaceOf(dialogContext),
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          contentPadding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
          actionsPadding: const EdgeInsets.fromLTRB(14, 6, 14, 14),
          title: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.error,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  localizations.deleteCourseTitle,
                  style: TextStyle(
                    color: AppColors.textPrimaryOf(dialogContext),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            localizations.deleteCourseConfirmation,
            style: TextStyle(
              color: AppColors.textSecondaryOf(dialogContext),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                localizations.cancel,
                style: TextStyle(
                  color: AppColors.textSecondaryOf(dialogContext),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
              label: Text(
                localizations.delete,
                style: const TextStyle(fontWeight: FontWeight.w800),
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

    return BlocBuilder<CourseCubit, CourseState>(
      builder: (context, state) {
        final isDeleting = state is CourseDeleting;

        return Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppColors.error.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: OutlinedButton.icon(
            onPressed: isDeleting ? null : () => _showConfirmDialog(context),
            icon: isDeleting
                ? const SizedBox(
                    width: 19,
                    height: 19,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.1,
                      color: AppColors.error,
                    ),
                  )
                : const Icon(Icons.delete_outline_rounded, size: 21),
            label: Text(
              localizations.deleteCourseTitle,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.surfaceOf(context),
              foregroundColor: AppColors.error,
              disabledForegroundColor: AppColors.error.withValues(alpha: 0.7),
              side: BorderSide(
                color: AppColors.error.withValues(alpha: 0.34),
                width: 1.2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
        );
      },
    );
  }
}
