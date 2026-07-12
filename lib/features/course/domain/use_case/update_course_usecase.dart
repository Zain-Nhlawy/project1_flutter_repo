// import 'package:project1/features/course/domain/entities/course_entity.dart';
// import 'package:project1/features/course/domain/repository/course_repository.dart';

// class UpdateCourseUseCase {
//   final CourseRepository repository;

//   UpdateCourseUseCase(this.repository);

//   Future<CourseEntity> call(
//     String courseId,
//     CourseEntity course,
//   ) {
//     return repository.updateCourse(courseId, course);
//   }
// }

import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/course/domain/entities/course_entity.dart';
import 'package:project1/features/course/domain/repository/course_repository.dart';

class UpdateCourseUseCase {
  final CourseRepository repository;

  UpdateCourseUseCase(this.repository);

  Future<Either<Failure, CourseEntity>> call(
    String courseId,
    CourseEntity course,
  ) {
    return repository.updateCourse(courseId, course);
  }
}