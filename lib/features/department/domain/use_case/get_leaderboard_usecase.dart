import 'package:dartz/dartz.dart';
import 'package:project1/features/department/data/models/leaderboard_member_model.dart';
import 'package:project1/features/department/domain/repository/leaderboard_repository.dart';

class GetLeaderboardUseCase {
  final LeaderboardRepository repository;

  GetLeaderboardUseCase({required this.repository});

  Future<Either<String, List<LeaderboardMemberModel>>> call({
    required String departmentId,
    required String demoId,
  }) {
    return repository.getLeaderboard(
      departmentId: departmentId,
      demoId: demoId,
    );
  }
}
