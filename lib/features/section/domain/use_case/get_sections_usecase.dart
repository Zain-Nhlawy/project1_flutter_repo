import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/section/domain/entities/section_entity.dart';
import 'package:project1/features/section/domain/repository/section_repository.dart';

class GetSectionsUseCase {
  final SectionRepository repository;

  GetSectionsUseCase(this.repository);

  Future<Either<Failure, List<SectionEntity>>> call({
    required String courseId,
  }) {
    return repository.getSections(courseId: courseId);
  }
}