import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/section/domain/entities/section_entity.dart';
import 'package:project1/features/section/domain/repository/section_repository.dart';

class GetSectionUseCase {
  final SectionRepository repository;

  GetSectionUseCase(this.repository);

  Future<Either<Failure, SectionEntity>> call({
    required String courseId,
    required String sectionId,
  }) {
    return repository.getSection(courseId: courseId, sectionId: sectionId);
  }
}
