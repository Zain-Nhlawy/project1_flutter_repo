class PaymentWebViewState {
  final bool isLoading;
  final String? status;
  final String? errorMessage;
  final String? managementUrl;

  PaymentWebViewState({
    this.isLoading = false,
    this.status,
    this.errorMessage,
    this.managementUrl,
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
