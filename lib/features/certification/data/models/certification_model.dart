import 'package:project1/features/certification/domain/entities/certification_entity.dart';

class CertificationModel extends CertificationEntity {
  const CertificationModel({
    required super.id,
    required super.courseId,
    required super.score,
    required super.demoName,
    required super.userName,
    required super.logoImagePath,
    required super.courseName,
    required super.signature,
    required super.issuedAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CertificationModel.fromJson(Map<String, dynamic> json) {
    return CertificationModel(
      id: json['id'] as String? ?? '',
      courseId: json['courseId'] as String? ?? '',
      score: (json['score'] as num?)?.toInt() ?? 0,
      demoName: json['demoName'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      logoImagePath: json['logoImagePath'] as String? ?? '',
      courseName: json['courseName'] as String? ?? '',
      signature: json['signature'] as String? ?? '',
      issuedAt: DateTime.tryParse(json['issuedAt'] as String? ?? '') ??
          DateTime.now(),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

class PaginatedCertifications {
  final List<CertificationModel> items;
  final bool hasNextPage;
  final String? endCursor;

  const PaginatedCertifications({
    required this.items,
    required this.hasNextPage,
    this.endCursor,
  });

  factory PaginatedCertifications.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List<dynamic>? ?? [];
    final meta = json['meta'] as Map<String, dynamic>?;

    return PaginatedCertifications(
      items: data
          .map((e) => CertificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasNextPage: meta?['hasNextPage'] as bool? ?? false,
      endCursor: meta?['endCursor'] as String?,
    );
  }
}