import 'package:project1/core/network/dio_client.dart';
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
  
}