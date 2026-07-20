import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/attachment/upload/domain/entities/attachment_upload_url_entity.dart';
import 'package:project1/features/attachment/upload/domain/repository/attachment_upload_repository.dart';

class GenerateAttachmentUploadUrlUseCase {
  final AttachmentUploadRepository repository;

  GenerateAttachmentUploadUrlUseCase(this.repository);

  Future<Either<Failure, AttachmentUploadUrlEntity>> call({
    required String lessonId,
    required String fileName,
  }) {
    return repository.generateUploadUrl(lessonId: lessonId, fileName: fileName);
  }
}
