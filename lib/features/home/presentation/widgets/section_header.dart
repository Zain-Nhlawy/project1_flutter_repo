import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/demo/domain/entities/demo_entity.dart';
import 'package:project1/features/demo/presentation/pages/demos_page.dart';
import 'package:project1/l10n/app_localizations.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final List<DemoEntity> demoList;

  const SectionHeader({super.key, required this.title, required this.demoList});

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final localizations = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.h3.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20 * textScale,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DemosPage(title: title, demos: demoList),
              ),
            );
          },
          child: Text(
            localizations.seeAll,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 14 * textScale,
            ),
          ),
        ),
      ],
    );
  }
}
