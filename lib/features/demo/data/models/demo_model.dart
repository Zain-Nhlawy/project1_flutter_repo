import 'package:project1/features/demo/domain/entities/demo_entity.dart';

class DemoModel extends DemoEntity {
  DemoModel({
    super.id,
    required super.name,
    required super.description,
    required super.imagePath,
    required super.ownerName,
    required super.isOwner,
    super.plan,
    required super.membersCount,
    super.createdAt,
  });

  factory DemoModel.fromJson(Map<String, dynamic> json) {
    return DemoModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String,
      imagePath: json['imagePath'] as String?,
      ownerName: json['ownerName'] as String, 
      isOwner: json['isOwner'] as bool,
      plan: json['plan'] as String?,
      membersCount: json['membersCount'] as int,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'ownerName': ownerName,
      'isOwner': isOwner,
      'plan': plan,
      'membersCount': membersCount,
    };
  }
}