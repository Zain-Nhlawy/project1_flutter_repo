import 'package:project1/features/live_stream/domain/entities/live_stream_entity.dart';

class LiveStreamModel extends LiveStreamEntity {
  const LiveStreamModel({
    required super.id,
    required super.title,
    required super.description,
    super.scheduledAt,
    super.startedAt,
    super.endedAt,
    super.status,
    required super.departmentId,
    super.hostId,
    super.roomName,
    super.createdAt,
  });

  factory LiveStreamModel.fromJson(Map<String, dynamic> json) {
    return LiveStreamModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      scheduledAt: json['scheduledAt'] != null
          ? DateTime.tryParse(json['scheduledAt'].toString())
          : null,
      startedAt: json['startedAt'] != null
          ? DateTime.tryParse(json['startedAt'].toString())
          : null,
      endedAt: json['endedAt'] != null
          ? DateTime.tryParse(json['endedAt'].toString())
          : null,
      status: json['status']?.toString() ?? 'SCHEDULED',
      departmentId: json['departmentId']?.toString() ?? '',
      hostId: json['hostId']?.toString(),
      roomName: json['roomName']?.toString() ?? json['jitsiRoomName']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      if (scheduledAt != null) 'scheduledAt': scheduledAt!.toIso8601String(),
      if (startedAt != null) 'startedAt': startedAt!.toIso8601String(),
      if (endedAt != null) 'endedAt': endedAt!.toIso8601String(),
      'status': status,
      'departmentId': departmentId,
      if (hostId != null) 'hostId': hostId,
      if (roomName != null) 'roomName': roomName,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }
}
