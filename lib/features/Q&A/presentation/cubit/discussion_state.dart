import 'package:project1/features/q&a/data/models/discussion_answer_model.dart';
import 'package:project1/features/q&a/data/models/discussion_question_model.dart';

abstract class DiscussionState {
  const DiscussionState();
}

class DiscussionInitial extends DiscussionState {
  const DiscussionInitial();
}

class DiscussionLoading extends DiscussionState {
  const DiscussionLoading();
}

class DiscussionError extends DiscussionState {
  final List<String> errors;

  const DiscussionError(this.errors);
}

class DiscussionQuestionPosted extends DiscussionState {
  final DiscussionQuestionModel question;

  const DiscussionQuestionPosted(this.question);
}

class DiscussionAnswerPosted extends DiscussionState {
  final DiscussionAnswerModel answer;

  const DiscussionAnswerPosted(this.answer);
}