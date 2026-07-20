import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/lesson/domain/entities/lesson_entity.dart';
import 'package:project1/features/lesson/domain/repository/lesson_repository.dart';

class UpdateLessonUseCase {
  final LessonRepository repository;

  UpdateLessonUseCase(this.repository);

  Future<Either<Failure, LessonEntity>> call({
    required String sectionId,
    required String lessonId,
    String? title,
    String? videoUrl,
    String? description,
    int? duration,
    int? order,
  }) {
    return repository.updateLesson(
      sectionId: sectionId,
      lessonId: lessonId,
      title: title,
      videoUrl: videoUrl,
      description: description,
      duration: duration,
      order: order,
    );
  }
}
