import '../../domain/entities/checkout_session_entity.dart';

class CheckoutSessionModel extends CheckoutSessionEntity {
  const CheckoutSessionModel({required super.url});

  factory CheckoutSessionModel.fromJson(Map<String, dynamic> json) {
    return CheckoutSessionModel(
      url: json['url']?.toString() ?? '',
    );
  }
}