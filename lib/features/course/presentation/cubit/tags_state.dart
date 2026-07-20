import 'package:project1/features/course/domain/entities/tag_entity.dart';

abstract class TagsState {
  const TagsState();
}

class TagsInitial extends TagsState {
  const TagsInitial();
}

class TagsLoading extends TagsState {
  const TagsLoading();
}

class TagsLoaded extends TagsState {
  final List<TagEntity> tags;
  const TagsLoaded(this.tags);
}

class TagsError extends TagsState {
  final List<String> errors;
  const TagsError(this.errors);
}
