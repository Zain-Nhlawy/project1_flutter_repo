import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/errors/exceptions.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/attachment/data/models/lesson_attachment_model.dart';

class LessonAttachmentRemoteDataSource {
  final DioClient dioClient;

  LessonAttachmentRemoteDataSource(this.dioClient);

  Future<List<AttachmentUploadUrlModel>> getUploadUrls({
    required String lessonId,
    required List<String> fileNames,
  }) async {
    try {
      final response = await dioClient.dio.post(
        '/lessons/$lessonId/attachments/upload-url',
        data: {'files': fileNames},
      );

      final data = response.data['data'];
      if (data == null) {
        throw const ServerException('Unable to get upload URLs.');
      }

      final List list = data is List ? data : [data];

      return list
          .map((e) => AttachmentUploadUrlModel.fromJson(
                Map<String, dynamic>.from(e),
              ))
          .toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<void> uploadFileToUrl({
  required String uploadUrl,
  required List<int> bytes,
  String? contentType,
}) async {
  try {
    await Dio().put(
      uploadUrl,
      data: bytes,
      options: Options(
        headers: {
          'x-ms-blob-type': 'BlockBlob',
          if (contentType != null) 'Content-Type': contentType,
          Headers.contentLengthHeader: bytes.length,
        },
      ),
    );
  } on DioException catch (e) {
    throw mapDioException(e);
  }
}

  Future<LessonAttachmentModel> createAttachment({
    required String lessonId,
    required String name,
    required String path,
  }) async {
    try {
      final response = await dioClient.dio.post(
        '/lessons/$lessonId/attachments',
        data: {
          'name': name,
          'path': path,
        },
      );

      final data = response.data['data'];
      if (data == null) {
        throw const ServerException('Unable to create attachment.');
      }

      return LessonAttachmentModel.fromJson(
        Map<String, dynamic>.from(data),
        lessonId: lessonId,
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<LessonAttachmentModel> getAttachment({
    required String lessonId,
    required String attachmentId,
  }) async {
    try {
      final response = await dioClient.dio.get(
        '/lessons/$lessonId/attachments/$attachmentId',
      );
      debugPrint(response.data.toString());
      final data = response.data['data'];
      if (data == null) {
        throw const ServerException('Attachment not found.');
      }

      return LessonAttachmentModel.fromJson(
        Map<String, dynamic>.from(data),
        lessonId: lessonId,
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<List<LessonAttachmentModel>> getAttachments({
    required String lessonId,
    String? cursor,
  }) async {
    try {
      final response = await dioClient.dio.get(
        '/lessons/$lessonId/attachments/cursor',
        queryParameters: {
          if (cursor != null) 'cursor': cursor,
        },
      );
      debugPrint(response.data.toString());
      final List list = response.data['data'];

      return list
          .map((e) => LessonAttachmentModel.fromJson(
                Map<String, dynamic>.from(e),
                lessonId: lessonId,
              ))
          .toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<LessonAttachmentModel> updateAttachment({
    required String lessonId,
    required String attachmentId,
    required String name,
  }) async {
    try {
      final response = await dioClient.dio.patch(
        '/lessons/$lessonId/attachments/$attachmentId',
        data: {'name': name},
      );

      final data = response.data['data'];
      if (data == null) {
        throw const ServerException('Unable to update attachment.');
      }

      return LessonAttachmentModel.fromJson(
        Map<String, dynamic>.from(data),
        lessonId: lessonId,
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<void> deleteAttachment({
  required String lessonId,
  required String attachmentId,
  required String name, 
}) async {
  try {
    await dioClient.dio.delete(
      '/lessons/$lessonId/attachments/$attachmentId',
      data: {
        "name": name, 
      },
    );
  } on DioException catch (e) {
    throw mapDioException(e);
  }
}
}