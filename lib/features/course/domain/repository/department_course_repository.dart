import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import '../entities/department_course_entity.dart';

abstract class DepartmentCourseRepository {
  Future<Either<Failure, DepartmentCourseEntity>> createDepartmentCourse({
    required String demoId,
    required String departmentId,
    required String assetId,
  });

  Future<Either<Failure, List<DepartmentCourseEntity>>> getDepartmentCourses({
    required String demoId,
    required String departmentId,
    String? cursor,
  });

  Future<Either<Failure, DepartmentCourseEntity>> getDepartmentCourse({
    required String demoId,
    required String departmentId,
    required String departmentCourseId,
  });

  Future<Either<Failure, void>> deleteDepartmentCourse({
    required String demoId,
    required String departmentId,
    required String departmentCourseId,
  });
}