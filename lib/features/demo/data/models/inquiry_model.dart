
import 'package:project1/features/demo/data/models/user_model.dart';
import 'package:project1/features/demo/domain/entities/inquiry_entity.dart';

class InquiryModel extends InquiryEntity {
  const InquiryModel({
    required super.id,
    required super.subject,
    required super.message,
    required super.demoId,
    required super.status,
    required super.creator,
  });

  factory InquiryModel.fromJson(Map<String, dynamic> json) {
    return InquiryModel(
      id: json['id'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      message: json['message'] as String? ?? '',
      demoId: json['demoId'] as String? ?? '',
      status: json['status'] as String? ?? '',
      creator: MembersModel.fromJson(json['creator'] as Map<String, dynamic>),
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
    };
  }
}