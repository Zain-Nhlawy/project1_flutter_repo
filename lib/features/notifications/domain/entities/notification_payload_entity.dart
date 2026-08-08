class NotificationPayloadEntity {
  final String title;
  final String body;
  final String type;
  final Map<String, dynamic> data;

  const NotificationPayloadEntity({
    required this.title,
    required this.body,
    required this.type,
    required this.data,
  });

  String? get targetId =>
      data['targetId']?.toString() ??
      data['id']?.toString() ??
      data['orderId']?.toString() ??
      data['courseId']?.toString() ??
      data['departmentId']?.toString() ??
      data['quizId']?.toString() ??
      data['messageId']?.toString();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationPayloadEntity &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          body == other.body &&
          type == other.type;

  @override
  int get hashCode => title.hashCode ^ body.hashCode ^ type.hashCode;
}
