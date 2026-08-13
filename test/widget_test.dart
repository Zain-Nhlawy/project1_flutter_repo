import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project1/features/auth/presentation/cubit/session_cubit.dart';
import 'package:project1/features/auth/presentation/pages/session_gate.dart';

import 'helpers/auth_test_fakes.dart';

void main() {
  testWidgets('session gate switches between login and authenticated content', (
    tester,
  ) async {
    final getMe = StubGetMeUseCase(const Right(testUser));
    final userCubit = createTestUserCubit(getMe);
    final sessionCubit = SessionCubit(
      storage: FakeSecureStorage(),
      getMeUseCase: getMe,
      userCubit: userCubit,
    );
    addTearDown(sessionCubit.close);
    addTearDown(userCubit.close);

    await tester.pumpWidget(
      BlocProvider.value(
        value: sessionCubit,
        child: MaterialApp(
          home: SessionGate(
            authenticatedBuilder: (_) => const Text('authenticated'),
            unauthenticatedBuilder: (_) => const Text('login'),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('session-loading')), findsOneWidget);

    await sessionCubit.clearSession();
    await tester.pump();
    expect(find.text('login'), findsOneWidget);

    sessionCubit.startSession(testUser);
    await tester.pump();
    expect(find.text('authenticated'), findsOneWidget);
  });
}
