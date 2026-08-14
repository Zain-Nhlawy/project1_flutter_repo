import 'package:project1/features/auth/domain/entities/user_entity.dart';

abstract class SessionState {
  const SessionState();
}

class SessionInitial extends SessionState {
  const SessionInitial();
}

class SessionChecking extends SessionState {
  const SessionChecking();
}

class SessionAuthenticated extends SessionState {
  final UserEntity user;

  const SessionAuthenticated(this.user);
}

class SessionUnauthenticated extends SessionState {
  const SessionUnauthenticated();
}

class SessionFailure extends SessionState {
  final List<String> errors;

  const SessionFailure(this.errors);
}
