class ExamAttemptChoiceEntity {
  final String id;
  final String choice;
  final bool? isCorrect;

  const ExamAttemptChoiceEntity({
    required this.id,
    required this.choice,
    this.isCorrect,
  });
}