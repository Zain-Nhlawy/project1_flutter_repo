import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/lesson/domain/entities/lesson_entity.dart';
import 'package:project1/features/lesson/domain/use_case/create_lesson_usecase.dart';
import 'package:project1/features/lesson/domain/use_case/delete_lesson_usecase.dart';
import 'package:project1/features/lesson/domain/use_case/get_lesson_usecase.dart';
import 'package:project1/features/lesson/domain/use_case/get_lessons_usecase.dart';
import 'package:project1/features/lesson/domain/use_case/update_lesson_usecase.dart';
import 'lesson_state.dart';

class LessonCubit extends Cubit<LessonState> {
  final CreateLessonUseCase createLessonUseCase;
  final GetLessonUseCase getLessonUseCase;
  final GetLessonsUseCase getLessonsUseCase;
  final UpdateLessonUseCase updateLessonUseCase;
  final DeleteLessonUseCase deleteLessonUseCase;

  LessonCubit({
    required this.createLessonUseCase,
    required this.getLessonUseCase,
    required this.getLessonsUseCase,
    required this.updateLessonUseCase,
    required this.deleteLessonUseCase,
  }) : super(const LessonInitial());

  List<String> _errorsOf(Failure failure) {
    return failure.errors ?? [failure.message];
  }

  Future<void> createLesson({
    required String sectionId,
    required String title,
    required int order,
    required String videoUrl,
    required String description,
    required int duration,
  }) async {
    emit(const LessonLoading());

    final result = await createLessonUseCase(
      sectionId: sectionId,
      title: title,
      order: order,
      videoUrl: videoUrl,
      description: description,
      duration: duration,
    );

    result.fold(
      (failure) {
        emit(LessonError(_errorsOf(failure)));
      },
      (lesson) {
        emit(LessonSuccess(lesson));
      },
    );
  }

  Future<List<LessonEntity>> getLessons({
    required String sectionId,
    String? cursor,
  }) async {
    final result = await getLessonsUseCase(
      sectionId: sectionId,
      cursor: cursor,
    );

    return result.fold(
      (failure) {
        emit(LessonError(_errorsOf(failure)));
        return <LessonEntity>[];
      },
      (lessons) {
        return lessons;
      },
    );
  }

  Future<LessonEntity?> getLesson({
    required String sectionId,
    required String lessonId,
  }) async {
    final result = await getLessonUseCase(
      sectionId: sectionId,
      lessonId: lessonId,
    );

    return result.fold(
      (failure) {
        emit(LessonError(_errorsOf(failure)));
        return null;
      },
      (lesson) {
        return lesson;
      },
    );
  }

  Future<void> updateLesson({
    required String sectionId,
    required String lessonId,
    String? title,
    String? videoUrl,
    String? description,
    int? duration,
    int? order,
  }) async {
    emit(const LessonLoading());

    final result = await updateLessonUseCase(
      sectionId: sectionId,
      lessonId: lessonId,
      title: title,
      videoUrl: videoUrl,
      description: description,
      duration: duration,
      order: order,
    );

    result.fold(
      (failure) {
        emit(LessonError(_errorsOf(failure)));
      },
      (lesson) {
        emit(LessonUpdated(lesson));
      },
    );
  }

  Future<void> deleteLesson({
    required String sectionId,
    required String lessonId,
  }) async {
    emit(const LessonLoading());

    final result = await deleteLessonUseCase(
      sectionId: sectionId,
      lessonId: lessonId,
    );

    result.fold(
      (failure) {
        emit(LessonError(_errorsOf(failure)));
      },
      (_) {
        emit(const LessonDeleted());
      },
    );
  }

  void reset() {
    emit(const LessonInitial());
  }

  Future<bool> deleteLessonAndReturn({
    required String sectionId,
    required String lessonId,
  }) async {
    final result = await deleteLessonUseCase(
      sectionId: sectionId,
      lessonId: lessonId,
    );

    return result.fold((failure) {
      emit(LessonError(_errorsOf(failure)));
      return false;
    }, (_) => true);
  }

  Future<LessonEntity?> updateLessonAndReturn({
    required String sectionId,
    required String lessonId,
    String? title,
    String? videoUrl,
    String? description,
    int? duration,
    int? order,
  }) async {
    final result = await updateLessonUseCase(
      sectionId: sectionId,
      lessonId: lessonId,
      title: title,
      videoUrl: videoUrl,
      description: description,
      duration: duration,
      order: order,
    );

    return result.fold(
      (failure) {
        emit(LessonError(_errorsOf(failure)));
        return null;
      },
      (lesson) {
        emit(LessonUpdated(lesson));
        return lesson;
      },
    );
  }
}
