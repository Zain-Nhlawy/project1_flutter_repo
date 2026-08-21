import 'package:project1/features/Q&A/domain/entities/discussion_answer_entity.dart';

class DiscussionAnswerModel extends DiscussionAnswerEntity {
  const DiscussionAnswerModel({
    required super.id,
    required super.questionId,
    required super.content,
    required super.authorId,
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
    final authorId = user?['id'] as String? ?? '';

    return DiscussionAnswerModel(
      id: json['id'] as String? ?? '',
      questionId: (json['discussionId'] ?? json['questionId']) as String? ??
          '',
      content: json['content'] as String? ?? '',
      authorId: authorId,
      authorName: authorName.isNotEmpty ? authorName : 'Unknown',
      authorAvatarUrl: authorAvatarUrl,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  DiscussionAnswerModel copyWith({
    String? id,
    String? questionId,
    String? content,
    String? authorId,
    String? authorName,
    String? authorAvatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DiscussionAnswerModel(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      content: content ?? this.content,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
