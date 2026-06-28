import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/auth/domain/use_case/get_me_usecase.dart';
import 'package:project1/features/profile/domain/use_case/update_profile_image_usecase.dart';
import 'package:project1/features/auth/presentation/cubit/user_state.dart';
class UserCubit extends Cubit<UserState> {
  final GetMeUseCase getMeUseCase;
  final UpdateProfileImageUseCase updateProfileImageUseCase;

  UserCubit({
    required this.getMeUseCase,
    required this.updateProfileImageUseCase,
  }) : super(const UserInitial());

  Future<void> getMe() async {
    emit(const UserLoading());
    try {
      final user = await getMeUseCase();
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> updateProfileImage(File file, String userId) async {
  try {
    emit(const UserLoading());

    await updateProfileImageUseCase(file, userId);

    await getMe();
  } catch (e) {
    emit(UserError(e.toString()));
  }
}
}