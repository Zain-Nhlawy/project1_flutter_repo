import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:project1/features/auth/presentation/cubit/auth_state.dart';
import 'package:project1/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:project1/features/auth/presentation/pages/signup_screen.dart';
import 'package:project1/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:project1/features/home/presentation/pages/navigations_tabs.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:project1/features/auth/presentation/pages/verify_2fa_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(AppLocalizations localizations) {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.pleaseEnterEmailPassword),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final body = {
      "email": emailController.text.trim(),
      "password": passwordController.text,
    };

    context.read<AuthCubit>().login(body);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final localizations = AppLocalizations.of(context)!;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is LoginRequires2FA) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  Verify2FAScreen(twoFactorToken: state.twoFactorToken),
            ),
          );
          return;
        }
        if (state is LoginSuccess) {
          final messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(
            SnackBar(
              content: Text(localizations.loginSuccessful),
              backgroundColor: AppColors.success,
              duration: const Duration(milliseconds: 500),
            ),
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            messenger.clearSnackBars();
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const NavigationsTabs()),
              );
            }
          });
        } else if (state is AuthError && state.errors.isNotEmpty) {
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
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 500 : double.infinity,
                ),
                child: Column(
                  children: [
                    Container(
                      height: size.height * 0.35,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: AppColors.headerGradient,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(50),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/main.png',
                            height: size.height * 0.22,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: size.height * 0.01),
                          Text(
                            localizations.welcomeBack,
                            style: AppTextStyles.h2.copyWith(
                              color: AppColors.surface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            localizations.diveBackLearning,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 32 : 24,
                        vertical: 30,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.signIn,
                            style: AppTextStyles.h3.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 25),
                          CustomTextField(
                            hintText: localizations.emailAddressHint,
                            icon: Icons.email_outlined,
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            hintText: localizations.passwordHint,
                            isPassword: true,
                            icon: Icons.lock_outline,
                            controller: passwordController,
                            onSubmitted: (_) => _handleLogin(localizations),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                localizations.forgotPasswordLink,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              final isLoading = state is AuthLoading;
                              return SizedBox(
                                width: double.infinity,
                                height: 58,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: AppColors.buttonGradient,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(
                                          0.25,
                                        ),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    onPressed: isLoading
                                        ? null
                                        : () => _handleLogin(localizations),
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
                                              localizations.logInBtn,
                                              style: AppTextStyles.titleMedium
                                                  .copyWith(
                                                    color: AppColors.surface,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 25),
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(color: AppColors.border),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Text(
                                  localizations.orDivider,
                                  style: AppTextStyles.label.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(color: AppColors.border),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          OutlinedButton.icon(
                            onPressed: () {
                              context.read<AuthCubit>().loginWithGoogle();
                            },
                            icon: Image.asset(
                              'assets/images/google.png',
                              height: isTablet ? 24 : 22,
                            ),
                            label: Text(
                              localizations.continueWithGoogle,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 56),
                              backgroundColor: AppColors.surface,
                              side: const BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                localizations.dontHaveAccount,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SignupScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  localizations.signUpLink,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
