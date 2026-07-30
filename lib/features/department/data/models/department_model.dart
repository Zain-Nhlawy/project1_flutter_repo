import 'package:project1/features/department/domain/entities/department_entity.dart';

class DepartmentModel extends DepartmentEntity {
  DepartmentModel({
    super.id,
    required super.name,
    required super.managerId,
    required super.description,
    super.memberCount,
    super.isJoined,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      managerId: json['managerId'] as String,
      description: json['description'] as String,
      memberCount: json['membersCount'] as int,
      isJoined: json['isJoind'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'managerId': managerId,
      'description': description,
    };
  }
}
