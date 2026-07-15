import 'package:project1/features/attachment/domain/entities/lesson_attachment_entity.dart';
import 'package:project1/features/attachment/upload/domain/entities/attachment_upload_url_entity.dart';

class LessonAttachmentModel extends LessonAttachmentEntity {
  LessonAttachmentModel({
    required super.id,
    required super.name,
    required super.path,
    required super.lessonId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory LessonAttachmentModel.fromJson(
    Map<String, dynamic> json, {
    String? lessonId,
  }) {
    return LessonAttachmentModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      path: json['path'] ?? '',
      lessonId: json['lessonId'] ?? lessonId ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "path": path,
    };
  }
}

class AttachmentUploadUrlModel extends AttachmentUploadUrlEntity {
  const AttachmentUploadUrlModel({
    required super.fileName,
    required super.uploadUrl,
    required super.path,
  });

  factory AttachmentUploadUrlModel.fromJson(Map<String, dynamic> json) {
    return AttachmentUploadUrlModel(
      fileName: json['fileName'] ?? json['name'] ?? '',
      uploadUrl: json['uploadUrl'] ?? json['url'] ?? '',
      path: json['path'] ?? json['key'] ?? '',
    );
  }
}