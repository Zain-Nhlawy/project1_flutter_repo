import 'package:dartz/dartz.dart';
import 'package:project1/features/demo/shared/entities/user_entity.dart';
import 'package:project1/features/demo/data/data_sources/demo_users_remote_data_source.dart';
import 'package:project1/features/demo/domain/repository/demo_users_repository.dart';

class DemoUserRepositoryImpl implements DemoUsersRepository {
  final DemoUsersRemoteDataSource remoteDataSource;
  DemoUserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<MembersEntity>>> getDemoUsers(String demoId) async {
    try {
      final users = await remoteDataSource.getDemoUsers(demoId);
      return Right(users);
    } catch (e) {
      return Left('Failed to load demo users: $e');
    }
  }

  @override
  Future<Either<String, List<MembersEntity>>> searchDemoUsers(String query) async {
    try {
      final users = await remoteDataSource.searchDemoUsers(query);
      return Right(users);
    } catch (e) {
      return Left('Failed to search demo users: $e');
    }
  }
  
}