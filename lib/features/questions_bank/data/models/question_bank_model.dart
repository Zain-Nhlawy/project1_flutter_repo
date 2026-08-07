import 'package:project1/features/questions_bank/data/models/question_choice_model.dart';
import 'package:project1/features/questions_bank/domain/entities/question_bank_entity.dart';

class QuestionBankModel extends QuestionBankEntity {
  const QuestionBankModel({
    required super.id,
    required super.sectionId,
    required super.question,
    required super.note,
    required List<QuestionChoiceModel> super.choices,
    required super.createdAt,
    required super.updatedAt,
  });

  factory QuestionBankModel.fromJson(Map<String, dynamic> json) {
    return QuestionBankModel(
      id: json['id'] as String? ?? '',
      sectionId: json['sectionId'] as String? ?? '',
      question: json['question'] as String? ?? '',
      note: json['note'] as String? ?? '',
      choices: (json['choices'] as List<dynamic>? ?? [])
          .map((e) => QuestionChoiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}