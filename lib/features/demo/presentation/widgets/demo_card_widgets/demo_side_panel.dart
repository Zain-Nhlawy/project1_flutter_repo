import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/demo/domain/entities/demo_entity.dart';
import 'package:project1/features/demo/domain/entities/demo_subscription_status.dart';
import 'package:project1/l10n/app_localizations.dart';

class DemoSidePanel extends StatelessWidget {
  final DemoEntity demo;
  final Size size;
  final double textScale;
  final AppLocalizations localizations;
  final int daysLeft;
  final DemoSubscriptionStatus subscriptionStatus;

  const DemoSidePanel({
    super.key,
    required this.demo,
    required this.size,
    required this.textScale,
    required this.localizations,
    required this.daysLeft,
    required this.subscriptionStatus,
  });

  Widget _buildImage(
    BuildContext context,
    String? imagePath,
    double avatarSize,
  ) {
    if (imagePath != null && imagePath.trim().isNotEmpty) {
      final path = imagePath.trim();
      if (path.startsWith('http://') || path.startsWith('https://')) {
        return Image.network(
          path,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _fallbackImage(context, avatarSize),
        );
      } else if (path.startsWith('assets/')) {
        return Image.asset(
          path,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _fallbackImage(context, avatarSize),
        );
      } else {
        final file = File(path);
        if (file.existsSync()) {
          return Image.file(
            file,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _fallbackImage(context, avatarSize),
          );
        }
      }
    }
    return _fallbackImage(context, avatarSize);
  }

  Widget _fallbackImage(BuildContext context, double avatarSize) {
    return Image.asset(
      'assets/images/logo1.png',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: AppColors.textSecondaryOf(context).withValues(alpha: 0.08),
        child: Icon(
          Icons.business_rounded,
          color: AppColors.textSecondaryOf(context).withValues(alpha: 0.4),
          size: avatarSize * 0.4,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avatarSize = 72.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: primary.withValues(alpha: 0.18),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.25)
                    : textSecondary.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.5),
            child: _buildImage(context, demo.imagePath, avatarSize),
          ),
        ),
        if (demo.isOwner) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.workspace_premium_rounded,
                  color: primary,
                  size: 11 * textScale,
                ),
                const SizedBox(width: 4),
                Text(
                  demo.plan ?? 'Starter',
                  style: AppTextStyles.label.copyWith(
                    color: primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 10 * textScale,
                  ),
                ),
              ],
            ),
          ),
          if (subscriptionStatus != DemoSubscriptionStatus.unknown) ...[
            const SizedBox(height: 6),
            _SubscriptionStatusBadge(
              status: subscriptionStatus,
              daysLeft: daysLeft,
              textScale: textScale,
              localizations: localizations,
            ),
          ],
        ],
      ],
    );
  }
}

class _SubscriptionStatusBadge extends StatelessWidget {
  final DemoSubscriptionStatus status;
  final int daysLeft;
  final double textScale;
  final AppLocalizations localizations;

  const _SubscriptionStatusBadge({
    required this.status,
    required this.daysLeft,
    required this.textScale,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = switch (status) {
      DemoSubscriptionStatus.trialing => (
        localizations.daysLeftText(daysLeft),
        Colors.orangeAccent,
        Icons.access_time_rounded,
      ),
      DemoSubscriptionStatus.active => (
        localizations.subscriptionActive,
        Colors.green,
        Icons.check_circle_outline_rounded,
      ),
      DemoSubscriptionStatus.expired => (
        localizations.freeTrialExpired,
        Colors.redAccent,
        Icons.timer_off_outlined,
      ),
      DemoSubscriptionStatus.cancelled => (
        localizations.subscriptionCancelled,
        Colors.redAccent,
        Icons.cancel_outlined,
      ),
      DemoSubscriptionStatus.unknown => ('', Colors.grey, Icons.help_outline),
    };

    return Container(
      constraints: const BoxConstraints(maxWidth: 110),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 10 * textScale),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: AppTextStyles.label.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 9 * textScale,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
