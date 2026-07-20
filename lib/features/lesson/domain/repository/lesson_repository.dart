import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/lesson/domain/entities/lesson_entity.dart';

abstract class LessonRepository {
  Future<Either<Failure, LessonEntity>> createLesson({
    required String sectionId,
    required String title,
    required int order,
    required String videoUrl,
    required String description,
    required int duration,
  });
  Future<Either<Failure, LessonEntity>> getLesson({
    required String sectionId,
    required String lessonId,
  });

  Future<Either<Failure, List<LessonEntity>>> getLessons({
    required String sectionId,
    String? cursor,
  });

  Future<Either<Failure, LessonEntity>> updateLesson({
    required String sectionId,
    required String lessonId,
    String? title,
    String? videoUrl,
    String? description,
    int? duration,
    int? order,
  });

  Future<Either<Failure, void>> deleteLesson({
    required String sectionId,
    required String lessonId,
  });
}
