class SectionEntity {
  final String id;
  final String courseId;
  final String title;
  final int order;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SectionEntity({
    required this.id,
    required this.courseId,
    required this.title,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });

  SectionEntity copyWith({
    String? id,
    String? courseId,
    String? title,
    int? order,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SectionEntity(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      order: order ?? this.order,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
