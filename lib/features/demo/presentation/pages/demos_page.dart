import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/demo/domain/entities/demo_entity.dart';
import 'package:project1/features/demo/presentation/widgets/demo_card_widgets/demo_card.dart';
import 'package:project1/l10n/app_localizations.dart';

class DemosPage extends StatelessWidget {
  final String title;
  final List<DemoEntity> demos;

  const DemosPage({super.key, required this.title, required this.demos});

  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
        ),
        title: Text(
          title,
          style: AppTextStyles.h3.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20 * textScale,
          ),
        ),
        centerTitle: true,
      ),
      body: demos.isEmpty
          ? Center(
              child: Text(
                localizations.noDemosAvailable,
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20 * textScale,
                ),
              ),
            )
          : SafeArea(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: demos.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: DemoCard(demo: demos[index]),
                  );
                },
              ),
            ),
    );
  }
}
