import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/course/domain/entities/course_entity.dart';
import 'package:project1/features/course/domain/repository/course_repository.dart';

class PublishCourseUseCase {
  final CourseRepository repository;

  PublishCourseUseCase(this.repository);

  Future<Either<Failure, CourseEntity>> call(
    String courseId,
  ) {
    return repository.publishCourse(courseId);
  }
}