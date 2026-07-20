import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/section/domain/entities/section_entity.dart';
import 'package:project1/features/section/domain/repository/section_repository.dart';

class CreateSectionUseCase {
  final SectionRepository repository;

  CreateSectionUseCase(this.repository);

  Future<Either<Failure, SectionEntity>> call({
    required String courseId,
    required String title,
    required int order,
  }) {
    return repository.createSection(
      courseId: courseId,
      title: title,
      order: order,
    );
  }
}
