import 'package:project1/features/demo/domain/entities/demo_entity.dart';

class DemoModel extends DemoEntity {
  DemoModel({
    super.id,
    required super.name,
    required super.description,
    super.imagePath,
    required super.ownerName,
    required super.isOwner,
    super.plan,
    required super.membersCount,
    super.createdAt,
  });

  factory DemoModel.fromJson(Map<String, dynamic> json) {
    return DemoModel(
      id: json['id']?.toString(),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imagePath: json['imagePath']?.toString(),
      ownerName: json['ownerName']?.toString() ?? '',
      isOwner: json['isOwner'] ?? false,
      plan: json['plan']?.toString(),
      membersCount: json['membersCount'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
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
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}