import 'package:project1/features/live_stream/domain/entities/live_stream_token_entity.dart';

class LiveStreamTokenModel extends LiveStreamTokenEntity {
  const LiveStreamTokenModel({
    required super.token,
    super.serverUrl,
    super.roomName,
    super.appId,
  });

  factory LiveStreamTokenModel.fromJson(dynamic json) {
    if (json is String) {
      return LiveStreamTokenModel(token: json);
    }

    Map<String, dynamic> map = {};
    if (json is Map) {
      if (json['data'] is Map) {
        map = Map<String, dynamic>.from(json['data']);
      } else if (json['data'] is String) {
        return LiveStreamTokenModel(token: json['data']);
      } else {
        map = Map<String, dynamic>.from(json);
      }
    }

    final token = map['token']?.toString() ??
        map['jwt']?.toString() ??
        json.toString();

    final appId = map['appId']?.toString() ?? map['tenant']?.toString();

    final serverUrl = map['serverUrl']?.toString() ??
        map['serverURL']?.toString() ??
        map['domain']?.toString() ??
        map['jitsiUrl']?.toString() ??
        map['jitsiServer']?.toString() ??
        (appId != null && appId.isNotEmpty ? 'https://8x8.vc' : null);

    final roomName = map['roomName']?.toString() ??
        map['room']?.toString() ??
        map['jitsiRoomName']?.toString();

    return LiveStreamTokenModel(
      token: token,
      serverUrl: serverUrl,
      roomName: roomName,
      appId: appId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      if (serverUrl != null) 'serverUrl': serverUrl,
      if (roomName != null) 'roomName': roomName,
      if (appId != null) 'appId': appId,
    };
  }
}
