import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/course/domain/repository/department_course_repository.dart';
import '../entities/department_course_entity.dart';

class CreateDepartmentCourseUseCase {
  final DepartmentCourseRepository repository;

  CreateDepartmentCourseUseCase(this.repository);

  Future<Either<Failure, DepartmentCourseEntity>> call({
    required String demoId,
    required String departmentId,
    required String assetId,
  }) {
    return repository.createDepartmentCourse(
      demoId: demoId,
      departmentId: departmentId,
      assetId: assetId,
    );
  }
}