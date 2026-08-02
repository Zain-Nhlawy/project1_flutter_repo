class MessageSenderEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String? imagePath;

  const MessageSenderEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.imagePath,
  });

  String get fullName => '$firstName $lastName'.trim();
}
