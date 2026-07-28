import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/course/domain/repository/department_course_repository.dart';
import '../entities/department_course_entity.dart';

class GetDepartmentCourseUseCase {
  final DepartmentCourseRepository repository;

  GetDepartmentCourseUseCase(this.repository);

  Future<Either<Failure, DepartmentCourseEntity>> call({
    required String demoId,
    required String departmentId,
    required String departmentCourseId,
  }) {
    return repository.getDepartmentCourse(
      demoId: demoId,
      departmentId: departmentId,
      departmentCourseId: departmentCourseId,
    );
  }
}