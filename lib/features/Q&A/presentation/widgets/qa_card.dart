import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/q&a/data/models/discussion_answer_model.dart';
import 'package:project1/features/q&a/presentation/cubit/discussion_cubit.dart';
import 'package:project1/l10n/app_localizations.dart';

class QaCard extends StatefulWidget {
  final String questionId;
  final String userName;
  final String? avatarUrl;
  final String question;
  final DateTime createdAt;

  const QaCard({
    super.key,
    required this.questionId,
    required this.userName,
    required this.avatarUrl,
    required this.question,
    required this.createdAt,
  });

  @override
  State<QaCard> createState() => _QaCardState();
}

class _QaCardState extends State<QaCard> {
  bool _expanded = false;
  bool _loadingReplies = false;
  List<DiscussionAnswerModel>? _replies;

  Future<void> _toggle() async {
    setState(() => _expanded = !_expanded);

    if (!_expanded || _replies != null) return;

    setState(() => _loadingReplies = true);

    final answers = await context.read<DiscussionCubit>().getAnswers(
          questionId: widget.questionId,
        );

    if (!mounted) return;
    setState(() {
      _replies = answers;
      _loadingReplies = false;
    });
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
        border: Border.all(color: AppColors.borderOf(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Avatar(name: widget.userName, avatarUrl: widget.avatarUrl, radius: 20),
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

          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
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
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : replies.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  localizations.noAnswersYet,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontFamily: AppTextStyles.fontFamily,
                                    color: AppColors.textSecondaryOf(context),
                                  ),
                                ),
                              )
                            : Column(
                                children:
                                    replies.map((r) => _ReplyTile(reply: r)).toList(),
                              ),
                  ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}

class _ReplyTile extends StatelessWidget {
  final DiscussionAnswerModel reply;

  const _ReplyTile({required this.reply});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundOf(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar(name: reply.authorName, avatarUrl: reply.authorAvatarUrl, radius: 15),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reply.authorName,
                  style: AppTextStyles.label.copyWith(
                    fontFamily: AppTextStyles.fontFamily,
                    color: AppColors.textPrimaryOf(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reply.content,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontFamily: AppTextStyles.fontFamily,
                    color: AppColors.textPrimaryOf(context),
                    height: 1.4,
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

class _Avatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final double radius;

  const _Avatar({required this.name, required this.avatarUrl, required this.radius});

  @override
  Widget build(BuildContext context) {
    final hasImage = avatarUrl != null && avatarUrl!.trim().isNotEmpty;

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryOf(context).withOpacity(.12),
      backgroundImage: hasImage ? NetworkImage(avatarUrl!) : null,
      child: hasImage
          ? null
          : Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: AppTextStyles.bodyMedium.copyWith(
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.primaryOf(context),
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}