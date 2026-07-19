import '../../domain/entities/course_faq_entity.dart';

abstract class CourseFaqState {
  const CourseFaqState();
}

class CourseFaqInitial extends CourseFaqState {
  const CourseFaqInitial();
}

class CourseFaqLoading extends CourseFaqState {
  const CourseFaqLoading();
}

class CourseFaqLoaded extends CourseFaqState {
  final List<CourseFaqEntity> faqs;
  final bool hasNextPage;
  final String? endCursor;

  const CourseFaqLoaded({
    required this.faqs,
    this.hasNextPage = false,
    this.endCursor,
  });
}

class CourseFaqActionSuccess extends CourseFaqState {
  final String message;

  const CourseFaqActionSuccess(this.message);
}

class CourseFaqError extends CourseFaqState {
  final String message;

  const CourseFaqError(this.message);
}