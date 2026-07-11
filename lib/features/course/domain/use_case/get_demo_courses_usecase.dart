import 'package:project1/features/course/domain/entities/course_entity.dart';
import 'package:project1/features/course/domain/repository/course_repository.dart';

class GetDemoCoursesUseCase {

  final CourseRepository repository;

  GetDemoCoursesUseCase(this.repository);


  Future<List<CourseEntity>> call(String demoId) {
    return repository.getDemoCourses(demoId);
  }
}