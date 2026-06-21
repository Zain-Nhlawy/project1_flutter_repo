import 'package:dartz/dartz.dart';
import 'package:project1/features/demo/data/models/demo_model.dart';
import 'package:project1/features/demo/data/repository/demo_repository.dart';
import 'package:project1/features/demo/domain/entities/demo_entity.dart';


class GetDemosUseCase {
  final DemoRepository repository;

  GetDemosUseCase(this.repository);

  Future<Either<String, List<DemoEntity>>> call() async {
    return await repository.getDemos();
  }
  Future<Either<String, void>> addDemo(DemoModel demo) async {
    return await repository.addDemo(demo);
  }
}