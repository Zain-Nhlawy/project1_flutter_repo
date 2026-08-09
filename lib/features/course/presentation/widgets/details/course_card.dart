import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/course/presentation/widgets/custom_button.dart';
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
        return "Manage";
      case CourseCardMode.demoView:
        return localizations.seeMore;
      case CourseCardMode.demoSelection:
        return localizations.seeMore;
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
        return onSeeMore;
      case CourseCardMode.library:
        return onSeeMore;
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isLibraryMode = mode == CourseCardMode.library;
    final surfaceColor = isLibraryMode
        ? AppColors.surfaceOf(context)
        : AppColors.surface;
    final primaryColor = isLibraryMode
        ? AppColors.primaryOf(context)
        : AppColors.primary;
    final textPrimaryColor = isLibraryMode
        ? AppColors.textPrimaryOf(context)
        : AppColors.textPrimary;
    final textSecondaryColor = isLibraryMode
        ? AppColors.textSecondaryOf(context)
        : AppColors.textSecondary;
    final buttonGradient = isLibraryMode
        ? AppColors.buttonGradientOf(context)
        : AppColors.buttonGradient;
    final displayDescription = description.length > 80
        ? "${description.substring(0, 80)}..."
        : description;

    final bool isFree = price == null || price == 0;
    final String displayPrice = isFree
        ? localizations.free
        : '\$${price!.toStringAsFixed(2)}';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: isLibraryMode
            ? Border.all(color: AppColors.borderOf(context))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: Theme.of(context).brightness == Brightness.dark
                  ? 0.18
                  : 0.05,
            ),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: SizedBox(
                height: 170,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) {
                              return Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 50,
                                  color: textSecondaryColor,
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 50,
                              color: textSecondaryColor,
                            ),
                          ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.25),
                          ],
                        ),
                      ),
                    ),
                    if (visibility != null && mode != CourseCardMode.library)
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                visibility == "PUBLIC"
                                    ? Icons.public
                                    : Icons.lock_outline,
                                size: 14,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                visibility!,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          gradient: isFree
                              ? LinearGradient(
                                  colors: [
                                    Colors.green.shade500,
                                    Colors.green.shade700,
                                  ],
                                )
                              : buttonGradient,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          displayPrice,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.business_rounded,
                          size: 15,
                          color: primaryColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          companyName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    displayDescription,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: textPrimaryColor.withValues(alpha: 0.75),
                    ),
                  ),
                  if (tags.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isLibraryMode
                                  ? AppColors.borderOf(context)
                                  : AppColors.primary,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (mode == CourseCardMode.demoSelection)
                        GestureDetector(
                          onTap: onSelect,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.add_circle_outline,
                              size: 30,
                              color: AppColors.primary,
                            ),
                          ),
                        )
                      else
                        const SizedBox(),

                      SizedBox(
                        width: 126,
                        child: CustomButton(
                          text: _buttonText(localizations),
                          height: 38,
                          onPressed: _buttonAction(),
                          gradient: buttonGradient,
                          expand: false,
                        ),
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
