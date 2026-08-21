import 'package:project1/features/demo/domain/entities/demo_entity.dart';

abstract class DemoState {}

class DemoInitial extends DemoState {}

class GetDemosLoading extends DemoState {
  final List<DemoEntity> previousDemos;
  final bool isRefresh;

  GetDemosLoading({this.previousDemos = const [], this.isRefresh = false});
}

class GetDemosLoaded extends DemoState {
  final List<DemoEntity> demos;

  GetDemosLoaded(this.demos);
}

class GetDemosError extends DemoState {
  final String message;
  final List<DemoEntity> previousDemos;
  final bool isRefresh;

  GetDemosError(
    this.message, {
    this.previousDemos = const [],
    this.isRefresh = false,
  });
}

class AddDemoLoading extends DemoState {}

class AddDemoSuccess extends DemoState {}

class AddDemoError extends DemoState {
  final String message;

  AddDemoError(this.message);
}
