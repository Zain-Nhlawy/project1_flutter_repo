import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/demo/domain/use case/demo_users_usecase.dart';
import 'invitation_state.dart';

class InvitationCubit extends Cubit<InvitationState> {
  final DemoUsersUsecase usecase;

  InvitationCubit({required this.usecase}) : super(InvitationInitial());

  Future<void> getInvitations() async {
    emit(InvitationLoading());
    final result = await usecase.getReceivedInvitations();
    result.fold(
      (failure) => emit(InvitationError(failure)),
      (invitations) => emit(InvitationLoaded(invitations)),
    );
  }

  Future<void> acceptInvitation(String invitationId) async {
    try {
      await usecase.acceptInvitation(invitationId);
      getInvitations();
    } catch (e) {
      emit(InvitationError('Failed to accept invitation: $e'));
    }
  }

  Future<void> rejectInvitation(String invitationId) async {
    try {
      await usecase.rejectInvitation(invitationId);
      getInvitations();
    } catch (e) {
      emit(InvitationError('Failed to reject invitation: $e'));
    }
  }
}
