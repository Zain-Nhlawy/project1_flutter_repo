import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/attachment/domain/entities/lesson_attachment_entity.dart';
import 'package:project1/features/attachment/domain/repository/lesson_attachment_repository.dart';

class GetAttachmentUseCase {
  final LessonAttachmentRepository repository;

  GetAttachmentUseCase(this.repository);

  Future<Either<Failure, LessonAttachmentEntity>> call({
    required String lessonId,
    required String attachmentId,
  }) {
    return repository.getAttachment(
      lessonId: lessonId,
      attachmentId: attachmentId,
    );
  }
}