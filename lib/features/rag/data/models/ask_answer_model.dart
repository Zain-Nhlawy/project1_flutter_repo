class AskAnswerModel {
  final bool success;
  final String message;
  final String answer;
  final DateTime timestamp;

  AskAnswerModel({
    required this.success,
    required this.message,
    required this.answer,
    required this.timestamp,
  });

  factory AskAnswerModel.fromJson(Map<String, dynamic> json) {
    return AskAnswerModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      answer: json['data'] as String? ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  @override
  String toString() => answer;
}