class MessageAttachmentEntity {
  final String? fileUrl;
  final String? fileName;
  final String? mimeType;
  final int? fileSize;

  const MessageAttachmentEntity({
    this.fileUrl,
    this.fileName,
    this.mimeType,
    this.fileSize,
  });
}
