
import 'package:project1/features/demo/domain/entities/user_entity.dart';

class InquiryEntity {
  final String id;
  final String subject;
  final String message;
  final String demoId;
  final String? status;
  final MembersEntity creator;
  final String? reply;

  const InquiryEntity({
    required this.id,
    required this.subject,
    required this.message,
    required this.demoId,
    this.status,
    required this.creator,
    this.reply,
  });
}