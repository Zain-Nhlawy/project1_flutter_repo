import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/lesson/upload_video/presentation/cubit/lesson_video_upload_state.dart';
import 'package:project1/l10n/app_localizations.dart';

class LessonUploadProgress extends StatelessWidget {
  final LessonVideoUploadState state;

  const LessonUploadProgress({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    String label;
    double? progressValue;

    final l10n = AppLocalizations.of(context)!;

    if (state is LessonVideoUploadRequestingUrl) {
      label = l10n.preparingToUpload;
      progressValue = null;
    } else if (state is LessonVideoUploadInProgress) {
      final progress = (state as LessonVideoUploadInProgress).progress;
      progressValue = progress.clamp(0.0, 1.0);

      label = l10n.uploadingVideo.replaceFirst(
        '{progress}',
        (progressValue * 100).toStringAsFixed(0),
      );
    } else {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondaryOf(context),
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 6,
              backgroundColor: AppColors.borderOf(context),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
