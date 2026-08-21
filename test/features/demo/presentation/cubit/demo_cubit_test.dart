import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project1/features/auth/upload_photo/domain/use_case/upload_photo_usecase.dart';
import 'package:project1/features/demo/domain/entities/demo_entity.dart';
import 'package:project1/features/demo/domain/use%20case/demos_usecase.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20cubit/demo_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20cubit/demo_state.dart';

void main() {
  group('DemoCubit refresh', () {
    late _ControllableGetDemosUseCase getDemos;
    late DemoCubit cubit;

    setUp(() {
      getDemos = _ControllableGetDemosUseCase();
      cubit = DemoCubit(
        getDemosUseCase: getDemos,
        uploadPhotoUseCase: _UnusedUploadPhotoUseCase(),
      );
    });

    tearDown(() => cubit.close());

    test('keeps loaded demos when refreshing fails', () async {
      final demo = DemoEntity(id: 'current', name: 'Current demo');
      final initialLoad = cubit.fetchDemos();
      getDemos.completeSuccess(0, [demo]);
      await initialLoad;

      final refresh = cubit.refreshDemos();

      expect(cubit.state, isA<GetDemosLoading>());
      final loading = cubit.state as GetDemosLoading;
      expect(loading.previousDemos, contains(same(demo)));
      expect(loading.isRefresh, isTrue);

      getDemos.completeError(1, 'No connection');
      final error = await refresh;

      expect(error, 'No connection');
      expect(cubit.state, isA<GetDemosError>());
      final state = cubit.state as GetDemosError;
      expect(state.previousDemos, contains(same(demo)));
      expect(state.isRefresh, isTrue);
    });

    test('ignores an older request that completes after a newer one', () async {
      final initialLoad = cubit.fetchDemos();
      getDemos.completeSuccess(0, [DemoEntity(id: 'initial')]);
      await initialLoad;

      final olderRefresh = cubit.refreshDemos();
      final newerRefresh = cubit.refreshDemos();

      getDemos.completeSuccess(2, [DemoEntity(id: 'newer')]);
      await newerRefresh;
      getDemos.completeSuccess(1, [DemoEntity(id: 'older')]);
      await olderRefresh;

      expect(cubit.state, isA<GetDemosLoaded>());
      final demos = (cubit.state as GetDemosLoaded).demos;
      expect(demos.single.id, 'newer');
      expect(cubit.currentDemos.single.id, 'newer');
    });
  });
}

class _ControllableGetDemosUseCase implements GetDemosUseCase {
  final List<Completer<Either<String, List<DemoEntity>>>> _requests = [];

  @override
  Future<Either<String, List<DemoEntity>>> getDemos() {
    final completer = Completer<Either<String, List<DemoEntity>>>();
    _requests.add(completer);
    return completer.future;
  }

  void completeSuccess(int index, List<DemoEntity> demos) {
    _requests[index].complete(Right(demos));
  }

  void completeError(int index, String message) {
    _requests[index].complete(Left(message));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnsupportedError('Not used by this test');
  }
}

class _UnusedUploadPhotoUseCase implements UploadPhotoUseCase {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnsupportedError('Not used by this test');
  }
}
