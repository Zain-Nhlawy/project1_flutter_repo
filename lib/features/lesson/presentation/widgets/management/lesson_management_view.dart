import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/attachment/presentation/widgets/management/lesson_attachments_manager.dart';
import 'package:project1/features/lesson/presentation/widgets/management/lesson_info_form.dart';
import 'package:project1/features/lesson/presentation/widgets/management/lesson_management_app_bar.dart';
import 'package:project1/features/lesson/presentation/widgets/management/lesson_save_button.dart';
import 'package:project1/features/lesson/presentation/widgets/management/lesson_video_picker_field.dart';
import 'package:project1/features/lesson/upload_video/presentation/cubit/lesson_video_upload_cubit.dart';
import 'package:project1/features/lesson/upload_video/presentation/cubit/lesson_video_upload_state.dart';

class LessonManagementView extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final String lessonId;
  final Uint8List? videoThumbnail;
  final String? thumbnailUrl;
  final bool loadingThumbnail;
  final bool isEditing;
  final bool isSaving;
  final VoidCallback onPickVideo;
  final VoidCallback onToggleEditOrSave;
  final Future<void> Function(bool isBusy) onBack;

  const LessonManagementView({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.lessonId,
    required this.videoThumbnail,
    this.thumbnailUrl,
    required this.loadingThumbnail,
    required this.isEditing,
    required this.isSaving,
    required this.onPickVideo,
    required this.onToggleEditOrSave,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonVideoUploadCubit, LessonVideoUploadState>(
      builder: (context, videoState) {
        final isUploadingVideo =
            videoState is LessonVideoUploadRequestingUrl ||
            videoState is LessonVideoUploadInProgress;

        final isBusy = isUploadingVideo || isSaving;

        return PopScope(
          canPop: !isBusy,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            onBack(isBusy);
          },
          child: Scaffold(
            backgroundColor: AppColors.backgroundOf(context),
            appBar: LessonManagementAppBar(onBackPressed: () => onBack(isBusy)),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 55),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LessonVideoPickerField(
                    thumbnail: videoThumbnail,
                    thumbnailUrl: thumbnailUrl,
                    loadingThumbnail: loadingThumbnail,
                    enabled: isEditing,
                    isUploading: isUploadingVideo,
                    uploadState: videoState,
                    onTap: onPickVideo,
                  ),
                  const SizedBox(height: 24),
                  LessonInfoForm(
                    titleController: titleController,
                    descriptionController: descriptionController,
                    enabled: isEditing,
                  ),
                  const SizedBox(height: 24),
                  LessonAttachmentsManager(
                    lessonId: lessonId,
                    enabled: isEditing,
                  ),
                  const SizedBox(height: 32),
                  LessonSaveButton(
                    isEditing: isEditing,
                    isSaving: isSaving,
                    onPressed: isSaving ? null : onToggleEditOrSave,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
