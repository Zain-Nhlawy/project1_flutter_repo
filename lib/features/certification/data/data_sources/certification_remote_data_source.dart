import 'package:dio/dio.dart';
import 'package:project1/core/errors/dio_exception_mapper.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/certification/data/models/certification_model.dart';

class CertificationRemoteDataSource {
  final DioClient dioClient;

  CertificationRemoteDataSource(this.dioClient);

  Future<PaginatedCertifications> getMyCertifications({
    String? cursor,
  }) async {
    try {
      final res = await dioClient.dio.get(
        '/certifications/me',
        queryParameters: {
          if (cursor != null) 'cursor': cursor,
        },
      );

      final data = res.data as Map<String, dynamic>;
      return PaginatedCertifications.fromJson(data);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  Future<CertificationModel> getCertificationById({
    required String certificationId,
  }) async {
    try {
      final res = await dioClient.dio.get(
        '/certifications/$certificationId',
      );

      final data = res.data as Map<String, dynamic>;
      return CertificationModel.fromJson(data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }
}