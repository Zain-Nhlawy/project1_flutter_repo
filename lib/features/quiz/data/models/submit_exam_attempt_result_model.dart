import 'package:project1/features/quiz/data/models/exam_attempt_model.dart';
import 'package:project1/features/quiz/data/models/generated_exam_model.dart';

class SubmitExamAttemptResultModel {
  final ExamAttemptModel examAttempt;
  final GeneratedExamModel exam;

  const SubmitExamAttemptResultModel({
    required this.examAttempt,
    required this.exam,
  });

  factory SubmitExamAttemptResultModel.fromJson(Map<String, dynamic> json) {
    return SubmitExamAttemptResultModel(
      examAttempt:
          ExamAttemptModel.fromJson(json['examAttempt'] as Map<String, dynamic>),
      exam: GeneratedExamModel.fromJson(json),
    );
  }
}