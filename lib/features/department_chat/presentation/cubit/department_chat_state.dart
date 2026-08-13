import '../../../department/domain/entities/department_member_entity.dart';
import '../../domain/entities/department_attachment_file_entity.dart';
import '../../domain/entities/department_message_entity.dart';
import '../../domain/entities/socket_connection_status.dart';

class DepartmentChatState {
  final List<DepartmentMessageEntity> messages;
  final bool isLoadingHistory;
  final bool isLoadingMore;
  final bool hasNextPage;
  final String? endCursor;
  final SocketConnectionStatus connectionStatus;
  final Map<String, bool> typingMembers;
  final Set<String> onlineMembers;
  final List<DepartmentMemberEntity> departmentMembers;
  final DepartmentMessageEntity? replyingToMessage;
  final DepartmentMessageEntity? editingMessage;
  final DepartmentAttachmentFileEntity? pendingAttachment;
  final bool isUploadingAttachment;
  final double attachmentUploadProgress;
  final String? errorMessage;
  final String? currentUserId;
  final String? currentDepartmentMemberId;
  final String? currentDemoMemberId;
  final String? currentUserName;
  final bool isUserResolved;

  const DepartmentChatState({
    this.messages = const [],
    this.isLoadingHistory = false,
    this.isLoadingMore = false,
    this.hasNextPage = false,
    this.endCursor,
    this.connectionStatus = SocketConnectionStatus.initial,
    this.typingMembers = const {},
    this.onlineMembers = const {},
    this.departmentMembers = const [],
    this.replyingToMessage,
    this.editingMessage,
    this.pendingAttachment,
    this.isUploadingAttachment = false,
    this.attachmentUploadProgress = 0,
    this.errorMessage,
    this.currentUserId,
    this.currentDepartmentMemberId,
    this.currentDemoMemberId,
    this.currentUserName,
    this.isUserResolved = false,
  });

  DepartmentChatState copyWith({
    List<DepartmentMessageEntity>? messages,
    bool? isLoadingHistory,
    bool? isLoadingMore,
    bool? hasNextPage,
    String? endCursor,
    SocketConnectionStatus? connectionStatus,
    Map<String, bool>? typingMembers,
    Set<String>? onlineMembers,
    List<DepartmentMemberEntity>? departmentMembers,
    DepartmentMessageEntity? Function()? replyingToMessage,
    DepartmentMessageEntity? Function()? editingMessage,
    DepartmentAttachmentFileEntity? Function()? pendingAttachment,
    bool? isUploadingAttachment,
    double? attachmentUploadProgress,
    String? Function()? errorMessage,
    String? currentUserId,
    String? currentDepartmentMemberId,
    String? currentDemoMemberId,
    String? currentUserName,
    bool? isUserResolved,
  }) {
    return DepartmentChatState(
      messages: messages ?? this.messages,
      isLoadingHistory: isLoadingHistory ?? this.isLoadingHistory,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      endCursor: endCursor ?? this.endCursor,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      typingMembers: typingMembers ?? this.typingMembers,
      onlineMembers: onlineMembers ?? this.onlineMembers,
      departmentMembers: departmentMembers ?? this.departmentMembers,
      replyingToMessage: replyingToMessage != null
          ? replyingToMessage()
          : this.replyingToMessage,
      editingMessage: editingMessage != null
          ? editingMessage()
          : this.editingMessage,
      pendingAttachment: pendingAttachment != null
          ? pendingAttachment()
          : this.pendingAttachment,
      isUploadingAttachment:
          isUploadingAttachment ?? this.isUploadingAttachment,
      attachmentUploadProgress:
          attachmentUploadProgress ?? this.attachmentUploadProgress,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      currentUserId: currentUserId ?? this.currentUserId,
      currentDepartmentMemberId:
          currentDepartmentMemberId ?? this.currentDepartmentMemberId,
      currentDemoMemberId: currentDemoMemberId ?? this.currentDemoMemberId,
      currentUserName: currentUserName ?? this.currentUserName,
      isUserResolved: isUserResolved ?? this.isUserResolved,
    );
  }
}
