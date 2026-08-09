class DiscussionAnswerEntity {
  final String id;
  final String questionId;
  final String content;
  final String authorName;
  final String? authorAvatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DiscussionAnswerEntity({
    required this.id,
    required this.questionId,
    required this.content,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });
}