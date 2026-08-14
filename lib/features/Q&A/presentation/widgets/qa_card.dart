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
  final bool isReplyTarget;
  final int? replyRefreshVersion;

  final VoidCallback? onReply;
  final ValueChanged<bool>? onAnswerEditorChanged;
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
    this.isReplyTarget = false,
    this.replyRefreshVersion,
    this.onReply,
    this.onAnswerEditorChanged,
    this.onQuestionDeleted,
    this.onQuestionUpdated,
  });

  @override
  State<QaCard> createState() => _QaCardState();
}

class _QaCardState extends State<QaCard> {
  bool _expanded = false;
  bool _loadingReplies = false;

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
  void didUpdateWidget(covariant QaCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    final refreshVersion = widget.replyRefreshVersion ?? 0;
    final oldRefreshVersion = oldWidget.replyRefreshVersion ?? 0;

    if (refreshVersion != oldRefreshVersion) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _loadReplies(expand: true);
        }
      });
    }
  }

  @override
  void dispose() {
    _editController.dispose();
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_expanded) {
      setState(() => _expanded = false);
      return;
    }

    setState(() => _expanded = true);
    if (_replies != null) return;

    await _loadReplies();
  }

  Future<void> _loadReplies({bool expand = false}) async {
    if (_loadingReplies) return;

    setState(() {
      if (expand) {
        _expanded = true;
      }
      _loadingReplies = true;
    });

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

  void _startReply() {
    if (_editingAnswer != null) {
      setState(() => _editingAnswer = null);
      _replyController.clear();
      widget.onAnswerEditorChanged?.call(false);
    }

    widget.onReply?.call();
  }

  void _startEditAnswer(DiscussionAnswerModel answer) {
    setState(() {
      _editingAnswer = answer;
      _replyController.text = answer.content;
    });

    widget.onAnswerEditorChanged?.call(true);
  }

  void _cancelAnswerEdit() {
    if (_postingReply) return;

    setState(() => _editingAnswer = null);
    _replyController.clear();
    widget.onAnswerEditorChanged?.call(false);
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
        _editingAnswer = null;
      }
    });

    if (updated != null) {
      widget.onAnswerEditorChanged?.call(false);
    }
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
    if (!mounted) return;

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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: Theme.of(context).brightness == Brightness.dark
                  ? 0.14
                  : 0.04,
            ),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
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
                        fontWeight: FontWeight.w800,
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
                          const Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.red,
                          ),
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
                filled: true,
                fillColor: AppColors.backgroundOf(context),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.borderOf(context)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: AppColors.borderOf(context)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: AppColors.primaryOf(context),
                    width: 1.5,
                  ),
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
                fontWeight: FontWeight.w500,
              ),
            ),

          const SizedBox(height: 12),

          Row(
            children: [
              _QaActionButton(
                icon: Icons.reply_rounded,
                label: localizations.reply,
                isActive: widget.isReplyTarget,
                onTap: _startReply,
              ),

              const SizedBox(width: 8),

              _QaActionButton(
                icon: _expanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                label: _repliesLabel(localizations),
                isActive: _expanded,
                onTap: _toggle,
              ),
            ],
          ),

          if (_editingAnswer != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.backgroundOf(context),
                borderRadius: BorderRadius.circular(17),
                border: Border.all(
                  color: AppColors.primaryOf(context).withValues(alpha: 0.14),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: AppColors.primaryOf(context),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          localizations.edit,
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.primaryOf(context),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _postingReply ? null : _cancelAnswerEdit,
                        tooltip: localizations.cancel,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints.tightFor(
                          width: 32,
                          height: 32,
                        ),
                        visualDensity: VisualDensity.compact,
                        icon: Icon(
                          Icons.close_rounded,
                          size: 17,
                          color: AppColors.textSecondaryOf(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  DiscussionComposer(
                    controller: _replyController,
                    hintText: localizations.replyHint,
                    isPosting: _postingReply,
                    onSubmit: _saveAnswerEdit,
                  ),
                ],
              ),
            ),
          ],

          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: !_expanded
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Column(
                      children: [
                        Divider(
                          height: 1,
                          color: AppColors.borderOf(
                            context,
                          ).withValues(alpha: 0.72),
                        ),
                        const SizedBox(height: 12),
                        if (_loadingReplies)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryOf(context),
                                strokeWidth: 2.3,
                              ),
                            ),
                          )
                        else if (replies.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              localizations.noAnswersYet,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontFamily: AppTextStyles.fontFamily,
                                color: AppColors.textSecondaryOf(context),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsetsDirectional.only(
                              start: 12,
                            ),
                            child: Column(
                              children: replies
                                  .map(
                                    (r) => ReplyTile(
                                      key: ValueKey(r.id),
                                      reply: r,
                                      demoId: widget.demoId,
                                      isOwner:
                                          widget.currentUserId != null &&
                                          r.authorId == widget.currentUserId,
                                      onEdit: () => _startEditAnswer(r),
                                      onDeleted: () {
                                        final wasEditingThisAnswer =
                                            _editingAnswer?.id == r.id;

                                        setState(() {
                                          _replies!.removeWhere(
                                            (a) => a.id == r.id,
                                          );
                                          if (wasEditingThisAnswer) {
                                            _editingAnswer = null;
                                          }
                                        });

                                        if (wasEditingThisAnswer) {
                                          widget.onAnswerEditorChanged?.call(
                                            false,
                                          );
                                        }
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                      ],
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

class _QaActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _QaActionButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);

    return Material(
      color: isActive ? primary.withValues(alpha: 0.09) : Colors.transparent,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        borderRadius: BorderRadius.circular(11),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: primary),
              const SizedBox(width: 5),
              Text(
                label,
                style: AppTextStyles.label.copyWith(
                  fontFamily: AppTextStyles.fontFamily,
                  fontWeight: FontWeight.w700,
                  color: primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
