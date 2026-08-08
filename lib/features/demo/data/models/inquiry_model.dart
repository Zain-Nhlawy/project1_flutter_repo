import 'package:project1/features/demo/data/models/user_model.dart';
import 'package:project1/features/demo/domain/entities/inquiry_entity.dart';

class InquiryModel extends InquiryEntity {
  const InquiryModel({
    required super.id,
    required super.subject,
    required super.message,
    required super.demoId,
    super.status,
    required super.creator,
    super.reply,
  });

  factory InquiryModel.fromJson(Map<String, dynamic> json) {
    String? replyText;
    if (json['reply'] != null) {
      if (json['reply'] is String) {
        replyText = json['reply'];
      } else if (json['reply'] is Map) {
        replyText = json['reply']['message'] as String?;
      }
    } else if (json['inquiryReplies'] != null &&
        json['inquiryReplies'] is List &&
        (json['inquiryReplies'] as List).isNotEmpty) {
      final firstReply = (json['inquiryReplies'] as List).first;
      if (firstReply is String) {
        replyText = firstReply;
      } else if (firstReply is Map) {
        replyText = firstReply['message'] as String?;
      }
    } else if (json['replies'] != null &&
        json['replies'] is List &&
        (json['replies'] as List).isNotEmpty) {
      final firstReply = (json['replies'] as List).first;
      if (firstReply is String) {
        replyText = firstReply;
      } else if (firstReply is Map) {
        replyText = firstReply['message'] as String?;
      }
    }

    return InquiryModel(
      id: json['id'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      message: json['message'] as String? ?? '',
      demoId: json['demoId'] as String? ?? '',
      status: json['status'] as String? ?? '',
      creator: MembersModel.fromJson(json['creator'] as Map<String, dynamic>),
      reply: replyText,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'message': message,
      'demoId': demoId,
      'status': status,
      'creator': (creator as MembersModel).toJson(),
      'reply': reply,
    };
  }
}