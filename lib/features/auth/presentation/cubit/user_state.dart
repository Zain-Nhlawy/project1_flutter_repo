import 'package:project1/features/auth/domain/entities/user_entity.dart';

abstract class UserState {
  const UserState();

  UserEntity? get user => null;
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  @override
  final UserEntity? user;
  final bool isRefresh;

  const UserLoading({this.user, this.isRefresh = false});
}

class UserLoaded extends UserState {
  @override
  final UserEntity user;

  const UserLoaded(this.user);
}

class UserError extends UserState {
  final List<String> errors;
  @override
  final UserEntity? user;
  final bool isRefresh;

  const UserError(this.errors, {this.user, this.isRefresh = false});
}
