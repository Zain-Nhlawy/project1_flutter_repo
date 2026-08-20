import 'package:dartz/dartz.dart';
import 'package:project1/features/demo/data/data_sources/demo_report_remote_data_source.dart';
import 'package:project1/features/demo/domain/entities/demo_report_entity.dart';
import 'package:project1/features/demo/domain/repository/demo_report_repository.dart';

class DemoReportRepositoryImpl implements DemoReportRepository {
  final DemoReportRemoteDataSource remoteDataSource;

  DemoReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, DemoOwnerReportEntity>> getOwnerReport(
    String demoId,
  ) async {
    try {
      final report = await remoteDataSource.getOwnerReport(demoId);
      return Right(report);
    } catch (error) {
      return Left(error.toString());
    }
  }
}
