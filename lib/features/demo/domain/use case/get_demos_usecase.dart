import 'package:dartz/dartz.dart';
import 'package:project1/features/demo/data/repository/demo_repository.dart';
import 'package:project1/features/demo/domain/entities/demo_entity.dart';


class GetDemosUseCase {
  final DemoRepository repository;

  GetDemosUseCase(this.repository);

  // استخدام دالة call يجعل الكلاس يتصرف كأنه دالة قابلة للاستدعاء مباشرة
  Future<Either<String, List<DemoEntity>>> call() async {
    return await repository.getDemos();
  }
}