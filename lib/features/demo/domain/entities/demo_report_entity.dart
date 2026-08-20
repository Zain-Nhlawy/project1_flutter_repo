class DemoOwnerReportEntity {
  final DemoReportOverviewEntity overview;
  final List<DemoReportMemberEntity> members;
  final List<DemoReportCourseEntity> courses;
  final List<DemoReportDepartmentEntity> departments;

  const DemoOwnerReportEntity({
    required this.overview,
    required this.members,
    required this.courses,
    required this.departments,
  });
}

class DemoReportOverviewEntity {
  final DateTime? generatedAt;
  final int totalMembers;
  final int newMembers;
  final int totalDepartments;
  final int totalCourses;
  final int publishedCourses;
  final int totalCertifications;
  final double certificationRate;
  final int totalExamAttempts;
  final double examPassRate;
  final double averageExamScore;

  const DemoReportOverviewEntity({
    this.generatedAt,
    required this.totalMembers,
    required this.newMembers,
    required this.totalDepartments,
    required this.totalCourses,
    required this.publishedCourses,
    required this.totalCertifications,
    required this.certificationRate,
    required this.totalExamAttempts,
    required this.examPassRate,
    required this.averageExamScore,
  });
}

class DemoReportMemberEntity {
  final String memberId;
  final String userId;
  final String fullName;
  final String email;
  final String? imagePath;
  final String demoRole;
  final DateTime? joinedAt;
  final List<String> departments;
  final List<String> departmentRoles;
  final List<String> jobTitles;
  final int assignedCourses;
  final int examAttempts;
  final int examsPassed;
  final int examsFailed;
  final double averageScore;
  final double highestScore;
  final int certificationsEarned;
  final int discussionQuestionsCount;
  final int discussionAnswersCount;
  final int messagesCount;
  final int inquiriesCount;

  const DemoReportMemberEntity({
    required this.memberId,
    required this.userId,
    required this.fullName,
    required this.email,
    this.imagePath,
    required this.demoRole,
    this.joinedAt,
    required this.departments,
    required this.departmentRoles,
    required this.jobTitles,
    required this.assignedCourses,
    required this.examAttempts,
    required this.examsPassed,
    required this.examsFailed,
    required this.averageScore,
    required this.highestScore,
    required this.certificationsEarned,
    required this.discussionQuestionsCount,
    required this.discussionAnswersCount,
    required this.messagesCount,
    required this.inquiriesCount,
  });

  int get engagementCount =>
      discussionQuestionsCount +
      discussionAnswersCount +
      messagesCount +
      inquiriesCount;
}

class DemoReportCourseEntity {
  final String courseId;
  final String courseTitle;
  final bool isPublished;
  final String visibility;
  final int departmentCount;
  final int assignedMemberCount;
  final int sectionCount;
  final int lessonCount;
  final int totalDuration;
  final int examCount;
  final int membersAttempted;
  final int totalAttempts;
  final double averageScore;
  final double passRate;
  final int certificationsIssued;
  final double certificationRate;

  const DemoReportCourseEntity({
    required this.courseId,
    required this.courseTitle,
    required this.isPublished,
    required this.visibility,
    required this.departmentCount,
    required this.assignedMemberCount,
    required this.sectionCount,
    required this.lessonCount,
    required this.totalDuration,
    required this.examCount,
    required this.membersAttempted,
    required this.totalAttempts,
    required this.averageScore,
    required this.passRate,
    required this.certificationsIssued,
    required this.certificationRate,
  });
}

class DemoReportDepartmentEntity {
  final String departmentId;
  final String departmentName;
  final int memberCount;
  final int courseCount;

  const DemoReportDepartmentEntity({
    required this.departmentId,
    required this.departmentName,
    required this.memberCount,
    required this.courseCount,
  });
}
