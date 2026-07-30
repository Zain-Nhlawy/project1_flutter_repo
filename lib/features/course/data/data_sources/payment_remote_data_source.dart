import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import '../../../../core/network/dio_client.dart';
import '../models/checkout_session_model.dart';

class PaymentRemoteDataSource {
  final DioClient dioClient;

  PaymentRemoteDataSource(this.dioClient);

  Future<CheckoutSessionModel> checkoutCourse({
  required String demoId,
  required String courseId,
}) async {
  try {
    final response = await dioClient.dio.post(
      '/payments/checkout/course',
      data: {'courseId': courseId},
      options: Options(
        headers: {'x-demo-id': demoId},
      ),
    );

    final data = response.data['data'];

    if (data == null) {
      return const CheckoutSessionModel(
        url: '',
      );
    }

    return CheckoutSessionModel.fromJson(
      Map<String, dynamic>.from(data),
    );
  } on DioException catch (e) {
    throw mapDioException(e);
  }
}
}