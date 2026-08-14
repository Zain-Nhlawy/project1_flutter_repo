import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/core/storage/storage_keys.dart';
import 'package:project1/features/auth/presentation/cubit/session_cubit.dart';
import 'package:project1/features/auth/presentation/cubit/session_state.dart';
import 'package:project1/features/auth/presentation/cubit/user_state.dart';

import '../../../../helpers/auth_test_fakes.dart';

void main() {
  group('SessionCubit', () {
    test('restores a user when a refresh token is stored', () async {
      final storage = FakeSecureStorage({
        StorageKeys.refreshToken: 'stored-refresh-token',
      });
      final getMe = StubGetMeUseCase(const Right(testUser));
      final userCubit = createTestUserCubit(getMe);
      final cubit = SessionCubit(
        storage: storage,
        getMeUseCase: getMe,
        userCubit: userCubit,
      );
      addTearDown(cubit.close);
      addTearDown(userCubit.close);

      await cubit.restoreSession();

      expect(cubit.state, isA<SessionAuthenticated>());
      expect((cubit.state as SessionAuthenticated).user, testUser);
      expect(userCubit.state, isA<UserLoaded>());
      expect(getMe.callCount, 1);
    });

    test('treats missing refresh credentials as logged out', () async {
      final storage = FakeSecureStorage({
        StorageKeys.token: 'stale-access-token',
      });
      final getMe = StubGetMeUseCase(const Right(testUser));
      final userCubit = createTestUserCubit(getMe);
      final cubit = SessionCubit(
        storage: storage,
        getMeUseCase: getMe,
        userCubit: userCubit,
      );
      addTearDown(cubit.close);
      addTearDown(userCubit.close);

      await cubit.restoreSession();

      expect(cubit.state, isA<SessionUnauthenticated>());
      expect(storage.values[StorageKeys.token], isNull);
      expect(getMe.callCount, 0);
    });

    test('clears rejected credentials and returns to login', () async {
      final storage = FakeSecureStorage({
        StorageKeys.token: 'expired-access-token',
        StorageKeys.refreshToken: 'rejected-refresh-token',
      });
      final getMe = StubGetMeUseCase(
        const Left(UnauthorizedFailure('Session expired')),
      );
      final userCubit = createTestUserCubit(getMe);
      final cubit = SessionCubit(
        storage: storage,
        getMeUseCase: getMe,
        userCubit: userCubit,
      );
      addTearDown(cubit.close);
      addTearDown(userCubit.close);

      await cubit.restoreSession();

      expect(cubit.state, isA<SessionUnauthenticated>());
      expect(storage.values[StorageKeys.token], isNull);
      expect(storage.values[StorageKeys.refreshToken], isNull);
    });

    test('preserves credentials after a temporary network failure', () async {
      final storage = FakeSecureStorage({
        StorageKeys.token: 'stored-access-token',
        StorageKeys.refreshToken: 'stored-refresh-token',
      });
      final getMe = StubGetMeUseCase(
        const Left(NetworkFailure('No connection')),
      );
      final userCubit = createTestUserCubit(getMe);
      final cubit = SessionCubit(
        storage: storage,
        getMeUseCase: getMe,
        userCubit: userCubit,
      );
      addTearDown(cubit.close);
      addTearDown(userCubit.close);

      await cubit.restoreSession();

      expect(cubit.state, isA<SessionFailure>());
      expect(storage.values[StorageKeys.token], 'stored-access-token');
      expect(storage.values[StorageKeys.refreshToken], 'stored-refresh-token');
    });
  });
}
