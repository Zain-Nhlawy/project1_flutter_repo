import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/core/errors/failures.dart';
import '../../domain/use_case/generate_video_upload_url_usecase.dart';
import '../../domain/use_case/upload_video_file_usecase.dart';
import 'lesson_video_upload_state.dart';

class LessonVideoUploadCubit extends Cubit<LessonVideoUploadState> {
  final GenerateVideoUploadUrlUseCase generateVideoUploadUrlUseCase;
  final UploadVideoFileUseCase uploadVideoFileUseCase;

  LessonVideoUploadCubit({
    required this.generateVideoUploadUrlUseCase,
    required this.uploadVideoFileUseCase,
  }) : super(const LessonVideoUploadInitial());

  List<String> _errorsOf(Failure failure) {
    return failure.errors ?? [failure.message];
  }

  Future<void> uploadVideo({
    required String sectionId,
    required File file,
  }) async {
    emit(const LessonVideoUploadRequestingUrl());

    final fileName = file.path.split('/').last;

    final extension = fileName.split('.').last.toLowerCase();

    const mimeTypes = {
      'mp4': 'video/mp4',
      'mov': 'video/quicktime',
      'avi': 'video/x-msvideo',
      'mkv': 'video/x-matroska',
      'webm': 'video/webm',
    };

    final contentType = mimeTypes[extension] ?? 'application/octet-stream';

    final generateResult = await generateVideoUploadUrlUseCase(
      sectionId: sectionId,
      fileName: fileName,
    );

    await generateResult.fold(
      (failure) async {
        emit(LessonVideoUploadError(_errorsOf(failure)));
      },
      (uploadData) async {
        emit(const LessonVideoUploadInProgress(0));

        final uploadResult = await uploadVideoFileUseCase(
          uploadUrl: uploadData['uploadUrl'] as String,
          file: file,
          contentType: contentType,
          onProgress: (progress) {
            emit(LessonVideoUploadInProgress(progress));
          },
        );

        uploadResult.fold(
          (failure) {
            emit(LessonVideoUploadError(_errorsOf(failure)));
          },
          (_) {
            emit(LessonVideoUploadSuccess(uploadData['cdnUrl'] as String));
          },
        );
      },
    );
  }

  void reset() {
    emit(const LessonVideoUploadInitial());
  }
}
