class AnswerSubmissionModel {
  final String questionId;
  final List<String> selectedChoiceIds;

  const AnswerSubmissionModel({
    required this.questionId,
    required this.selectedChoiceIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'selectedChoiceIds': selectedChoiceIds,
    };
  }
}