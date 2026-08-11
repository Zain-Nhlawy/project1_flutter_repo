import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/core/presentation/widgets/gradient_action_button.dart';
import 'package:project1/features/course/presentation/cubit/course_cubit.dart';
import 'package:project1/features/course/presentation/cubit/course_state.dart';
import 'package:project1/l10n/app_localizations.dart';

class CoursePublishButton extends StatelessWidget {
  final String courseId;

  const CoursePublishButton({super.key, required this.courseId});

  Future<void> _showConfirmDialog(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        final primary = AppColors.primaryOf(dialogContext);

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
                  color: primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.rocket_launch_outlined,
                  color: primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  localizations.publishCourse,
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
            localizations.publishCourseConfirmation,
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
                backgroundColor: primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.rocket_launch_outlined, size: 18),
              label: Text(
                localizations.publish,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
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

    return BlocBuilder<CourseCubit, CourseState>(
      builder: (context, state) {
        final isPublishing = state is CoursePublishing;

        return GradientActionButton(
          label: localizations.publish,
          icon: Icons.rocket_launch_outlined,
          isLoading: isPublishing,
          expand: true,
          onPressed: isPublishing ? null : () => _showConfirmDialog(context),
        );
      },
    );
  }
}
