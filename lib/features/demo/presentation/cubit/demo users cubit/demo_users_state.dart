
import 'package:project1/features/demo/domain/entities/user_entity.dart';

abstract class DemoUsersState {}

class DemoUserInitial extends DemoUsersState {}

class GetDemoUsersLoading extends DemoUsersState {}

class GetDemoUsersLoaded extends DemoUsersState {
  final List<MembersEntity> users;

  GetDemoUsersLoaded(this.users);
}

class GetDemoUsersError extends DemoUsersState {
  final String message;

  GetDemoUsersError(this.message);
}