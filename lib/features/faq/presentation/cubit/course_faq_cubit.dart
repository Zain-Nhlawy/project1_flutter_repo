import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/faq/domain/use_case/create_course_faq_usecase.dart';
import 'package:project1/features/faq/domain/use_case/delete_course_faq_usecase.dart';
import 'package:project1/features/faq/domain/use_case/get_course_faqs_usecase.dart';
import 'course_faq_state.dart';

class CourseFaqCubit extends Cubit<CourseFaqState> {
  final GetCourseFaqsUseCase getCourseFaqsUseCase;
  final CreateCourseFaqUseCase createCourseFaqUseCase;
  final DeleteCourseFaqUseCase deleteCourseFaqUseCase;

  CourseFaqCubit({
    required this.getCourseFaqsUseCase,
    required this.createCourseFaqUseCase,
    required this.deleteCourseFaqUseCase,
  }) : super(const CourseFaqInitial());

  Future<void> getCourseFaqs({required String courseId, String? cursor}) async {
    emit(const CourseFaqLoading());
    final result = await getCourseFaqsUseCase(
      courseId: courseId,
      cursor: cursor,
    );

    result.fold(
      (failure) => emit(CourseFaqError(failure.message)),
      (faqs) => emit(CourseFaqLoaded(faqs: faqs)),
    );
  }

  Future<void> createCourseFaq({
    required String courseId,
    required String question,
    required String answer,
  }) async {
    emit(const CourseFaqLoading());
    final result = await createCourseFaqUseCase(
      courseId: courseId,
      question: question,
      answer: answer,
    );

    result.fold(
      (failure) => emit(CourseFaqError(failure.message)),
      (_) => emit(const CourseFaqActionSuccess('FAQ created successfully')),
    );
  }

  Future<void> deleteCourseFaq({
    required String courseId,
    required String faqId,
  }) async {
    emit(const CourseFaqLoading());
    final result = await deleteCourseFaqUseCase(
      courseId: courseId,
      faqId: faqId,
    );

    result.fold(
      (failure) => emit(CourseFaqError(failure.message)),
      (_) => emit(const CourseFaqActionSuccess('FAQ deleted successfully')),
    );
  }
}
