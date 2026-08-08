import 'package:project1/features/quiz/domain/entities/exam_Attempt_question_entity.dart';

class GeneratedExamEntity {
  final String id;
  final String sectionId;
  final String title;
  final int durationMinutes;
  final int numberOfQuestions;
  final List<ExamAttemptQuestionEntity> questions;

  const GeneratedExamEntity({
    required this.id,
    required this.sectionId,
    required this.title,
    required this.durationMinutes,
    required this.numberOfQuestions,
    required this.questions,
  });
}