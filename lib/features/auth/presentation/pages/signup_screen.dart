import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:project1/features/auth/presentation/cubit/auth_state.dart';
import 'package:project1/features/auth/presentation/pages/login_screen.dart';
import 'package:project1/features/auth/presentation/pages/verify_email_screen.dart';
import 'package:project1/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:project1/features/auth/presentation/widgets/date_picker_field.dart';
import 'package:project1/features/auth/presentation/widgets/image_picker_widget.dart';
import 'package:project1/l10n/app_localizations.dart';

class SignupScreen extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;
    final localizations = AppLocalizations.of(context)!;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VerifyEmailScreen(
                email: emailController.text,
              ),
            ),
          );
        }

        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isTablet ? 520 : double.infinity,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: isTablet ? 180 : 150,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: AppColors.headerGradient,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(40),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              localizations.createAccountTitle,
                              style: AppTextStyles.h2.copyWith(
                                color: AppColors.surface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              localizations.startLearningToday,
                              textAlign: TextAlign.center,
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
                          vertical: 20,
                        ),
                        child: Column(
                          children: [
                            const ImagePickerWidget(),
                            SizedBox(height: isTablet ? 28 : 20),

                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    controller: firstNameController,
                                    hintText: localizations.firstNameHint,
                                    icon: Icons.person_outline,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CustomTextField(
                                    controller: lastNameController,
                                    hintText: localizations.lastNameHint,
                                    icon: Icons.person_outline,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            CustomTextField(
                              controller: emailController,
                              hintText: localizations.emailAddressHint,
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                            ),

                            const SizedBox(height: 16),

                            DatePickerField(
                              controller: dobController,
                            ),

                            const SizedBox(height: 16),

                            CustomTextField(
                              controller: passwordController,
                              hintText: localizations.passwordHint,
                              isPassword: true,
                              icon: Icons.lock_outline,
                            ),

                            const SizedBox(height: 16),

                            CustomTextField(
                              controller: confirmPasswordController,
                              hintText: localizations.confirmPasswordHint,
                              isPassword: true,
                              icon: Icons.lock_outline,
                            ),

                            SizedBox(height: isTablet ? 30 : 25),

                            isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : SizedBox(
                                    width: double.infinity,
                                    height: 56,
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
                                        onPressed: () {
                                          if (passwordController.text !=
                                              confirmPasswordController.text) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  localizations.passwordsDoNotMatch,
                                                ),
                                              ),
                                            );
                                            return;
                                          }

                                          context.read<AuthCubit>().register({
                                            "firstName": firstNameController.text,
                                            "lastName": lastNameController.text,
                                            "imagePath": "123456789",
                                            "birthDate": dobController.text,
                                            "email": emailController.text,
                                            "password": passwordController.text,
                                          });
                                        },
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
                                            localizations.createAccountBtn,
                                            style: AppTextStyles.titleMedium.copyWith(
                                              color: AppColors.surface,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                            const SizedBox(height: 20),

                            OutlinedButton.icon(
                              onPressed: () {
                                context.read<AuthCubit>().loginWithGoogle();
                              },
                              icon: Image.asset(
                                'assets/images/google.png',
                                height: 24,
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
                                  localizations.alreadyHaveAccount,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    localizations.logInLink,
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
      },
    );
  }
}


