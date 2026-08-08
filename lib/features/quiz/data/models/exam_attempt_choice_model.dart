import 'package:project1/features/quiz/domain/entities/exam_attempt_choice_entity.dart';

class ExamAttemptChoiceModel extends ExamAttemptChoiceEntity {
  const ExamAttemptChoiceModel({
    required super.id,
    required super.choice,
    super.isCorrect,
  });

  factory ExamAttemptChoiceModel.fromJson(Map<String, dynamic> json) {
    return ExamAttemptChoiceModel(
      id: json['id'] as String? ?? '',
      choice: json['choice'] as String? ?? '',
      isCorrect: json['isCorrect'] as bool?,
    );
  }
}