class LeaderboardMemberEntity {
  final int rank;
  final String userId;
  final String departmentMemberId;
  final String firstName;
  final String lastName;
  final String? imagePath;
  final String jobTitle;
  final int totalScore;

  const LeaderboardMemberEntity({
    required this.rank,
    required this.userId,
    required this.departmentMemberId,
    required this.firstName,
    required this.lastName,
    this.imagePath,
    required this.jobTitle,
    required this.totalScore,
  });

  String get fullName => '$firstName $lastName'.trim();
}
