import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/auth/presentation/pages/change_password_screen.dart';
import 'package:project1/l10n/app_localizations.dart';

class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(localizations.security),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE3F2FD),
                  child: Icon(
                    Icons.lock_outline,
                    color: Colors.blue,
                  ),
                ),
                title: Text(
                  localizations.changePassword,
                  style: AppTextStyles.titleMedium,
                ),
                subtitle: Text(
                  localizations.enterPasswordToContinue,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ChangePasswordScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SwitchListTile(
                value: false,
                onChanged: (value) {},
                secondary: const CircleAvatar(
                  backgroundColor: Color(0xFFE8F5E9),
                  child: Icon(
                    Icons.security,
                    color: Colors.green,
                  ),
                ),
                title: Text(
                  localizations.twoFactorAuth,
                  style: AppTextStyles.titleMedium,
                ),
                subtitle: Text(
                  localizations.extraSecurityLayer,
                ),
                activeColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}