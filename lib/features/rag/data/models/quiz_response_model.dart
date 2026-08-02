import 'quiz_question_model.dart';

class QuizResponseModel {
  final bool success;
  final String message;
  final List<QuizQuestionModel> questions;
  final DateTime timestamp;

  QuizResponseModel({
    required this.success,
    required this.message,
    required this.questions,
    required this.timestamp,
  });

  factory QuizResponseModel.fromJson(Map<String, dynamic> json) {
    return QuizResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      questions: (json['data'] as List<dynamic>? ?? [])
          .map((e) => QuizQuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  @override
  String toString() =>
      questions.map((q) => q.toString()).join('\n');
}