import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/core/storage/secure_storage.dart';
import 'package:project1/core/storage/storage_keys.dart';
import 'package:project1/features/auth/domain/entities/user_entity.dart';
import 'package:project1/features/auth/domain/use_case/get_me_usecase.dart';
import 'package:project1/features/auth/presentation/cubit/session_state.dart';
import 'package:project1/features/auth/presentation/cubit/user_cubit.dart';

class SessionCubit extends Cubit<SessionState> {
  final AppSecureStorage storage;
  final GetMeUseCase getMeUseCase;
  final UserCubit userCubit;

  int _sessionRevision = 0;

  SessionCubit({
    required this.storage,
    required this.getMeUseCase,
    required this.userCubit,
  }) : super(const SessionInitial());

  Future<void> restoreSession() async {
    final revision = ++_sessionRevision;
    emit(const SessionChecking());

    try {
      final refreshToken = await storage.read(StorageKeys.refreshToken);

      if (!_isCurrent(revision)) return;

      if (refreshToken == null || refreshToken.isEmpty) {
        await storage.delete(StorageKeys.token);
        if (!_isCurrent(revision)) return;
        userCubit.clearUser();
        emit(const SessionUnauthenticated());
        return;
      }

      final result = await getMeUseCase();

      if (!_isCurrent(revision)) return;

      await result.fold(
        (failure) async {
          if (!_isCurrent(revision)) return;

          if (failure is UnauthorizedFailure) {
            await _clearStoredTokens();
            if (!_isCurrent(revision)) return;
            userCubit.clearUser();
            emit(const SessionUnauthenticated());
            return;
          }

          emit(SessionFailure(failure.errors ?? [failure.message]));
        },
        (user) async {
          if (!_isCurrent(revision)) return;
          userCubit.setUser(user);
          emit(SessionAuthenticated(user));
        },
      );
    } catch (error) {
      if (!_isCurrent(revision)) return;
      emit(SessionFailure([error.toString()]));
    }
  }

  void startSession(UserEntity user) {
    _sessionRevision++;
    userCubit.setUser(user);
    emit(SessionAuthenticated(user));
  }

  Future<void> clearSession() async {
    _sessionRevision++;
    try {
      await _clearStoredTokens();
    } finally {
      userCubit.clearUser();
      emit(const SessionUnauthenticated());
    }
  }

  void markSessionExpired() {
    _sessionRevision++;
    userCubit.clearUser();
    emit(const SessionUnauthenticated());
  }

  bool _isCurrent(int revision) => revision == _sessionRevision;

  Future<void> _clearStoredTokens() async {
    await storage.delete(StorageKeys.token);
    await storage.delete(StorageKeys.refreshToken);
    await storage.delete(StorageKeys.currentUserId);
  }
}
