import 'package:project1/features/quiz/domain/entities/exam_attempt_entity.dart';

class ExamAttemptModel extends ExamAttemptEntity {
  const ExamAttemptModel({
    required super.id,
    required super.demoMemberId,
    required super.examId,
    required super.score,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ExamAttemptModel.fromJson(Map<String, dynamic> json) {
    return ExamAttemptModel(
      id: json['id'] as String? ?? '',
      demoMemberId: json['demoMemberId'] as String? ?? '',
      examId: json['examId'] as String? ?? '',
      score: json['score'] as int? ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}