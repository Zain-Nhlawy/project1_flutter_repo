import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';

import '../repository/department_chat_repository.dart';

class UploadDepartmentAttachmentFileUseCase {
  final DepartmentChatRepository repository;

  UploadDepartmentAttachmentFileUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String uploadUrl,
    required Uint8List bytes,
    required String mimeType,
    required void Function(double progress) onProgress,
  }) {
    return repository.uploadAttachmentFile(
      uploadUrl: uploadUrl,
      bytes: bytes,
      mimeType: mimeType,
      onProgress: onProgress,
    );
  }
}
