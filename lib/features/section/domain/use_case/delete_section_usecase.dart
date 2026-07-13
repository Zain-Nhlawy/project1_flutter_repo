import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/section/domain/repository/section_repository.dart';

class DeleteSectionUseCase {
  final SectionRepository repository;

  DeleteSectionUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String courseId,
    required String sectionId,
  }) {
    return repository.deleteSection(
      courseId: courseId,
      sectionId: sectionId,
    );
  }
}