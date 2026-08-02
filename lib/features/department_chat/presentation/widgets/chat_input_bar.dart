import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/l10n/app_localizations.dart';
import '../../domain/entities/department_message_entity.dart';

class ChatInputBar extends StatefulWidget {
  final DepartmentMessageEntity? replyingToMessage;
  final DepartmentMessageEntity? editingMessage;
  final ValueChanged<String> onSubmit;
  final ValueChanged<bool> onTyping;
  final VoidCallback onCancelReply;
  final VoidCallback onCancelEdit;

  const ChatInputBar({
    super.key,
    this.replyingToMessage,
    this.editingMessage,
    required this.onSubmit,
    required this.onTyping,
    required this.onCancelReply,
    required this.onCancelEdit,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounceTimer;
  bool _isTypingSent = false;
  TextDirection? _currentTextDirection;

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

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
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

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty && widget.editingMessage == null) return;

    _debounceTimer?.cancel();
    if (_isTypingSent) {
      _isTypingSent = false;
      widget.onTyping(false);
    }

    widget.onSubmit(text);
    _controller.clear();
    setState(() {
      _currentTextDirection = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isEditing = widget.editingMessage != null;
    final isReplying = widget.replyingToMessage != null;
    final inputDir =
        _currentTextDirection ?? _calculateTextDirection(_controller.text);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isReplying)
          _buildBanner(
            context,
            title: localizations?.chatReplyingTo(
                  widget.replyingToMessage!.sender.firstName,
                ) ??
                'Replying to ${widget.replyingToMessage!.sender.firstName}',
            content: widget.replyingToMessage!.content ?? '',
            icon: Icons.reply_rounded,
            onClose: widget.onCancelReply,
          ),
        if (isEditing)
          _buildBanner(
            context,
            title: localizations?.chatEditingMessageTitle ?? 'Editing Message',
            content: widget.editingMessage!.content ?? '',
            icon: Icons.edit_outlined,
            onClose: widget.onCancelEdit,
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceOf(context),
            border: Border(
              top: BorderSide(color: AppColors.borderOf(context)),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundOf(context),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.borderOf(context)),
                  ),
                  child: TextField(
                    controller: _controller,
                    onChanged: _onTextChanged,
                    onSubmitted: (_) => _handleSend(),
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
                          ? (localizations?.chatEditMessageHint ?? 'Edit message...')
                          : (localizations?.chatTypeMessageHint ?? 'Type a message...'),
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: AppColors.textSecondaryOf(context),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: AppColors.primary,
                shape: const CircleBorder(),
                elevation: 2,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _handleSend,
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
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
          border: Border(
            left: BorderSide(color: AppColors.primary, width: 4),
          ),
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
