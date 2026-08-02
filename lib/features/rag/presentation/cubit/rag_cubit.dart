import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/rag/domain/use_case/ask_question_usecase.dart';
import 'package:project1/features/rag/domain/use_case/generate_random_quiz_usecase.dart';
import 'package:project1/features/rag/domain/use_case/generate_topic_quiz_usecase.dart';
import 'package:project1/features/rag/presentation/cubit/rag_state.dart';

class RagCubit extends Cubit<RagState> {
  final AskQuestionUseCase askQuestionUseCase;
  final GenerateTopicQuizUseCase generateTopicQuizUseCase;
  final GenerateRandomQuizUseCase generateRandomQuizUseCase;

  RagCubit({
    required this.askQuestionUseCase,
    required this.generateTopicQuizUseCase,
    required this.generateRandomQuizUseCase,
  }) : super(const RagInitial());

  Future<void> askQuestion({
    required String courseId,
    required String question,
  }) async {
    emit(const RagLoading());
    final result = await askQuestionUseCase(
      courseId: courseId,
      question: question,
    );
    result.fold(
      (failure) => emit(RagError(failure.message)),
      (data) => emit(RagLoaded(data)),
    );
  }

  Future<void> generateTopicQuiz({
    required String courseId,
    required String topic,
    required int questionCount,
  }) async {
    emit(const RagLoading());
    final result = await generateTopicQuizUseCase(
      courseId: courseId,
      topic: topic,
      questionCount: questionCount,
    );
    result.fold(
      (failure) => emit(RagError(failure.message)),
      (data) => emit(RagLoaded(data)),
    );
  }

  Future<void> generateRandomQuiz({
    required String courseId,
    required int questionCount,
  }) async {
    emit(const RagLoading());
    final result = await generateRandomQuizUseCase(
      courseId: courseId,
      questionCount: questionCount,
    );
    result.fold(
      (failure) => emit(RagError(failure.message)),
      (data) => emit(RagLoaded(data)),
    );
  }
}