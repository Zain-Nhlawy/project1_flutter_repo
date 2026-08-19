import 'package:project1/features/department/data/models/leaderboard_member_model.dart';

abstract class LeaderboardState {}

class LeaderboardInitial extends LeaderboardState {}

class LeaderboardLoading extends LeaderboardState {}

class LeaderboardLoaded extends LeaderboardState {
  final List<LeaderboardMemberModel> members;

  LeaderboardLoaded(this.members);
}

class LeaderboardError extends LeaderboardState {
  final String message;

  LeaderboardError(this.message);
}
