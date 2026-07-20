import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/course/domain/entities/course_entity.dart';
import 'package:project1/features/course/domain/repository/course_repository.dart';

class GetDemoCoursesUseCase {
  final CourseRepository repository;

  GetDemoCoursesUseCase(this.repository);

  Future<Either<Failure, List<CourseEntity>>> call(String demoId) {
    return repository.getDemoCourses(demoId);
  }
}
