import 'package:project1/features/quiz/data/models/exam_model.dart';

class PaginatedExams {
  final List<ExamModel> data;
  final bool hasNextPage;
  final String? endCursor;

  const PaginatedExams({
    required this.data,
    required this.hasNextPage,
    required this.endCursor,
  });

  factory PaginatedExams.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List<dynamic>? ?? [])
        .map((e) => ExamModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final meta = json['meta'] as Map<String, dynamic>?;

    return PaginatedExams(
      data: list,
      hasNextPage: meta?['hasNextPage'] as bool? ?? false,
      endCursor: meta?['endCursor'] as String?,
    );
  }
}