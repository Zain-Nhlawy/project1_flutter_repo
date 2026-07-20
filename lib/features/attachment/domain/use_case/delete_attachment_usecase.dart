import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/attachment/domain/repository/lesson_attachment_repository.dart';

class DeleteAttachmentUseCase {
  final LessonAttachmentRepository repository;

  DeleteAttachmentUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String lessonId,
    required String attachmentId,
    required String name,
  }) {
    return repository.deleteAttachment(
      lessonId: lessonId,
      attachmentId: attachmentId,
      name: name,
    );
  }
}
