import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/lesson/domain/entities/lesson_entity.dart';
import 'package:project1/features/lesson/domain/repository/lesson_repository.dart';

class CreateLessonUseCase {
  final LessonRepository repository;

  CreateLessonUseCase(this.repository);

  Future<Either<Failure, LessonEntity>> call({
    required String sectionId,
    required String title,
    required int order,
    required String videoUrl,
    required String description,
    required int duration,
  }) {
    return repository.createLesson(
      sectionId: sectionId,
      title: title,
      order: order,
      videoUrl: videoUrl,
      description: description,
      duration: duration,
    );
  }
}