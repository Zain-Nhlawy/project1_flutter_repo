import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/notifications/data/data_sources/notification_storage_service.dart';
import 'package:project1/features/notifications/data/models/notification_payload_model.dart';
import 'package:project1/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:project1/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:project1/features/notifications/presentation/services/notification_navigation_handler.dart';
import 'package:project1/l10n/app_localizations.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NotificationsCubit>(
      create: (_) => NotificationsCubit(
        storageService: getIt<NotificationStorageService>(),
      )..fetchNotifications(),
      child: const _NotificationsPageView(),
    );
  }
}

class _NotificationsPageView extends StatelessWidget {
  const _NotificationsPageView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final topPadding = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      body: Column(
        children: [
          // Header matching Inquiries / DemoStats gradient app bar
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: AppColors.headerGradientOf(context),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOf(context).withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: topPadding > 0 ? topPadding + 8 : 32,
                left: 20,
                right: 20,
                bottom: 18,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints.tightFor(
                            width: 38,
                            height: 38,
                          ),
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: AppColors.surface,
                            size: 17,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          l10n.notificationsTitle,
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.surface,
                            fontWeight: FontWeight.bold,
                            fontSize: 21,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      BlocBuilder<NotificationsCubit, NotificationsState>(
                        builder: (context, state) {
                          if (state is NotificationsLoaded &&
                              state.notifications.isNotEmpty) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (state.unreadCount > 0)
                                  Container(
                                    margin: const EdgeInsets.only(right: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface.withValues(
                                        alpha: 0.25,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      tooltip: l10n.markAllAsRead,
                                      onPressed: () {
                                        context
                                            .read<NotificationsCubit>()
                                            .markAllAsRead();
                                      },
                                      visualDensity: VisualDensity.compact,
                                      padding: EdgeInsets.zero,
                                      constraints:
                                          const BoxConstraints.tightFor(
                                            width: 38,
                                            height: 38,
                                          ),
                                      icon: const Icon(
                                        Icons.done_all_rounded,
                                        color: AppColors.surface,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.surface.withValues(
                                      alpha: 0.25,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: IconButton(
                                    tooltip: l10n.clearAllNotifications,
                                    onPressed: () =>
                                        _confirmClearAll(context, l10n),
                                    visualDensity: VisualDensity.compact,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints.tightFor(
                                      width: 38,
                                      height: 38,
                                    ),
                                    icon: const Icon(
                                      Icons.delete_sweep_rounded,
                                      color: AppColors.surface,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  BlocBuilder<NotificationsCubit, NotificationsState>(
                    builder: (context, state) {
                      String subtitle = l10n.notificationsSubtitle;
                      if (state is NotificationsLoaded &&
                          state.unreadCount > 0) {
                        subtitle = '${state.unreadCount} unread';
                      }
                      return Text(
                        subtitle,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.surface.withValues(alpha: 0.85),
                          fontSize: 13,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Body List
          Expanded(
            child: BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                if (state is NotificationsLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryOf(context),
                    ),
                  );
                }

                if (state is NotificationsLoaded) {
                  if (state.notifications.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () =>
                          context.read<NotificationsCubit>().fetchNotifications(),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(22),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryOf(context)
                                            .withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.notifications_none_rounded,
                                        size: 48,
                                        color: AppColors.primaryOf(context),
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    Text(
                                      l10n.noNewNotifications,
                                      style: AppTextStyles.titleMedium.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimaryOf(context),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      l10n.noNotificationsSubtitle,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textSecondaryOf(
                                          context,
                                        ),
                                        fontSize: 13,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: AppColors.primaryOf(context),
                    onRefresh: () =>
                        context.read<NotificationsCubit>().fetchNotifications(),
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 36),
                      itemCount: state.notifications.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final notification = state.notifications[index];
                        return _NotificationCard(
                          notification: notification,
                          onTap: () {
                            context
                                .read<NotificationsCubit>()
                                .markAsRead(notification.id);
                            NotificationNavigationHandler
                                .handleNotificationTap(notification);
                          },
                          onDismissed: () {
                            context
                                .read<NotificationsCubit>()
                                .deleteNotification(notification.id);
                          },
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surfaceOf(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          l10n.clearAllNotifications,
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryOf(context),
          ),
        ),
        content: Text(
          l10n.clearNotificationsConfirmation,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondaryOf(context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<NotificationsCubit>().clearAll();
            },
            child: Text(l10n.clearAllNotifications),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationPayloadModel notification;
  final VoidCallback onTap;
  final VoidCallback onDismissed;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    final typeConfig = _getTypeConfig(context, notification);
    final timeStr = _formatRelativeTime(notification.receivedAt);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: notification.isRead
                  ? AppColors.surfaceOf(context)
                  : AppColors.primaryOf(context).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: notification.isRead
                    ? AppColors.borderOf(context).withValues(alpha: 0.5)
                    : AppColors.primaryOf(context).withValues(alpha: 0.35),
                width: notification.isRead ? 1 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon badge
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: typeConfig.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    typeConfig.icon,
                    color: typeConfig.color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title.isEmpty
                                  ? typeConfig.label
                                  : notification.title,
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: notification.isRead
                                    ? FontWeight.w600
                                    : FontWeight.bold,
                                color: AppColors.textPrimaryOf(context),
                                fontSize: 15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!notification.isRead) ...[
                            const SizedBox(width: 6),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.primaryOf(context),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (notification.body.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          notification.body,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondaryOf(context),
                            fontSize: 13,
                            height: 1.35,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 6),
                      Text(
                        timeStr,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondaryOf(
                            context,
                          ).withValues(alpha: 0.7),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: AppColors.textSecondaryOf(context).withValues(
                    alpha: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _TypeConfig _getTypeConfig(
    BuildContext context,
    NotificationPayloadModel payload,
  ) {
    final screen = payload.targetScreen.toLowerCase();
    if (screen.contains('invit')) {
      return _TypeConfig(
        icon: Icons.mail_outline_rounded,
        color: const Color(0xFF6366F1),
        label: 'Invitation',
      );
    }
    if (screen.contains('inquir')) {
      return _TypeConfig(
        icon: Icons.question_answer_rounded,
        color: const Color(0xFFF59E0B),
        label: 'Inquiry',
      );
    }
    if (screen.contains('stat') || screen.contains('report')) {
      return _TypeConfig(
        icon: Icons.insights_rounded,
        color: const Color(0xFF8B5CF6),
        label: 'Report',
      );
    }
    if (screen.contains('chat') || screen.contains('message')) {
      return _TypeConfig(
        icon: Icons.chat_bubble_outline_rounded,
        color: const Color(0xFF06B6D4),
        label: 'Chat',
      );
    }
    if (screen.contains('course')) {
      return _TypeConfig(
        icon: Icons.menu_book_rounded,
        color: const Color(0xFF3B82F6),
        label: 'Course',
      );
    }
    if (screen.contains('live')) {
      return _TypeConfig(
        icon: Icons.live_tv_rounded,
        color: const Color(0xFFEF4444),
        label: 'Live',
      );
    }
    if (screen.contains('cert')) {
      return _TypeConfig(
        icon: Icons.workspace_premium_rounded,
        color: const Color(0xFF10B981),
        label: 'Certificate',
      );
    }
    return _TypeConfig(
      icon: Icons.notifications_active_outlined,
      color: AppColors.primaryOf(context),
      label: 'Notification',
    );
  }

  String _formatRelativeTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(time);
    }
  }
}

class _TypeConfig {
  final IconData icon;
  final Color color;
  final String label;

  _TypeConfig({required this.icon, required this.color, required this.label});
}
