class QuizQuestionModel {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String explanation;

  QuizQuestionModel({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      question: json['question'] as String? ?? '',
      options: (json['options'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      correctAnswer: json['correct_answer'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
    );
  }

  @override
  String toString() => question;
}