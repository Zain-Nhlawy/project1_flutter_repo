class PaymentWebViewState {
  final bool isLoading;
  final String? status;
  final String? errorMessage;

  PaymentWebViewState({
    this.isLoading = false, 
    this.status, 
    this.errorMessage,
  });
}
  abstract class PaymentRequestState {}

  class PaymentRequestInitial extends PaymentRequestState {}

  class PaymentRequestLoading extends PaymentRequestState {}

  class PaymentRequestSuccess extends PaymentRequestState {}

  class PaymentRequestError extends PaymentRequestState {
    final String message;
    PaymentRequestError(this.message);
  }


