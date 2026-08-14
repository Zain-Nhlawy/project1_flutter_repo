import 'package:project1/features/quiz/domain/entities/exam_entity.dart';

class ExamModel extends ExamEntity {
  const ExamModel({
    required super.id,
    required super.sectionId,
    required super.title,
    required super.numberOfQuestions,
    required super.durationMinutes,
    required super.passingScore,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'] as String? ?? '',
      sectionId: json['sectionId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      numberOfQuestions: json['numberOfQuestions'] as int? ?? 0,
      durationMinutes: json['durationMinutes'] as int? ?? 0,
      passingScore: json['passingScore'] as int? ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toRequestJson() {
    return {
      'title': title,
      'numberOfQuestions': numberOfQuestions,
      'durationMinutes': durationMinutes,
      'passingScore': passingScore,
    };
  }
}