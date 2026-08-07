import 'package:project1/features/questions_bank/domain/entities/question_choice_entity.dart';

class QuestionBankEntity {
  final String id;
  final String sectionId;
  final String question;
  final String note;
  final List<QuestionChoiceEntity> choices;
  final DateTime createdAt;
  final DateTime updatedAt;

  const QuestionBankEntity({
    required this.id,
    required this.sectionId,
    required this.question,
    required this.note,
    required this.choices,
    required this.createdAt,
    required this.updatedAt,
  });
}