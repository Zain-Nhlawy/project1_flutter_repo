import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/notifications/data/models/fcm_token_request_model.dart';

abstract class NotificationRemoteDataSource {
  Future<void> registerFcmToken(FcmTokenRequestModel requestModel);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final DioClient dioClient;

  NotificationRemoteDataSourceImpl(this.dioClient);

  @override
  Future<void> registerFcmToken(FcmTokenRequestModel requestModel) async {
    try {
      await dioClient.dio.post(
        '/notifications/fcm-token',
        data: requestModel.toJson(),
      );
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}
