import 'package:dartz/dartz.dart';
import 'package:project1/features/demo/domain/entities/demo_report_entity.dart';

abstract class DemoReportRepository {
  Future<Either<String, DemoOwnerReportEntity>> getOwnerReport(String demoId);
}
