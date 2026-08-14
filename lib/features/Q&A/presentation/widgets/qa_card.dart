import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/q&a/data/models/discussion_answer_model.dart';
import 'package:project1/features/q&a/presentation/cubit/discussion_cubit.dart';
import 'package:project1/features/q&a/presentation/widgets/avatar.dart';
import 'package:project1/features/q&a/presentation/widgets/reply_tile.dart';
import 'package:project1/features/q&a/presentation/widgets/discussion_composer.dart';
import 'package:project1/l10n/app_localizations.dart';

class QaCard extends StatefulWidget {
  final String questionId;
  final String demoId;
  final String lessonId;
  final String userName;
  final String? avatarUrl;
  final String question;
  final DateTime createdAt;

  final bool isOwner;

  final String? currentUserId;

  final Future<void> Function(String questionId, String content)?
      onSubmitReply;

  final VoidCallback? onQuestionDeleted;
  final void Function(String newContent)? onQuestionUpdated;

  const QaCard({
    super.key,
    required this.questionId,
    required this.demoId,
    required this.lessonId,
    required this.userName,
    required this.avatarUrl,
    required this.question,
    required this.createdAt,
    this.isOwner = false,
    this.currentUserId,
    this.onSubmitReply,
    this.onQuestionDeleted,
    this.onQuestionUpdated,
  });

  @override
  State<QaCard> createState() => _QaCardState();
}

class _QaCardState extends State<QaCard> {
  bool _expanded = false;
  bool _loadingReplies = false;

  bool _replying = false;
  bool _postingReply = false;
  DiscussionAnswerModel? _editingAnswer;
  final TextEditingController _replyController = TextEditingController();

  bool _editingQuestion = false;
  bool _savingQuestion = false;
  bool _deletingQuestion = false;
  late TextEditingController _editController;

  late String _questionText;

  List<DiscussionAnswerModel>? _replies;

  @override
  void initState() {
    super.initState();
    _questionText = widget.question;
    _editController = TextEditingController(text: _questionText);
  }

  @override
  void dispose() {
    _editController.dispose();
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    setState(() => _expanded = !_expanded);

    if (!_expanded || _replies != null) return;

    setState(() => _loadingReplies = true);

    final answers = await context.read<DiscussionCubit>().getAnswers(
          questionId: widget.questionId,
          demoId: widget.demoId,
        );

    if (!mounted) return;

    setState(() {
      _replies = answers;
      _loadingReplies = false;
    });
  }

  void _toggleReplyComposer() {
    setState(() {
      if (_replying) {
        _replying = false;
        _editingAnswer = null;
      } else {
        _replying = true;
        _editingAnswer = null;
        _replyController.clear();
      }
    });
  }

  void _startEditAnswer(DiscussionAnswerModel answer) {
    setState(() {
      _editingAnswer = answer;
      _replyController.text = answer.content;
      _replying = true;
    });
  }

  Future<void> _handleComposerSubmit(String content) async {
    if (_editingAnswer != null) {
      await _saveAnswerEdit(content);
    } else {
      await _submitNewReply(content);
    }
  }

  Future<void> _submitNewReply(String content) async {
    if (widget.onSubmitReply == null || _postingReply) return;

    setState(() => _postingReply = true);

    try {
      await widget.onSubmitReply!(widget.questionId, content);

      if (!mounted) return;

      setState(() {
        _replying = false;
        _postingReply = false;
      });

      if (!_expanded) {
        await _toggle();
      } else {
        final answers = await context.read<DiscussionCubit>().getAnswers(
              questionId: widget.questionId,
              demoId: widget.demoId,
            );

        if (!mounted) return;

        setState(() {
          _replies = answers;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _postingReply = false);
    }
  }

  Future<void> _saveAnswerEdit(String content) async {
    final answer = _editingAnswer;
    if (answer == null || _postingReply) return;

    setState(() => _postingReply = true);

    final updated = await context.read<DiscussionCubit>().updateAnswer(
          questionId: answer.questionId,
          answerId: answer.id,
          content: content,
          demoId: widget.demoId,
        );

    if (!mounted) return;

    setState(() {
      _postingReply = false;
      if (updated != null) {
        final i = _replies?.indexWhere((a) => a.id == answer.id) ?? -1;
        if (i != -1) {
          _replies![i] = updated;
        }
        _replying = false;
        _editingAnswer = null;
      }
    });
  }

  void _startEditQuestion() {
    setState(() {
      _editController.text = _questionText;
      _editingQuestion = true;
    });
  }

  void _cancelEditQuestion() {
    setState(() => _editingQuestion = false);
  }

  Future<void> _saveQuestionEdit() async {
    final newContent = _editController.text.trim();
    if (newContent.isEmpty || _savingQuestion) return;

    setState(() => _savingQuestion = true);

    final updated = await context.read<DiscussionCubit>().updateQuestion(
          lessonId: widget.lessonId,
          questionId: widget.questionId,
          content: newContent,
          demoId: widget.demoId,
        );

    if (!mounted) return;

    setState(() {
      _savingQuestion = false;
      if (updated != null) {
        _questionText = updated.content;
        _editingQuestion = false;
        widget.onQuestionUpdated?.call(_questionText);
      }
    });
  }

  Future<void> _confirmDeleteQuestion() async {
    final localizations = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(localizations.deleteQuestionTitle),
        content: Text(localizations.deleteQuestionConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(localizations.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              localizations.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _deletingQuestion = true);

    final success = await context.read<DiscussionCubit>().deleteQuestion(
          lessonId: widget.lessonId,
          questionId: widget.questionId,
          demoId: widget.demoId,
        );

    if (!mounted) return;

    if (success) {
      widget.onQuestionDeleted?.call();
    } else {
      setState(() => _deletingQuestion = false);
    }
  }

  String _repliesLabel(AppLocalizations localizations) {
    if (_replies == null) {
      return localizations.answers;
    }
    return '${_replies!.length} ${localizations.answers}';
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final replies = _replies ?? const <DiscussionAnswerModel>[];

    if (_deletingQuestion) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.borderOf(context),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Avatar(
                name: widget.userName,
                avatarUrl: widget.avatarUrl,
                radius: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontFamily: AppTextStyles.fontFamily,
                        color: AppColors.textPrimaryOf(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(widget.createdAt),
                      style: AppTextStyles.caption.copyWith(
                        fontFamily: AppTextStyles.fontFamily,
                        color: AppColors.textSecondaryOf(context),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.isOwner && !_editingQuestion)
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: AppColors.textSecondaryOf(context),
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      _startEditQuestion();
                    } else if (value == 'delete') {
                      _confirmDeleteQuestion();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit_outlined, size: 18),
                          const SizedBox(width: 8),
                          Text(localizations.edit),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline,
                              size: 18, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            localizations.delete,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 14),

          if (_editingQuestion) ...[
            TextField(
              controller: _editController,
              maxLines: null,
              autofocus: true,
              style: AppTextStyles.bodyLarge.copyWith(
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.textPrimaryOf(context),
                height: 1.4,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _savingQuestion ? null : _cancelEditQuestion,
                  child: Text(localizations.cancel),
                ),
                const SizedBox(width: 4),
                ElevatedButton(
                  onPressed: _savingQuestion ? null : _saveQuestionEdit,
                  child: _savingQuestion
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(localizations.save),
                ),
              ],
            ),
          ] else
            Text(
              _questionText,
              style: AppTextStyles.bodyLarge.copyWith(
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.textPrimaryOf(context),
                height: 1.4,
              ),
            ),

          const SizedBox(height: 12),

          Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: _toggleReplyComposer,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _replying ? Icons.close : Icons.reply_outlined,
                        size: 18,
                        color: AppColors.primaryOf(context),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _replying ? 'Cancel' : 'Reply',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontFamily: AppTextStyles.fontFamily,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryOf(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: _toggle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _expanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 20,
                        color: AppColors.primaryOf(context),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _repliesLabel(localizations),
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontFamily: AppTextStyles.fontFamily,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryOf(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          if (_replying) ...[
            const SizedBox(height: 8),
            DiscussionComposer(
              controller: _replyController,
              hintText: _editingAnswer != null
                  ? 'Edit your reply...'
                  : 'Write a reply...',
              isPosting: _postingReply,
              onSubmit: _handleComposerSubmit,
            ),
          ],

          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: !_expanded
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: _loadingReplies
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : replies.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: Text(
                                  localizations.noAnswersYet,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontFamily: AppTextStyles.fontFamily,
                                    color:
                                        AppColors.textSecondaryOf(context),
                                  ),
                                ),
                              )
                            : Column(
                                children: replies
                                    .map(
                                      (r) => ReplyTile(
                                        key: ValueKey(r.id),
                                        reply: r,
                                        demoId: widget.demoId,
                                        isOwner: widget.currentUserId !=
                                                null &&
                                            r.authorId ==
                                                widget.currentUserId,
                                        onEdit: () => _startEditAnswer(r),
                                        onDeleted: () {
                                          setState(() {
                                            _replies!.removeWhere(
                                                (a) => a.id == r.id);
                                            if (_editingAnswer?.id == r.id) {
                                              _editingAnswer = null;
                                              _replying = false;
                                            }
                                          });
                                        },
                                      ),
                                    )
                                    .toList(),
                              ),
                  ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}