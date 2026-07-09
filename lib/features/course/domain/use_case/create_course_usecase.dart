import 'package:project1/features/course/domain/entities/course_entity.dart';
import 'package:project1/features/course/domain/repository/course_repository.dart';

class CreateCourseUseCase {
  final CourseRepository repository;

  CreateCourseUseCase(this.repository);

  Future<CourseEntity> call(CourseEntity course) async {
    return await repository.createCourse(course);
  }
}