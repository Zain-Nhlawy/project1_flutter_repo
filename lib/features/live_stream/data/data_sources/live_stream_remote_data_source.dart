import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/live_stream/data/models/live_stream_model.dart';
import 'package:project1/features/live_stream/data/models/live_stream_token_model.dart';

abstract class LiveStreamRemoteDataSource {
  Future<List<LiveStreamModel>> getLiveStreams({
    required String departmentId,
    String? demoId,
    String? cursor,
    int? limit,
  });

  Future<LiveStreamModel> getLiveStreamDetails(
    String id, {
    required String departmentId,
    String? demoId,
  });

  Future<LiveStreamModel> createLiveStream({
    required String title,
    required String description,
    required String scheduledAt,
    required String departmentId,
    String? demoId,
  });

  Future<LiveStreamModel> updateLiveStream({
    required String id,
    required String departmentId,
    String? demoId,
    String? title,
    String? description,
    String? scheduledAt,
  });

  Future<LiveStreamModel> startLiveStream(
    String id, {
    required String departmentId,
    String? demoId,
  });

  Future<LiveStreamModel> endLiveStream(
    String id, {
    required String departmentId,
    String? demoId,
  });

  Future<LiveStreamTokenModel> getLiveStreamToken(
    String id, {
    required String departmentId,
    String? demoId,
  });
}

class LiveStreamRemoteDataSourceImpl implements LiveStreamRemoteDataSource {
  final DioClient dioClient;

  LiveStreamRemoteDataSourceImpl(this.dioClient);

  Dio get dio => dioClient.dio;

  Options _getOptions({required String departmentId, String? demoId}) {
    final headers = <String, dynamic>{
      if (departmentId.isNotEmpty) 'x-department-id': departmentId,
      if (demoId != null && demoId.isNotEmpty) 'x-demo-id': demoId,
    };
    return Options(headers: headers);
  }

  @override
  Future<List<LiveStreamModel>> getLiveStreams({
    required String departmentId,
    String? demoId,
    String? cursor,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'departmentId': departmentId,
        if (cursor != null && cursor.isNotEmpty) 'cursor': cursor,
        if (limit != null) 'limit': limit,
      };

      final response = await dio.get(
        '/liveStreams/cursor',
        queryParameters: queryParams,
        options: _getOptions(departmentId: departmentId, demoId: demoId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic rawData = response.data['data'];
        List<dynamic> dataList = [];

        if (rawData is List) {
          dataList = rawData;
        } else if (rawData is Map && rawData['items'] is List) {
          dataList = rawData['items'];
        } else if (rawData is Map && rawData['liveStreams'] is List) {
          dataList = rawData['liveStreams'];
        } else if (response.data is List) {
          dataList = response.data;
        }

        return dataList.map((json) => LiveStreamModel.fromJson(json)).toList();
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to fetch live streams',
        );
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<LiveStreamModel> getLiveStreamDetails(
    String id, {
    required String departmentId,
    String? demoId,
  }) async {
    try {
      final response = await dio.get(
        '/liveStreams/$id',
        options: _getOptions(departmentId: departmentId, demoId: demoId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] ?? response.data;
        return LiveStreamModel.fromJson(data);
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to fetch live stream details',
        );
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<LiveStreamModel> createLiveStream({
    required String title,
    required String description,
    required String scheduledAt,
    required String departmentId,
    String? demoId,
  }) async {
    try {
      final response = await dio.post(
        '/liveStreams',
        data: {
          'title': title,
          'description': description,
          'scheduledAt': scheduledAt,
          'departmentId': departmentId,
        },
        options: _getOptions(departmentId: departmentId, demoId: demoId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] ?? response.data;
        return LiveStreamModel.fromJson(data);
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to create live stream',
        );
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<LiveStreamModel> updateLiveStream({
    required String id,
    required String departmentId,
    String? demoId,
    String? title,
    String? description,
    String? scheduledAt,
  }) async {
    try {
      final payload = <String, dynamic>{
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (scheduledAt != null) 'scheduledAt': scheduledAt,
      };

      final response = await dio.patch(
        '/liveStreams/$id',
        data: payload,
        options: _getOptions(departmentId: departmentId, demoId: demoId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] ?? response.data;
        return LiveStreamModel.fromJson(data);
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to update live stream',
        );
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<LiveStreamModel> startLiveStream(
    String id, {
    required String departmentId,
    String? demoId,
  }) async {
    try {
      final response = await dio.post(
        '/liveStreams/$id/start',
        options: _getOptions(departmentId: departmentId, demoId: demoId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] ?? response.data;
        return LiveStreamModel.fromJson(
          data is Map<String, dynamic> ? data : {'id': id, 'status': 'LIVE'},
        );
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to start live stream',
        );
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<LiveStreamModel> endLiveStream(
    String id, {
    required String departmentId,
    String? demoId,
  }) async {
    try {
      final response = await dio.post(
        '/liveStreams/$id/end',
        options: _getOptions(departmentId: departmentId, demoId: demoId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data['data'] ?? response.data;
        return LiveStreamModel.fromJson(
          data is Map<String, dynamic> ? data : {'id': id, 'status': 'ENDED'},
        );
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to end live stream',
        );
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  @override
  Future<LiveStreamTokenModel> getLiveStreamToken(
    String id, {
    required String departmentId,
    String? demoId,
  }) async {
    try {
      final response = await dio.post(
        '/liveStreams/$id/token',
        options: _getOptions(departmentId: departmentId, demoId: demoId),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LiveStreamTokenModel.fromJson(response.data);
      } else {
        throw Exception(
          response.data['message'] ?? 'Failed to retrieve stream token',
        );
      }
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
