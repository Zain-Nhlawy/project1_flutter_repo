import 'package:dartz/dartz.dart';
import 'package:project1/features/demo/shared/entities/user_entity.dart';

abstract class DemoUsersRepository {
   Future<Either<String, List<MembersEntity>>> getDemoUsers(String demoId);
  Future<Either<String, List<MembersEntity>>> searchDemoUsers(String query);
}