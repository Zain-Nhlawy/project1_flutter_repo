import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/demo/domain/entities/inquiry_entity.dart';
import 'package:project1/features/demo/presentation/cubit/inquiry%20cubit/inquiry_cubit.dart';
import 'package:project1/l10n/app_localizations.dart';

class InquiryDetailDialog extends StatefulWidget {
  final InquiryEntity inquiry;
  final bool isOwner;
  final String demoId;
  final InquiryCubit inquiryCubit;

  const InquiryDetailDialog({
    super.key,
    required this.inquiry,
    required this.isOwner,
    required this.demoId,
    required this.inquiryCubit,
  });

  static Future<void> show(
    BuildContext context, {
    required InquiryEntity inquiry,
    required bool isOwner,
    required String demoId,
    required InquiryCubit inquiryCubit,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: InquiryDetailDialog(
          inquiry: inquiry,
          isOwner: isOwner,
          demoId: demoId,
          inquiryCubit: inquiryCubit,
        ),
      ),
    );
  }

  @override
  State<InquiryDetailDialog> createState() => _InquiryDetailDialogState();
}

class _InquiryDetailDialogState extends State<InquiryDetailDialog> {
  late final TextEditingController _replyController;
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _replyController = TextEditingController(text: widget.inquiry.reply ?? '');
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  void _sendReply() {
    if (_formKey.currentState?.validate() ?? false) {
      final replyMsg = _replyController.text.trim();
      setState(() {
        _isSubmitting = true;
      });
      Navigator.of(context).pop();
      widget.inquiryCubit.replyForInquiry(
        widget.inquiry.id,
        replyMsg,
        widget.demoId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final inquiry = widget.inquiry;
    final isReplied =
        (inquiry.status?.toLowerCase() == 'replied') ||
        (inquiry.reply != null && inquiry.reply!.isNotEmpty);

    final statusColor = isReplied ? AppColors.success : AppColors.warning;
    final statusText = isReplied ? l10n.statusReplied : l10n.statusPending;

    final creatorName =
        '${inquiry.creator.firstName} ${inquiry.creator.lastName}'.trim();
    final hasName = creatorName.isNotEmpty;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.borderOf(context),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Header Row with Gradient Container
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: AppColors.headerGradientOf(context),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.mark_unread_chat_alt_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.inquiryDetails,
                      style: AppTextStyles.h3.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryOf(context),
                      ),
                    ),
                  ),
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
                    child: Text(
                      statusText,
                      style: AppTextStyles.caption.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Sender details section (ONLY FOR OWNER)
              if (widget.isOwner) ...[
                Text(
                  l10n.senderDetails,
                  style: AppTextStyles.label.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundOf(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.borderOf(context).withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
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
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryOf(context),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hasName ? creatorName : inquiry.creator.email,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimaryOf(context),
                              ),
                            ),
                            if (inquiry.creator.email.isNotEmpty)
                              Text(
                                inquiry.creator.email,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondaryOf(context),
                                ),
                              ),
                            if (inquiry.creator.role != null &&
                                inquiry.creator.role!.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                inquiry.creator.role!,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.primaryOf(context),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
              ],

              // Inquiry Subject & Message
              Text(
                l10n.inquirySubject,
                style: AppTextStyles.label.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryOf(context),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.backgroundOf(context),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.borderOf(context).withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  inquiry.subject,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              Text(
                l10n.inquiryMessage,
                style: AppTextStyles.label.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryOf(context),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.backgroundOf(context),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.borderOf(context).withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  inquiry.message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimaryOf(context),
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Owner Reply Display or Form
              if (inquiry.reply != null && inquiry.reply!.isNotEmpty) ...[
                Text(
                  l10n.ownerReply,
                  style: AppTextStyles.label.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimaryOf(context),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.reply_rounded,
                          size: 16,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          inquiry.reply!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimaryOf(context),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ] else if (!widget.isOwner) ...[
                // Awaiting reply banner for member
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        color: AppColors.warning,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.awaitingReply,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimaryOf(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Owner Reply Input Form (Only for un-replied inquiries)
              if (widget.isOwner && !isReplied) ...[
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (inquiry.reply != null && inquiry.reply!.isNotEmpty)
                            ? '${l10n.reply} (${l10n.saveChanges})'
                            : l10n.reply,
                        style: AppTextStyles.label.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimaryOf(context),
                        ),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _replyController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: l10n.replyHint,
                          filled: true,
                          fillColor: AppColors.backgroundOf(context),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: AppColors.borderOf(context),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: AppColors.borderOf(context),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: AppColors.primaryOf(context),
                              width: 1.5,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.fillAllFields;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Submit Reply Button
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: AppColors.headerGradientOf(context),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryOf(context)
                                  .withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _sendReply,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            l10n.sendReply,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
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
    );
  }
}
