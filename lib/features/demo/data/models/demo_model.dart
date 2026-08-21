import 'package:project1/features/demo/domain/entities/demo_entity.dart';

class DemoModel extends DemoEntity {
  DemoModel({
    super.id,
    required super.name,
    required super.description,
    super.imagePath,
    super.signatureImagePath,
    required super.ownerName,
    required super.isOwner,
    super.plan,
    required super.membersCount,
    super.createdAt,
    super.subscriptionStatus,
  });

  factory DemoModel.fromJson(Map<String, dynamic> json) {
    int parsedMembersCount = 0;
    if (json['membersCount'] is int) {
      parsedMembersCount = json['membersCount'] as int;
    } else if (json['membersCount'] != null) {
      parsedMembersCount = int.tryParse(json['membersCount'].toString()) ?? 0;
    }

    final rawIsOwner = json['isOwner'];
    final bool parsedIsOwner = rawIsOwner == true ||
        rawIsOwner == 'true' ||
        rawIsOwner == 1 ||
        rawIsOwner == '1';

    return DemoModel(
      id: json['id']?.toString(),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imagePath: json['imagePath']?.toString(),
      signatureImagePath: json['signatureImagePath']?.toString(),
      ownerName: json['ownerName']?.toString() ?? '',
      isOwner: parsedIsOwner,
      plan: json['plan']?.toString(),
      membersCount: parsedMembersCount,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      subscriptionStatus: json['subscriptionStatus']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imagePath': imagePath,
      'signatureImagePath': signatureImagePath,
      'ownerName': ownerName,
      'isOwner': isOwner,
      'plan': plan,
      'membersCount': membersCount,
      'createdAt': createdAt?.toIso8601String(),
      'subscriptionStatus': subscriptionStatus,
    };
  }
}
