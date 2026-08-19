import 'package:dartz/dartz.dart';
import 'package:project1/features/department/data/models/leaderboard_member_model.dart';

abstract class LeaderboardRepository {
  Future<Either<String, List<LeaderboardMemberModel>>> getLeaderboard({
    required String departmentId,
    required String demoId,
  });
}
