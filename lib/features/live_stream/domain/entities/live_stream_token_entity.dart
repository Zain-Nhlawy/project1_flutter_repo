class LiveStreamTokenEntity {
  final String token;
  final String? serverUrl;
  final String? roomName;
  final String? appId;

  const LiveStreamTokenEntity({
    required this.token,
    this.serverUrl,
    this.roomName,
    this.appId,
  });

  /// Returns the correctly formatted Jitsi / 8x8 JaaS room name
  String get formattedRoomName {
    if (roomName == null || roomName!.isEmpty) return '';
    if (appId != null && appId!.isNotEmpty && !roomName!.startsWith('$appId/')) {
      return '$appId/$roomName';
    }
    return roomName!;
  }
}
