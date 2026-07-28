import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/course/domain/repository/department_course_repository.dart';
import '../entities/department_course_entity.dart';

class GetDepartmentCoursesUseCase {
  final DepartmentCourseRepository repository;

  GetDepartmentCoursesUseCase(this.repository);

  Future<Either<Failure, List<DepartmentCourseEntity>>> call({
    required String demoId,
    required String departmentId,
    String? cursor,
  }) {
    return repository.getDepartmentCourses(
      demoId: demoId,
      departmentId: departmentId,
      cursor: cursor,
    );
  }
}