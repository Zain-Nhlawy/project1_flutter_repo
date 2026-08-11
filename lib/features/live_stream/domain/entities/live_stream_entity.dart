class LiveStreamEntity {
  final String id;
  final String title;
  final String description;
  final DateTime? scheduledAt;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final String status;
  final String departmentId;
  final String? hostId;
  final String? roomName;
  final DateTime? createdAt;

  const LiveStreamEntity({
    required this.id,
    required this.title,
    required this.description,
    this.scheduledAt,
    this.startedAt,
    this.endedAt,
    this.status = 'SCHEDULED',
    required this.departmentId,
    this.hostId,
    this.roomName,
    this.createdAt,
  });

  bool get isLive => status.toUpperCase() == 'LIVE';
  bool get isEnded => status.toUpperCase() == 'ENDED';
  bool get isScheduled => status.toUpperCase() == 'SCHEDULED';
}
