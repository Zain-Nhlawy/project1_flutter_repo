import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/l10n/app_localizations.dart';

enum CourseCardMode { ongoing, demoView, demoSelection, library }

class CourseCard extends StatelessWidget {
  final String id;
  final String title;
  final String companyName;
  final String imageUrl;
  final double? price;
  final String description;
  final List<String> tags;
  final String? visibility;
  final bool isPublished;
  final CourseCardMode mode;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onSeeMore;
  final VoidCallback? onSelect;
  final VoidCallback? onBuy;

  const CourseCard({
    super.key,
    required this.id,
    required this.title,
    required this.companyName,
    required this.imageUrl,
    required this.price,
    required this.description,
    this.tags = const [],
    this.visibility,
    this.isPublished = false,
    this.mode = CourseCardMode.demoView,
    this.isSelected = false,
    this.onTap,
    this.onSeeMore,
    this.onSelect,
    this.onBuy,
  });

  String _buttonText(AppLocalizations localizations) {
    switch (mode) {
      case CourseCardMode.ongoing:
        return 'Manage';
      case CourseCardMode.demoView:
      case CourseCardMode.demoSelection:
      case CourseCardMode.library:
        return localizations.seeMore;
    }
  }

  VoidCallback? _buttonAction() {
    switch (mode) {
      case CourseCardMode.ongoing:
        return onTap;
      case CourseCardMode.demoView:
      case CourseCardMode.demoSelection:
      case CourseCardMode.library:
        return onSeeMore;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final primary = AppColors.primaryOf(context);
    final surface = AppColors.surfaceOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);
    final border = AppColors.borderOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isFree = price == null || price == 0;
    final displayPrice = isFree
        ? localizations.free
        : '\$${price!.toStringAsFixed(2)}';
    final visibleTags = tags.take(3).toList();
    final hiddenTagsCount = tags.length - visibleTags.length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 9),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border.withValues(alpha: 0.82)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 184,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (imageUrl.isNotEmpty)
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const _CourseCardFallback(),
                    )
                  else
                    const _CourseCardFallback(),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x12000000),
                          Color(0x00000000),
                          Color(0xA6000000),
                        ],
                        stops: [0, 0.48, 1],
                      ),
                    ),
                  ),
                  if (visibility != null && mode != CourseCardMode.library)
                    PositionedDirectional(
                      top: 14,
                      start: 14,
                      child: _CourseBadge(
                        icon: visibility == 'PUBLIC'
                            ? Icons.public_rounded
                            : Icons.lock_outline_rounded,
                        text: visibility!,
                        foregroundColor: primary,
                        backgroundColor: Colors.white.withValues(alpha: 0.92),
                      ),
                    ),
                  PositionedDirectional(
                    top: 14,
                    end: 14,
                    child: _CourseBadge(
                      icon: isFree
                          ? Icons.check_circle_outline_rounded
                          : Icons.payments_outlined,
                      text: displayPrice,
                      foregroundColor: Colors.white,
                      gradient: isFree
                          ? const LinearGradient(
                              colors: [Color(0xFF16A34A), Color(0xFF15803D)],
                            )
                          : AppColors.buttonGradientOf(context),
                    ),
                  ),
                  PositionedDirectional(
                    start: 16,
                    end: 16,
                    bottom: 14,
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.18),
                            ),
                          ),
                          child: const Icon(
                            Icons.auto_stories_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 9),
                        Text(
                          localizations.courseDetails,
                          style: AppTextStyles.label.copyWith(
                            color: Colors.white.withValues(alpha: 0.90),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 17, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: textPrimary,
                      fontSize: 19,
                      height: 1.25,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.25,
                    ),
                  ),
                  if (companyName.trim().isNotEmpty) ...[
                    const SizedBox(height: 11),
                    Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.business_rounded,
                            size: 16,
                            color: primary,
                          ),
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Text(
                            companyName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.label.copyWith(
                              color: textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (description.trim().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: textSecondary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                  if (visibleTags.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: [
                        ...visibleTags.map(
                          (tag) => _CourseTagChip(text: tag, color: primary),
                        ),
                        if (hiddenTagsCount > 0)
                          _CourseTagChip(
                            text: '+$hiddenTagsCount',
                            color: textSecondary,
                          ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 17),
                  Divider(height: 1, color: border.withValues(alpha: 0.72)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      if (mode == CourseCardMode.demoSelection)
                        _CourseSelectionButton(
                          isSelected: isSelected,
                          onTap: onSelect,
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundOf(context),
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(
                              color: border.withValues(alpha: 0.72),
                            ),
                          ),
                          child: Icon(
                            mode == CourseCardMode.ongoing
                                ? Icons.settings_outlined
                                : Icons.menu_book_outlined,
                            size: 18,
                            color: textSecondary,
                          ),
                        ),
                      const Spacer(),
                      _CourseCardActionButton(
                        text: _buttonText(localizations),
                        icon: mode == CourseCardMode.ongoing
                            ? Icons.tune_rounded
                            : Icons.arrow_forward_rounded,
                        onPressed: _buttonAction(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseCardFallback extends StatelessWidget {
  const _CourseCardFallback();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: AppColors.headerGradientOf(context)),
      child: Center(
        child: Icon(
          Icons.menu_book_rounded,
          size: 58,
          color: Colors.white.withValues(alpha: 0.70),
        ),
      ),
    );
  }
}

class _CourseBadge extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color foregroundColor;
  final Color? backgroundColor;
  final Gradient? gradient;

  const _CourseBadge({
    required this.icon,
    required this.text,
    required this.foregroundColor,
    this.backgroundColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: gradient == null ? backgroundColor : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foregroundColor),
          const SizedBox(width: 5),
          Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w800,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseTagChip extends StatelessWidget {
  final String text;
  final Color color;

  const _CourseTagChip({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _CourseSelectionButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback? onTap;

  const _CourseSelectionButton({required this.isSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);

    return Material(
      color: isSelected
          ? primary
          : primary.withValues(alpha: onTap == null ? 0.05 : 0.09),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(
            isSelected ? Icons.check_rounded : Icons.add_rounded,
            color: isSelected ? Colors.white : primary,
            size: 21,
          ),
        ),
      ),
    );
  }
}

class _CourseCardActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onPressed;

  const _CourseCardActionButton({
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return Container(
      constraints: const BoxConstraints(minWidth: 132),
      height: 42,
      decoration: BoxDecoration(
        gradient: enabled ? AppColors.buttonGradientOf(context) : null,
        color: enabled
            ? null
            : AppColors.textSecondaryOf(context).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: AppColors.primaryOf(context).withValues(alpha: 0.22),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.label.copyWith(
                      color: enabled
                          ? Colors.white
                          : AppColors.textSecondaryOf(context),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                Icon(
                  icon,
                  size: 17,
                  color: enabled
                      ? Colors.white
                      : AppColors.textSecondaryOf(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
