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
    final isRestricted = daysLeft <= 0;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: size.height * 0.02),
      padding: EdgeInsets.all(size.width * 0.045),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
          SizedBox(width: size.width * 0.04),
          DemoMainContent(
            demo: demo,
            size: size,
            textScale: textScale,
            localizations: localizations,
            isRestricted: isRestricted,
          ),
        ],
      ),
    );
  }
}
