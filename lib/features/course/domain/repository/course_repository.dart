import 'package:project1/features/course/domain/entities/tag_entity.dart';

abstract class CourseRepository {
  Future<List<TagEntity>> getTags();
}