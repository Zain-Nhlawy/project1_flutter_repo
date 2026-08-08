class ExamAttemptEntity {
  final String id;
  final String demoMemberId;
  final String examId;
  final int score;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ExamAttemptEntity({
    required this.id,
    required this.demoMemberId,
    required this.examId,
    required this.score,
    required this.createdAt,
    required this.updatedAt,
  });
}