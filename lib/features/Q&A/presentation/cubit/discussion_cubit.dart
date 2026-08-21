import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/Q&A/data/models/discussion_answer_model.dart';
import 'package:project1/features/Q&A/data/models/discussion_question_model.dart';
import 'package:project1/features/Q&A/domain/use_case/create_discussion_answer_usecase.dart';
import 'package:project1/features/Q&A/domain/use_case/create_discussion_question_usecase.dart';
import 'package:project1/features/Q&A/domain/use_case/delete_discussion_answer_usecase.dart';
import 'package:project1/features/Q&A/domain/use_case/delete_discussion_question_usecase.dart';
import 'package:project1/features/Q&A/domain/use_case/get_discussion_answers_usecase.dart';
import 'package:project1/features/Q&A/domain/use_case/get_discussion_questions_usecase.dart';
import 'package:project1/features/Q&A/domain/use_case/update_discussion_answer_usecase.dart';
import 'package:project1/features/Q&A/domain/use_case/update_discussion_question_usecase.dart';
import 'discussion_state.dart';

class DiscussionCubit extends Cubit<DiscussionState> {
  final GetDiscussionQuestionsUseCase getDiscussionQuestionsUseCase;
  final CreateDiscussionQuestionUseCase createDiscussionQuestionUseCase;
  final GetDiscussionAnswersUseCase getDiscussionAnswersUseCase;
  final CreateDiscussionAnswerUseCase createDiscussionAnswerUseCase;
  final UpdateDiscussionQuestionUseCase updateDiscussionQuestionUseCase;
final DeleteDiscussionQuestionUseCase deleteDiscussionQuestionUseCase;
final UpdateDiscussionAnswerUseCase updateDiscussionAnswerUseCase;
final DeleteDiscussionAnswerUseCase deleteDiscussionAnswerUseCase;

  DiscussionCubit({
  required this.getDiscussionQuestionsUseCase,
  required this.createDiscussionQuestionUseCase,
  required this.getDiscussionAnswersUseCase,
  required this.createDiscussionAnswerUseCase,
  required this.updateDiscussionQuestionUseCase,
  required this.deleteDiscussionQuestionUseCase,
  required this.updateDiscussionAnswerUseCase,
  required this.deleteDiscussionAnswerUseCase,
}) : super(const DiscussionInitial());

  List<String> _errorsOf(Failure failure) {
    final errors = failure.errors;
    if (errors != null && errors.isNotEmpty) {
      return errors;
    }

    return [failure.message];
  }

  Future<List<DiscussionQuestionModel>> getQuestions({
    required String lessonId,
    required String demoId,
    String? cursor,
  }) async {
    final result = await getDiscussionQuestionsUseCase(
      lessonId: lessonId,
      demoId: demoId,
      cursor: cursor,
    );

    return result.fold(
      (failure) {
        emit(DiscussionError(_errorsOf(failure)));
        return <DiscussionQuestionModel>[];
      },
      (data) => data.items,
    );
  }

  Future<List<DiscussionAnswerModel>> getAnswers({
    required String questionId,
    required String demoId,
    String? cursor,
  }) async {
    final result = await getDiscussionAnswersUseCase(
      questionId: questionId,
      demoId: demoId,
      cursor: cursor,
    );

    return result.fold(
      (failure) {
        emit(DiscussionError(_errorsOf(failure)));
        return <DiscussionAnswerModel>[];
      },
      (data) => data.items,
    );
  }

  Future<void> postQuestion({
    required String lessonId,
    required String content,
    required String demoId,
  }) async {
    emit(const DiscussionLoading());

    final result = await createDiscussionQuestionUseCase(
      lessonId: lessonId,
      content: content,
      demoId: demoId,
    );

    result.fold(
      (failure) => emit(DiscussionError(_errorsOf(failure))),
      (question) => emit(DiscussionQuestionPosted(question)),
    );
  }

  Future<void> postAnswer({
    required String questionId,
    required String content,
    required String demoId,
  }) async {
    emit(const DiscussionLoading());

    final result = await createDiscussionAnswerUseCase(
      questionId: questionId,
      content: content,
      demoId: demoId,
    );

    result.fold(
      (failure) => emit(DiscussionError(_errorsOf(failure))),
      (answer) => emit(DiscussionAnswerPosted(answer)),
    );
  }
  Future<DiscussionQuestionModel?> updateQuestion({
  required String lessonId,
  required String questionId,
  required String content,
  required String demoId,
}) async {
  emit(const DiscussionLoading());

  final result = await updateDiscussionQuestionUseCase(
    lessonId: lessonId,
    questionId: questionId,
    content: content,
    demoId: demoId,
  );

  return result.fold(
    (failure) {
      emit(DiscussionError(_errorsOf(failure)));
      return null;
    },
    (question) {
      emit(DiscussionQuestionUpdated(question));
      return question;
    },
  );
}

Future<bool> deleteQuestion({
  required String lessonId,
  required String questionId,
  required String demoId,
}) async {
  emit(const DiscussionLoading());

  final result = await deleteDiscussionQuestionUseCase(
    lessonId: lessonId,
    questionId: questionId,
    demoId: demoId,
  );

  return result.fold(
    (failure) {
      emit(DiscussionError(_errorsOf(failure)));
      return false;
    },
    (_) {
      emit(const DiscussionQuestionDeleted());
      return true;
    },
  );
}

Future<DiscussionAnswerModel?> updateAnswer({
  required String questionId,
  required String answerId,
  required String content,
  required String demoId,
}) async {
  emit(const DiscussionLoading());

  final result = await updateDiscussionAnswerUseCase(
    questionId: questionId,
    answerId: answerId,
    content: content,
    demoId: demoId,
  );

  return result.fold(
    (failure) {
      emit(DiscussionError(_errorsOf(failure)));
      return null;
    },
    (answer) {
      emit(DiscussionAnswerUpdated(answer));
      return answer;
    },
  );
}

Future<bool> deleteAnswer({
  required String questionId,
  required String answerId,
  required String demoId,
}) async {
  emit(const DiscussionLoading());

  final result = await deleteDiscussionAnswerUseCase(
    questionId: questionId,
    answerId: answerId,
    demoId: demoId,
  );

  return result.fold(
    (failure) {
      emit(DiscussionError(_errorsOf(failure)));
      return false;
    },
    (_) {
      emit(const DiscussionAnswerDeleted());
      return true;
    },
  );
}
}
