import 'package:project1/features/live_stream/domain/entities/live_stream_entity.dart';
import 'package:project1/features/live_stream/domain/entities/live_stream_token_entity.dart';

abstract class LiveStreamState {}

class LiveStreamInitial extends LiveStreamState {}

class LiveStreamLoading extends LiveStreamState {}

class LiveStreamsLoaded extends LiveStreamState {
  final List<LiveStreamEntity> streams;
  final bool hasMore;
  final String? cursor;

  LiveStreamsLoaded({
    required this.streams,
    this.hasMore = false,
    this.cursor,
  });
}

class LiveStreamTokenLoaded extends LiveStreamState {
  final LiveStreamTokenEntity tokenData;
  final LiveStreamEntity stream;
  final bool isHost;

  LiveStreamTokenLoaded({
    required this.tokenData,
    required this.stream,
    required this.isHost,
  });

  String get token => tokenData.token;
  String? get serverUrl => tokenData.serverUrl;
  String get formattedRoomName => tokenData.formattedRoomName.isNotEmpty
      ? tokenData.formattedRoomName
      : (stream.roomName?.isNotEmpty == true
          ? stream.roomName!
          : 'LiveStream-${stream.id}');
}

class LiveStreamActionSuccess extends LiveStreamState {
  final String message;
  final LiveStreamEntity? stream;

  LiveStreamActionSuccess({required this.message, this.stream});
}

class LiveStreamError extends LiveStreamState {
  final String message;

  LiveStreamError(this.message);
}
