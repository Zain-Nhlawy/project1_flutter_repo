import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/attachment/domain/entities/lesson_attachment_entity.dart';
import 'package:project1/features/attachment/domain/repository/lesson_attachment_repository.dart';

class UpdateAttachmentUseCase {
  final LessonAttachmentRepository repository;

  UpdateAttachmentUseCase(this.repository);

  Future<Either<Failure, LessonAttachmentEntity>> call({
    required String lessonId,
    required String attachmentId,
    required String name,
  }) {
    return repository.updateAttachment(
      lessonId: lessonId,
      attachmentId: attachmentId,
      name: name,
    );
  }
}