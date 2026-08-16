import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:project1/features/certification/presentation/pages/my_certifications_screen.dart';
import 'package:project1/features/profile/presentation/cubit/locale_cubit.dart';
import 'package:project1/features/profile/presentation/cubit/theme_cubit.dart';
import 'package:project1/features/profile/presentation/cubit/notification_cubit.dart';
import 'package:project1/features/auth/presentation/cubit/user_cubit.dart';
import 'package:project1/features/auth/presentation/cubit/user_state.dart';
import 'package:project1/features/profile/presentation/pages/security_settings_screen.dart';
import 'package:project1/features/profile/presentation/pages/about_us_screen.dart';
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
    final themeCubit = context.watch<ThemeCubit>();
    final isDark = themeCubit.isDark;
    final notifCubit = context.watch<NotificationCubit>();
    final isNotifEnabled = notifCubit.isEnabled;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
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
                  decoration: BoxDecoration(
                    gradient: AppColors.headerGradientOf(context),
                    borderRadius: const BorderRadius.vertical(
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
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24 * textScale,
                        ),
                      ),
                      SizedBox(height: size.height * 0.005),
                      Text(
                        localizations.manageAccount,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
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
                          color: AppColors.surfaceOf(context),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            ProfileTile(
                              icon: isDark
                                  ? Icons.dark_mode_outlined
                                  : Icons.light_mode_outlined,
                              iconBackgroundColor: isDark
                                  ? Colors.indigo
                                  : Colors.lightBlue,
                              iconColor: isDark
                                  ? Colors.indigo
                                  : Colors.lightBlue,
                              title: localizations.tileTheme,
                              trailing: Row(
                                children: [
                                  Text(
                                    isDark
                                        ? localizations.themeDark
                                        : localizations.themeLight,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondaryOf(context),
                                      fontSize: 14 * textScale,
                                    ),
                                  ),
                                  Switch(
                                    value: isDark,
                                    onChanged: (val) {
                                      context.read<ThemeCubit>().toggleTheme(
                                        val,
                                      );
                                    },
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
                                  color: AppColors.primaryOf(context),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14 * textScale,
                                ),
                              ),
                            ),
                            ProfileTile(
                              icon: isNotifEnabled
                                  ? Icons.notifications_active_outlined
                                  : Icons.notifications_off_outlined,
                              iconBackgroundColor: isNotifEnabled
                                  ? Colors.purple
                                  : Colors.blueGrey,
                              iconColor: isNotifEnabled
                                  ? Colors.purple
                                  : Colors.blueGrey,
                              title: localizations.tileNotifications,
                              showDivider: true,
                              onTap: () {
                                context
                                    .read<NotificationCubit>()
                                    .toggleNotifications(
                                      context,
                                      !isNotifEnabled,
                                    );
                              },
                              trailing: Row(
                                children: [
                                  Text(
                                    isNotifEnabled
                                        ? localizations.notifOn
                                        : localizations.notifOff,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondaryOf(context),
                                      fontSize: 14 * textScale,
                                    ),
                                  ),
                                  Switch(
                                    value: isNotifEnabled,
                                    onChanged: (val) {
                                      context
                                          .read<NotificationCubit>()
                                          .toggleNotifications(context, val);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            ProfileTile(
                              icon: Icons.workspace_premium_rounded,
                              iconBackgroundColor: Colors.amber,
                              iconColor: Colors.amber,
                              title: localizations.tileMyCertificates,
                              showDivider: false,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const MyCertificationsPage(),
                                  ),
                                );
                              },
                              trailing: const Icon(Icons.chevron_right),
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
                          color: AppColors.surfaceOf(context),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            ProfileTile(
                              icon: Icons.info_outline_rounded,
                              iconBackgroundColor: Colors.teal,
                              iconColor: Colors.teal,
                              title: localizations.tileAboutUs,
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AboutUsScreen(),
                                  ),
                                );
                              },
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
                                    builder: (_) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider.value(
                                          value: context.read<UserCubit>(),
                                        ),
                                        BlocProvider.value(
                                          value: context.read<AuthCubit>(),
                                        ),
                                      ],
                                      child: const SecuritySettingsScreen(),
                                    ),
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
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.02,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceOf(context),
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
      backgroundColor: AppColors.surfaceOf(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        final isAr = currentLocale == 'ar';
        final isEn = currentLocale == 'en';

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.language_rounded,
                    color: isAr
                        ? AppColors.primaryOf(context)
                        : AppColors.textSecondaryOf(context),
                  ),
                  title: Text(
                    "العربية",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isAr
                          ? AppColors.primaryOf(context)
                          : AppColors.textPrimaryOf(context),
                      fontWeight: isAr ? FontWeight.bold : FontWeight.normal,
                      fontSize: 15 * textScale,
                    ),
                  ),
                  trailing: isAr
                      ? Icon(
                          Icons.check_rounded,
                          color: AppColors.primaryOf(context),
                        )
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    context.read<LocaleCubit>().changeLanguage('ar');
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.language_rounded,
                    color: isEn
                        ? AppColors.primaryOf(context)
                        : AppColors.textSecondaryOf(context),
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.englishLanguage,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isEn
                          ? AppColors.primaryOf(context)
                          : AppColors.textPrimaryOf(context),
                      fontWeight: isEn ? FontWeight.bold : FontWeight.normal,
                      fontSize: 15 * textScale,
                    ),
                  ),
                  trailing: isEn
                      ? Icon(
                          Icons.check_rounded,
                          color: AppColors.primaryOf(context),
                        )
                      : null,
                  onTap: () {
                    Navigator.pop(context);
                    context.read<LocaleCubit>().changeLanguage('en');
                  },
                ),
              ],
            ),
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
    if (!context.mounted) return;

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