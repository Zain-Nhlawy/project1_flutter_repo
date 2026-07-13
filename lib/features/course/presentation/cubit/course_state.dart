import 'package:project1/features/course/domain/entities/course_entity.dart';
import 'package:project1/features/course/domain/entities/tag_entity.dart';

abstract class CourseState {
  const CourseState();
}

class CourseInitial extends CourseState {
  const CourseInitial();
}

class CourseTagsLoading extends CourseState {
  const CourseTagsLoading();
}

class CourseTagsLoaded extends CourseState {
  final List<TagEntity> tags;
  const CourseTagsLoaded(this.tags);
}

class CourseTagsError extends CourseState {
  final List<String> errors;
  const CourseTagsError(this.errors);
}

class CourseCreating extends CourseState {
  const CourseCreating();
}

class CourseCreated extends CourseState {
  final CourseEntity course;
  const CourseCreated(this.course);
}

class CourseCreateError extends CourseState {
  final List<String> errors;
  const CourseCreateError(this.errors);
}

class CourseLoading extends CourseState {
  const CourseLoading();
}

class CourseLoaded extends CourseState {
  final List<CourseEntity> courses;
  const CourseLoaded(this.courses);
}

class CourseError extends CourseState {
  final List<String> errors;
  const CourseError(this.errors);
}

class CourseUpdating extends CourseState {
  const CourseUpdating();
}

class CourseUpdated extends CourseState {
  final CourseEntity course;
  const CourseUpdated(this.course);
}

class CourseUpdateError extends CourseState {
  final List<String> errors;
  const CourseUpdateError(this.errors);
}

class CourseDeleting extends CourseState {
  const CourseDeleting();
}

class CourseDeleted extends CourseState {
  const CourseDeleted();
}

class CourseDeleteError extends CourseState {
  final List<String> errors;
  const CourseDeleteError(this.errors);
}

class CoursePublishing extends CourseState {
  const CoursePublishing();
}

class CoursePublished extends CourseState {
  final CourseEntity course;

  const CoursePublished(this.course);
}

class CoursePublishError extends CourseState {
  final List<String> errors;

  const CoursePublishError(this.errors);
}

class CourseDetailsLoading extends CourseState {
  const CourseDetailsLoading();
}

class CourseDetailsLoaded extends CourseState {
  final CourseEntity course;
  const CourseDetailsLoaded(this.course);
}

class CourseDetailsError extends CourseState {
  final List<String> errors;
  const CourseDetailsError(this.errors);
}

class CourseAssetLoading extends CourseState {
  const CourseAssetLoading();
}

class CourseAssetLoaded extends CourseState {
  final CourseEntity course;
  const CourseAssetLoaded(this.course);
}

class CourseAssetError extends CourseState {
  final List<String> errors;
  const CourseAssetError(this.errors);
}