import '../../domain/entities/course_faq_entity.dart';

class CourseFaqModel extends CourseFaqEntity {
  const CourseFaqModel({
    required super.id,
    required super.question,
    required super.answer,
    required super.courseId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CourseFaqModel.fromJson(Map<String, dynamic> json) {
    return CourseFaqModel(
      id: json['id'] as String,
      question: json['question'] as String,
      answer: json['answer'] as String,
      courseId: json['courseId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'courseId': courseId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}