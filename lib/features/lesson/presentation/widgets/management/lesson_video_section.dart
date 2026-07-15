import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/lesson/upload_video/presentation/cubit/lesson_video_upload_state.dart';
import 'package:project1/l10n/app_localizations.dart';

class LessonVideoSection extends StatelessWidget {
  final LessonVideoUploadState state;
  final File? selectedFile;
  final Uint8List? thumbnail;
  final bool loadingThumbnail;
  final VoidCallback onPick;

  const LessonVideoSection({
    super.key,
    required this.state,
    required this.selectedFile,
    required this.onPick,
    this.thumbnail,
    this.loadingThumbnail = false,
  });

  @override
  Widget build(BuildContext context) {
    final isUploading = state is LessonVideoUploadRequestingUrl ||
        state is LessonVideoUploadInProgress;

    return InkWell(
      onTap: isUploading ? null : onPick,
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
                const Center(child: CircularProgressIndicator(strokeWidth: 2))
              else if (thumbnail != null)
                Image.memory(thumbnail!, fit: BoxFit.cover)
              else if (selectedFile == null)
                const Center(
                  child: Icon(Icons.video_call_outlined, size: 40, color: AppColors.textSecondary),
                )
              else
                const Center(
                  child: Icon(Icons.video_library_outlined, size: 40, color: AppColors.textSecondary),
                ),

              if (thumbnail != null && !loadingThumbnail)
                Container(
                  color: Colors.black.withOpacity(0.25),
                  child: const Center(
                    child: Icon(Icons.play_circle_fill_rounded, size: 52, color: Colors.white),
                  ),
                ),

              if (isUploading)
                Container(
                  color: Colors.black.withOpacity(0.4),
                  child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                ),

              if (selectedFile == null && thumbnail == null && !loadingThumbnail)
                Positioned(
                  bottom: 12,
                  child: Text(
                    AppLocalizations.of(context)!.pressToSelectVideo,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}