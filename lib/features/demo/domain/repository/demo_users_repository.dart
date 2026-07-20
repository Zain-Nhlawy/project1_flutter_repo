import 'package:dartz/dartz.dart';
import 'package:project1/features/demo/domain/entities/invitation_entity.dart';
import 'package:project1/features/demo/domain/entities/user_entity.dart';

abstract class DemoUsersRepository {
  Future<Either<String, List<MembersEntity>>> getDemoUsers(String demoId);
  Future<Either<String, List<MembersEntity>>> searchDemoUsers(String query);
  Future<Either<String, bool>> removeUserFromDemo(String demoId, String userId);
  Future<Either<String, bool>> sendInvitation(String demoId, String userId);
  Future<Either<String, List<InvitationEntity>>> getReceivedInvitations();
  Future<void> acceptInvitation(String invitationId);
  Future<void> rejectInvitation(String invitationId);
}
