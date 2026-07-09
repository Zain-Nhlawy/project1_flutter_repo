import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/course/data/models/course_model.dart';
import 'package:project1/features/course/data/models/tag_model.dart';

class CourseRemoteDataSource {
  final DioClient dioClient;

  CourseRemoteDataSource(this.dioClient);

  Future<List<TagModel>> getTags() async {
    final res = await dioClient.dio.get('/tags');
    final List<dynamic>? data = res.data?['data'];
    if (data == null) {
      throw Exception('Failed to load tags: Invalid response format');
    }
    return data.map((tagJson) => TagModel.fromJson(tagJson)).toList();
  }
  
  Future<CourseModel> createCourse(CourseModel course) async {
  final res = await dioClient.dio.post(
    '/courses',
    data: course.toJson(),
  );

  return CourseModel.fromJson(res.data['data']);
}


Future<List<CourseModel>> getDemoCourses(String demoId) async {
  final res = await dioClient.dio.get(
    '/demos/$demoId/assets/cursor',
  );
  final List<dynamic>? data = res.data?['data'];
  if (data == null) {
    throw Exception('Failed to load demo courses');
  }
  return data
      .map((asset) {
        final courseJson = asset['course'];
        if (courseJson == null) {
          return null;
        }
        return CourseModel.fromJson(courseJson);
      })
      .whereType<CourseModel>()
      .toList();
}
}