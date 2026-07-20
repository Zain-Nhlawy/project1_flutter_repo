import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/attachment/upload/domain/repository/attachment_upload_repository.dart';

class UploadAttachmentFileUseCase {
  final AttachmentUploadRepository repository;

  UploadAttachmentFileUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String uploadUrl,
    required File file,
    required String contentType,
    required void Function(double progress) onProgress,
  }) {
    return repository.uploadFile(
      uploadUrl: uploadUrl,
      file: file,
      contentType: contentType,
      onProgress: onProgress,
    );
  }
}
