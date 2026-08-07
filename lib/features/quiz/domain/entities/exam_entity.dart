class ExamEntity {
  final String id;
  final String sectionId;
  final String title;
  final int numberOfQuestions;
  final int durationMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ExamEntity({
    required this.id,
    required this.sectionId,
    required this.title,
    required this.numberOfQuestions,
    required this.durationMinutes,
    required this.createdAt,
    required this.updatedAt,
  });
}