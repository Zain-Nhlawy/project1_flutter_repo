import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/attachment/domain/entities/lesson_attachment_entity.dart';
import 'package:project1/features/attachment/domain/repository/lesson_attachment_repository.dart';

class GetAttachmentsUseCase {
  final LessonAttachmentRepository repository;

  GetAttachmentsUseCase(this.repository);

  Future<Either<Failure, List<LessonAttachmentEntity>>> call({
    required String lessonId,
    String? cursor,
  }) {
    return repository.getAttachments(lessonId: lessonId, cursor: cursor);
  }
}
