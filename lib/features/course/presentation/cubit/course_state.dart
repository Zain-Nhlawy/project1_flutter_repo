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