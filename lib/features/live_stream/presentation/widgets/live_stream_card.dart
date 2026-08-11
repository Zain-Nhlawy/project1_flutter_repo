import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/live_stream/domain/entities/live_stream_entity.dart';
import 'package:project1/features/live_stream/presentation/widgets/live_stream_status_badge.dart';
import 'package:project1/l10n/app_localizations.dart';

class LiveStreamCard extends StatelessWidget {
  final LiveStreamEntity stream;
  final bool canManage;
  final VoidCallback onJoin;
  final VoidCallback? onStart;
  final VoidCallback? onEnd;
  final VoidCallback? onEdit;

  const LiveStreamCard({
    super.key,
    required this.stream,
    required this.canManage,
    required this.onJoin,
    this.onStart,
    this.onEnd,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final dateStr = stream.scheduledAt != null
        ? DateFormat('EEE, MMM d, yyyy • hh:mm a').format(stream.scheduledAt!)
        : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: stream.isLive
              ? Colors.red.withValues(alpha: 0.4)
              : AppColors.borderOf(context),
          width: stream.isLive ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondaryOf(context).withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    stream.title,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textPrimaryOf(context),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                LiveStreamStatusBadge(status: stream.status),
              ],
            ),
            if (stream.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                stream.description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondaryOf(context),
                  fontSize: 13,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (dateStr != null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 14,
                    color: AppColors.textSecondaryOf(context),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    dateStr,
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.textSecondaryOf(context),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                if (stream.isLive)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.headerGradientOf(context),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryOf(context).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onJoin,
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.videocam_rounded, size: 20, color: Colors.white),
                                const SizedBox(width: 6),
                                Text(
                                  localizations.joinLiveStream,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                else if (canManage && stream.isScheduled)
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.headerGradientOf(context),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryOf(context).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onStart ?? onJoin,
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.play_arrow_rounded, size: 20, color: Colors.white),
                                const SizedBox(width: 6),
                                Text(
                                  localizations.startLiveStream,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (canManage && stream.isLive && onEnd != null) ...[
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    onPressed: onEnd,
                    icon: const Icon(Icons.stop_rounded, size: 18, color: Colors.red),
                    label: Text(
                      localizations.endLiveStream,
                      style: const TextStyle(color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                    ),
                  ),
                ],
                if (canManage && stream.isScheduled && onEdit != null) ...[
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceOf(context),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.borderOf(context),
                      ),
                    ),
                    child: IconButton(
                      onPressed: onEdit,
                      icon: ShaderMask(
                        shaderCallback: (bounds) =>
                            AppColors.headerGradientOf(context).createShader(bounds),
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
