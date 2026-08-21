import 'package:dartz/dartz.dart';
import 'package:project1/features/demo/domain/entities/demo_report_entity.dart';
import 'package:project1/features/demo/domain/repository/demo_report_repository.dart';

class GetDemoOwnerReportUseCase {
  final DemoReportRepository repository;

  GetDemoOwnerReportUseCase(this.repository);

  Future<Either<String, DemoOwnerReportEntity>> call(String demoId) {
    return repository.getOwnerReport(demoId);
  }
}
