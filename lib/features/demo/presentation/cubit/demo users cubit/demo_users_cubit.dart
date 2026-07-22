import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/demo/domain/use%20case/demo_users_usecase.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20users%20cubit/demo_users_state.dart';

class DemoUserCubit extends Cubit<DemoUsersState> {
  final DemoUsersUsecase getUsersUseCase;

  DemoUserCubit({required this.getUsersUseCase}) : super(DemoUserInitial());

  Future<void> fetchUsers(String demoId) async {
    emit(GetDemoUsersLoading());

    try {
      final result = await getUsersUseCase(demoId);

      result.fold(
        (error) => emit(GetDemoUsersError(error)),
        (users) => emit(GetDemoUsersLoaded(users)),
      );
    } catch (e) {
      emit(GetDemoUsersError(e.toString()));
    }
  }

  Future<void> searchUsers(String query) async {
    emit(GetDemoUsersLoading());

    try {
      final result = await getUsersUseCase.search(query);

      result.fold(
        (error) => emit(GetDemoUsersError(error)),
        (users) => emit(GetDemoUsersLoaded(users)),
      );
    } catch (e) {
      emit(GetDemoUsersError(e.toString()));
    }
  }

  Future<bool> removeUser(String demoId, String userId) async {
    emit(GetDemoUsersLoading());

    try {
      final result = await getUsersUseCase.removeUserFromDemo(demoId, userId);

      return result.fold(
        (error) {
          emit(GetDemoUsersError(error));
          return false;
        },
        (success) {
          if (success) {
            fetchUsers(demoId);
            return true;
          } else {
            emit(GetDemoUsersError('Failed to remove user.'));
            return false;
          }
        },
      );
    } catch (e) {
      emit(GetDemoUsersError(e.toString()));
      return false;
    }
  }

  Future<String?> sendInvitation(String demoId, String userId) async {
    try {
      final result = await getUsersUseCase.sendInvitation(demoId, userId);

      return result.fold((error) => error, (success) {
        if (success) {
          fetchUsers(demoId);
          return null; // success
        } else {
          return 'Failed to send invitation.';
        }
      });
    } catch (e) {
      return e.toString();
    }
  }
}
