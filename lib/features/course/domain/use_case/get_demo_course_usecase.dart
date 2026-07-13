import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/course/domain/entities/course_entity.dart';
import 'package:project1/features/course/domain/repository/course_repository.dart';

class GetDemoCourseUseCase {
  final CourseRepository repository;

  GetDemoCourseUseCase(this.repository);

  Future<Either<Failure, CourseEntity>> call({
    required String demoId,
    required String assetId,
  }) {
    return repository.getDemoCourse(demoId: demoId, assetId: assetId);
  }
}