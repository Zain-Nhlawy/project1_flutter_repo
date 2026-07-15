import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/attachment/domain/entities/lesson_attachment_entity.dart';

abstract class LessonAttachmentRepository {
  Future<Either<Failure, LessonAttachmentEntity>> createAttachment({
    required String lessonId,
    required String name,
    required String path,
  });

  Future<Either<Failure, LessonAttachmentEntity>> getAttachment({
    required String lessonId,
    required String attachmentId,
  });

  Future<Either<Failure, List<LessonAttachmentEntity>>> getAttachments({
    required String lessonId,
    String? cursor,
  });

  Future<Either<Failure, LessonAttachmentEntity>> updateAttachment({
    required String lessonId,
    required String attachmentId,
    required String name,
  });

  Future<Either<Failure, void>> deleteAttachment({
  required String lessonId,
  required String attachmentId,
  required String name, 
});
}