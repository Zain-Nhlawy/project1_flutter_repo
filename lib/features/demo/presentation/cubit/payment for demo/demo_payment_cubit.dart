import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/demo/domain/use%20case/demo_payment_usecase.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20cubit/demo_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/payment%20for%20demo/demo_payment_state.dart';

class PaymentWebViewCubit extends Cubit<PaymentWebViewState> {
  final DemoPaymentUseCase requestPaymentUseCase;

  PaymentWebViewCubit({required this.requestPaymentUseCase})
    : super(PaymentWebViewState());

  void pageStarted() => emit(PaymentWebViewState(isLoading: true));

  void pageFinished() => emit(PaymentWebViewState(isLoading: false));

  Future<String> requestPayment(String demoId, String plan) async {
    emit(PaymentWebViewState(isLoading: true));
    try {
      final result = await requestPaymentUseCase.requestPayment(demoId, plan);

      return result.fold(
        (error) {
          emit(PaymentWebViewState(isLoading: false, errorMessage: error));
          throw Exception(error);
        },
        (url) {
          emit(PaymentWebViewState(isLoading: false));
          return url;
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(PaymentWebViewState(isLoading: false, errorMessage: e.toString()));
      }
      rethrow;
    }
  }

  Future<void> handlePaymentSuccess(String sessionId) async {
    if (isClosed) return;
    emit(PaymentWebViewState(isLoading: true));

    bool isConfirmed = false;
    int maxRetries = 10;
    int attempts = 0;

    while (!isConfirmed && attempts < maxRetries) {
      if (isClosed) return;

      attempts++;
      final result = await requestPaymentUseCase.confirmPayment(sessionId);

      await result.fold(
        (error) async {
          if (!isClosed) {
            emit(
              PaymentWebViewState(
                isLoading: false,
                errorMessage: error.toString(),
              ),
            );
          }
          isConfirmed = true;
        },
        (status) async {
          if (status.toLowerCase() == 'complete') {
            if (!isClosed) {
              emit(PaymentWebViewState(isLoading: false, status: status));
            }
            if (getIt.isRegistered<DemoCubit>()) {
              getIt<DemoCubit>().fetchDemos();
            }
            isConfirmed = true;
          } else {
            await Future.delayed(const Duration(seconds: 3));
          }
        },
      );
    }

    if (!isConfirmed && attempts >= maxRetries) {
      if (!isClosed) {
        emit(
          PaymentWebViewState(
            isLoading: false,
            errorMessage:
                "Payment confirmation failed after multiple attempts. Please try again later.",
          ),
        );
      }
    }
  }

  Future<void> requestSubscriptionManagement(String demoId) async {
    if (isClosed) return;
    emit(PaymentWebViewState(isLoading: true));

    final result = await requestPaymentUseCase.manageSubscription(demoId);
    if (isClosed) return;

    result.fold(
      (error) =>
          emit(PaymentWebViewState(isLoading: false, errorMessage: error)),
      (url) => emit(PaymentWebViewState(isLoading: false, managementUrl: url)),
    );
  }
}
