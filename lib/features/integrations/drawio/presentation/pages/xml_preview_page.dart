import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/presentation/widgets/gradient_page_app_bar.dart';
import 'package:project1/l10n/app_localizations.dart';

class XmlPreviewPage extends StatelessWidget {
  final String xml;
  final String filePath;

  const XmlPreviewPage({super.key, required this.xml, required this.filePath});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final title = l10n?.diagramPreview ?? 'Diagram Preview';
    final savedAt = l10n?.savedAt ?? 'Saved at';

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: GradientPageAppBar(title: title, bottomRadius: 0),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.22),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.success,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '$savedAt: $filePath',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondaryOf(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: Container(
                  width: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceOf(context),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.borderOf(context)),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: SelectableText(
                      xml,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontFamily: 'monospace',
                        color: AppColors.textPrimaryOf(context),
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
