
import 'package:project1/features/demo/domain/entities/user_entity.dart';

abstract class SearchUserState  {
  const SearchUserState();

  @override
  List<Object?> get props => [];
}

class SearchUserInitial extends SearchUserState {}

class SearchUserLoading extends SearchUserState {}

class SearchUserLoaded extends SearchUserState {
  final List<MembersEntity> users;

  const SearchUserLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class SearchUserEmpty extends SearchUserState {}

class SearchUserError extends SearchUserState {
  final String message;

  const SearchUserError(this.message);

  @override
  List<Object?> get props => [message];
}