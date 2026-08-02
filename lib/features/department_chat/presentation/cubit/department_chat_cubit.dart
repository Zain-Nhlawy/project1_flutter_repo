import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/domain/use_case/get_me_usecase.dart';
import '../../../department/domain/repository/department_member_repository.dart';
import '../../domain/entities/department_message_entity.dart';
import '../../domain/entities/message_type.dart';
import '../../domain/entities/socket_connection_status.dart';
import '../../domain/repository/department_chat_repository.dart';
import '../../domain/use_case/connect_department_chat_usecase.dart';
import '../../domain/use_case/delete_department_message_usecase.dart';
import '../../domain/use_case/disconnect_department_chat_usecase.dart';
import '../../domain/use_case/edit_department_message_usecase.dart';
import '../../domain/use_case/get_message_history_usecase.dart';
import '../../domain/use_case/send_department_message_usecase.dart';
import '../../domain/use_case/set_typing_status_usecase.dart';
import 'department_chat_state.dart';

class DepartmentChatCubit extends Cubit<DepartmentChatState> {
  final GetMessageHistoryUseCase getMessageHistoryUseCase;
  final ConnectDepartmentChatUseCase connectDepartmentChatUseCase;
  final DisconnectDepartmentChatUseCase disconnectDepartmentChatUseCase;
  final SendDepartmentMessageUseCase sendDepartmentMessageUseCase;
  final EditDepartmentMessageUseCase editDepartmentMessageUseCase;
  final DeleteDepartmentMessageUseCase deleteDepartmentMessageUseCase;
  final SetTypingStatusUseCase setTypingStatusUseCase;
  final DepartmentChatRepository repository;
  final GetMeUseCase? getMeUseCase;
  final DepartmentMemberRepository? departmentMemberRepository;

  StreamSubscription? _msgReceivedSub;
  StreamSubscription? _msgEditedSub;
  StreamSubscription? _msgDeletedSub;
  StreamSubscription? _typingSub;
  StreamSubscription? _userOnlineSub;
  StreamSubscription? _userOfflineSub;
  StreamSubscription? _connStatusSub;
  StreamSubscription? _exceptionSub;
  StreamSubscription? _joinedMemberSub;

  final Map<String, Timer> _typingTimers = {};
  String? _departmentId;
  String? _demoId;

  DepartmentChatCubit({
    required this.getMessageHistoryUseCase,
    required this.connectDepartmentChatUseCase,
    required this.disconnectDepartmentChatUseCase,
    required this.sendDepartmentMessageUseCase,
    required this.editDepartmentMessageUseCase,
    required this.deleteDepartmentMessageUseCase,
    required this.setTypingStatusUseCase,
    required this.repository,
    this.getMeUseCase,
    this.departmentMemberRepository,
  }) : super(const DepartmentChatState());

  void init({
    required String departmentId,
    required String demoId,
    String? currentUserId,
  }) async {
    _departmentId = departmentId;
    _demoId = demoId;

    if (currentUserId != null && currentUserId.isNotEmpty) {
      emit(state.copyWith(currentUserId: currentUserId));
    }

    _subscribeToSocketStreams();

    await _loadUserInfoAndMemberIds(
      departmentId: departmentId,
      demoId: demoId,
      initialUserId: currentUserId,
    );

    await connectDepartmentChatUseCase(departmentId: departmentId);
    await loadInitialHistory();
  }

  Future<void> _loadUserInfoAndMemberIds({
    required String departmentId,
    required String demoId,
    String? initialUserId,
  }) async {
    try {
      String? resolvedUserId = initialUserId ?? state.currentUserId;
      String? fullName;

      if (getMeUseCase != null) {
        final userRes = await getMeUseCase!();
        userRes.fold(
          (_) {},
          (user) {
            resolvedUserId = user.id;
            fullName = '${user.firstName} ${user.lastName}'.trim();
            emit(state.copyWith(
              currentUserId: user.id,
              currentUserName: fullName,
            ));
          },
        );
      }

      if (resolvedUserId != null &&
          resolvedUserId!.isNotEmpty &&
          departmentMemberRepository != null) {
        final result =
            await departmentMemberRepository!.getDepartmentMembers(departmentId, demoId);
        result.fold(
          (_) {},
          (members) {
            try {
              final myMember = members.firstWhere(
                (m) =>
                    m.userId == resolvedUserId ||
                    (fullName != null &&
                        '${m.firstName} ${m.lastName}'.trim().toLowerCase() ==
                            fullName!.toLowerCase()),
              );
              emit(state.copyWith(
                currentDepartmentMemberId: myMember.id,
                currentDemoMemberId: myMember.demoMemberId,
              ));
            } catch (_) {}
          },
        );
      }
    } finally {
      emit(state.copyWith(isUserResolved: true));
    }
  }


  void _subscribeToSocketStreams() {
    _msgReceivedSub?.cancel();
    _msgReceivedSub = repository.messageReceivedStream.listen(_onMessageReceived);

    _msgEditedSub?.cancel();
    _msgEditedSub = repository.messageEditedStream.listen(_onMessageEdited);

    _msgDeletedSub?.cancel();
    _msgDeletedSub = repository.messageDeletedStream.listen(_onMessageDeleted);

    _typingSub?.cancel();
    _typingSub = repository.typingStatusStream.listen(_onTypingStatus);

    _userOnlineSub?.cancel();
    _userOnlineSub = repository.userOnlineStream.listen(_onUserOnline);

    _userOfflineSub?.cancel();
    _userOfflineSub = repository.userOfflineStream.listen(_onUserOffline);

    _connStatusSub?.cancel();
    _connStatusSub = repository.connectionStatusStream.listen(_onConnectionStatusChanged);

    _exceptionSub?.cancel();
    _exceptionSub = repository.exceptionStream.listen(_onExceptionReceived);

    _joinedMemberSub?.cancel();
    _joinedMemberSub = repository.joinedDepartmentMemberIdStream.listen((memberId) {
      emit(state.copyWith(currentDepartmentMemberId: memberId));
    });
  }

  Future<void> loadInitialHistory() async {
    if (_departmentId == null || _demoId == null) return;

    emit(state.copyWith(isLoadingHistory: true, errorMessage: () => null));

    final result = await getMessageHistoryUseCase(
      departmentId: _departmentId!,
      demoId: _demoId!,
      take: 20,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoadingHistory: false,
            errorMessage: () => failure.message,
          ),
        );
      },
      (page) {
        final list = List<DepartmentMessageEntity>.from(page.messages);
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));

        emit(
          state.copyWith(
            messages: list,
            isLoadingHistory: false,
            hasNextPage: page.hasNextPage,
            endCursor: page.endCursor,
          ),
        );
      },
    );
  }

  Future<void> loadOlderMessages() async {
    if (state.isLoadingMore || !state.hasNextPage || state.endCursor == null) {
      return;
    }
    if (_departmentId == null || _demoId == null) return;

    emit(state.copyWith(isLoadingMore: true));

    final result = await getMessageHistoryUseCase(
      departmentId: _departmentId!,
      demoId: _demoId!,
      cursor: state.endCursor,
      take: 20,
    );

    result.fold(
      (failure) {
        emit(state.copyWith(isLoadingMore: false));
      },
      (page) {
        final olderList = List<DepartmentMessageEntity>.from(page.messages);
        olderList.sort((a, b) => a.createdAt.compareTo(b.createdAt));

        final existingIds = state.messages.map((m) => m.id).toSet();
        final filteredOlder = olderList.where((m) => !existingIds.contains(m.id)).toList();

        final merged = [...filteredOlder, ...state.messages];

        emit(
          state.copyWith(
            messages: merged,
            isLoadingMore: false,
            hasNextPage: page.hasNextPage,
            endCursor: page.endCursor,
          ),
        );
      },
    );
  }

  void _onMessageReceived(DepartmentMessageEntity message) {
    final existingIndex = state.messages.indexWhere((m) => m.id == message.id);
    if (existingIndex != -1) {
      final updatedList = List<DepartmentMessageEntity>.from(state.messages);
      updatedList[existingIndex] = message;
      emit(state.copyWith(messages: updatedList));
    } else {
      final updatedList = List<DepartmentMessageEntity>.from(state.messages)..add(message);
      emit(state.copyWith(messages: updatedList));
    }
  }

  void _onMessageEdited(DepartmentMessageEntity message) {
    final index = state.messages.indexWhere((m) => m.id == message.id);
    if (index != -1) {
      final updatedList = List<DepartmentMessageEntity>.from(state.messages);
      updatedList[index] = message;
      emit(state.copyWith(messages: updatedList));
    }
  }

  void _onMessageDeleted(DepartmentMessageEntity message) {
    final index = state.messages.indexWhere((m) => m.id == message.id);
    if (index != -1) {
      final updatedList = List<DepartmentMessageEntity>.from(state.messages);
      final current = state.messages[index];
      updatedList[index] = DepartmentMessageEntity(
        id: current.id,
        departmentId: current.departmentId,
        type: current.type,
        content: null,
        isEdited: current.isEdited,
        isDeleted: true,
        createdAt: current.createdAt,
        updatedAt: message.updatedAt,
        sender: current.sender,
        attachment: current.attachment,
        replyTo: current.replyTo,
      );
      emit(state.copyWith(messages: updatedList));
    }
  }

  void _onTypingStatus(Map<String, dynamic> data) {
    final memberId = data['departmentMemberId']?.toString();
    final isTyping = data['isTyping'] == true;

    if (memberId == null || memberId.isEmpty) return;

    final updatedMap = Map<String, bool>.from(state.typingMembers);
    if (isTyping) {
      updatedMap[memberId] = true;
      _typingTimers[memberId]?.cancel();
      _typingTimers[memberId] = Timer(const Duration(seconds: 4), () {
        final mapCopy = Map<String, bool>.from(state.typingMembers);
        mapCopy.remove(memberId);
        emit(state.copyWith(typingMembers: mapCopy));
      });
    } else {
      updatedMap.remove(memberId);
      _typingTimers[memberId]?.cancel();
    }
    emit(state.copyWith(typingMembers: updatedMap));
  }

  void _onUserOnline(String memberId) {
    final updatedSet = Set<String>.from(state.onlineMembers)..add(memberId);
    emit(state.copyWith(onlineMembers: updatedSet));
  }

  void _onUserOffline(String memberId) {
    final updatedSet = Set<String>.from(state.onlineMembers)..remove(memberId);
    emit(state.copyWith(onlineMembers: updatedSet));
  }

  void _onConnectionStatusChanged(SocketConnectionStatus status) {
    emit(state.copyWith(connectionStatus: status));
  }

  void _onExceptionReceived(String exceptionMessage) {
    emit(state.copyWith(errorMessage: () => exceptionMessage));
  }

  void clearError() {
    emit(state.copyWith(errorMessage: () => null));
  }

  void startReply(DepartmentMessageEntity message) {
    emit(state.copyWith(replyingToMessage: () => message, editingMessage: () => null));
  }

  void cancelReply() {
    emit(state.copyWith(replyingToMessage: () => null));
  }

  void startEdit(DepartmentMessageEntity message) {
    if (message.isDeleted) return;
    emit(state.copyWith(editingMessage: () => message, replyingToMessage: () => null));
  }

  void cancelEdit() {
    emit(state.copyWith(editingMessage: () => null));
  }

  Future<void> submitMessage(String content) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty && state.editingMessage == null) return;
    if (_departmentId == null) return;

    if (state.editingMessage != null) {
      final msgToEdit = state.editingMessage!;
      cancelEdit();

      _onMessageEdited(msgToEdit.copyWith(content: trimmed, isEdited: true));

      final res = await editDepartmentMessageUseCase(
        messageId: msgToEdit.id,
        content: trimmed,
      );
      res.fold(
        (failure) {
          emit(state.copyWith(errorMessage: () => failure.message));
        },
        (_) {},
      );
    } else {
      final replyId = state.replyingToMessage?.id;
      cancelReply();

      final res = await sendDepartmentMessageUseCase(
        departmentId: _departmentId!,
        type: MessageType.text,
        content: trimmed,
        replyToId: replyId,
      );

      res.fold(
        (failure) {
          emit(state.copyWith(errorMessage: () => failure.message));
        },
        (_) {},
      );
    }
  }

  Future<void> deleteMessage(String messageId) async {
    final index = state.messages.indexWhere((m) => m.id == messageId);
    if (index != -1) {
      _onMessageDeleted(state.messages[index]);
    }

    final res = await deleteDepartmentMessageUseCase(messageId: messageId);
    res.fold(
      (failure) {
        emit(state.copyWith(errorMessage: () => failure.message));
      },
      (_) {},
    );
  }

  void sendTyping(bool isTyping) {
    setTypingStatusUseCase(isTyping: isTyping);
  }

  @override
  Future<void> close() {
    for (var timer in _typingTimers.values) {
      timer.cancel();
    }
    _msgReceivedSub?.cancel();
    _msgEditedSub?.cancel();
    _msgDeletedSub?.cancel();
    _typingSub?.cancel();
    _userOnlineSub?.cancel();
    _userOfflineSub?.cancel();
    _connStatusSub?.cancel();
    _exceptionSub?.cancel();
    _joinedMemberSub?.cancel();
    disconnectDepartmentChatUseCase();
    return super.close();
  }
}
