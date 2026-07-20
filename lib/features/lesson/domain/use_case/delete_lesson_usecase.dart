import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/lesson/domain/repository/lesson_repository.dart';

class DeleteLessonUseCase {
  final LessonRepository repository;

  DeleteLessonUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String sectionId,
    required String lessonId,
  }) {
    return repository.deleteLesson(sectionId: sectionId, lessonId: lessonId);
  }
}
