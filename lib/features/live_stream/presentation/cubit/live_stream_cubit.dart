import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/live_stream/domain/entities/live_stream_entity.dart';
import 'package:project1/features/live_stream/domain/use_cases/create_live_stream_usecase.dart';
import 'package:project1/features/live_stream/domain/use_cases/end_live_stream_usecase.dart';
import 'package:project1/features/live_stream/domain/use_cases/get_live_stream_details_usecase.dart';
import 'package:project1/features/live_stream/domain/use_cases/get_live_stream_token_usecase.dart';
import 'package:project1/features/live_stream/domain/use_cases/get_live_streams_usecase.dart';
import 'package:project1/features/live_stream/domain/use_cases/start_live_stream_usecase.dart';
import 'package:project1/features/live_stream/domain/use_cases/update_live_stream_usecase.dart';
import 'live_stream_state.dart';

class LiveStreamCubit extends Cubit<LiveStreamState> {
  final GetLiveStreamsUseCase getLiveStreamsUseCase;
  final GetLiveStreamDetailsUseCase getLiveStreamDetailsUseCase;
  final CreateLiveStreamUseCase createLiveStreamUseCase;
  final UpdateLiveStreamUseCase updateLiveStreamUseCase;
  final StartLiveStreamUseCase startLiveStreamUseCase;
  final EndLiveStreamUseCase endLiveStreamUseCase;
  final GetLiveStreamTokenUseCase getLiveStreamTokenUseCase;

  List<LiveStreamEntity> _cachedStreams = [];

  LiveStreamCubit({
    required this.getLiveStreamsUseCase,
    required this.getLiveStreamDetailsUseCase,
    required this.createLiveStreamUseCase,
    required this.updateLiveStreamUseCase,
    required this.startLiveStreamUseCase,
    required this.endLiveStreamUseCase,
    required this.getLiveStreamTokenUseCase,
  }) : super(LiveStreamInitial());

  Future<void> fetchLiveStreams(String departmentId, {String? demoId, bool isSilent = false}) async {
    if (!isSilent) {
      emit(LiveStreamLoading());
    }

    final result = await getLiveStreamsUseCase(
      departmentId: departmentId,
      demoId: demoId,
    );

    result.fold(
      (failure) {
        if (!isSilent) {
          emit(LiveStreamError(failure.message));
        }
      },
      (streams) {
        _cachedStreams = streams;
        emit(LiveStreamsLoaded(streams: streams));
      },
    );
  }

  Future<void> createLiveStream({
    required String title,
    required String description,
    required String scheduledAt,
    required String departmentId,
    String? demoId,
  }) async {
    emit(LiveStreamLoading());

    final result = await createLiveStreamUseCase(
      title: title,
      description: description,
      scheduledAt: scheduledAt,
      departmentId: departmentId,
      demoId: demoId,
    );

    result.fold(
      (failure) => emit(LiveStreamError(failure.message)),
      (newStream) {
        _cachedStreams.insert(0, newStream);
        emit(LiveStreamActionSuccess(
          message: 'Live stream created successfully',
          stream: newStream,
        ));
        fetchLiveStreams(departmentId, demoId: demoId, isSilent: true);
      },
    );
  }

  Future<void> updateLiveStream({
    required String id,
    required String departmentId,
    String? demoId,
    String? title,
    String? description,
    String? scheduledAt,
  }) async {
    emit(LiveStreamLoading());

    final result = await updateLiveStreamUseCase(
      id: id,
      departmentId: departmentId,
      demoId: demoId,
      title: title,
      description: description,
      scheduledAt: scheduledAt,
    );

    result.fold(
      (failure) => emit(LiveStreamError(failure.message)),
      (updatedStream) {
        final index = _cachedStreams.indexWhere((s) => s.id == id);
        if (index != -1) {
          _cachedStreams[index] = updatedStream;
        }
        emit(LiveStreamActionSuccess(
          message: 'Live stream updated successfully',
          stream: updatedStream,
        ));
        fetchLiveStreams(departmentId, demoId: demoId, isSilent: true);
      },
    );
  }

  Future<void> startLiveStream({
    required String id,
    required String departmentId,
    String? demoId,
  }) async {
    emit(LiveStreamLoading());

    final result = await startLiveStreamUseCase(
      id,
      departmentId: departmentId,
      demoId: demoId,
    );

    result.fold(
      (failure) => emit(LiveStreamError(failure.message)),
      (startedStream) {
        fetchLiveStreams(departmentId, demoId: demoId, isSilent: true);
      },
    );
  }

  Future<void> endLiveStream({
    required String id,
    required String departmentId,
    String? demoId,
  }) async {
    emit(LiveStreamLoading());

    final result = await endLiveStreamUseCase(
      id,
      departmentId: departmentId,
      demoId: demoId,
    );

    result.fold(
      (failure) => emit(LiveStreamError(failure.message)),
      (endedStream) {
        emit(LiveStreamActionSuccess(
          message: 'Live stream ended',
          stream: endedStream,
        ));
        fetchLiveStreams(departmentId, demoId: demoId, isSilent: true);
      },
    );
  }

  Future<void> joinOrStartMeeting({
    required LiveStreamEntity stream,
    required bool isHost,
    required String departmentId,
    String? demoId,
  }) async {
    emit(LiveStreamLoading());

    if (isHost && !stream.isLive) {
      final startRes = await startLiveStreamUseCase(
        stream.id,
        departmentId: departmentId,
        demoId: demoId,
      );
      startRes.fold(
        (failure) {},
        (startedStream) {
          stream = startedStream;
        },
      );
    }

    final tokenRes = await getLiveStreamTokenUseCase(
      stream.id,
      departmentId: departmentId,
      demoId: demoId,
    );

    tokenRes.fold(
      (failure) => emit(LiveStreamError(failure.message)),
      (tokenData) {
        emit(LiveStreamTokenLoaded(
          tokenData: tokenData,
          stream: stream,
          isHost: isHost,
        ));
      },
    );
  }
}
