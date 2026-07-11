import 'package:dartz/dartz.dart';
import 'package:project1/core/shared/entities/user_entity.dart';
import 'package:project1/features/demo/domain/repository/demo_users_repository.dart';

class DemoUsersUsecase {
  final DemoUsersRepository repository;
  DemoUsersUsecase({required this.repository});

  Future<Either<String, List<MembersEntity>>> call(String demoId) async {
    return await repository.getDemoUsers(demoId);
  }


}
