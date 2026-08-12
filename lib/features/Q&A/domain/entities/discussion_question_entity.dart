class DiscussionQuestionEntity {
  final String id;
  final String lessonId;
  final String content;
  final String authorName;
  final String? authorAvatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String authorId;

  const DiscussionQuestionEntity({
    required this.id,
    required this.lessonId,
    required this.content,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.authorId
  });
}