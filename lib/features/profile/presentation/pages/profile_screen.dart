import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:project1/features/auth/presentation/pages/login_screen.dart';
import 'package:project1/features/profile/presentation/cubit/locale_cubit.dart';
import 'package:project1/features/auth/presentation/cubit/user_cubit.dart';
import 'package:project1/features/auth/presentation/cubit/user_state.dart';
import 'package:project1/features/profile/presentation/pages/security_settings_screen.dart';
import 'package:project1/l10n/app_localizations.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/profile_section_title.dart'; 
import '../widgets/profile_tile.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final localizations = AppLocalizations.of(context)!;
    final currentLocale = context.watch<LocaleCubit>().state.languageCode;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          String name = "";
          String email = "";
          String image = "";

          if (state is UserLoaded) {
            name = "${state.user.firstName} ${state.user.lastName}";
            email = state.user.email;
            image = state.user.imagePath;
          }

          return SingleChildScrollView(
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
                        localizations.profileTitle,
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.surface,
                          fontWeight: FontWeight.bold,
                          fontSize: 24 * textScale,
                        ),
                      ),
                      SizedBox(height: size.height * 0.005),
                      Text(
                        localizations.manageAccount,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.surface.withOpacity(0.8),
                          fontSize: 14 * textScale,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),

                      ProfileInfoCard(
                      name: name,
                      email: email,
                      imagePath: image,
                      onImageTap: () => _pickAndUploadImage(context),
                    ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: ProfileSectionTitle(
                          title: localizations.secPreferences,
                        ),
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
                              title: localizations.tileTheme,
                              trailing: Row(
                                children: [
                                  Text(
                                    localizations.themeLight,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 14 * textScale,
                                    ),
                                  ),
                                  Switch(
                                    value: false,
                                    onChanged: (val) {},
                                  ),
                                ],
                              ),
                            ),
                            ProfileTile(
                              icon: Icons.language_rounded,
                              iconBackgroundColor: Colors.teal,
                              iconColor: Colors.teal,
                              title: localizations.tileLanguage,
                              onTap: () {
                                _showLanguageBottomSheet(
                                  context,
                                  currentLocale,
                                  textScale,
                                );
                              },
                              trailing: Text(
                                currentLocale == 'ar' ? 'العربية' : 'English',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14 * textScale,
                                ),
                              ),
                            ),
                            ProfileTile(
                              icon: Icons.notifications_none_rounded,
                              iconBackgroundColor: Colors.purple,
                              iconColor: Colors.purple,
                              title: localizations.tileNotifications,
                              showDivider: false,
                              trailing: Switch(
                                value: true,
                                onChanged: (val) {},
                              ),
                            ),
                          ],
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: ProfileSectionTitle(
                          title: localizations.secSupport,
                        ),
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
                              title: localizations.tileMessageAdmins,
                              trailing: const Icon(Icons.chevron_right),
                            ),
                            ProfileTile(
                              icon: Icons.help_outline_rounded,
                              iconBackgroundColor: Colors.green,
                              iconColor: Colors.green,
                              title: localizations.tileHelpFAQ,
                              trailing: const Icon(Icons.chevron_right),
                            ),
                            ProfileTile(
                              icon: Icons.shield_outlined,
                              iconBackgroundColor: Colors.blue,
                              iconColor: Colors.blue,
                              title: localizations.tilePrivacyPolicy,
                              showDivider: false,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const SecuritySettingsScreen(),
                                  ),
                                );
                              },
                              trailing: const Icon(Icons.chevron_right),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: size.height * 0.03),

                      InkWell(
                        onTap: () async {
                          await context.read<AuthCubit>().logout();
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
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
                              const Icon(
                                Icons.logout_rounded,
                                color: Colors.redAccent,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                localizations.btnLogOut,
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w600,
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
          );
        },
      ),
    );
  }

  void _showLanguageBottomSheet(
    BuildContext context,
    String currentLocale,
    double textScale,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("العربية"),
                onTap: () {
                  Navigator.pop(context);
                  context.read<LocaleCubit>().changeLanguage('ar');
                },
              ),
              ListTile(
                title: const Text("English"),
                onTap: () {
                  Navigator.pop(context);
                  context.read<LocaleCubit>().changeLanguage('en');
                },
              ),
            ],
          ),
        );
      },
    );
  }
  Future<void> _pickAndUploadImage(BuildContext context) async {
  final picker = ImagePicker();

  final XFile? file = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 80,
  );

  if (file == null) return;

  final userState = context.read<UserCubit>().state;

  if (userState is! UserLoaded) {
    return;
  }

  final imageFile = File(file.path);

  await context.read<UserCubit>().updateProfileImage(
    imageFile,
    userState.user.id,
  );
}
}