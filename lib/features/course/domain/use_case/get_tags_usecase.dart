import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/course/domain/entities/tag_entity.dart';
import 'package:project1/features/course/domain/repository/course_repository.dart';

class GetTagsUseCase {
  final CourseRepository repository;

  GetTagsUseCase(this.repository);

  Future<Either<Failure, List<TagEntity>>> call() {
    return repository.getTags();
  }
}