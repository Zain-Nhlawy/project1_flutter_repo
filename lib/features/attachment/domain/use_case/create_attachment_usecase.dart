import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/attachment/domain/entities/lesson_attachment_entity.dart';
import 'package:project1/features/attachment/domain/repository/lesson_attachment_repository.dart';

class CreateAttachmentUseCase {
  final LessonAttachmentRepository repository;

  CreateAttachmentUseCase(this.repository);

  Future<Either<Failure, LessonAttachmentEntity>> call({
    required String lessonId,
    required String name,
    required String path,
  }) {
    return repository.createAttachment(
      lessonId: lessonId,
      name: name,
      path: path,
    );
  }
}
