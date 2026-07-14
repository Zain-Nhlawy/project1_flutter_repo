import 'package:dartz/dartz.dart';
import 'package:project1/features/demo/shared/entities/user_entity.dart';
import 'package:project1/features/demo/domain/repository/demo_users_repository.dart';

class DemoUsersUsecase {
  final DemoUsersRepository repository;
  DemoUsersUsecase({required this.repository});

  Future<Either<String, List<MembersEntity>>> call(String demoId) async {
    return await repository.getDemoUsers(demoId);
  }

Future<Either<String, List<MembersEntity>>> search(String query) async {
    return await repository.searchDemoUsers(query);
  }

  Future<Either<String, bool>> removeUserFromDemo(String demoId, String userId) async {
    return await repository.removeUserFromDemo(demoId, userId);
  }
}
