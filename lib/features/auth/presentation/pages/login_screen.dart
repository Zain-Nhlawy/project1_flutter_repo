import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/auth/presentation/widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
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
                          "Welcome Back!",
                          style: AppTextStyles.h2.copyWith(
                            color: AppColors.surface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Dive back into your learning",
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
                          "Sign In",
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 25),
                        const CustomTextField(
                          hintText: 'Email Address',
                          icon: Icons.email_outlined,
                        ),
                        const SizedBox(height: 16),
                        const CustomTextField(
                          hintText: 'Password',
                          isPassword: true,
                          icon: Icons.lock_outline,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password?',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: AppColors.buttonGradient,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.25),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "Log In",
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.surface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                color: AppColors.border,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "OR",
                                style: AppTextStyles.label.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                color: AppColors.border,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: Image.asset(
                            'assets/images/google.png',
                            height: isTablet ? 24 : 22,
                          ),
                          label: Text(
                            "Continue with Google",
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                            backgroundColor: AppColors.surface,
                            side: const BorderSide(
                              color: AppColors.border,
                            ),
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
                              "Don't have an account?",
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Sign Up",
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
    );
  }
}