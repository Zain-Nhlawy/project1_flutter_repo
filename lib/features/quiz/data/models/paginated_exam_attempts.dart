import 'package:project1/features/quiz/data/models/exam_attempt_model.dart';

class PaginatedExamAttempts {
  final List<ExamAttemptModel> data;
  final bool hasNextPage;
  final String? endCursor;

  const PaginatedExamAttempts({
    required this.data,
    required this.hasNextPage,
    required this.endCursor,
  });

  factory PaginatedExamAttempts.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List<dynamic>? ?? [])
        .map((e) => ExamAttemptModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final meta = json['meta'] as Map<String, dynamic>?;

    return PaginatedExamAttempts(
      data: list,
      hasNextPage: meta?['hasNextPage'] as bool? ?? false,
      endCursor: meta?['endCursor'] as String?,
    );
  }
}