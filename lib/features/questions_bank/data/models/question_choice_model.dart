import 'package:project1/features/questions_bank/domain/entities/question_choice_entity.dart';

class QuestionChoiceModel extends QuestionChoiceEntity {
  const QuestionChoiceModel({
    required super.choice,
    required super.isCorrect,
  });

  factory QuestionChoiceModel.fromJson(Map<String, dynamic> json) {
    return QuestionChoiceModel(
      choice: json['choice'] as String? ?? '',
      isCorrect: json['isCorrect'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toRequestJson() {
    return {
      'text': choice,
      'isCorrect': isCorrect,
    };
  }
}