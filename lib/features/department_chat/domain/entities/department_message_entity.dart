import 'message_type.dart';
import 'message_sender_entity.dart';
import 'message_attachment_entity.dart';
import 'message_reply_preview_entity.dart';

class DepartmentMessageEntity {
  final String id;
  final String departmentId;
  final MessageType type;
  final String? content;
  final bool isEdited;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final MessageSenderEntity sender;
  final MessageAttachmentEntity? attachment;
  final MessageReplyPreviewEntity? replyTo;

  const DepartmentMessageEntity({
    required this.id,
    required this.departmentId,
    required this.type,
    this.content,
    required this.isEdited,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.sender,
    this.attachment,
    this.replyTo,
  });

  DepartmentMessageEntity copyWith({
    String? id,
    String? departmentId,
    MessageType? type,
    String? content,
    bool? isEdited,
    bool? isDeleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    MessageSenderEntity? sender,
    MessageAttachmentEntity? attachment,
    MessageReplyPreviewEntity? replyTo,
  }) {
    return DepartmentMessageEntity(
      id: id ?? this.id,
      departmentId: departmentId ?? this.departmentId,
      type: type ?? this.type,
      content: content ?? this.content,
      isEdited: isEdited ?? this.isEdited,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sender: sender ?? this.sender,
      attachment: attachment ?? this.attachment,
      replyTo: replyTo ?? this.replyTo,
    );
  }
}
