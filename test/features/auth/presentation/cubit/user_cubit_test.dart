import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project1/core/errors/failures.dart';
import 'package:project1/features/auth/presentation/cubit/user_state.dart';

import '../../../../helpers/auth_test_fakes.dart';

void main() {
  group('UserCubit refresh', () {
    test('keeps the current user when refreshing fails', () async {
      final getMe = StubGetMeUseCase(const Right(testUser));
      final cubit = createTestUserCubit(getMe)..setUser(testUser);
      addTearDown(cubit.close);

      getMe.result = const Left(NetworkFailure('No connection'));

      final error = await cubit.refreshUser();

      expect(error, 'No connection');
      expect(cubit.state, isA<UserError>());
      final state = cubit.state as UserError;
      expect(state.user, same(testUser));
      expect(state.isRefresh, isTrue);
    });
  });
}
