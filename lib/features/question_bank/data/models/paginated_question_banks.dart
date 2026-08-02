import 'package:project1/features/question_bank/data/models/question_bank_model.dart';

class PaginatedQuestionBanks {
  final List<QuestionBankModel> data;
  final bool hasNextPage;
  final String? endCursor;

  const PaginatedQuestionBanks({
    required this.data,
    required this.hasNextPage,
    required this.endCursor,
  });

  factory PaginatedQuestionBanks.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List<dynamic>? ?? [])
        .map((e) => QuestionBankModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final meta = json['meta'] as Map<String, dynamic>?;

    return PaginatedQuestionBanks(
      data: list,
      hasNextPage: meta?['hasNextPage'] as bool? ?? false,
      endCursor: meta?['endCursor'] as String?,
    );
  }
}