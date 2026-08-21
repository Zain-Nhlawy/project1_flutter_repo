class NotificationPayloadEntity {
  final String id;
  final String title;
  final String body;
  final String type;
  final String? screen;
  final Map<String, dynamic> data;
  final DateTime receivedAt;
  final bool isRead;

  const NotificationPayloadEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.screen,
    required this.data,
    required this.receivedAt,
    this.isRead = false,
  });

  String get targetScreen {
    final explicit = screen ??
        data['screen']?.toString() ??
        data['screenName']?.toString() ??
        data['screen_name']?.toString() ??
        data['targetScreen']?.toString() ??
        data['target_screen']?.toString() ??
        data['route']?.toString() ??
        data['page']?.toString();
    if (explicit != null && explicit.trim().isNotEmpty) {
      return explicit.trim();
    }
    return type.trim();
  }

  String? get targetId =>
      data['targetId']?.toString() ??
      data['id']?.toString() ??
      data['demoId']?.toString() ??
      data['orderId']?.toString() ??
      data['courseId']?.toString() ??
      data['departmentId']?.toString() ??
      data['quizId']?.toString() ??
      data['messageId']?.toString();

  String? get demoId =>
      data['demoId']?.toString() ??
      data['targetDemoId']?.toString() ??
      targetId;

  String? get departmentId =>
      data['departmentId']?.toString() ??
      data['targetDepartmentId']?.toString() ??
      targetId;

  String? get courseId =>
      data['courseId']?.toString() ??
      data['targetCourseId']?.toString() ??
      targetId;

  NotificationPayloadEntity copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    String? screen,
    Map<String, dynamic>? data,
    DateTime? receivedAt,
    bool? isRead,
  }) {
    return NotificationPayloadEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      screen: screen ?? this.screen,
      data: data ?? this.data,
      receivedAt: receivedAt ?? this.receivedAt,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationPayloadEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
