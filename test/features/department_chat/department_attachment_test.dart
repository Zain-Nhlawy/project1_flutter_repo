import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project1/features/department_chat/data/data_sources/department_chat_remote_datasource.dart';
import 'package:project1/features/department_chat/data/models/department_attachment_upload_model.dart';
import 'package:project1/features/department_chat/domain/entities/department_attachment_file_entity.dart';
import 'package:project1/features/department_chat/domain/entities/message_type.dart';

void main() {
  group('DepartmentChatRemoteDataSource', () {
    test(
      'requests a signed URL with department headers and file name',
      () async {
        late RequestOptions capturedRequest;
        final dio = Dio(BaseOptions(baseUrl: 'https://api.example.test'));
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              capturedRequest = options;
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'success': true,
                    'data': {
                      'fileName': 'photo.png',
                      'uploadUrl': 'https://blob.example/upload',
                      'fileKey': 'attachments/file-id.png',
                      'isPublic': true,
                      'cdnUrl': 'https://cdn.example/attachments/file-id.png',
                    },
                  },
                ),
              );
            },
          ),
        );
        final dataSource = DepartmentChatRemoteDataSourceImpl(dio: dio);

        final result = await dataSource.requestAttachmentUpload(
          departmentId: 'department-id',
          demoId: 'demo-id',
          fileName: 'photo.png',
        );

        expect(capturedRequest.method, 'POST');
        expect(capturedRequest.path, '/departmentMessages/upload-url');
        expect(capturedRequest.headers['x-demo-id'], 'demo-id');
        expect(capturedRequest.headers['x-department-id'], 'department-id');
        expect(capturedRequest.data, {'fileName': 'photo.png'});
        expect(result['cdnUrl'], 'https://cdn.example/attachments/file-id.png');
      },
    );

    test('uploads bytes to Azure with blob and content headers', () async {
      late RequestOptions capturedRequest;
      final uploadDio = Dio();
      uploadDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            capturedRequest = options;
            handler.resolve(
              Response<void>(requestOptions: options, statusCode: 201),
            );
          },
        ),
      );
      final dataSource = DepartmentChatRemoteDataSourceImpl(
        dio: Dio(),
        uploadDio: uploadDio,
      );
      final bytes = Uint8List.fromList([1, 2, 3]);

      await dataSource.uploadAttachmentFile(
        uploadUrl: 'https://blob.example/upload?signed=true',
        bytes: bytes,
        mimeType: 'image/png',
        onProgress: (_) {},
      );

      expect(capturedRequest.method, 'PUT');
      expect(capturedRequest.uri.toString(), contains('signed=true'));
      expect(capturedRequest.headers['x-ms-blob-type'], 'BlockBlob');
      expect(capturedRequest.headers['Content-Type'], 'image/png');
      expect(capturedRequest.headers['Content-Length'], bytes.length);
      expect(capturedRequest.data, same(bytes));
    });
  });

  group('DepartmentAttachmentUploadModel', () {
    test('maps the signed upload response data', () {
      final model = DepartmentAttachmentUploadModel.fromJson(const {
        'fileName': 'lesson.pdf',
        'uploadUrl': 'https://blob.example/upload',
        'fileKey': 'attachments/file-id.pdf',
        'isPublic': true,
        'cdnUrl': 'https://cdn.example/attachments/file-id.pdf',
      });

      expect(model.fileName, 'lesson.pdf');
      expect(model.uploadUrl, 'https://blob.example/upload');
      expect(model.fileKey, 'attachments/file-id.pdf');
      expect(model.isPublic, isTrue);
      expect(model.cdnUrl, 'https://cdn.example/attachments/file-id.pdf');
    });
  });

  group('DepartmentAttachmentFileEntity', () {
    test('uses IMAGE messages for photos', () {
      final attachment = DepartmentAttachmentFileEntity(
        fileName: 'photo.png',
        mimeType: 'image/png',
        bytes: Uint8List.fromList([1, 2, 3]),
      );

      expect(attachment.isImage, isTrue);
      expect(attachment.messageType, MessageType.image);
      expect(attachment.fileSize, 3);
    });

    test('uses FILE messages for PDFs', () {
      final attachment = DepartmentAttachmentFileEntity(
        fileName: 'document.pdf',
        mimeType: 'application/pdf',
        bytes: Uint8List.fromList([1, 2]),
      );

      expect(attachment.isImage, isFalse);
      expect(attachment.messageType, MessageType.file);
    });
  });
}
