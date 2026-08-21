import 'package:project1/features/demo/domain/entities/demo_report_entity.dart';

abstract class DemoReportState {
  const DemoReportState();
}

class DemoReportInitial extends DemoReportState {
  const DemoReportInitial();
}

class DemoReportLoading extends DemoReportState {
  const DemoReportLoading();
}

class DemoReportLoaded extends DemoReportState {
  final DemoOwnerReportEntity report;

  const DemoReportLoaded(this.report);
}

class DemoReportError extends DemoReportState {
  final String message;

  const DemoReportError(this.message);
}
