import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/error_mapper.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/attachment/data/data_sources/lesson_attachment_remote_data_source.dart';
import 'package:project1/features/attachment/domain/entities/lesson_attachment_entity.dart';
import 'package:project1/features/attachment/domain/repository/lesson_attachment_repository.dart';

class LessonAttachmentRepositoryImpl implements LessonAttachmentRepository {
  final LessonAttachmentRemoteDataSource remoteDataSource;

  LessonAttachmentRepositoryImpl(this.remoteDataSource);

  Future<Either<Failure, T>> _handle<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, LessonAttachmentEntity>> createAttachment({
    required String lessonId,
    required String name,
    required String path,
  }) {
    return _handle(
      () => remoteDataSource.createAttachment(
        lessonId: lessonId,
        name: name,
        path: path,
      ),
    );
  }

  @override
  Future<Either<Failure, LessonAttachmentEntity>> getAttachment({
    required String lessonId,
    required String attachmentId,
  }) {
    return _handle(
      () => remoteDataSource.getAttachment(
        lessonId: lessonId,
        attachmentId: attachmentId,
      ),
    );
  }

  @override
  Future<Either<Failure, List<LessonAttachmentEntity>>> getAttachments({
    required String lessonId,
    String? cursor,
  }) {
    return _handle(
      () => remoteDataSource.getAttachments(
        lessonId: lessonId,
        cursor: cursor,
      ),
    );
  }

  @override
  Future<Either<Failure, LessonAttachmentEntity>> updateAttachment({
    required String lessonId,
    required String attachmentId,
    required String name,
  }) {
    return _handle(
      () => remoteDataSource.updateAttachment(
        lessonId: lessonId,
        attachmentId: attachmentId,
        name: name,
      ),
    );
  }

  @override
Future<Either<Failure, void>> deleteAttachment({
  required String lessonId,
  required String attachmentId,
  required String name,
}) async {
  return _handle(() => remoteDataSource.deleteAttachment(
        lessonId: lessonId,
        attachmentId: attachmentId,
        name: name,
      ));
}
}