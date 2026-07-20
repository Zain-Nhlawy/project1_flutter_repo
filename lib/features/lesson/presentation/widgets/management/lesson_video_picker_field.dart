import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/lesson/presentation/widgets/management/lesson_upload_progress.dart';
import 'package:project1/features/lesson/upload_video/presentation/cubit/lesson_video_upload_state.dart';

class LessonVideoPickerField extends StatelessWidget {
  final Uint8List? thumbnail;
  final String? thumbnailUrl;
  final bool loadingThumbnail;
  final bool enabled;
  final bool isUploading;
  final LessonVideoUploadState uploadState;
  final VoidCallback onTap;

  const LessonVideoPickerField({
    super.key,
    required this.thumbnail,
    this.thumbnailUrl,
    required this.loadingThumbnail,
    required this.enabled,
    required this.isUploading,
    required this.uploadState,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (loadingThumbnail)
                    const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else if (thumbnail != null)
                    Image.memory(thumbnail!, fit: BoxFit.cover)
                  else if (thumbnailUrl != null)
                    Image.network(
                      thumbnailUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.video_library_outlined,
                            size: 40,
                            color: AppColors.textSecondary,
                          ),
                        );
                      },
                    )
                  else
                    const Center(
                      child: Icon(
                        Icons.video_library_outlined,
                        size: 40,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  if (!loadingThumbnail &&
                      (thumbnail != null || thumbnailUrl != null))
                    Container(
                      color: Colors.black.withOpacity(0.25),
                      child: const Center(
                        child: Icon(
                          Icons.play_circle_fill_rounded,
                          size: 52,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  if (isUploading)
                    Container(
                      color: Colors.black.withOpacity(0.4),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  if (enabled && !isUploading)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (isUploading) LessonUploadProgress(state: uploadState),
      ],
    );
  }
}
