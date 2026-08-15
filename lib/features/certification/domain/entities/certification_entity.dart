class CertificationEntity {
  final String id;
  final String courseId;
  final int score;
  final String demoName;
  final String userName;
  final String logoImagePath;
  final String courseName;
  final String signature;
  final DateTime issuedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CertificationEntity({
    required this.id,
    required this.courseId,
    required this.score,
    required this.demoName,
    required this.userName,
    required this.logoImagePath,
    required this.courseName,
    required this.signature,
    required this.issuedAt,
    required this.createdAt,
    required this.updatedAt,
  });
}