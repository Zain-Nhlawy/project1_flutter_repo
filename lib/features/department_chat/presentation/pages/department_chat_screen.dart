import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/core/dummy/dummy_entities.dart';
import 'package:project1/core/presentation/widgets/app_skeletonizer.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/auth/presentation/cubit/user_cubit.dart';
import 'package:project1/features/auth/presentation/cubit/user_state.dart';
import 'package:project1/features/department/domain/entities/department_member_entity.dart';
import 'package:project1/l10n/app_localizations.dart';
import '../cubit/department_chat_cubit.dart';
import '../cubit/department_chat_state.dart';
import '../../domain/entities/department_member_presence.dart';
import '../../domain/entities/department_message_entity.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/connection_status_banner.dart';
import '../widgets/typing_indicator_widget.dart';

class DepartmentChatScreen extends StatelessWidget {
  final String departmentId;
  final String demoId;
  final ValueChanged<List<DepartmentMemberEntity>>? onOnlineMembersChanged;

  const DepartmentChatScreen({
    super.key,
    required this.departmentId,
    required this.demoId,
    this.onOnlineMembersChanged,
  });

  @override
  Widget build(BuildContext context) {
    String? currentUserId;
    final userState = context.watch<UserCubit>().state;
    if (userState is UserLoaded) {
      currentUserId = userState.user.id;
    } else if (userState is UserInitial) {
      context.read<UserCubit>().getMe();
    }

    return BlocProvider<DepartmentChatCubit>(
      create: (context) => sl<DepartmentChatCubit>()
        ..init(
          departmentId: departmentId,
          demoId: demoId,
          currentUserId: currentUserId,
        ),
      child: _DepartmentChatView(
        currentUserId: currentUserId,
        onOnlineMembersChanged: onOnlineMembersChanged,
      ),
    );
  }
}

class _DepartmentChatView extends StatefulWidget {
  final String? currentUserId;
  final ValueChanged<List<DepartmentMemberEntity>>? onOnlineMembersChanged;

  const _DepartmentChatView({this.currentUserId, this.onOnlineMembersChanged});

  @override
  State<_DepartmentChatView> createState() => _DepartmentChatViewState();
}

class _DepartmentChatViewState extends State<_DepartmentChatView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _publishOnlineMembers(context.read<DepartmentChatCubit>().state);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        context.read<DepartmentChatCubit>().loadOlderMessages();
      }
    }
  }

  List<DepartmentMemberEntity> _onlineMembers(DepartmentChatState state) {
    final members = state.departmentMembers
        .where(
          (member) =>
              DepartmentMemberPresence.isOnline(member, state.onlineMembers),
        )
        .toList();
    members.sort((first, second) {
      final currentMemberId = state.currentDepartmentMemberId;
      if (first.id == currentMemberId) return -1;
      if (second.id == currentMemberId) return 1;
      final firstName = '${first.firstName} ${first.lastName}'.trim();
      final secondName = '${second.firstName} ${second.lastName}'.trim();
      return firstName.toLowerCase().compareTo(secondName.toLowerCase());
    });
    return members;
  }

  void _publishOnlineMembers(DepartmentChatState state) {
    widget.onOnlineMembersChanged?.call(_onlineMembers(state));
  }

  bool _isSenderOnline(String senderId, DepartmentChatState state) {
    if (state.onlineMembers.contains(senderId)) return true;

    for (final member in state.departmentMembers) {
      final isSender =
          member.id == senderId ||
          member.demoMemberId == senderId ||
          member.userId == senderId;
      if (isSender &&
          DepartmentMemberPresence.isOnline(member, state.onlineMembers)) {
        return true;
      }
    }
    return false;
  }

  bool _isSameSender(
    DepartmentMessageEntity first,
    DepartmentMessageEntity second,
  ) {
    final firstId = first.sender.id.trim();
    final secondId = second.sender.id.trim();
    if (firstId.isNotEmpty && secondId.isNotEmpty) {
      return firstId == secondId;
    }

    final firstName = first.sender.fullName.trim().toLowerCase();
    final secondName = second.sender.fullName.trim().toLowerCase();
    return firstName.isNotEmpty && firstName == secondName;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocListener<DepartmentChatCubit, DepartmentChatState>(
      listenWhen: (previous, current) =>
          previous.onlineMembers != current.onlineMembers ||
          previous.departmentMembers != current.departmentMembers ||
          previous.currentDepartmentMemberId !=
              current.currentDepartmentMemberId,
      listener: (context, state) {
        _publishOnlineMembers(state);
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundOf(context),
        body: SafeArea(
          child: Column(
            children: [
              BlocBuilder<DepartmentChatCubit, DepartmentChatState>(
                buildWhen: (prev, curr) =>
                    prev.connectionStatus != curr.connectionStatus,
                builder: (context, state) {
                  return ConnectionStatusBanner(status: state.connectionStatus);
                },
              ),
              Expanded(
                child: BlocConsumer<DepartmentChatCubit, DepartmentChatState>(
                  listener: (context, state) {
                    if (state.errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.errorMessage!),
                          backgroundColor: AppColors.error,
                        ),
                      );
                      context.read<DepartmentChatCubit>().clearError();
                    }
                  },
                  builder: (context, state) {
                    if ((state.isLoadingHistory || !state.isUserResolved) &&
                        state.messages.isEmpty) {
                      return AppSkeletonizer(
                        child: ListView.builder(
                          reverse: true,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: 6,
                          itemBuilder: (context, index) => ChatMessageBubble(
                            message: dummyDepartmentMessage,
                            isMine: index.isEven,
                            isFirstInGroup: index % 3 == 0,
                            isLastInGroup: index % 3 == 2,
                          ),
                        ),
                      );
                    }

                    if (state.messages.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline_rounded,
                              size: 48,
                              color: AppColors.textSecondaryOf(context),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              localizations?.chatNoMessagesYet ??
                                  'No messages yet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondaryOf(context),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              localizations?.chatFirstMessagePrompt ??
                                  'Be the first to start the conversation!',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondaryOf(context),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final myMemberId = state.currentDepartmentMemberId;
                    final myUserId =
                        state.currentUserId ?? widget.currentUserId;
                    final myDemoMemberId = state.currentDemoMemberId;
                    final myUserName = state.currentUserName;

                    return ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount:
                          state.messages.length + (state.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (state.isLoadingMore &&
                            index == state.messages.length) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          );
                        }

                        final messageIndex = state.messages.length - 1 - index;
                        final msg = state.messages[messageIndex];
                        final senderId = msg.sender.id;
                        final senderName = msg.sender.fullName.trim();
                        final hasPreviousMessageFromSameSender =
                            messageIndex > 0 &&
                            _isSameSender(
                              state.messages[messageIndex - 1],
                              msg,
                            );
                        final hasNextMessageFromSameSender =
                            messageIndex < state.messages.length - 1 &&
                            _isSameSender(
                              msg,
                              state.messages[messageIndex + 1],
                            );

                        final isMine =
                            (myMemberId != null &&
                                myMemberId.isNotEmpty &&
                                senderId == myMemberId) ||
                            (myUserId != null &&
                                myUserId.isNotEmpty &&
                                senderId == myUserId) ||
                            (myDemoMemberId != null &&
                                myDemoMemberId.isNotEmpty &&
                                senderId == myDemoMemberId) ||
                            (myUserName != null &&
                                myUserName.isNotEmpty &&
                                senderName.isNotEmpty &&
                                senderName.toLowerCase() ==
                                    myUserName.toLowerCase());
                        final isOnline = _isSenderOnline(senderId, state);

                        return ChatMessageBubble(
                          key: ValueKey(msg.id),
                          message: msg,
                          isMine: isMine,
                          isOnline: isOnline,
                          isFirstInGroup: !hasPreviousMessageFromSameSender,
                          isLastInGroup: !hasNextMessageFromSameSender,
                          onReply: () => context
                              .read<DepartmentChatCubit>()
                              .startReply(msg),
                          onEdit: () => context
                              .read<DepartmentChatCubit>()
                              .startEdit(msg),
                          onDelete: () => context
                              .read<DepartmentChatCubit>()
                              .deleteMessage(msg.id),
                        );
                      },
                    );
                  },
                ),
              ),
              BlocBuilder<DepartmentChatCubit, DepartmentChatState>(
                buildWhen: (prev, curr) =>
                    prev.typingMembers != curr.typingMembers,
                builder: (context, state) {
                  final typingNames = state.typingMembers.keys
                      .where((id) => id != state.currentDepartmentMemberId)
                      .map((id) {
                        for (final member in state.departmentMembers) {
                          if (member.id == id ||
                              member.demoMemberId == id ||
                              member.userId == id) {
                            return '${member.firstName} ${member.lastName}'
                                .trim();
                          }
                        }
                        return id;
                      })
                      .toList();
                  return TypingIndicatorWidget(typingMemberNames: typingNames);
                },
              ),
              BlocBuilder<DepartmentChatCubit, DepartmentChatState>(
                buildWhen: (prev, curr) =>
                    prev.replyingToMessage != curr.replyingToMessage ||
                    prev.editingMessage != curr.editingMessage ||
                    prev.pendingAttachment != curr.pendingAttachment ||
                    prev.isUploadingAttachment != curr.isUploadingAttachment ||
                    prev.attachmentUploadProgress !=
                        curr.attachmentUploadProgress,
                builder: (context, state) {
                  final cubit = context.read<DepartmentChatCubit>();
                  return ChatInputBar(
                    replyingToMessage: state.replyingToMessage,
                    editingMessage: state.editingMessage,
                    pendingAttachment: state.pendingAttachment,
                    isUploadingAttachment: state.isUploadingAttachment,
                    attachmentUploadProgress: state.attachmentUploadProgress,
                    onSubmit: cubit.submitMessage,
                    onTyping: (isTyping) => cubit.sendTyping(isTyping),
                    onAttachmentSelected: cubit.selectAttachment,
                    onRemoveAttachment: cubit.removeAttachment,
                    onCancelReply: () => cubit.cancelReply(),
                    onCancelEdit: () => cubit.cancelEdit(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
