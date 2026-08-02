import '../../domain/entities/department_message_entity.dart';
import '../../domain/entities/message_attachment_entity.dart';
import '../../domain/entities/message_reply_preview_entity.dart';
import '../../domain/entities/message_sender_entity.dart';
import '../../domain/entities/message_type.dart';

class MessageSenderModel extends MessageSenderEntity {
  const MessageSenderModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    super.imagePath,
  });

  factory MessageSenderModel.fromJson(Map<String, dynamic> json) {
    return MessageSenderModel(
      id: json['id']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      imagePath: json['imagePath']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'imagePath': imagePath,
    };
  }
}

class MessageAttachmentModel extends MessageAttachmentEntity {
  const MessageAttachmentModel({
    super.fileUrl,
    super.fileName,
    super.mimeType,
    super.fileSize,
  });

  factory MessageAttachmentModel.fromJson(Map<String, dynamic> json) {
    return MessageAttachmentModel(
      fileUrl: json['fileUrl']?.toString(),
      fileName: json['fileName']?.toString(),
      mimeType: json['mimeType']?.toString(),
      fileSize: json['fileSize'] is num ? (json['fileSize'] as num).toInt() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileUrl': fileUrl,
      'fileName': fileName,
      'mimeType': mimeType,
      'fileSize': fileSize,
    };
  }
}

class MessageReplyPreviewModel extends MessageReplyPreviewEntity {
  const MessageReplyPreviewModel({
    required super.id,
    required super.content,
    required super.type,
  });

  factory MessageReplyPreviewModel.fromJson(Map<String, dynamic> json) {
    return MessageReplyPreviewModel(
      id: json['id']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      type: MessageType.fromString(json['type']?.toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type.toJson(),
    };
  }
}

class DepartmentMessageModel extends DepartmentMessageEntity {
  const DepartmentMessageModel({
    required super.id,
    required super.departmentId,
    required super.type,
    super.content,
    required super.isEdited,
    required super.isDeleted,
    required super.createdAt,
    required super.updatedAt,
    required super.sender,
    super.attachment,
    super.replyTo,
  });

  factory DepartmentMessageModel.fromJson(Map<String, dynamic> json) {
    final senderJson = json['sender'] is Map<String, dynamic>
        ? json['sender'] as Map<String, dynamic>
        : <String, dynamic>{};

    final attachmentJson = json['attachment'] is Map<String, dynamic>
        ? json['attachment'] as Map<String, dynamic>
        : null;

    final replyToJson = json['replyTo'] is Map<String, dynamic>
        ? json['replyTo'] as Map<String, dynamic>
        : null;

    final createdAtStr = json['createdAt']?.toString();
    final updatedAtStr = json['updatedAt']?.toString();

    return DepartmentMessageModel(
      id: json['id']?.toString() ?? '',
      departmentId: json['departmentId']?.toString() ?? '',
      type: MessageType.fromString(json['type']?.toString()),
      content: json['content']?.toString(),
      isEdited: json['isEdited'] == true,
      isDeleted: json['isDeleted'] == true,
      createdAt: createdAtStr != null
          ? DateTime.tryParse(createdAtStr) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: updatedAtStr != null
          ? DateTime.tryParse(updatedAtStr) ?? DateTime.now()
          : DateTime.now(),
      sender: MessageSenderModel.fromJson(senderJson),
      attachment: attachmentJson != null
          ? MessageAttachmentModel.fromJson(attachmentJson)
          : null,
      replyTo: replyToJson != null
          ? MessageReplyPreviewModel.fromJson(replyToJson)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'departmentId': departmentId,
      'type': type.toJson(),
      if (content != null) 'content': content,
      'isEdited': isEdited,
      'isDeleted': isDeleted,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'sender': (sender as MessageSenderModel).toJson(),
      if (attachment != null)
        'attachment': (attachment as MessageAttachmentModel).toJson(),
      if (replyTo != null)
        'replyTo': (replyTo as MessageReplyPreviewModel).toJson(),
    };
  }
}
