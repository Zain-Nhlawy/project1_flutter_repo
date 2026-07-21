import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/demo/domain/entities/demo_entity.dart';
import 'package:project1/features/demo/presentation/widgets/demo_card_widgets/demo_main_content.dart';
import 'package:project1/features/demo/presentation/widgets/demo_card_widgets/demo_side_panel.dart';
import 'package:project1/l10n/app_localizations.dart';

class DemoCard extends StatelessWidget {
  final DemoEntity demo;

  const DemoCard({super.key, required this.demo});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final localizations = AppLocalizations.of(context)!;

    final createdAt = demo.createdAt ?? DateTime.now();
    final daysPassed = DateTime.now().difference(createdAt).inDays;
    final daysLeft = 14 - daysPassed;
    final isRestricted = daysLeft <= 0 && (demo.plan?.toLowerCase() == 'free');

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: isRestricted
            ? Border.all(color: Colors.red.withOpacity(0.25), width: 1)
            : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withOpacity(0.3),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isRestricted)
              Container(width: 4, color: Colors.red.withOpacity(0.6)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DemoSidePanel(
                      demo: demo,
                      size: size,
                      textScale: textScale,
                      localizations: localizations,
                      isRestricted: isRestricted,
                      daysLeft: daysLeft,
                    ),
                    const SizedBox(width: 16),
                    DemoMainContent(
                      demo: demo,
                      size: size,
                      textScale: textScale,
                      localizations: localizations,
                      isRestricted: isRestricted,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
