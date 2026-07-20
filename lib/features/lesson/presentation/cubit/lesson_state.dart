import 'package:project1/features/lesson/domain/entities/lesson_entity.dart';

abstract class LessonState {
  const LessonState();
}

class LessonInitial extends LessonState {
  const LessonInitial();
}

class LessonLoading extends LessonState {
  const LessonLoading();
}

class LessonSuccess extends LessonState {
  final LessonEntity lesson;

  const LessonSuccess(this.lesson);
}

class LessonUpdated extends LessonState {
  final LessonEntity lesson;

  const LessonUpdated(this.lesson);
}

class LessonDeleted extends LessonState {
  const LessonDeleted();
}

class LessonError extends LessonState {
  final List<String> errors;

  const LessonError(this.errors);
}
