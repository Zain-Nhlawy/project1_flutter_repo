import 'package:dartz/dartz.dart';
import 'package:project1/features/demo/domain/entities/invitation_entity.dart';
import 'package:project1/features/demo/domain/entities/user_entity.dart';
import 'package:project1/features/demo/data/data_sources/demo_users_remote_data_source.dart';
import 'package:project1/features/demo/domain/repository/demo_users_repository.dart';

class DemoUserRepositoryImpl implements DemoUsersRepository {
  final DemoUsersRemoteDataSource remoteDataSource;
  DemoUserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<MembersEntity>>> getDemoUsers(String demoId) async {
    try {
      final users = await remoteDataSource.getDemoUsers(demoId);
      return Right(users);
    } catch (e) {
      return Left('Failed to load demo users: $e');
    }
  }

  @override
  Future<Either<String, List<MembersEntity>>> searchDemoUsers(String query) async {
    try {
      final users = await remoteDataSource.searchDemoUsers(query);
      return Right(users);
    } catch (e) {
      return Left('Failed to search demo users: $e');
    }
  }
  
@override
  Future<Either<String, bool>> removeUserFromDemo(String demoId, String userId) async {
    try {
      final result = await remoteDataSource.removeUserFromDemo(demoId, userId);
      return Right(result);
    } catch (e) {
      return Left('Failed to remove user from demo: $e');
    }
  }
@override
  Future<Either<String, bool>> sendInvitation(String demoId, String userId) async
  {
    try {
      final result = await remoteDataSource.sendInvitation(demoId, userId);
      return Right(result);
    } catch (e) {
      if (e.toString().contains('user_already_invited')) {
        return const Left('user_already_invited');
      }
      return Left('Failed to send invitation: $e');
    }
  }

  Future<Either<String, List<InvitationEntity>>> getReceivedInvitations() async {
    try {
      final invitations = await remoteDataSource.getReceivedInvitations();
      return Right(invitations);
    } catch (e) {
      return Left('Failed to load received invitations: $e');
    }
  }

  @override
  Future<void> acceptInvitation(String invitationId) async {
    try {
      await remoteDataSource.acceptInvitation(invitationId);
    } catch (e) {
      throw Exception('Failed to accept invitation: $e');
    }
  }

  @override
  Future<void> rejectInvitation(String invitationId) async {
    try {
      await remoteDataSource.rejectInvitation(invitationId);
    } catch (e) {
      throw Exception('Failed to reject invitation: $e');
    }
  }

}