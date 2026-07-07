import 'package:project1/features/course/domain/entities/tag_entity.dart';
import 'package:project1/features/course/domain/repository/course_repository.dart';

class GetTagsUseCase {
  final CourseRepository repository;

  GetTagsUseCase(this.repository);

  Future<List<TagEntity>> call() async {
    return await repository.getTags();
  }
}