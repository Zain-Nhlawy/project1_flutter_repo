import 'package:project1/features/Q&A/data/models/discussion_answer_model.dart';

class PaginatedDiscussionAnswers {
  final List<DiscussionAnswerModel> items;
  final String? nextCursor;
  final bool hasMore;

  const PaginatedDiscussionAnswers({
    required this.items,
    required this.nextCursor,
    required this.hasMore,
  });

  factory PaginatedDiscussionAnswers.fromJson(Map<String, dynamic> json) {
    final rawItems = json['data'] as List<dynamic>? ?? [];

    return PaginatedDiscussionAnswers(
      items: rawItems
          .map((e) =>
              DiscussionAnswerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['nextCursor'] as String?,
      hasMore: json['hasMore'] as bool? ??
          (json['nextCursor'] != null),
    );
  }
}
