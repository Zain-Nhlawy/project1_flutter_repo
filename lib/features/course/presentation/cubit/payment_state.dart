abstract class PaymentState {
  const PaymentState();
}

class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

class PaymentLoading extends PaymentState {
  const PaymentLoading();
}

class PaymentCheckoutReady extends PaymentState {
  final String url;

  const PaymentCheckoutReady(this.url);
}

class PaymentError extends PaymentState {
  final String message;

  const PaymentError(this.message);
}

class PaymentConfirmLoading extends PaymentState {
  const PaymentConfirmLoading();
}

class PaymentConfirmSuccess extends PaymentState {
  final String status;

  const PaymentConfirmSuccess(this.status);
}

class PaymentConfirmError extends PaymentState {
  final String message;

  const PaymentConfirmError(this.message);
}