import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/l10n/app_localizations.dart'; 

class XmlPreviewPage extends StatelessWidget {
  final String xml;
  final String filePath;

  const XmlPreviewPage({
    super.key,
    required this.xml,
    required this.filePath,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final title = l10n?.diagramPreview ?? 'Diagram Preview';
    final savedAt = l10n?.savedAt ?? 'Saved at';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(title, style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.success.withOpacity(0.1),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: AppColors.success),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '$savedAt: $filePath',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SelectableText(
                xml,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontFamily: 'monospace',
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}