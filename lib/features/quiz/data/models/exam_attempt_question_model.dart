import 'package:project1/features/quiz/data/models/exam_attempt_choice_model.dart';
import 'package:project1/features/quiz/domain/entities/exam_Attempt_question_entity.dart';

class ExamAttemptQuestionModel extends ExamAttemptQuestionEntity {
  const ExamAttemptQuestionModel({
    required super.id,
    required super.question,
    required super.note,
    required List<ExamAttemptChoiceModel> super.choices,
  });

  factory ExamAttemptQuestionModel.fromJson(Map<String, dynamic> json) {
    return ExamAttemptQuestionModel(
      id: json['id'] as String? ?? '',
      question: json['question'] as String? ?? '',
      note: json['note'] as String? ?? '',
      choices: (json['choices'] as List<dynamic>? ?? [])
          .map((e) =>
              ExamAttemptChoiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}