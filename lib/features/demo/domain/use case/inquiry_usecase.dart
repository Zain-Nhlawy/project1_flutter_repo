import 'package:dartz/dartz.dart';
import 'package:project1/features/demo/domain/entities/inquiry_entity.dart';
import 'package:project1/features/demo/domain/repository/inquiry_repository.dart';

class InquiryUseCase {

  final InquiryRepository inquiryRepository;

  InquiryUseCase({required this.inquiryRepository});

  Future<Either<String, List<InquiryEntity>>> getInquiriesForOwner(
    String demoId,
  ) async {
    return await inquiryRepository.getInquiriesForOwner(demoId);
  }

Future<Either<String, List<InquiryEntity>>> getInquiriesForMember(
    String demoId,
  ) async {
    return await inquiryRepository.getInquiriesForMember(demoId);
  }

  Future<Either<String, InquiryEntity>> getInquiryById(
    String inquiryId,
    String demoId,
  ) async {
    return await inquiryRepository.getInquiryById(inquiryId, demoId);
  }

  Future<Either<String, bool>> deleteInquiry(
    String inquiryId,
    String demoId,
  ) async {
    return await inquiryRepository.deleteInquiry(inquiryId, demoId);
  }

  Future<Either<String, bool>> createInquiry(
    String subject,
    String message,
    String demoId,
  ) async {
    return await inquiryRepository.createInquiry(subject, message, demoId);
  }

  Future<Either<String, bool>> updateInquiry(
    String inquiryId,
    String subject,
    String message,
    String demoId,
  ) async {
    return await inquiryRepository.updateInquiry(inquiryId, subject, message, demoId);
  }

  Future<Either<String, bool>> replyForInquiry(
    String inquiryId,
    String message,
    String demoId,
  ) async {
    return await inquiryRepository.replyForInquiry(inquiryId, message, demoId);
  }


}
