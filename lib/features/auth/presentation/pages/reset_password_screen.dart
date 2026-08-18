import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/features/auth/domain/validators/password_validator.dart';
import 'package:project1/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:project1/features/auth/presentation/cubit/auth_state.dart';
import 'package:project1/features/auth/presentation/cubit/session_cubit.dart';
import 'package:project1/features/auth/presentation/pages/session_gate.dart';
import 'package:project1/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:project1/features/auth/presentation/widgets/password_requirements_hint.dart';
import 'package:project1/l10n/app_localizations.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String token;
  const ResetPasswordScreen({super.key, required this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetPassword(AppLocalizations localizations) {
    if (passwordController.text.isEmpty) {
      SnackbarTheme().newSnackBarError(
        context,
        localizations.pleaseEnterNewPassword,
      );
      return;
    }

    if (!PasswordValidator.isValid(passwordController.text)) {
      SnackbarTheme().newSnackBarError(
        context,
        localizations.passwordRequirementsError,
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      SnackbarTheme().newSnackBarError(
        context,
        localizations.passwordsDoNotMatch,
      );
      return;
    }

    final body = {"token": widget.token, "password": passwordController.text};

    context.read<AuthCubit>().resetPassword(body);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final localizations = AppLocalizations.of(context)!;
    final primary = AppColors.primaryOf(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: AppColors.surfaceOf(context),
              surfaceTintColor: Colors.transparent,
              title: Text(
                localizations.successTitle,
                style: TextStyle(color: AppColors.textPrimaryOf(context)),
              ),
              content: Text(
                state.message,
                style: TextStyle(color: AppColors.textSecondaryOf(context)),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await context.read<SessionCubit>().clearSession();
                    if (!context.mounted) return;
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const SessionGate()),
                      (route) => false,
                    );
                  },
                  child: Text(localizations.goToLoginBtn),
                ),
              ],
            ),
          );
        } else if (state is AuthError && state.errors.isNotEmpty) {
          SnackbarTheme().newSnackBarError(context, state.errors.first);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundOf(context),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.textPrimaryOf(context),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            localizations.resetPasswordScreenTitle,
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textPrimaryOf(context),
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32 : 24,
                  vertical: 20,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isTablet ? 500 : double.infinity,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.lock_reset_outlined,
                        size: 80,
                        color: primary,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        localizations.createNewPassword,
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.textPrimaryOf(context),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        localizations.enterNewPasswordBelow,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondaryOf(context),
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomTextField(
                        hintText: localizations.newPasswordHint,
                        isPassword: true,
                        icon: Icons.lock_outline,
                        controller: passwordController,
                      ),
                      PasswordRequirementsHint(controller: passwordController),
                      const SizedBox(height: 16),
                      CustomTextField(
                        hintText: localizations.confirmPasswordHint,
                        isPassword: true,
                        icon: Icons.lock_outline,
                        controller: confirmPasswordController,
                        onSubmitted: (_) => _handleResetPassword(localizations),
                      ),
                      const SizedBox(height: 30),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          final isLoading = state is AuthLoading;
                          return SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: AppColors.buttonGradientOf(context),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: primary.withValues(alpha: 0.25),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () => _handleResetPassword(localizations),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Center(
                                  child: isLoading
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          localizations.resetPasswordBtn,
                                          style: AppTextStyles.titleMedium
                                              .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
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
          ),
        ),
      ),
    );
  }
}