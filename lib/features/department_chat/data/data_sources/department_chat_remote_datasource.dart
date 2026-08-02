import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/network/dio_client.dart';
import '../models/department_message_model.dart';

abstract class DepartmentChatRemoteDataSource {
  Future<Map<String, dynamic>> getMessagesHistory({
    required String departmentId,
    required String demoId,
    String? cursor,
    int take = 15,
  });
}

class DepartmentChatRemoteDataSourceImpl
    implements DepartmentChatRemoteDataSource {
  final Dio dio;

  DepartmentChatRemoteDataSourceImpl(DioClient dioClient, {required this.dio});

  @override
  Future<Map<String, dynamic>> getMessagesHistory({
    required String departmentId,
    required String demoId,
    String? cursor,
    int take = 15,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'take': take,
        if (cursor != null && cursor.isNotEmpty) 'cursor': cursor,
      };

      final response = await dio.get(
        '/departmentMessages/cursor',
        queryParameters: queryParams,
        options: Options(
          headers: {
            'x-demo-id': demoId,
            'x-department-id': departmentId,
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final rawList = data['data'] as List<dynamic>? ?? [];
        final messages = rawList
            .map((json) => DepartmentMessageModel.fromJson(json as Map<String, dynamic>))
            .toList();

        final meta = data['meta'] as Map<String, dynamic>? ?? {};
        final hasNextPage = meta['hasNextPage'] == true;
        final endCursor = meta['endCursor']?.toString();

        return {
          'messages': messages,
          'hasNextPage': hasNextPage,
          'endCursor': endCursor,
        };
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load message history');
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
