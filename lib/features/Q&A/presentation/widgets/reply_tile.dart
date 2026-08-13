import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/q&a/data/models/discussion_answer_model.dart';
import 'package:project1/features/q&a/presentation/cubit/discussion_cubit.dart';
import 'package:project1/features/q&a/presentation/widgets/avatar.dart';
import 'package:project1/l10n/app_localizations.dart';

class ReplyTile extends StatefulWidget {
  final DiscussionAnswerModel reply;
  final String demoId;

  final bool isOwner;

  final VoidCallback? onEdit;

  final VoidCallback? onDeleted;

  const ReplyTile({
    super.key,
    required this.reply,
    required this.demoId,
    this.isOwner = false,
    this.onEdit,
    this.onDeleted,
  });

  @override
  State<ReplyTile> createState() => _ReplyTileState();
}

class _ReplyTileState extends State<ReplyTile> {
  bool _deleting = false;

  Future<void> _confirmDelete() async {
    final localizations = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(localizations.deleteAnswerTitle),
        content: Text(localizations.deleteAnswerConfirm),
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

    setState(() => _deleting = true);

    final success = await context.read<DiscussionCubit>().deleteAnswer(
      questionId: widget.reply.questionId,
      answerId: widget.reply.id,
      demoId: widget.demoId,
    );

    if (!mounted) return;

    if (success) {
      widget.onDeleted?.call();
    } else {
      setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (_deleting) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.backgroundOf(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.72),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Avatar(
            name: widget.reply.authorName,
            avatarUrl: widget.reply.authorAvatarUrl,
            radius: 15,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.reply.authorName,
                        style: AppTextStyles.label.copyWith(
                          fontFamily: AppTextStyles.fontFamily,
                          color: AppColors.textPrimaryOf(context),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (widget.isOwner)
                      PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.more_vert,
                          size: 18,
                          color: AppColors.textSecondaryOf(context),
                        ),
                        onSelected: (value) {
                          if (value == 'edit') {
                            widget.onEdit?.call();
                          } else if (value == 'delete') {
                            _confirmDelete();
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                const Icon(Icons.edit_outlined, size: 16),
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
                                  size: 16,
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
                const SizedBox(height: 4),
                Text(
                  widget.reply.content,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontFamily: AppTextStyles.fontFamily,
                    color: AppColors.textPrimaryOf(context),
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
