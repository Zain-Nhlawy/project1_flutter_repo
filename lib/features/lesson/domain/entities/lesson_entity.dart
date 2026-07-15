class LessonEntity {
  final String id;
  final String title;
  final int order;
  final String videoUrl;
  final String? subTitleUrl;
  final String sectionId;
  final int duration;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  const LessonEntity({
    required this.id,
    required this.title,
    required this.order,
    required this.videoUrl,
    this.subTitleUrl,
    required this.sectionId,
    required this.duration,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });
}