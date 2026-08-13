import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/auth/domain/entities/user_entity.dart';
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

    final result = await getMeUseCase();

    result.fold(
      (failure) {
        emit(UserError(failure.errors ?? [failure.message]));
      },
      (user) {
        emit(UserLoaded(user));
      },
    );
  }

  Future<void> updateProfileImage(File file, String userId) async {
    emit(const UserLoading());

    final result = await updateProfileImageUseCase(file, userId);

    result.fold(
      (failure) {
        emit(UserError(failure.errors ?? [failure.message]));
      },
      (_) async {
        await getMe();
      },
    );
  }

  void setUser(UserEntity user) {
    emit(UserLoaded(user));
  }

  void clearUser() {
    emit(const UserInitial());
  }
}
