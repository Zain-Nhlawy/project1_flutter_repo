import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/lesson/domain/entities/lesson_entity.dart';
import 'package:project1/features/lesson/domain/repository/lesson_repository.dart';

class GetLessonsUseCase {
  final LessonRepository repository;

  GetLessonsUseCase(this.repository);

  Future<Either<Failure, List<LessonEntity>>> call({
    required String sectionId,
    String? cursor,
  }) {
    return repository.getLessons(
      sectionId: sectionId,
      cursor: cursor,
    );
  }
}