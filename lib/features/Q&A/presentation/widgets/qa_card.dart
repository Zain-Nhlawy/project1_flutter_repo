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
  final String userName;
  final String? avatarUrl;
  final String question;
  final DateTime createdAt;

  final Future<void> Function(String questionId, String content)?
      onSubmitReply;

  const QaCard({
    super.key,
    required this.questionId,
    required this.demoId,
    required this.userName,
    required this.avatarUrl,
    required this.question,
    required this.createdAt,
    this.onSubmitReply,
  });

  @override
  State<QaCard> createState() => _QaCardState();
}

class _QaCardState extends State<QaCard> {
  bool _expanded = false;
  bool _loadingReplies = false;
  bool _replying = false;
  bool _postingReply = false;

  List<DiscussionAnswerModel>? _replies;

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

  void _toggleReply() {
    setState(() {
      _replying = !_replying;
    });
  }

  Future<void> _submitReply(String content) async {
    if (widget.onSubmitReply == null || _postingReply) return;

    setState(() {
      _postingReply = true;
    });

    try {
      await widget.onSubmitReply!(
        widget.questionId,
        content,
      );

      if (!mounted) return;

      setState(() {
        _replying = false;
        _postingReply = false;
        _replies = null;
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

      setState(() {
        _postingReply = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final replies = _replies ?? const <DiscussionAnswerModel>[];

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
            ],
          ),

          const SizedBox(height: 14),

          Text(
            widget.question,
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
                onTap: _toggleReply,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _replying
                            ? Icons.close
                            : Icons.reply_outlined,
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
                        _expanded
                            ? localizations.hideReplies
                            : (_replies == null
                                ? localizations.viewReplies
                                : '${replies.length} ${localizations.answers}'),
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
              hintText: 'Write a reply...',
              isPosting: _postingReply,
              onSubmit: _submitReply,
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
                                  style:
                                      AppTextStyles.bodyMedium.copyWith(
                                    fontFamily:
                                        AppTextStyles.fontFamily,
                                    color: AppColors
                                        .textSecondaryOf(context),
                                  ),
                                ),
                              )
                            : Column(
                                children: replies
                                    .map(
                                      (r) => ReplyTile(reply: r),
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