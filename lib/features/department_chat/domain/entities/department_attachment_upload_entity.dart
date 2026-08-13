class DepartmentAttachmentUploadEntity {
  final String fileName;
  final String uploadUrl;
  final String fileKey;
  final bool isPublic;
  final String cdnUrl;

  const DepartmentAttachmentUploadEntity({
    required this.fileName,
    required this.uploadUrl,
    required this.fileKey,
    required this.isPublic,
    required this.cdnUrl,
  });
}
