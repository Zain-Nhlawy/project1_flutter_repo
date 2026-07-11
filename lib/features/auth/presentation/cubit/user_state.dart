import 'package:project1/features/auth/domain/entities/user_entity.dart';

abstract class UserState {
  const UserState();
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserLoaded extends UserState {
  final UserEntity user;

  const UserLoaded(this.user);
}

class UserError extends UserState {
  final List<String> errors;

  const UserError(this.errors);
}