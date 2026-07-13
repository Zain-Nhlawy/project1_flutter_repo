import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/demo/domain/use%20case/demo_users_usecase.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20users%20cubit/demo_users_state.dart';

class DemoUserCubit extends Cubit<DemoUsersState> {
  final DemoUsersUsecase getUsersUseCase;

  DemoUserCubit({required this.getUsersUseCase}) : super(DemoUserInitial());

  Future<void> fetchUsers(String demoId) async {
    emit(GetDemoUsersLoading());

    final result = await getUsersUseCase(demoId);

    result.fold(
      (error) => emit(GetDemoUsersError(error)),
      (users) => emit(GetDemoUsersLoaded(users)),
    );
  }

  Future<void> searchUsers(String query) async {
    emit(GetDemoUsersLoading());

    final result = await getUsersUseCase.search(query);

    result.fold(
      (error) => emit(GetDemoUsersError(error)),
      (users) => emit(GetDemoUsersLoaded(users)),
    );
  }
}
