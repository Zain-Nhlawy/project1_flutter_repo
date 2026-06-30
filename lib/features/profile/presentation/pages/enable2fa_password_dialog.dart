import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/l10n/app_localizations.dart';

class Enable2FAPasswordDialog extends StatefulWidget {
  const Enable2FAPasswordDialog({super.key});

  @override
  State<Enable2FAPasswordDialog> createState() =>
      _Enable2FAPasswordDialogState();
}

class _Enable2FAPasswordDialogState
    extends State<Enable2FAPasswordDialog> {
  final _passwordController = TextEditingController();

  bool obscure = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      title: Text(
        local.enableTwoFactorAuth,
        style: AppTextStyles.titleMedium,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            local.enterPasswordToEnable2FA,
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _passwordController,
            obscureText: obscure,
            decoration: InputDecoration(
              labelText: local.password,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  obscure
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    obscure = !obscure;
                  });
                },
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(local.cancel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
          ),
          onPressed: () {
            Navigator.pop(
              context,
              _passwordController.text.trim(),
            );
          },
          child: Text(local.confirm),
        ),
      ],
    );
  }
}