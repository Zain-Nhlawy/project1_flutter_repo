class LessonEntity {
  final String id;
  final String title;

  const LessonEntity({
    required this.id,
    required this.title,
  });
}

class SectionEntity {
  final String id;
  final String title;
  final List<LessonEntity> lessons;

  const SectionEntity({
    required this.id,
    required this.title,
    this.lessons = const [],
  });

  SectionEntity copyWith({
    String? title,
    List<LessonEntity>? lessons,
  }) {
    return SectionEntity(
      id: id,
      title: title ?? this.title,
      lessons: lessons ?? this.lessons,
    );
  }
}