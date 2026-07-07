import 'package:project1/features/demo/domain/entities/demo_entity.dart';

abstract class DemoState {}

class DemoInitial extends DemoState {}

class GetDemosLoading extends DemoState {}

class GetDemosLoaded extends DemoState {
  final List<DemoEntity> demos;

  GetDemosLoaded(this.demos);
} 

class GetDemosError extends DemoState {
  final String message;

  GetDemosError(this.message);
}

class AddDemoLoading extends DemoState {

}
class AddDemoSuccess extends DemoState {

}
class AddDemoError extends DemoState {
  final String message;

  AddDemoError(this.message);
}
