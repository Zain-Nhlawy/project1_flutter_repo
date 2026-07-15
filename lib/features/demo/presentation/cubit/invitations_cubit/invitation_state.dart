import 'package:project1/features/demo/domain/entities/invitation_entity.dart';

abstract class InvitationState {}

class InvitationInitial extends InvitationState {}

class InvitationLoading extends InvitationState {}

class InvitationLoaded extends InvitationState {
  final List<InvitationEntity> invitations;
  InvitationLoaded(this.invitations);
}

class InvitationError extends InvitationState {
  final String message;
  InvitationError(this.message);
}
