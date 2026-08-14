import '../../domain/entities/department_attachment_upload_entity.dart';

class DepartmentAttachmentUploadModel extends DepartmentAttachmentUploadEntity {
  const DepartmentAttachmentUploadModel({
    required super.fileName,
    required super.uploadUrl,
    required super.fileKey,
    required super.isPublic,
    required super.cdnUrl,
  });

  factory DepartmentAttachmentUploadModel.fromJson(Map<String, dynamic> json) {
    return DepartmentAttachmentUploadModel(
      fileName: json['fileName']?.toString() ?? '',
      uploadUrl: json['uploadUrl']?.toString() ?? '',
      fileKey: json['fileKey']?.toString() ?? '',
      isPublic: json['isPublic'] == true,
      cdnUrl: json['cdnUrl']?.toString() ?? '',
    );
  }
}
