import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';

class GradientPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final int subtitleMaxLines;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final double bottomRadius;

  const GradientPageAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.subtitleMaxLines = 1,
    this.onBackPressed,
    this.actions,
    this.bottomRadius = 30,
  });

  @override
  Widget build(BuildContext context) {
    final hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: preferredSize.height,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shadowColor: AppColors.primaryOf(context).withValues(alpha: 0.22),
      elevation: 8,
      scrolledUnderElevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(bottomRadius),
        ),
      ),
      flexibleSpace: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          gradient: AppColors.headerGradientOf(context),
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(bottomRadius),
          ),
        ),
        child: Stack(
          children: [
            PositionedDirectional(
              top: -42,
              end: -28,
              child: Container(
                width: 132,
                height: 132,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.07),
                ),
              ),
            ),
            PositionedDirectional(
              bottom: -52,
              start: 54,
              child: Container(
                width: 108,
                height: 108,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),
          ],
        ),
      ),
      leadingWidth: 68,
      leading: Padding(
        padding: const EdgeInsetsDirectional.only(start: 16),
        child: Center(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
            ),
            child: IconButton(
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 19,
              ),
            ),
          ),
        ),
      ),
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsetsDirectional.only(end: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.titleLarge.copyWith(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.25,
              ),
            ),
            if (hasSubtitle) ...[
              const SizedBox(height: 4),
              Text(
                subtitle!,
                maxLines: subtitleMaxLines,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.82),
                  fontSize: 12,
                  height: 1.35,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize {
    final hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;
    if (!hasSubtitle) return const Size.fromHeight(72);
    return Size.fromHeight(subtitleMaxLines > 1 ? 98 : 82);
  }
}
