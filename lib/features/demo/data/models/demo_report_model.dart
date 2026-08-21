import 'package:project1/features/demo/domain/entities/demo_report_entity.dart';

class DemoOwnerReportModel extends DemoOwnerReportEntity {
  const DemoOwnerReportModel({
    required super.overview,
    required super.members,
    required super.courses,
    required super.departments,
  });

  factory DemoOwnerReportModel.fromJson(Map<String, dynamic> json) {
    return DemoOwnerReportModel(
      overview: DemoReportOverviewModel.fromJson(_asMap(json['overview'])),
      members: _asList(
        json['members'],
      ).map((item) => DemoReportMemberModel.fromJson(_asMap(item))).toList(),
      courses: _asList(
        json['courses'],
      ).map((item) => DemoReportCourseModel.fromJson(_asMap(item))).toList(),
      departments: _asList(json['departments'])
          .map((item) => DemoReportDepartmentModel.fromJson(_asMap(item)))
          .toList(),
    );
  }
}

class DemoReportOverviewModel extends DemoReportOverviewEntity {
  const DemoReportOverviewModel({
    super.generatedAt,
    required super.totalMembers,
    required super.newMembers,
    required super.totalDepartments,
    required super.totalCourses,
    required super.publishedCourses,
    required super.totalCertifications,
    required super.certificationRate,
    required super.totalExamAttempts,
    required super.examPassRate,
    required super.averageExamScore,
  });

  factory DemoReportOverviewModel.fromJson(Map<String, dynamic> json) {
    return DemoReportOverviewModel(
      generatedAt: DateTime.tryParse(_asString(json['generatedAt'])),
      totalMembers: _asInt(json['totalMembers']),
      newMembers: _asInt(json['newMembers']),
      totalDepartments: _asInt(json['totalDepartments']),
      totalCourses: _asInt(json['totalCourses']),
      publishedCourses: _asInt(json['publishedCourses']),
      totalCertifications: _asInt(json['totalCertifications']),
      certificationRate: _asDouble(json['certificationRate']),
      totalExamAttempts: _asInt(json['totalExamAttempts']),
      examPassRate: _asDouble(json['examPassRate']),
      averageExamScore: _asDouble(json['averageExamScore']),
    );
  }
}

class DemoReportMemberModel extends DemoReportMemberEntity {
  const DemoReportMemberModel({
    required super.memberId,
    required super.userId,
    required super.fullName,
    required super.email,
    super.imagePath,
    required super.demoRole,
    super.joinedAt,
    required super.departments,
    required super.departmentRoles,
    required super.jobTitles,
    required super.assignedCourses,
    required super.examAttempts,
    required super.examsPassed,
    required super.examsFailed,
    required super.averageScore,
    required super.highestScore,
    required super.certificationsEarned,
    required super.discussionQuestionsCount,
    required super.discussionAnswersCount,
    required super.messagesCount,
    required super.inquiriesCount,
  });

  factory DemoReportMemberModel.fromJson(Map<String, dynamic> json) {
    return DemoReportMemberModel(
      memberId: _asString(json['memberId']),
      userId: _asString(json['userId']),
      fullName: _asString(json['fullName']),
      email: _asString(json['email']),
      imagePath: _nullableString(json['imagePath']),
      demoRole: _asString(json['demoRole']),
      joinedAt: DateTime.tryParse(_asString(json['joinedAt'])),
      departments: _asStringList(json['departments']),
      departmentRoles: _asStringList(json['departmentRoles']),
      jobTitles: _asStringList(json['jobTitle']),
      assignedCourses: _asInt(json['assignedCourses']),
      examAttempts: _asInt(json['examAttempts']),
      examsPassed: _asInt(json['examsPassed']),
      examsFailed: _asInt(json['examsFailed']),
      averageScore: _asDouble(json['averageScore']),
      highestScore: _asDouble(json['highestScore']),
      certificationsEarned: _asInt(json['certificationsEarned']),
      discussionQuestionsCount: _asInt(json['discussionQuestionsCount']),
      discussionAnswersCount: _asInt(json['discussionAnswersCount']),
      messagesCount: _asInt(json['messagesCount']),
      inquiriesCount: _asInt(json['inquiriesCount']),
    );
  }
}

class DemoReportCourseModel extends DemoReportCourseEntity {
  const DemoReportCourseModel({
    required super.courseId,
    required super.courseTitle,
    required super.isPublished,
    required super.visibility,
    required super.departmentCount,
    required super.assignedMemberCount,
    required super.sectionCount,
    required super.lessonCount,
    required super.totalDuration,
    required super.examCount,
    required super.membersAttempted,
    required super.totalAttempts,
    required super.averageScore,
    required super.passRate,
    required super.certificationsIssued,
    required super.certificationRate,
  });

  factory DemoReportCourseModel.fromJson(Map<String, dynamic> json) {
    return DemoReportCourseModel(
      courseId: _asString(json['courseId']),
      courseTitle: _asString(json['courseTitle']),
      isPublished: _asBool(json['isPublished']),
      visibility: _asString(json['visibility']),
      departmentCount: _asInt(json['departmentCount']),
      assignedMemberCount: _asInt(json['assignedMemberCount']),
      sectionCount: _asInt(json['sectionCount']),
      lessonCount: _asInt(json['lessonCount']),
      totalDuration: _asInt(json['totalDuration']),
      examCount: _asInt(json['examCount']),
      membersAttempted: _asInt(json['membersAttempted']),
      totalAttempts: _asInt(json['totalAttempts']),
      averageScore: _asDouble(json['averageScore']),
      passRate: _asDouble(json['passRate']),
      certificationsIssued: _asInt(json['certificationsIssued']),
      certificationRate: _asDouble(json['certificationRate']),
    );
  }
}

class DemoReportDepartmentModel extends DemoReportDepartmentEntity {
  const DemoReportDepartmentModel({
    required super.departmentId,
    required super.departmentName,
    required super.memberCount,
    required super.courseCount,
  });

  factory DemoReportDepartmentModel.fromJson(Map<String, dynamic> json) {
    return DemoReportDepartmentModel(
      departmentId: _asString(json['departmentId'] ?? json['id']),
      departmentName: _asString(
        json['departmentName'] ?? json['name'] ?? json['title'],
      ),
      memberCount: _asInt(
        json['memberCount'] ??
            json['membersCount'] ??
            json['assignedMemberCount'],
      ),
      courseCount: _asInt(json['courseCount'] ?? json['coursesCount']),
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, item) => MapEntry(key.toString(), item));
  }
  return const {};
}

List<dynamic> _asList(dynamic value) => value is List ? value : const [];

String _asString(dynamic value) => value?.toString() ?? '';

String? _nullableString(dynamic value) {
  final result = _asString(value).trim();
  return result.isEmpty ? null : result;
}

int _asInt(dynamic value) {
  if (value is num) return value.toInt();
  return int.tryParse(_asString(value)) ?? 0;
}

double _asDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(_asString(value)) ?? 0;
}

bool _asBool(dynamic value) {
  if (value is bool) return value;
  return _asString(value).toLowerCase() == 'true';
}

List<String> _asStringList(dynamic value) {
  return _asList(value)
      .map((item) {
        if (item is Map) {
          return _asString(
            item['name'] ?? item['title'] ?? item['role'] ?? item['jobTitle'],
          );
        }
        return _asString(item);
      })
      .where((item) => item.trim().isNotEmpty)
      .toList();
}
