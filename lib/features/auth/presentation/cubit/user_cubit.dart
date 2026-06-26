import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/auth/domain/use_case/get_me_usecase.dart';
import 'package:project1/features/auth/presentation/cubit/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetMeUseCase getMeUseCase;

  UserCubit(this.getMeUseCase) : super(const UserInitial());

  Future<void> getMe() async {
    emit(const UserLoading());
    try {
      final user = await getMeUseCase();
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}