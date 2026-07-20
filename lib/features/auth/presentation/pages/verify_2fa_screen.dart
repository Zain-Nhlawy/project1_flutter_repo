import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:project1/features/auth/presentation/cubit/auth_state.dart';
import 'package:project1/features/home/presentation/pages/navigations_tabs.dart';
import 'package:project1/l10n/app_localizations.dart';

class Verify2FAScreen extends StatefulWidget {
  final String twoFactorToken;

  const Verify2FAScreen({super.key, required this.twoFactorToken});

  @override
  State<Verify2FAScreen> createState() => _Verify2FAScreenState();
}

class _Verify2FAScreenState extends State<Verify2FAScreen> {
  final TextEditingController codeController = TextEditingController();

  void verify() {
    if (codeController.text.length != 6) return;

    context.read<AuthCubit>().verify2FA(
      twoFactorToken: widget.twoFactorToken,
      tfaCode: codeController.text,
    );
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const NavigationsTabs()),
            (route) => false,
          );
        }

        if (state is AuthError && state.errors.isNotEmpty) {
          final messenger = ScaffoldMessenger.of(context);

          messenger.clearSnackBars();

          messenger.showSnackBar(
            SnackBar(
              content: Text(state.errors.first),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, size: 80, color: AppColors.primary),

                const SizedBox(height: 20),

                Text(
                  loc.twoFactorAuth,
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  loc.verify2FASubtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 30),

                Pinput(
                  length: 6,
                  controller: codeController,
                  keyboardType: TextInputType.number,
                  defaultPinTheme: PinTheme(
                    width: 50,
                    height: 55,
                    textStyle: AppTextStyles.h3,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final loading = state is AuthLoading;

                    return SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: loading ? null : verify,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                loc.verifyCode,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
