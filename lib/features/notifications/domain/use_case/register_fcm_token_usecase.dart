import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/notifications/domain/repository/notification_repository.dart';

class RegisterFcmTokenUseCase {
  final NotificationRepository repository;

  RegisterFcmTokenUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String token,
    required String deviceModel,
  }) {
    return repository.registerFcmToken(
      token: token,
      deviceModel: deviceModel,
    );
  }
}
