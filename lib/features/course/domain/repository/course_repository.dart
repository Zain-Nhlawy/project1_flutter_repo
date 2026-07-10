import 'package:project1/features/course/domain/entities/course_entity.dart';
import 'package:project1/features/course/domain/entities/tag_entity.dart';

abstract class CourseRepository {
  Future<List<TagEntity>> getTags();
  Future<CourseEntity> createCourse(CourseEntity course);
  Future<List<CourseEntity>> getDemoCourses(String demoId);
  Future<CourseEntity> updateCourse(
  String courseId,
  CourseEntity course,
);
Future<void> deleteCourse(String courseId);
}