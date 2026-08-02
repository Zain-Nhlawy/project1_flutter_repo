import 'message_type.dart';

class MessageReplyPreviewEntity {
  final String id;
  final String content;
  final MessageType type;

  const MessageReplyPreviewEntity({
    required this.id,
    required this.content,
    required this.type,
  });
}
