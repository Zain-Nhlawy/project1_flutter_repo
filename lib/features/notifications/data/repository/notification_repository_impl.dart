import 'package:dartz/dartz.dart';
import 'package:project1/core/errors/error_mapper.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/notifications/data/data_sources/notification_remote_data_source.dart';
import 'package:project1/features/notifications/data/models/fcm_token_request_model.dart';
import 'package:project1/features/notifications/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> registerFcmToken({
    required String token,
    required String deviceModel,
  }) async {
    try {
      final requestModel = FcmTokenRequestModel(
        token: token,
        deviceModel: deviceModel,
      );
      await remoteDataSource.registerFcmToken(requestModel);
      return const Right(null);
    } on Exception catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }
}
