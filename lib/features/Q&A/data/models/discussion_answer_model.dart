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
    final author = json['author'] as Map<String, dynamic>? ??
        json['user'] as Map<String, dynamic>? ??
        json['demoMember'] as Map<String, dynamic>?;

    final authorName = author?['name'] as String? ??
        author?['fullName'] as String? ??
        json['authorName'] as String? ??
        'Unknown';

    final authorAvatarUrl = author?['avatarUrl'] as String? ??
        author?['photoUrl'] as String? ??
        json['authorAvatarUrl'] as String?;

    return DiscussionAnswerModel(
      id: json['id'] as String? ?? '',
      questionId: json['questionId'] as String? ?? '',
      content: json['content'] as String? ?? '',
      authorName: authorName,
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