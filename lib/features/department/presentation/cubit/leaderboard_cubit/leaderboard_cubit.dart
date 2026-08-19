import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/department/domain/use_case/get_leaderboard_usecase.dart';
import 'leaderboard_state.dart';

class LeaderboardCubit extends Cubit<LeaderboardState> {
  final GetLeaderboardUseCase getLeaderboardUseCase;

  LeaderboardCubit(this.getLeaderboardUseCase) : super(LeaderboardInitial());

  Future<void> getLeaderboard({
    required String departmentId,
    required String demoId,
  }) async {
    emit(LeaderboardLoading());
    final result = await getLeaderboardUseCase(
      departmentId: departmentId,
      demoId: demoId,
    );
    result.fold(
      (error) => emit(LeaderboardError(error)),
      (members) => emit(LeaderboardLoaded(members)),
    );
  }
}
