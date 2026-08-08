import 'package:project1/features/quiz/domain/entities/exam_attempt_choice_entity.dart';

class ExamAttemptQuestionEntity {
  final String id;
  final String question;
  final String note;
  final List<ExamAttemptChoiceEntity> choices;

  const ExamAttemptQuestionEntity({
    required this.id,
    required this.question,
    required this.note,
    required this.choices,
  });
}