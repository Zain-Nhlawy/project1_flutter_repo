import 'package:project1/features/q&a/domain/entities/discussion_answer_entity.dart';

class DiscussionAnswerModel extends DiscussionAnswerEntity {
  const DiscussionAnswerModel({
    required super.id,
    required super.questionId,
    required super.content,
    required super.authorName,
    required super.authorAvatarUrl,
    required super.createdAt,
    required super.updatedAt,
  });

factory DiscussionAnswerModel.fromJson(Map<String, dynamic> json) {
  final demoMember = json['demoMember'] as Map<String, dynamic>?;
  final user = demoMember?['user'] as Map<String, dynamic>?;

  final firstName = user?['firstName'] as String? ?? '';
  final lastName = user?['lastName'] as String? ?? '';

  final authorName = '$firstName $lastName'.trim();

  final authorAvatarUrl = user?['imagePath'] as String?;

  return DiscussionAnswerModel(
    id: json['id'] as String? ?? '',
    questionId: json['questionId'] as String? ?? '',
    content: json['content'] as String? ?? '',
    authorName: authorName.isNotEmpty ? authorName : 'Unknown',
    authorAvatarUrl: authorAvatarUrl,
    createdAt:
        DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
    updatedAt:
        DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
            DateTime.now(),
  );
}
}