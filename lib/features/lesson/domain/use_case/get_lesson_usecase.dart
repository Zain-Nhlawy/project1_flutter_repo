import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/lesson/domain/entities/lesson_entity.dart';
import 'package:project1/features/lesson/domain/repository/lesson_repository.dart';

class GetLessonUseCase {
  final LessonRepository repository;

  GetLessonUseCase(this.repository);

  Future<Either<Failure, LessonEntity>> call({
    required String sectionId,
    required String lessonId,
  }) {
    return repository.getLesson(
      sectionId: sectionId,
      lessonId: lessonId,
    );
  }
}