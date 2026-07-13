abstract class UploadPhotoState {}

class UploadPhotoInitial extends UploadPhotoState {}

class UploadPhotoLoading extends UploadPhotoState {}

class UploadPhotoSuccess extends UploadPhotoState {
  final String imageUrl;

  UploadPhotoSuccess(this.imageUrl);
}

class UploadPhotoError extends UploadPhotoState {
  final List<String> errors;

  UploadPhotoError(this.errors);
}