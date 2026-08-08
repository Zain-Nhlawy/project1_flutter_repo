import 'package:dartz/dartz.dart';
import 'package:project1/features/demo/domain/entities/inquiry_entity.dart';

abstract class InquiryRepository {
  Future<Either<String, List<InquiryEntity>>> getInquiriesForOwner(String demoId);
  Future<Either<String, List<InquiryEntity>>> getInquiriesForMember(String demoId);
  Future<Either<String, InquiryEntity>> getInquiryById(String inquiryId, String demoId);
  Future<Either<String, bool>> deleteInquiry(String inquiryId, String demoId);
  Future<Either<String, bool>> createInquiry(
    String subject,
    String message,
    String demoId,
  );
  Future<Either<String, bool>> updateInquiry(
    String inquiryId,
    String subject,
    String message,
    String demoId,
  );
  Future<Either<String, bool>> replyForInquiry(
    String inquiryId,
    String message,
    String demoId,
  );
  
}