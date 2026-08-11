import 'package:project1/features/q&a/data/models/discussion_question_model.dart';

class PaginatedDiscussionQuestions {
  final List<DiscussionQuestionModel> items;
  final String? nextCursor;
  final bool hasMore;

  const PaginatedDiscussionQuestions({
    required this.items,
    required this.nextCursor,
    required this.hasMore,
  });

  factory PaginatedDiscussionQuestions.fromJson(Map<String, dynamic> json) {
    final rawItems = json['data'] as List<dynamic>? ?? [];

    return PaginatedDiscussionQuestions(
      items: rawItems
          .map((e) =>
              DiscussionQuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['nextCursor'] as String?,
      hasMore: json['hasMore'] as bool? ??
          (json['nextCursor'] != null),
    );
  }
}