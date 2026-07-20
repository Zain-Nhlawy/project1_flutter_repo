import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/course/domain/entities/course_entity.dart';
import 'package:project1/features/course/domain/entities/tag_entity.dart';

abstract class CourseRepository {
  Future<Either<Failure, List<TagEntity>>> getTags();
  Future<Either<Failure, CourseEntity>> createCourse(CourseEntity course);
  Future<Either<Failure, CourseEntity>> getCourse(String courseId);
  Future<Either<Failure, List<CourseEntity>>> getDemoCourses(String demoId);
  Future<Either<Failure, CourseEntity>> getDemoCourse({
    required String demoId,
    required String assetId,
  });
  Future<Either<Failure, CourseEntity>> updateCourse(
    String courseId,
    CourseEntity course,
  );
  Future<Either<Failure, void>> deleteCourse(String courseId);
  Future<Either<Failure, CourseEntity>> publishCourse(String courseId);
}
