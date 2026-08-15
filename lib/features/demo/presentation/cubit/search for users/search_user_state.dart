import 'package:project1/features/demo/domain/entities/user_entity.dart';

abstract class SearchUserState {
  const SearchUserState();
}

class SearchUserInitial extends SearchUserState {
  const SearchUserInitial();
}

class SearchUserLoading extends SearchUserState {
  const SearchUserLoading();
}

class SearchUserLoaded extends SearchUserState {
  final List<MembersEntity> users;

  const SearchUserLoaded(this.users);
}

class SearchUserEmpty extends SearchUserState {
  const SearchUserEmpty();
}

class SearchUserError extends SearchUserState {
  final String message;

  const SearchUserError(this.message);
}
