import 'package:project1/features/department/domain/entities/leaderboard_member_entity.dart';

class LeaderboardMemberModel extends LeaderboardMemberEntity {
  const LeaderboardMemberModel({
    required super.rank,
    required super.userId,
    required super.departmentMemberId,
    required super.firstName,
    required super.lastName,
    super.imagePath,
    required super.jobTitle,
    required super.totalScore,
  });

  factory LeaderboardMemberModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardMemberModel(
      rank: json['rank'] is int
          ? json['rank'] as int
          : int.tryParse(json['rank']?.toString() ?? '0') ?? 0,
      userId: json['userId'] as String? ?? '',
      departmentMemberId: json['departmentMemberId'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      imagePath: json['imagePath']?.toString(),
      jobTitle: json['jobTitle'] as String? ?? '',
      totalScore: json['totalScore'] is int
          ? json['totalScore'] as int
          : int.tryParse(json['totalScore']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'userId': userId,
      'departmentMemberId': departmentMemberId,
      'firstName': firstName,
      'lastName': lastName,
      'imagePath': imagePath,
      'jobTitle': jobTitle,
      'totalScore': totalScore,
    };
  }
}
