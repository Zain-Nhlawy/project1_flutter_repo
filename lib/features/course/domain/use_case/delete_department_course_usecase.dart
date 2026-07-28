import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/course/domain/repository/department_course_repository.dart';


class DeleteDepartmentCourseUseCase {
  final DepartmentCourseRepository repository;

  DeleteDepartmentCourseUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String demoId,
    required String departmentId,
    required String departmentCourseId,
  }) {
    return repository.deleteDepartmentCourse(
      demoId: demoId,
      departmentId: departmentId,
      departmentCourseId: departmentCourseId,
    );
  }
}