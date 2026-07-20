abstract class LessonVideoUploadState {
  const LessonVideoUploadState();
}

class LessonVideoUploadInitial extends LessonVideoUploadState {
  const LessonVideoUploadInitial();
}

class LessonVideoUploadRequestingUrl extends LessonVideoUploadState {
  const LessonVideoUploadRequestingUrl();
}

class LessonVideoUploadInProgress extends LessonVideoUploadState {
  final double progress;

  const LessonVideoUploadInProgress(this.progress);
}

class LessonVideoUploadSuccess extends LessonVideoUploadState {
  final String cdnUrl;

  const LessonVideoUploadSuccess(this.cdnUrl);
}

class LessonVideoUploadError extends LessonVideoUploadState {
  final List<String> errors;

  const LessonVideoUploadError(this.errors);
}
