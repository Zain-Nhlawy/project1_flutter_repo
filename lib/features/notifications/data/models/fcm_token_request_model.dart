class FcmTokenRequestModel {
  final String token;
  final String deviceModel;

  const FcmTokenRequestModel({
    required this.token,
    required this.deviceModel,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'deviceModel': deviceModel,
    };
  }

  factory FcmTokenRequestModel.fromJson(Map<String, dynamic> json) {
    return FcmTokenRequestModel(
      token: json['token'] as String? ?? '',
      deviceModel: json['deviceModel'] as String? ?? '',
    );
  }
}
