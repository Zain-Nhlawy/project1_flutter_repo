import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/l10n/app_localizations.dart';
import '../../domain/entities/department_attachment_file_entity.dart';
import '../../domain/entities/department_message_entity.dart';

typedef ChatSubmitCallback = Future<bool> Function(String content);

class ChatInputBar extends StatefulWidget {
  final DepartmentMessageEntity? replyingToMessage;
  final DepartmentMessageEntity? editingMessage;
  final DepartmentAttachmentFileEntity? pendingAttachment;
  final bool isUploadingAttachment;
  final double attachmentUploadProgress;
  final ChatSubmitCallback onSubmit;
  final ValueChanged<bool> onTyping;
  final ValueChanged<DepartmentAttachmentFileEntity> onAttachmentSelected;
  final VoidCallback onRemoveAttachment;
  final VoidCallback onCancelReply;
  final VoidCallback onCancelEdit;

  const ChatInputBar({
    super.key,
    this.replyingToMessage,
    this.editingMessage,
    this.pendingAttachment,
    this.isUploadingAttachment = false,
    this.attachmentUploadProgress = 0,
    required this.onSubmit,
    required this.onTyping,
    required this.onAttachmentSelected,
    required this.onRemoveAttachment,
    required this.onCancelReply,
    required this.onCancelEdit,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounceTimer;
  bool _isTypingSent = false;
  bool _isSubmitting = false;
  TextDirection? _currentTextDirection;

  static const _allowedExtensions = [
    'pdf',
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
  ];

  static const _mimeTypes = {
    'pdf': 'application/pdf',
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'gif': 'image/gif',
    'webp': 'image/webp',
  };

  @override
  void initState() {
    super.initState();
    if (widget.editingMessage != null) {
      _controller.text = widget.editingMessage!.content ?? '';
    }
  }

  @override
  void didUpdateWidget(covariant ChatInputBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.replyingToMessage?.id != widget.replyingToMessage?.id) {
      _requestComposerFocus();
    }
    if (widget.editingMessage != oldWidget.editingMessage) {
      if (widget.editingMessage != null) {
        _controller.text = widget.editingMessage!.content ?? '';
        _currentTextDirection = null;
      } else {
        _controller.clear();
        _currentTextDirection = null;
      }
    }
  }

  void _requestComposerFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _focusNode.canRequestFocus) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  TextDirection _calculateTextDirection(String text) {
    if (text.trim().isEmpty) return Directionality.of(context);
    final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(text);
    return isArabic ? TextDirection.rtl : TextDirection.ltr;
  }

  void _onTextChanged(String value) {
    final newDir = _calculateTextDirection(value);
    if (newDir != _currentTextDirection) {
      setState(() {
        _currentTextDirection = newDir;
      });
    }

    if (value.trim().isNotEmpty && !_isTypingSent) {
      _isTypingSent = true;
      widget.onTyping(true);
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 1500), () {
      if (_isTypingSent) {
        _isTypingSent = false;
        widget.onTyping(false);
      }
    });
  }

  Future<void> _pickAttachment() async {
    if (_isSubmitting ||
        widget.isUploadingAttachment ||
        widget.editingMessage != null) {
      return;
    }

    final localizations = AppLocalizations.of(context);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _allowedExtensions,
        allowMultiple: false,
        withData: true,
      );
      if (result == null || !mounted) return;

      final file = result.files.single;
      final bytes = file.bytes;
      final extension = (file.extension ?? file.name.split('.').last)
          .toLowerCase();
      final mimeType = _mimeTypes[extension];

      if (bytes == null || mimeType == null) {
        _showPickerError(
          localizations?.chatAttachmentReadFailed ??
              'Could not read the selected file.',
        );
        return;
      }

      widget.onAttachmentSelected(
        DepartmentAttachmentFileEntity(
          fileName: file.name,
          mimeType: mimeType,
          bytes: bytes,
        ),
      );
    } catch (_) {
      if (mounted) {
        _showPickerError(
          localizations?.chatAttachmentReadFailed ??
              'Could not read the selected file.',
        );
      }
    }
  }

  void _showPickerError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  Future<void> _handleSend() async {
    if (_isSubmitting || widget.isUploadingAttachment) return;

    final text = _controller.text.trim();
    if (text.isEmpty &&
        widget.editingMessage == null &&
        widget.pendingAttachment == null) {
      return;
    }

    final shouldRetainFocus = _focusNode.hasFocus;

    _debounceTimer?.cancel();
    if (_isTypingSent) {
      _isTypingSent = false;
      widget.onTyping(false);
    }

    setState(() => _isSubmitting = true);
    final wasSubmitted = await widget.onSubmit(text);
    if (!mounted) return;

    if (wasSubmitted) {
      _controller.clear();
      _currentTextDirection = null;
    }
    setState(() => _isSubmitting = false);
    if (shouldRetainFocus) {
      _requestComposerFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isEditing = widget.editingMessage != null;
    final isReplying = widget.replyingToMessage != null;
    final isBusy = _isSubmitting || widget.isUploadingAttachment;
    final inputDir =
        _currentTextDirection ?? _calculateTextDirection(_controller.text);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isReplying)
          KeyedSubtree(
            key: const ValueKey('reply-banner'),
            child: _buildBanner(
              context,
              title:
                  localizations?.chatReplyingTo(
                    widget.replyingToMessage!.sender.firstName,
                  ) ??
                  'Replying to ${widget.replyingToMessage!.sender.firstName}',
              content: widget.replyingToMessage!.content ?? '',
              icon: Icons.reply_rounded,
              onClose: widget.onCancelReply,
            ),
          ),
        if (isEditing)
          KeyedSubtree(
            key: const ValueKey('edit-banner'),
            child: _buildBanner(
              context,
              title:
                  localizations?.chatEditingMessageTitle ?? 'Editing Message',
              content: widget.editingMessage!.content ?? '',
              icon: Icons.edit_outlined,
              onClose: widget.onCancelEdit,
            ),
          ),
        if (widget.pendingAttachment != null)
          KeyedSubtree(
            key: const ValueKey('attachment-preview'),
            child: _buildAttachmentPreview(
              context,
              attachment: widget.pendingAttachment!,
              isUploading: widget.isUploadingAttachment,
              progress: widget.attachmentUploadProgress,
            ),
          ),
        Container(
          key: const ValueKey('chat-composer-row'),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceOf(context),
            border: Border(top: BorderSide(color: AppColors.borderOf(context))),
          ),
          child: Row(
            children: [
              IconButton(
                tooltip: localizations?.chatAddAttachment ?? 'Add photo or PDF',
                onPressed: isBusy || isEditing ? null : _pickAttachment,
                icon: Icon(
                  Icons.attach_file_rounded,
                  color: isBusy || isEditing
                      ? AppColors.textSecondaryOf(context)
                      : AppColors.primaryOf(context),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundOf(context),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.borderOf(context)),
                  ),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    inputFormatters: [
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        return isBusy ? oldValue : newValue;
                      }),
                    ],
                    onChanged: _onTextChanged,
                    // Override Flutter's default completion behavior, which
                    // unfocuses the field for the send action.
                    onEditingComplete: () {},
                    onSubmitted: (_) {
                      _handleSend();
                    },
                    maxLines: 4,
                    minLines: 1,
                    textDirection: inputDir,
                    textAlign: inputDir == TextDirection.rtl
                        ? TextAlign.right
                        : TextAlign.left,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.send,
                    decoration: InputDecoration(
                      hintText: isEditing
                          ? (localizations?.chatEditMessageHint ??
                                'Edit message...')
                          : (localizations?.chatTypeMessageHint ??
                                'Type a message...'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide: BorderSide.none,
                      ),
                      hintStyle: TextStyle(
                        color: AppColors.textSecondaryOf(context),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.headerGradientOf(context),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color:
                          (Theme.of(context).brightness == Brightness.dark
                                  ? AppColors.darkSecondary
                                  : AppColors.secondary)
                              .withValues(alpha: 0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: isBusy ? null : _handleSend,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: isBusy
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentPreview(
    BuildContext context, {
    required DepartmentAttachmentFileEntity attachment,
    required bool isUploading,
    required double progress,
  }) {
    final localizations = AppLocalizations.of(context);

    return Container(
      color: AppColors.surfaceOf(context),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.backgroundOf(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderOf(context)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: attachment.isImage
                  ? Image.memory(
                      attachment.bytes,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 48,
                      height: 48,
                      color: AppColors.error.withValues(alpha: 0.1),
                      child: const Icon(
                        Icons.picture_as_pdf_rounded,
                        color: AppColors.error,
                      ),
                    ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    attachment.fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textPrimaryOf(context),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    isUploading
                        ? (localizations?.chatUploadingAttachment ??
                              'Uploading attachment...')
                        : _formatFileSize(attachment.fileSize),
                    style: TextStyle(
                      color: AppColors.textSecondaryOf(context),
                      fontSize: 11,
                    ),
                  ),
                  if (isUploading) ...[
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: progress > 0
                          ? progress.clamp(0.0, 1.0).toDouble()
                          : null,
                      minHeight: 3,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              onPressed: isUploading ? null : widget.onRemoveAttachment,
              icon: const Icon(Icons.close_rounded, size: 19),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    final kilobytes = bytes / 1024;
    if (kilobytes < 1024) return '${kilobytes.toStringAsFixed(1)} KB';
    return '${(kilobytes / 1024).toStringAsFixed(1)} MB';
  }

  Widget _buildBanner(
    BuildContext context, {
    required String title,
    required String content,
    required IconData icon,
    required VoidCallback onClose,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: AppColors.surfaceOf(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.backgroundOf(context),
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(color: AppColors.primary, width: 4)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondaryOf(context),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 18),
              onPressed: onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }
}
