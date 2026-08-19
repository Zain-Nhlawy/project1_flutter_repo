import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/auth/presentation/cubit/user_cubit.dart';
import 'package:project1/features/auth/presentation/cubit/user_state.dart';
import 'package:project1/features/live_stream/domain/entities/live_stream_entity.dart';
import 'package:project1/features/live_stream/presentation/cubit/live_stream_cubit.dart';
import 'package:project1/features/live_stream/presentation/cubit/live_stream_state.dart';
import 'package:project1/features/live_stream/presentation/pages/create_live_stream_screen.dart';
import 'package:project1/features/live_stream/presentation/pages/edit_live_stream_screen.dart';
import 'package:project1/features/live_stream/presentation/services/jitsi_meeting_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project1/features/live_stream/presentation/widgets/live_stream_card.dart';
import 'package:project1/l10n/app_localizations.dart';

class LiveStreamsPage extends StatelessWidget {
  final String departmentId;
  final String? demoId;
  final bool canManage;

  const LiveStreamsPage({
    super.key,
    required this.departmentId,
    this.demoId,
    this.canManage = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LiveStreamCubit>()..fetchLiveStreams(departmentId, demoId: demoId),
      child: _LiveStreamsPageView(
        departmentId: departmentId,
        demoId: demoId,
        canManage: canManage,
      ),
    );
  }
}

class _LiveStreamsPageView extends StatefulWidget {
  final String departmentId;
  final String? demoId;
  final bool canManage;

  const _LiveStreamsPageView({
    required this.departmentId,
    this.demoId,
    required this.canManage,
  });

  @override
  State<_LiveStreamsPageView> createState() => _LiveStreamsPageViewState();
}

class _LiveStreamsPageViewState extends State<_LiveStreamsPageView> {
  final JitsiMeetingService _jitsiService = JitsiMeetingService();

  Future<void> _launchJitsi({
    required String token,
    String? serverUrl,
    String? tokenRoomName,
    required LiveStreamEntity stream,
    required bool isHost,
  }) async {
    final userState = context.read<UserCubit>().state;
    final currentUser = userState is UserLoaded ? userState.user : null;
    final userName = currentUser != null && (currentUser.firstName.isNotEmpty || currentUser.lastName.isNotEmpty)
        ? '${currentUser.firstName} ${currentUser.lastName}'.trim()
        : (isHost ? 'Host' : 'Viewer');
    final userEmail = currentUser?.email;
    final userAvatar = currentUser?.imagePath;

    try {
      await [
        Permission.camera,
        Permission.microphone,
      ].request();
    } catch (_) {}

    if (!mounted) return;

    final roomName = (tokenRoomName != null && tokenRoomName.isNotEmpty)
        ? tokenRoomName
        : (stream.roomName?.isNotEmpty == true
            ? stream.roomName!
            : 'LiveStream-${stream.id}');

    await _jitsiService.joinMeeting(
      roomName: roomName,
      token: token,
      serverUrl: serverUrl,
      displayName: userName,
      email: userEmail,
      avatarUrl: userAvatar,
      subject: stream.title,
      isHost: isHost,
      eventListener: JitsiMeetEventListener(
        conferenceTerminated: (url, error) {
          if (isHost && mounted) {
            context.read<LiveStreamCubit>().endLiveStream(
                  id: stream.id,
                  departmentId: widget.departmentId,
                  demoId: widget.demoId,
                );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: widget.canManage
          ? Container(
              decoration: BoxDecoration(
                gradient: AppColors.headerGradientOf(context),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryOf(context).withValues(alpha: 0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    final cubit = context.read<LiveStreamCubit>();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: cubit,
                          child: CreateLiveStreamScreen(
                            departmentId: widget.departmentId,
                            demoId: widget.demoId,
                          ),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add_rounded, color: Colors.white, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          localizations.createLiveStream,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : null,
      body: BlocConsumer<LiveStreamCubit, LiveStreamState>(
        listener: (context, state) {
          if (state is LiveStreamTokenLoaded) {
            _launchJitsi(
              token: state.token,
              serverUrl: state.serverUrl,
              tokenRoomName: state.formattedRoomName,
              stream: state.stream,
              isHost: state.isHost,
            );
          } else if (state is LiveStreamError) {
            SnackbarTheme().newSnackBarError(context, state.message);
          } else if (state is LiveStreamActionSuccess) {
            SnackbarTheme().newSnackBarSuccess(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is LiveStreamLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is LiveStreamsLoaded) {
            if (state.streams.isEmpty) {
              return RefreshIndicator(
                onRefresh: () => context
                    .read<LiveStreamCubit>()
                    .fetchLiveStreams(widget.departmentId, demoId: widget.demoId),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: MediaQuery.sizeOf(context).height * 0.6,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.live_tv_rounded,
                          size: 64,
                          color: AppColors.textSecondaryOf(context).withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          localizations.noLiveStreamsFound,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.textSecondaryOf(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context
                  .read<LiveStreamCubit>()
                  .fetchLiveStreams(widget.departmentId, demoId: widget.demoId),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.streams.length,
                itemBuilder: (context, index) {
                  final stream = state.streams[index];
                  return LiveStreamCard(
                    stream: stream,
                    canManage: widget.canManage,
                    onJoin: () {
                      context.read<LiveStreamCubit>().joinOrStartMeeting(
                            stream: stream,
                            isHost: widget.canManage,
                            departmentId: widget.departmentId,
                            demoId: widget.demoId,
                          );
                    },
                    onStart: widget.canManage
                        ? () {
                            context.read<LiveStreamCubit>().joinOrStartMeeting(
                                  stream: stream,
                                  isHost: true,
                                  departmentId: widget.departmentId,
                                  demoId: widget.demoId,
                                );
                          }
                        : null,
                    onEnd: widget.canManage
                        ? () {
                            context.read<LiveStreamCubit>().endLiveStream(
                                  id: stream.id,
                                  departmentId: widget.departmentId,
                                  demoId: widget.demoId,
                                );
                          }
                        : null,
                    onEdit: widget.canManage
                        ? () {
                            final cubit = context.read<LiveStreamCubit>();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: cubit,
                                  child: EditLiveStreamScreen(
                                    stream: stream,
                                    departmentId: widget.departmentId,
                                    demoId: widget.demoId,
                                  ),
                                ),
                              ),
                            );
                          }
                        : null,
                  );
                },
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context
                .read<LiveStreamCubit>()
                .fetchLiveStreams(widget.departmentId, demoId: widget.demoId),
            child: const SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: SizedBox(height: 300),
            ),
          );
        },
      ),
    );
  }
}
