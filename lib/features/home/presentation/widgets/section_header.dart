import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/demo/domain/entities/demo_entity.dart';
import 'package:project1/features/demo/presentation/pages/demos_page.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:animations/animations.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final List<DemoEntity> demoList;

  const SectionHeader({super.key, required this.title, required this.demoList});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final primary = AppColors.primaryOf(context);

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: AppColors.buttonGradientOf(context),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textPrimaryOf(context),
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              if (demoList.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    demoList.length.toString(),
                    style: AppTextStyles.caption.copyWith(
                      color: primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        TextButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (context, animation, secondaryAnimation) =>
                    DemosPage(title: title, demos: demoList),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      return FadeThroughTransition(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        child: child,
                      );
                    },
              ),
            );
          },
          style: TextButton.styleFrom(
            foregroundColor: primary,
            backgroundColor: primary.withValues(alpha: 0.07),
            minimumSize: Size.zero,
            padding: const EdgeInsetsDirectional.fromSTEB(11, 8, 9, 8),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          iconAlignment: IconAlignment.end,
          icon: const Icon(Icons.arrow_forward_rounded, size: 16),
          label: Text(
            localizations.seeAll,
            style: AppTextStyles.label.copyWith(
              color: primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
