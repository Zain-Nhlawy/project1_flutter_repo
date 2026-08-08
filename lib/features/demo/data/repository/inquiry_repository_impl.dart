import 'package:dartz/dartz.dart';
import 'package:project1/features/demo/data/data_sources/inquery_data_source.dart';
import 'package:project1/features/demo/domain/entities/inquiry_entity.dart';
import 'package:project1/features/demo/domain/repository/inquiry_repository.dart';

class InquiryRepositoryImpl implements InquiryRepository {
  final InquiryDataSource inquiryDataSource;

  InquiryRepositoryImpl({required this.inquiryDataSource});

  @override
  Future<Either<String, List<InquiryEntity>>> getInquiriesForOwner(String demoId) async {
    try {
      final inquiries = await inquiryDataSource.getInquiriesForOwner(demoId);
      return Right(inquiries);
    } catch (e) {
      return Left(e.toString());
    }
  }
  @override
  Future<Either<String, List<InquiryEntity>>> getInquiriesForMember(String demoId) async {
    try {
      final inquiries = await inquiryDataSource.getInquiriesForMember(demoId);
      return Right(inquiries);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, InquiryEntity>> getInquiryById(String inquiryId, String demoId) async {
    try {
      final inquiry = await inquiryDataSource.getInquiryById(inquiryId, demoId);
      return Right(inquiry);
    } catch (e) {
      return Left(e.toString());
    }
  }

@override
  Future<Either<String, bool>> deleteInquiry(String inquiryId, String demoId) async {
    try {
      final result = await inquiryDataSource.deleteInquiry(inquiryId, demoId);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> createInquiry(
    String subject,
    String message,
    String demoId,
  ) async {
    try {
      final result = await inquiryDataSource.createInquiry(subject, message, demoId);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> updateInquiry(
    String inquiryId,
    String subject,
    String message,
    String demoId,
  ) async {
    try {
      final result = await inquiryDataSource.updateInquiry(inquiryId, subject, message, demoId);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> replyForInquiry(
    String inquiryId,
    String message,
    String demoId,
  ) async {
    try {
      final result = await inquiryDataSource.replyForInquiry(inquiryId, message, demoId);
      return Right(result);
    } catch (e) {
      return Left(e.toString());
    }
  }

}