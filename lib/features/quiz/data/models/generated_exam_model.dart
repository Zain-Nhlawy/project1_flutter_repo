import 'package:project1/features/quiz/data/models/exam_attempt_question_model.dart';
import 'package:project1/features/quiz/domain/entities/generated_exam_entity.dart';

class GeneratedExamModel extends GeneratedExamEntity {
  const GeneratedExamModel({
    required super.id,
    required super.sectionId,
    required super.title,
    required super.durationMinutes,
    required super.numberOfQuestions,
    required List<ExamAttemptQuestionModel> super.questions,
  });

  factory GeneratedExamModel.fromJson(Map<String, dynamic> json) {
    return GeneratedExamModel(
      id: json['id'] as String? ?? '',
      sectionId: json['sectionId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      numberOfQuestions: json['numberOfQuestions'] as int? ?? 0,
      questions: (json['questions'] as List<dynamic>? ?? [])
          .map((e) =>
              ExamAttemptQuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}