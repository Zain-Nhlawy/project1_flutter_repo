class CourseFaqEntity {
  final String id;
  final String question;
  final String answer;
  final String courseId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CourseFaqEntity({
    required this.id,
    required this.question,
    required this.answer,
    required this.courseId,
    required this.createdAt,
    required this.updatedAt,
  });
}