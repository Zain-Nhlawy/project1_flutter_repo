import 'package:project1/features/course/data/data_sources/course_remote_datasource.dart';
import 'package:project1/features/course/data/models/course_model.dart';
import 'package:project1/features/course/domain/entities/course_entity.dart';
import 'package:project1/features/course/domain/entities/tag_entity.dart';
import 'package:project1/features/course/domain/repository/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remoteDataSource;

  CourseRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<TagEntity>> getTags() async {
    return await remoteDataSource.getTags();
  }

  @override
Future<CourseEntity> createCourse(CourseEntity course) async {

  final model = CourseModel(
  id: course.id,
  title: course.title,
  description: course.description,
  visibility: course.visibility,
  price: course.price,
  imagePath: course.imagePath,
  demoId: course.demoId,
  tagIds: course.tagIds,
  demo: course.demo,
  createdAt: course.createdAt,
  updatedAt: course.updatedAt,
  sectionsCount: course.sectionsCount,
  totalLessons: course.totalLessons,
  totalDuration: course.totalDuration,
);
  return await remoteDataSource.createCourse(model);
}

@override
Future<List<CourseEntity>> getDemoCourses(String demoId) async {
  return await remoteDataSource.getDemoCourses(demoId);
}
}