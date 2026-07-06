class DemoEntity {
  final String? id;
  final String name;
  final String description;
  final String? imagePath;
  final String ownerName;
  final bool isOwner;
  final String? plan;
  final int membersCount;
  final DateTime? createdAt;
  
  DemoEntity({
    this.id,
    required this.name,
    required this.description,
    this.imagePath,
    required this.ownerName,
    required this.isOwner,
    this.plan,
    required this.membersCount,
    this.createdAt,
  });
}
