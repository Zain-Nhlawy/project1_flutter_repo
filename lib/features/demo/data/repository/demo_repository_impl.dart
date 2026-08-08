import 'package:dartz/dartz.dart';
import 'package:project1/core/network/dio_client.dart';
import 'package:project1/features/demo/data/data_sources/demo_remote_data_source.dart';
import 'package:project1/features/demo/data/models/demo_model.dart';
import 'package:project1/features/demo/domain/entities/demo_entity.dart';
import 'package:project1/features/demo/domain/repository/demo_repository.dart';

class DemoRepositoryImpl implements DemoRepository {
  final DemoRemoteDataSource remoteDataSource;

  DemoRepositoryImpl(DioClient dioClient, {required this.remoteDataSource});

  @override
  Future<Either<String, List<DemoModel>>> getDemos() async {
    try {
      final result = await remoteDataSource.getDemos();
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> addDemo(DemoEntity demo) async {
    try {
      await remoteDataSource.addDemo(demo as DemoModel);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
