import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/core/services/remote_file_opener.dart';
import 'package:project1/l10n/app_localizations.dart';
import '../../domain/entities/department_message_entity.dart';
import '../../domain/entities/message_attachment_entity.dart';
import '../../domain/entities/message_type.dart';

class ChatMessageBubble extends StatelessWidget {
  final DepartmentMessageEntity message;
  final bool isMine;
  final bool isOnline;
  final bool isFirstInGroup;
  final bool isLastInGroup;
  final VoidCallback? onReply;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isMine,
    this.isOnline = false,
    this.isFirstInGroup = true,
    this.isLastInGroup = true,
    this.onReply,
    this.onEdit,
    this.onDelete,
  });

  TextDirection _getMessageTextDirection(String text) {
    if (text.isEmpty) return TextDirection.ltr;
    final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(text);
    return isArabic ? TextDirection.rtl : TextDirection.ltr;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    final timeStr = DateFormat('hh:mm a').format(message.createdAt.toLocal());
    final messageText = message.content ?? '';
    final contentTextDir = _getMessageTextDirection(messageText);

    return Directionality(
      // Reply is always a physical left swipe, including in RTL layouts.
      textDirection: TextDirection.ltr,
      child: _SwipeToReply(
        onReply: message.isDeleted ? null : onReply,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            12,
            isFirstInGroup ? 4 : 1,
            12,
            isLastInGroup ? 4 : 1,
          ),
          child: Row(
            mainAxisAlignment: isMine
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isMine) ...[
                if (isLastInGroup)
                  _buildAvatar(context)
                else
                  const SizedBox(width: 32, height: 32),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: GestureDetector(
                  onLongPress: isMine && !message.isDeleted
                      ? () => _showOptionsSheet(context)
                      : null,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: isMine
                          ? AppColors.headerGradientOf(context)
                          : null,
                      color: isMine ? null : AppColors.surfaceOf(context),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          !isMine && !isFirstInGroup ? 6 : 16,
                        ),
                        topRight: Radius.circular(
                          isMine && !isFirstInGroup ? 6 : 16,
                        ),
                        bottomLeft: Radius.circular(
                          !isMine ? (isLastInGroup ? 4 : 6) : 16,
                        ),
                        bottomRight: Radius.circular(
                          isMine ? (isLastInGroup ? 4 : 6) : 16,
                        ),
                      ),
                      border: isMine
                          ? null
                          : Border.all(color: AppColors.borderOf(context)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: isMine
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isMine && isFirstInGroup) ...[
                          Text(
                            message.sender.fullName,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                        ],
                        if (message.replyTo != null) ...[
                          _buildReplyPreview(context),
                          const SizedBox(height: 6),
                        ],
                        if (message.isDeleted)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.block_rounded,
                                size: 16,
                                color: isMine
                                    ? Colors.white.withValues(alpha: 0.7)
                                    : AppColors.textSecondaryOf(context),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                localizations?.chatMessageDeleted ??
                                    'This message was deleted',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: isMine
                                      ? Colors.white.withValues(alpha: 0.7)
                                      : AppColors.textSecondaryOf(context),
                                ),
                              ),
                            ],
                          )
                        else ...[
                          if (message.attachment != null)
                            _buildAttachment(context, message.attachment!),
                          if (message.attachment != null &&
                              messageText.isNotEmpty)
                            const SizedBox(height: 8),
                          if (messageText.isNotEmpty)
                            Directionality(
                              textDirection: contentTextDir,
                              child: Text(
                                messageText,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isMine
                                      ? Colors.white
                                      : AppColors.textPrimaryOf(context),
                                ),
                              ),
                            ),
                        ],
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (message.isEdited && !message.isDeleted) ...[
                              Text(
                                '${localizations?.chatEditedTag ?? 'edited'} ',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontSize: 10,
                                  fontStyle: FontStyle.italic,
                                  color: isMine
                                      ? Colors.white70
                                      : AppColors.textSecondaryOf(context),
                                ),
                              ),
                            ],
                            Text(
                              timeStr,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontSize: 10,
                                color: isMine
                                    ? Colors.white70
                                    : AppColors.textSecondaryOf(context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isMine) const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final imagePath = message.sender.imagePath;
    final initials = message.sender.firstName.isNotEmpty
        ? message.sender.firstName[0].toUpperCase()
        : '?';

    return Stack(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.secondary.withValues(alpha: 0.2),
          backgroundImage: imagePath != null && imagePath.isNotEmpty
              ? NetworkImage(imagePath)
              : null,
          child: imagePath == null || imagePath.isEmpty
              ? Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                )
              : null,
        ),
        if (isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.surfaceOf(context),
                  width: 1.5,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildReplyPreview(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final replyContent = message.replyTo!.content.isNotEmpty
        ? message.replyTo!.content
        : switch (message.replyTo!.type) {
            MessageType.image => localizations?.chatPhoto ?? 'Photo',
            _ => localizations?.chatFile ?? 'File',
          };
    final replyDir = _getMessageTextDirection(replyContent);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isMine
            ? Colors.white.withValues(alpha: 0.15)
            : AppColors.backgroundOf(context),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: isMine ? Colors.white : AppColors.primary,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Directionality(
            textDirection: replyDir,
            child: Text(
              replyContent,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: isMine
                    ? Colors.white.withValues(alpha: 0.9)
                    : AppColors.textSecondaryOf(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachment(
    BuildContext context,
    MessageAttachmentEntity attachment,
  ) {
    final fileUrl = attachment.fileUrl;
    final isImage =
        message.type == MessageType.image ||
        (attachment.mimeType?.startsWith('image/') ?? false);

    if (isImage && fileUrl != null && fileUrl.isNotEmpty) {
      return GestureDetector(
        onTap: () => _openAttachment(context, attachment),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            fileUrl,
            width: 240,
            height: 180,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              final total = progress.expectedTotalBytes;
              return SizedBox(
                width: 240,
                height: 180,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    value: total == null
                        ? null
                        : progress.cumulativeBytesLoaded / total,
                    color: isMine ? Colors.white : AppColors.primary,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return _buildUnavailableAttachment(context);
            },
          ),
        ),
      );
    }

    return _buildFileAttachment(context, attachment);
  }

  Widget _buildFileAttachment(
    BuildContext context,
    MessageAttachmentEntity attachment,
  ) {
    final fileUrl = attachment.fileUrl;
    final fileName = attachment.fileName?.trim();
    final isPdf =
        attachment.mimeType == 'application/pdf' ||
        (fileName?.toLowerCase().endsWith('.pdf') ?? false);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: fileUrl == null || fileUrl.isEmpty
            ? null
            : () => _openAttachment(context, attachment),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 260),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isMine
                ? Colors.white.withValues(alpha: 0.14)
                : AppColors.backgroundOf(context),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPdf
                    ? Icons.picture_as_pdf_rounded
                    : Icons.insert_drive_file_rounded,
                color: isMine ? Colors.white : AppColors.error,
                size: 30,
              ),
              const SizedBox(width: 9),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName?.isNotEmpty == true
                          ? fileName!
                          : (AppLocalizations.of(context)?.chatFile ?? 'File'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isMine
                            ? Colors.white
                            : AppColors.textPrimaryOf(context),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (attachment.fileSize != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        _formatFileSize(attachment.fileSize!),
                        style: TextStyle(
                          color: isMine
                              ? Colors.white70
                              : AppColors.textSecondaryOf(context),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.open_in_new_rounded,
                size: 16,
                color: isMine
                    ? Colors.white70
                    : AppColors.textSecondaryOf(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnavailableAttachment(BuildContext context) {
    return Container(
      width: 240,
      height: 120,
      alignment: Alignment.center,
      color: isMine
          ? Colors.white.withValues(alpha: 0.14)
          : AppColors.backgroundOf(context),
      child: Icon(
        Icons.broken_image_outlined,
        color: isMine ? Colors.white70 : AppColors.textSecondaryOf(context),
        size: 36,
      ),
    );
  }

  Future<void> _openAttachment(
    BuildContext context,
    MessageAttachmentEntity attachment,
  ) async {
    final fileUrl = attachment.fileUrl;
    if (fileUrl == null || fileUrl.isEmpty) return;

    final navigator = Navigator.of(context, rootNavigator: true);
    final loadingDialog = showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return const PopScope(
          canPop: false,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );

    var wasOpened = false;
    try {
      wasOpened = await RemoteFileOpener().open(
        url: fileUrl,
        fileName: attachment.fileName ?? '',
      );
    } catch (_) {
      wasOpened = false;
    } finally {
      if (navigator.mounted && navigator.canPop()) {
        navigator.pop();
      }
      await loadingDialog;
    }

    if (!wasOpened && context.mounted) {
      final localizations = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localizations?.chatOpenAttachmentFailed ??
                'Could not open attachment.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    final kilobytes = bytes / 1024;
    if (kilobytes < 1024) return '${kilobytes.toStringAsFixed(1)} KB';
    return '${(kilobytes / 1024).toStringAsFixed(1)} MB';
  }

  void _showOptionsSheet(BuildContext context) {
    if (message.isDeleted || !isMine) return;

    final localizations = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceOf(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (message.content?.trim().isNotEmpty == true)
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: Text(localizations?.chatEdit ?? 'Edit'),
                  onTap: () {
                    Navigator.pop(ctx);
                    onEdit?.call();
                  },
                ),
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: AppColors.error,
                ),
                title: Text(
                  localizations?.chatDelete ?? 'Delete',
                  style: const TextStyle(color: AppColors.error),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  onDelete?.call();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SwipeToReply extends StatefulWidget {
  final VoidCallback? onReply;
  final Widget child;

  const _SwipeToReply({required this.onReply, required this.child});

  @override
  State<_SwipeToReply> createState() => _SwipeToReplyState();
}

class _SwipeToReplyState extends State<_SwipeToReply>
    with SingleTickerProviderStateMixin {
  static const double _maxDragDistance = 68;
  static const double _replyThreshold = 0.55;
  static const double _minimumFlingProgress = 0.2;
  static const double _replyFlingVelocity = -700;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 180),
  );

  @override
  void didUpdateWidget(covariant _SwipeToReply oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onReply == null && _controller.value != 0) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    final delta = details.primaryDelta ?? 0;
    _controller.value = (_controller.value - delta / _maxDragDistance).clamp(
      0.0,
      1.0,
    );
  }

  void _handleDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final shouldReply =
        _controller.value >= _replyThreshold ||
        (velocity <= _replyFlingVelocity &&
            _controller.value >= _minimumFlingProgress);

    if (shouldReply) {
      widget.onReply?.call();
    }
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onReply != null;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragUpdate: enabled ? _handleDragUpdate : null,
      onHorizontalDragEnd: enabled ? _handleDragEnd : null,
      onHorizontalDragCancel: enabled ? _controller.reverse : null,
      child: AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (context, child) {
          final progress = _controller.value;

          return Stack(
            children: [
              Transform.translate(
                offset: Offset(-_maxDragDistance * progress, 0),
                child: child,
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Transform.translate(
                      offset: const Offset(-16, 0),
                      child: Opacity(
                        opacity: progress,
                        child: Transform.scale(
                          scale: 0.75 + (0.25 * progress),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primaryOf(
                                context,
                              ).withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.reply_rounded,
                              color: AppColors.primaryOf(context),
                              size: 21,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
