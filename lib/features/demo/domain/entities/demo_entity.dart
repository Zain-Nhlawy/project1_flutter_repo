class DemoEntity {
  final String? id;
  final String name;
  final String description;
  final String? imagePath;
  final String? signatureImagePath;
  final String ownerName;
  final bool isOwner;
  final String? plan;
  final int membersCount;
  final DateTime? createdAt;

  DemoEntity({
    this.id,
    this.name = '',
    this.description = '',
    this.imagePath,
    this.signatureImagePath,
    this.ownerName = '',
    this.isOwner = false,
    this.plan,
    this.membersCount = 0,
    this.createdAt,
  });

}
