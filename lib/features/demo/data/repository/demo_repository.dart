import 'package:dartz/dartz.dart';
import 'package:project1/features/demo/data/models/demo_model.dart';

abstract class DemoRepository {
  Future<Either<String, List<DemoModel>>> getDemos();
}