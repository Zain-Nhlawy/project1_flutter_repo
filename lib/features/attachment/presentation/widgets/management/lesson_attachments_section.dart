import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/attachment/domain/entities/lesson_attachment_entity.dart';
import 'package:project1/features/attachment/presentation/widgets/management/lesson_attachment_card.dart';
import 'package:project1/l10n/app_localizations.dart';

class LessonAttachmentsSection extends StatelessWidget {
  final List<LessonAttachmentEntity> attachments;

  final VoidCallback onAdd;

  final void Function(LessonAttachmentEntity) onEdit;
  final void Function(LessonAttachmentEntity) onDelete;

  final bool enabled;
  final bool isUploading;

  const LessonAttachmentsSection({
    super.key,
    required this.attachments,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    this.enabled = true,
    this.isUploading = false,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final primary = AppColors.primaryOf(context);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: enabled ? 1 : 0.62,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: AppColors.surfaceOf(context),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.borderOf(context).withValues(alpha: 0.82),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.045),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(
                    Icons.attach_file_rounded,
                    color: primary,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    l.lessonAttachments,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimaryOf(context),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (attachments.isNotEmpty)
                  Container(
                    constraints: const BoxConstraints(minWidth: 30),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${attachments.length}',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.label.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 15),
            InkWell(
              onTap: enabled && !isUploading ? onAdd : null,
              borderRadius: BorderRadius.circular(17),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.055),
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: primary.withValues(alpha: 0.24)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: enabled
                            ? AppColors.buttonGradientOf(context)
                            : null,
                        color: enabled ? null : AppColors.borderOf(context),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: enabled
                            ? [
                                BoxShadow(
                                  color: primary.withValues(alpha: 0.16),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : const [],
                      ),
                      child: isUploading
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: CircularProgressIndicator(
                                strokeWidth: 2.1,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 23,
                            ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.addAttachment,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimaryOf(context),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'PDF  •  DOC  •  PPT  •  ZIP  •  TXT',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondaryOf(context),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: primary.withValues(alpha: 0.72),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            if (attachments.isEmpty && !isUploading)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 21),
                decoration: BoxDecoration(
                  color: AppColors.backgroundOf(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.borderOf(context).withValues(alpha: 0.72),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.folder_open_outlined,
                      color: AppColors.textSecondaryOf(
                        context,
                      ).withValues(alpha: 0.6),
                      size: 29,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l.noAttachments,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondaryOf(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
            else
              IgnorePointer(
                ignoring: !enabled,
                child: Column(
                  children: [
                    for (
                      int index = 0;
                      index < attachments.length;
                      index++
                    ) ...[
                      if (index > 0) const SizedBox(height: 10),
                      LessonAttachmentCard(
                        attachment: attachments[index],
                        onEdit: () => onEdit(attachments[index]),
                        onDelete: () => onDelete(attachments[index]),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
