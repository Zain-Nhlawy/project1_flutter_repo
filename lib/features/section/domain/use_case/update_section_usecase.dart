import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/section/domain/entities/section_entity.dart';
import 'package:project1/features/section/domain/repository/section_repository.dart';

class UpdateSectionUseCase {
  final SectionRepository repository;

  UpdateSectionUseCase(this.repository);

  Future<Either<Failure, SectionEntity>> call({
    required String courseId,
    required String sectionId,
    required String title,
    required int order,
  }) {
    return repository.updateSection(
      courseId: courseId,
      sectionId: sectionId,
      title: title,
      order: order,
    );
  }
}