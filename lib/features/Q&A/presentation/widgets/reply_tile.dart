import 'package:flutter/material.dart';

import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/q&a/data/models/discussion_answer_model.dart';
import 'package:project1/features/q&a/presentation/widgets/avatar.dart';

class ReplyTile extends StatelessWidget {
  final DiscussionAnswerModel reply;

  const ReplyTile({
    super.key,
    required this.reply,
  });

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
          Avatar(
            name: reply.authorName,
            avatarUrl: reply.authorAvatarUrl,
            radius: 15,
          ),

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