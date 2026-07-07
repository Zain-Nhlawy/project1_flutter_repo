import 'package:project1/features/course/data/data_sources/course_remote_datasource.dart';
import 'package:project1/features/course/domain/entities/tag_entity.dart';
import 'package:project1/features/course/domain/repository/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remoteDataSource;

  CourseRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<TagEntity>> getTags() async {
    return await remoteDataSource.getTags();
  }
}