import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/demo/domain/entities/inquiry_entity.dart';
import 'package:project1/l10n/app_localizations.dart';

class InquiryCardWidget extends StatelessWidget {
  final InquiryEntity inquiry;
  final bool isOwner;
  final VoidCallback onTap;

  const InquiryCardWidget({
    super.key,
    required this.inquiry,
    required this.isOwner,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isReplied =
        (inquiry.status?.toLowerCase() == 'replied') ||
        (inquiry.reply != null && inquiry.reply!.isNotEmpty);

    final statusColor = isReplied ? AppColors.success : AppColors.warning;
    final statusText = isReplied ? l10n.statusReplied : l10n.statusPending;
    final statusIcon =
        isReplied ? Icons.check_circle_rounded : Icons.schedule_rounded;

    final creatorName =
        '${inquiry.creator.firstName} ${inquiry.creator.lastName}'.trim();
    final hasName = creatorName.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Subject and Status Chip
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        inquiry.subject.isEmpty
                            ? l10n.inquirySubject
                            : inquiry.subject,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimaryOf(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, size: 13, color: statusColor),
                          const SizedBox(width: 4),
                          Text(
                            statusText,
                            style: AppTextStyles.caption.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Message Preview
                Text(
                  inquiry.message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondaryOf(context),
                    fontSize: 14,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 14),

                // Owner view: Sender details
                if (isOwner) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundOf(context),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.primaryOf(context)
                              .withValues(alpha: 0.15),
                          backgroundImage:
                              (inquiry.creator.imagePath != null &&
                                      inquiry.creator.imagePath!.isNotEmpty)
                                  ? NetworkImage(inquiry.creator.imagePath!)
                                  : null,
                          child: (inquiry.creator.imagePath == null ||
                                  inquiry.creator.imagePath!.isEmpty)
                              ? Text(
                                  hasName
                                      ? creatorName[0].toUpperCase()
                                      : 'U',
                                  style: AppTextStyles.caption.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryOf(context),
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hasName
                                    ? creatorName
                                    : inquiry.creator.email,
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimaryOf(context),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (hasName && inquiry.creator.email.isNotEmpty)
                                Text(
                                  inquiry.creator.email,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textSecondaryOf(context),
                                    fontSize: 11,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Reply preview (shown when replied)
                if (isReplied &&
                    inquiry.reply != null &&
                    inquiry.reply!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.success.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.reply_rounded,
                          size: 16,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${l10n.ownerReply}: ${inquiry.reply}',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textPrimaryOf(context),
                              fontSize: 12.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
