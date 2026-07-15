class LessonAttachmentEntity {
  final String id;
  final String name;
  final String path;
  final String lessonId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LessonAttachmentEntity({
    required this.id,
    required this.name,
    required this.path,
    required this.lessonId,
    required this.createdAt,
    required this.updatedAt,
  });

  LessonAttachmentEntity copyWith({
    String? id,
    String? name,
    String? path,
    String? lessonId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LessonAttachmentEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      lessonId: lessonId ?? this.lessonId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}