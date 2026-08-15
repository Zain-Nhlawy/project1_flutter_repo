import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:project1/features/auth/presentation/cubit/auth_state.dart';
import 'package:project1/features/auth/presentation/cubit/user_cubit.dart';
import 'package:project1/features/auth/presentation/cubit/user_state.dart';
import 'package:project1/features/auth/presentation/pages/change_password_screen.dart';
import 'package:project1/features/profile/presentation/pages/enable2fa_screen.dart';
import 'package:project1/l10n/app_localizations.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final authCubit = context.read<AuthCubit>();
    final state = context.watch<UserCubit>().state;
    final user = state is UserLoaded ? state.user : null;
    final topPadding = MediaQuery.paddingOf(context).top;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;

        if (state is TwoFAGenerated) {
          await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => Enable2FAScreen(qrCode: state.qrData),
            ),
          );

          await context.read<UserCubit>().getMe();

          setState(() {
            isLoading = false;
          });
        }

        if (state is TurnOn2FASuccess || state is TurnOff2FASuccess) {
          await context.read<UserCubit>().getMe();

          setState(() {
            isLoading = false;
          });

          final msg = (state is TurnOn2FASuccess)
              ? state.message
              : (state as TurnOff2FASuccess).message;

          SnackbarTheme().newSnackBarInfo(context, msg);
        }
        if (state is AuthError && state.errors.isNotEmpty) {
          SnackbarTheme().newSnackBarError(context, state.errors.first);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundOf(context),
        body: Column(
          children: [
            _SecurityHeader(
              topPadding: topPadding,
              title: local.security,
              subtitle: local.extraSecurityLayer,
            ),
            Expanded(
              child: SingleChildScrollView(
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
                          child: Icon(Icons.lock_outline, color: Colors.blue),
                        ),
                        title: Text(
                          local.changePassword,
                          style: AppTextStyles.titleMedium,
                        ),
                        subtitle: Text(local.enterPasswordToContinue),
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
                        value: user?.isTwoFactorEnabled ?? false,
                        activeThumbColor: AppColors.primary,
                        secondary: const CircleAvatar(
                          backgroundColor: Color(0xFFE8F5E9),
                          child: Icon(Icons.security, color: Colors.green),
                        ),
                        title: Text(
                          local.twoFactorAuth,
                          style: AppTextStyles.titleMedium,
                        ),
                        subtitle: Text(local.extraSecurityLayer),

                        onChanged: isLoading
                            ? null
                            : (value) async {
                                setState(() {
                                  isLoading = true;
                                });

                                if (!value) {
                                  await authCubit.turnOff2FA();
                                  return;
                                }

                                if (user == null) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  return;
                                }


                                await authCubit.generate2FA(
                                  email: user.email,
                                  password: "..",
                                );
                              },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecurityHeader extends StatelessWidget {
  final double topPadding;
  final String title;
  final String subtitle;

  const _SecurityHeader({
    required this.topPadding,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.headerGradientOf(context),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOf(context).withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: topPadding > 0 ? topPadding + 8 : 32,
          left: 20,
          right: 20,
          bottom: 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints.tightFor(
                      width: 38,
                      height: 38,
                    ),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.surface,
                      size: 17,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.surface.withValues(alpha: 0.85),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
