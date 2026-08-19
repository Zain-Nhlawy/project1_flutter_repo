import 'package:dartz/dartz.dart';
import 'package:project1/features/department/data/data_sources/leaderboard_remote_data_source.dart';
import 'package:project1/features/department/data/models/leaderboard_member_model.dart';
import 'package:project1/features/department/domain/repository/leaderboard_repository.dart';

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  final LeaderboardRemoteDataSource remoteDataSource;

  LeaderboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<LeaderboardMemberModel>>> getLeaderboard({
    required String departmentId,
    required String demoId,
  }) async {
    try {
      final result = await remoteDataSource.getLeaderboard(
        departmentId: departmentId,
        demoId: demoId,
      );
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
