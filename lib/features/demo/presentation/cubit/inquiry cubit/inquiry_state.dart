import 'package:project1/features/demo/domain/entities/inquiry_entity.dart';

abstract class InquiryState {}
class InquiryInitial extends InquiryState {}
class InquiryLoading extends InquiryState {}
class InquiryLoaded extends InquiryState {
  final List<InquiryEntity> inquiries;
  InquiryLoaded({required this.inquiries});
}
class InquiryError extends InquiryState {
  final String message;
  InquiryError({required this.message});
}

class InquiryDetailLoaded extends InquiryState {
  final InquiryEntity inquiry;
  InquiryDetailLoaded({required this.inquiry});
}

class InquiryDeleted extends InquiryState {
  final bool success;
  InquiryDeleted({required this.success});
}

class InquiryCreated extends InquiryState {
  final bool success;
  InquiryCreated({required this.success});
}

class InquiryUpdated extends InquiryState {
  final bool success;
  InquiryUpdated({required this.success});
}

class InquiryReplied extends InquiryState {
  final bool success;
  InquiryReplied({required this.success});
}
