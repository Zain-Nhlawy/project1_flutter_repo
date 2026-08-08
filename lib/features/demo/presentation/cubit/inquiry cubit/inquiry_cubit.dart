import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/demo/domain/repository/inquiry_repository.dart';
import 'package:project1/features/demo/presentation/cubit/inquiry%20cubit/inquiry_state.dart';

class InquiryCubit extends Cubit<InquiryState> {
  final InquiryRepository repository;

  InquiryCubit({required this.repository}) : super(InquiryInitial());

  Future<void> getInquiriesForOwner(String demoId) async {
    emit(InquiryLoading());
    try {
      final result = await repository.getInquiriesForOwner(demoId);
      result.fold(
        (failure) => emit(InquiryError(message: failure)),
        (inquiries) => emit(InquiryLoaded(inquiries: inquiries)),
      );
    } catch (e) {
      emit(InquiryError(message: e.toString()));
    }
  }

  Future<void> getInquiriesForMember(String demoId) async {
    emit(InquiryLoading());
    try {
      final result = await repository.getInquiriesForMember(demoId);
      result.fold(
        (failure) => emit(InquiryError(message: failure)),
        (inquiries) => emit(InquiryLoaded(inquiries: inquiries)),
      );
    } catch (e) {
      emit(InquiryError(message: e.toString()));
    }
  }

  Future<void> getInquiryById(String inquiryId, String demoId) async {
    emit(InquiryLoading());
    try {
      final result = await repository.getInquiryById(inquiryId, demoId);
      result.fold(
        (failure) => emit(InquiryError(message: failure)),
        (inquiry) => emit(InquiryDetailLoaded(inquiry: inquiry)),
      );
    } catch (e) {
      emit(InquiryError(message: e.toString()));
    }
  }

Future<void> deleteInquiry(String inquiryId, String demoId) async {
    emit(InquiryLoading());
    try {
      final result = await repository.deleteInquiry(inquiryId, demoId);
      result.fold(
        (failure) => emit(InquiryError(message: failure)),
        (success) => emit(InquiryDeleted(success: success)),
      );
    } catch (e) {
      emit(InquiryError(message: e.toString()));
    }
  }

  Future<void> createInquiry(String subject, String message, String demoId) async {
    emit(InquiryLoading());
    try {
      final result = await repository.createInquiry(subject, message, demoId);
      result.fold(
        (failure) => emit(InquiryError(message: failure)),
        (success) => emit(InquiryCreated(success: success)),
      );
    } catch (e) {
      emit(InquiryError(message: e.toString()));
    }
  }

  Future<void> updateInquiry(String inquiryId, String subject, String message, String demoId) async {
    emit(InquiryLoading());
    try {
      final result = await repository.updateInquiry(inquiryId, subject, message, demoId);
      result.fold(
        (failure) => emit(InquiryError(message: failure)),
        (success) => emit(InquiryUpdated(success: success)),
      );
    } catch (e) {
      emit(InquiryError(message: e.toString()));
    }
  }

  Future<void> replyForInquiry(String inquiryId, String message, String demoId) async {
    emit(InquiryLoading());
    try {
      final result = await repository.replyForInquiry(inquiryId, message, demoId);
      result.fold(
        (failure) => emit(InquiryError(message: failure)),
        (success) => emit(InquiryReplied(success: success)),
      );
    } catch (e) {
      emit(InquiryError(message: e.toString()));
    }
  }

}