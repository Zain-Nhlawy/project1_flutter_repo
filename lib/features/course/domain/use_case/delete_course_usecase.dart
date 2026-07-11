import 'package:project1/features/course/domain/repository/course_repository.dart';

class DeleteCourseUseCase {
  final CourseRepository repository;

  DeleteCourseUseCase(this.repository);

  Future<void> call(String courseId) async {
    await repository.deleteCourse(courseId);
  }
}