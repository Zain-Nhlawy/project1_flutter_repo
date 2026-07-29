import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/course/domain/use_case/checkout_course_usecase.dart';
import 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final CheckoutCourseUseCase checkoutCourseUseCase;

  PaymentCubit({required this.checkoutCourseUseCase}) : super(const PaymentInitial());

  Future<void> checkoutCourse({
    required String demoId,
    required String courseId,
  }) async {
    emit(const PaymentLoading());

    final result = await checkoutCourseUseCase(demoId: demoId, courseId: courseId);

    result.fold(
      (failure) => emit(PaymentError(failure.message)),
      (session) => emit(PaymentCheckoutReady(session.url)),
    );
  }
}