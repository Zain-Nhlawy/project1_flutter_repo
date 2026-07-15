import 'package:flutter/foundation.dart';
import 'package:project1/features/attachment/upload/domain/entities/attachment_upload_url_entity.dart';

class AttachmentUploadUrlModel extends AttachmentUploadUrlEntity {
  const AttachmentUploadUrlModel({
    required super.fileName,
    required super.uploadUrl,
    required super.path,
  });

  factory AttachmentUploadUrlModel.fromJson(Map<String, dynamic> json) {
    
    final dynamic dataToParse;
    if (json.containsKey('data')) {
      final dataList = json['data'];
      dataToParse = (dataList is List && dataList.isNotEmpty) ? dataList[0] : {};
    } else {
      dataToParse = json;
    }

    final Map<String, dynamic> data = dataToParse is Map<String, dynamic> 
        ? dataToParse 
        : {};

    final fileName = data['fileName'] ?? data['file'] ?? data['name'] ?? '';
    final uploadUrl = data['uploadUrl'] ?? data['url'] ?? data['signedUrl'] ?? '';
    final path = data['fileKey'] ?? data['path'] ?? data['key'] ?? data['filePath'] ?? '';

    debugPrint("PARSED PATH = $path");

    return AttachmentUploadUrlModel(
      fileName: fileName,
      uploadUrl: uploadUrl,
      path: path,
    );
  }
}