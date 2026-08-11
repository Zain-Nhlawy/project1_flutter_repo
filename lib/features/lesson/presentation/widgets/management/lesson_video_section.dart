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
    final isUploading =
        state is LessonVideoUploadRequestingUrl ||
        state is LessonVideoUploadInProgress;
    final primary = AppColors.primaryOf(context);

    return InkWell(
      onTap: isUploading ? null : onPick,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: 205,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: thumbnail == null
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    primary.withValues(alpha: 0.11),
                    AppColors.surfaceOf(context),
                  ],
                )
              : null,
          color: AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: primary.withValues(alpha: 0.22),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.045),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(21),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (loadingThumbnail)
                const Center(child: CircularProgressIndicator(strokeWidth: 2))
              else if (thumbnail != null)
                Image.memory(thumbnail!, fit: BoxFit.cover)
              else if (selectedFile == null)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceOf(context),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primary.withValues(alpha: 0.15),
                              blurRadius: 14,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.video_call_outlined,
                          size: 30,
                          color: primary,
                        ),
                      ),
                      const SizedBox(height: 13),
                      Text(
                        AppLocalizations.of(context)!.pressToSelectVideo,
                        style: TextStyle(
                          color: AppColors.textPrimaryOf(context),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Center(
                  child: Icon(
                    Icons.video_library_outlined,
                    size: 40,
                    color: AppColors.textSecondaryOf(context),
                  ),
                ),

              if (thumbnail != null && !loadingThumbnail)
                Container(
                  color: Colors.black.withValues(alpha: 0.25),
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
                  color: Colors.black.withValues(alpha: 0.4),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
