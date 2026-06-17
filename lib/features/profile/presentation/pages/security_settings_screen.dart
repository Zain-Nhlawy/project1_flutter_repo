import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';

class SecuritySettingsScreen extends StatelessWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Security"),
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
                  "Change Password",
                  style: AppTextStyles.titleMedium,
                ),
                subtitle: const Text(
                  "Update your account password",
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
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
                onChanged: (value) {
                },
                secondary: const CircleAvatar(
                  backgroundColor: Color(0xFFE8F5E9),
                  child: Icon(
                    Icons.security,
                    color: Colors.green,
                  ),
                ),
                title: Text(
                  "Two-Factor Authentication",
                  style: AppTextStyles.titleMedium,
                ),
                subtitle: const Text(
                  "Add an extra layer of security",
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