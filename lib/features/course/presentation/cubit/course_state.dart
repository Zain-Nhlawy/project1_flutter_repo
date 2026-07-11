import 'package:project1/features/course/domain/entities/course_entity.dart';
import 'package:project1/features/course/domain/entities/tag_entity.dart';

abstract class CourseState {}

class CourseInitial extends CourseState {}



class CourseTagsLoading extends CourseState {}

class CourseTagsLoaded extends CourseState {
  final List<TagEntity> tags;

  CourseTagsLoaded(this.tags);
}

class CourseTagsError extends CourseState {
  final String message;

  CourseTagsError(this.message);
}



class CourseCreating extends CourseState {}

class CourseCreated extends CourseState {
  final CourseEntity course;

  CourseCreated(this.course);
}

class CourseCreateError extends CourseState {
  final String message;

  CourseCreateError(this.message);
}

class CourseLoading extends CourseState {}

class CourseLoaded extends CourseState {
  final List<CourseEntity> courses;

  CourseLoaded(this.courses);
}

class CourseError extends CourseState {
  final String message;

  CourseError(this.message);
}

class CourseUpdating extends CourseState {}

class CourseUpdated extends CourseState {
  final CourseEntity course;

  CourseUpdated(this.course);
}

class CourseUpdateError extends CourseState {
  final String message;

  CourseUpdateError(this.message);
}

class CourseDeleting extends CourseState {}

class CourseDeleted extends CourseState {}

class CourseDeleteError extends CourseState {
  final String message;

  CourseDeleteError(this.message);
}