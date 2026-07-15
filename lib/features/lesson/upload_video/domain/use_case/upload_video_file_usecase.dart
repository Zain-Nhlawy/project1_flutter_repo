import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import '../repository/lesson_video_upload_repository.dart';

class UploadVideoFileUseCase {
  final LessonVideoUploadRepository repository;

  UploadVideoFileUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String uploadUrl,
    required File file,
    required String contentType,
    required void Function(double progress) onProgress,
  }) {
    return repository.uploadVideo(
      uploadUrl: uploadUrl,
      file: file,
      contentType: contentType,
      onProgress: onProgress,
    );
  }
}