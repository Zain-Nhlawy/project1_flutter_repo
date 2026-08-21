import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/auth/domain/entities/user_entity.dart';
import 'package:project1/features/auth/domain/use_case/get_me_usecase.dart';
import 'package:project1/features/profile/domain/use_case/update_profile_image_usecase.dart';
import 'package:project1/features/auth/presentation/cubit/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetMeUseCase getMeUseCase;
  final UpdateProfileImageUseCase updateProfileImageUseCase;
  UserEntity? _currentUser;
  int _getMeRevision = 0;

  UserCubit({
    required this.getMeUseCase,
    required this.updateProfileImageUseCase,
  }) : super(const UserInitial());

  Future<void> getMe() async {
    await _loadUser(isRefresh: false);
  }

  Future<String?> refreshUser() {
    return _loadUser(isRefresh: true);
  }

  Future<String?> _loadUser({required bool isRefresh}) async {
    final revision = ++_getMeRevision;
    final previousUser = isRefresh ? _currentUser : null;

    emit(UserLoading(user: previousUser, isRefresh: isRefresh));

    try {
      final result = await getMeUseCase();
      if (revision != _getMeRevision) return null;

      String? errorMessage;
      result.fold(
        (failure) {
          final errors = failure.errors ?? [failure.message];
          errorMessage = errors.join('\n');
          emit(UserError(errors, user: previousUser, isRefresh: isRefresh));
        },
        (user) {
          _currentUser = user;
          emit(UserLoaded(user));
        },
      );
      return errorMessage;
    } catch (error) {
      if (revision != _getMeRevision) return null;

      final message = error.toString();
      emit(UserError([message], user: previousUser, isRefresh: isRefresh));
      return message;
    }
  }

  Future<void> updateProfileImage(File file, String userId) async {
    emit(UserLoading(user: _currentUser));

    final result = await updateProfileImageUseCase(file, userId);

    await result.fold<Future<void>>(
      (failure) async {
        emit(
          UserError(failure.errors ?? [failure.message], user: _currentUser),
        );
      },
      (_) async {
        await refreshUser();
      },
    );
  }

  void setUser(UserEntity user) {
    _getMeRevision++;
    _currentUser = user;
    emit(UserLoaded(user));
  }

  void clearUser() {
    _getMeRevision++;
    _currentUser = null;
    emit(const UserInitial());
  }
}
