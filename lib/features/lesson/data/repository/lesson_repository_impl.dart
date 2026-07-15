import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/error_mapper.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/lesson/data/data_sources/lesson_remote_datasource.dart';
import 'package:project1/features/lesson/domain/entities/lesson_entity.dart';
import 'package:project1/features/lesson/domain/repository/lesson_repository.dart';

class LessonRepositoryImpl implements LessonRepository {
  final LessonRemoteDataSource remoteDataSource;

  LessonRepositoryImpl(this.remoteDataSource);

  Future<Either<Failure, T>> _handle<T>(
    Future<T> Function() call,
  ) async {
    try {
      return Right(await call());
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, LessonEntity>> createLesson({
    required String sectionId,
    required String title,
    required int order,
    required String videoUrl,
    required String description,
    required int duration,
  }) {
    return _handle(
      () => remoteDataSource.createLesson(
        sectionId: sectionId,
        title: title,
        order: order,
        videoUrl: videoUrl,
        description: description,
        duration: duration,
      ),
    );
  }

  @override
Future<Either<Failure, LessonEntity>> getLesson({
  required String sectionId,
  required String lessonId,
}) {
  return _handle(
    () => remoteDataSource.getLesson(
      sectionId: sectionId,
      lessonId: lessonId,
    ),
  );
}

@override
Future<Either<Failure, List<LessonEntity>>> getLessons({
  required String sectionId,
  String? cursor,
}) {
  return _handle(
    () => remoteDataSource.getLessons(
      sectionId: sectionId,
      cursor: cursor,
    ),
  );
}

  @override
  Future<Either<Failure, LessonEntity>> updateLesson({
    required String sectionId,
    required String lessonId,
    String? title,
    String? videoUrl,
    String? description,
    int? duration,
    int? order,
  }) {
    return _handle(
      () => remoteDataSource.updateLesson(
        sectionId: sectionId,
        lessonId: lessonId,
        title: title,
        videoUrl: videoUrl,
        description: description,
        duration: duration,
        order: order,
      ),
    );
  }

  @override
  Future<Either<Failure, void>> deleteLesson({
    required String sectionId,
    required String lessonId,
  }) {
    return _handle(
      () => remoteDataSource.deleteLesson(
        sectionId: sectionId,
        lessonId: lessonId,
      ),
    );
  }
}