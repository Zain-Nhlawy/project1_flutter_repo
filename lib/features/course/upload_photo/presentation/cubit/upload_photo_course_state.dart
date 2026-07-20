abstract class UploadPhotoCourseState {}

class UploadPhotoCourseInitial extends UploadPhotoCourseState {}

class UploadPhotoCourseLoading extends UploadPhotoCourseState {}

class UploadPhotoCourseSuccess extends UploadPhotoCourseState {
  final String url;

  UploadPhotoCourseSuccess(this.url);
}

class UploadPhotoCourseError extends UploadPhotoCourseState {
  final String message;

  UploadPhotoCourseError(this.message);
}
