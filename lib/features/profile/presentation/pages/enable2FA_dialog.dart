import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/l10n/app_localizations.dart';

class Enable2FADialog extends StatelessWidget {
  const Enable2FADialog({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(local.enableTwoFactorAuth),
      content: Text(local.enableTwoFactorAuthMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(local.cancel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text(local.confirm),
        ),
      ],
    );
  }
}