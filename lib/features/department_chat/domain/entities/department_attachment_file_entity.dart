import 'dart:typed_data';

import 'message_type.dart';

class DepartmentAttachmentFileEntity {
  final String fileName;
  final String mimeType;
  final Uint8List bytes;

  const DepartmentAttachmentFileEntity({
    required this.fileName,
    required this.mimeType,
    required this.bytes,
  });

  int get fileSize => bytes.length;

  bool get isImage => mimeType.startsWith('image/');

  MessageType get messageType => isImage ? MessageType.image : MessageType.file;
}
