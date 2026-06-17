import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/profile/presentation/pages/security_settings_screen.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/profile_section_title.dart';
import '../widgets/profile_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: size.height * 0.32,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppColors.headerGradient,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(35),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.08),
                  Text(
                    "Profile",
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.bold,
                      fontSize: 24 * textScale,
                    ),
                  ),
                  SizedBox(height: size.height * 0.005),
                  Text(
                    "Manage your account",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.surface.withOpacity(0.8),
                      fontSize: 14 * textScale,
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  const ProfileInfoCard(),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: ProfileSectionTitle(title: "Preferences"),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        ProfileTile(
                          icon: Icons.light_mode_outlined,
                          iconBackgroundColor: Colors.lightBlue,
                          iconColor: Colors.lightBlue,
                          title: "Theme",
                          trailing: Row(
                            children: [
                              Text(
                                "Light",
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 14 * textScale,
                                ),
                              ),
                              SizedBox(width: size.width * 0.02),
                              Switch(
                                value: false,
                                onChanged: (val) {},
                                activeColor: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                        ProfileTile(
                          icon: Icons.language_rounded,
                          iconBackgroundColor: Colors.teal,
                          iconColor: Colors.teal,
                          title: "Language",
                          trailing: Row(
                            children: [
                              Text(
                                "English",
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14 * textScale,
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: AppColors.textSecondary,
                                size: 20 * textScale,
                              ),
                            ],
                          ),
                        ),
                        ProfileTile(
                          icon: Icons.notifications_none_rounded,
                          iconBackgroundColor: Colors.purple,
                          iconColor: Colors.purple,
                          title: "Notifications",
                          showDivider: false,
                          trailing: Row(
                            children: [
                              Text(
                                "On",
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 14 * textScale,
                                ),
                              ),
                              SizedBox(width: size.width * 0.02),
                              Switch(
                                value: true,
                                onChanged: (val) {},
                                activeColor: AppColors.surface,
                                activeTrackColor: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: ProfileSectionTitle(title: "Support"),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        ProfileTile(
                          icon: Icons.chat_bubble_outline_rounded,
                          iconBackgroundColor: Colors.orange,
                          iconColor: Colors.orange,
                          title: "Message Admins",
                          trailing: Icon(
                            Icons.chevron_right,
                            color: AppColors.textSecondary,
                            size: 20 * textScale,
                          ),
                        ),
                        ProfileTile(
                          icon: Icons.help_outline_rounded,
                          iconBackgroundColor: Colors.green,
                          iconColor: Colors.green,
                          title: "Help & FAQ",
                          trailing: Icon(
                            Icons.chevron_right,
                            color: AppColors.textSecondary,
                            size: 20 * textScale,
                          ),
                        ),
                        ProfileTile(
                          icon: Icons.shield_outlined,
                          iconBackgroundColor: Colors.blue,
                          iconColor: Colors.blue,
                          title: "Privacy Policy",
                          showDivider: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SecuritySettingsScreen(),
                              ),
                            );
                          },
                          trailing: Icon(
                            Icons.chevron_right,
                            color: AppColors.textSecondary,
                            size: 20 * textScale,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.02,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: Colors.redAccent,
                            size: 20 * textScale,
                          ),
                          SizedBox(width: size.width * 0.02),
                          Text(
                            "Log Out",
                            style: AppTextStyles.titleMedium.copyWith(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w600,
                              fontSize: 16 * textScale,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
