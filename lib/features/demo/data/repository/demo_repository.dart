import 'package:dartz/dartz.dart';
import 'package:project1/features/demo/data/models/demo_model.dart';
import 'package:project1/features/demo/domain/entities/demo_entity.dart';

abstract class DemoRepository {
  Future<Either<String, List<DemoModel>>> getDemos();
  Future<Either<String, void>> addDemo(DemoEntity demo);
}