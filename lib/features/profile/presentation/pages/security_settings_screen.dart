import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:project1/features/auth/presentation/cubit/auth_state.dart';
import 'package:project1/features/auth/presentation/cubit/user_cubit.dart';
import 'package:project1/features/auth/presentation/cubit/user_state.dart';
import 'package:project1/features/auth/presentation/pages/change_password_screen.dart';
import 'package:project1/features/profile/presentation/pages/enable2fa_password_dialog.dart';
import 'package:project1/features/profile/presentation/pages/enable2fa_screen.dart';
import 'package:project1/l10n/app_localizations.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() =>
      _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool is2FAEnabled = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final authCubit = context.read<AuthCubit>();
    final state = context.watch<UserCubit>().state;
    final user = state is UserLoaded ? state.user : null;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is TwoFAGenerated) {
  final enabled = await Navigator.push<bool>(
    context,
    MaterialPageRoute(
      builder: (_) => Enable2FAScreen(
        qrCode: state.qrData,
      ),
    ),
  );

          if (enabled == true) {
            setState(() {
              is2FAEnabled = true;
            });
          }

          setState(() {
            isLoading = false;
          });
        }

        if (state is AuthError) {
          setState(() {
            isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(local.security),
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
                    local.changePassword,
                    style: AppTextStyles.titleMedium,
                  ),
                  subtitle: Text(
                    local.enterPasswordToContinue,
                  ),
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
                  value: is2FAEnabled,
                  activeColor: AppColors.primary,
                  secondary: const CircleAvatar(
                    backgroundColor: Color(0xFFE8F5E9),
                    child: Icon(
                      Icons.security,
                      color: Colors.green,
                    ),
                  ),
                  title: Text(
                    local.twoFactorAuth,
                    style: AppTextStyles.titleMedium,
                  ),
                  subtitle: Text(
                    local.extraSecurityLayer,
                  ),
                  onChanged: isLoading
                      ? null
                      : (value) async {
                          if (!value) {
                            setState(() {
                              is2FAEnabled = false;
                            });
                            return;
                          }

                          if (user == null) {
                            return;
                          }

                          final password = await showDialog<String>(
                            context: context,
                            builder: (_) =>
                                const Enable2FAPasswordDialog(),
                          );

                          if (password == null || password.isEmpty) {
                            return;
                          }

                          setState(() {
                            isLoading = true;
                          });

                          authCubit.generate2FA(
                            email: user.email,
                            password: password,
                          );
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:project1/config/theme/app_colors.dart';
// import 'package:project1/config/theme/app_text_styles.dart';
// import 'package:project1/features/auth/presentation/cubit/auth_cubit.dart';
// import 'package:project1/features/auth/presentation/cubit/auth_state.dart';
// import 'package:project1/features/auth/presentation/cubit/user_cubit.dart';
// import 'package:project1/features/auth/presentation/cubit/user_state.dart';
// import 'package:project1/features/auth/presentation/pages/change_password_screen.dart';
// import 'package:project1/features/profile/presentation/pages/enable2fa_password_dialog.dart';
// import 'package:project1/features/profile/presentation/pages/enable2fa_screen.dart';
// import 'package:project1/l10n/app_localizations.dart';

// class SecuritySettingsScreen extends StatefulWidget {
//   const SecuritySettingsScreen({super.key});

//   @override
//   State<SecuritySettingsScreen> createState() =>
//       _SecuritySettingsScreenState();
// }

// class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
//   bool isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     final local = AppLocalizations.of(context)!;
//     final authCubit = context.read<AuthCubit>();
//     final state = context.watch<UserCubit>().state;
//     final user = state is UserLoaded ? state.user : null;

//     return BlocListener<AuthCubit, AuthState>(
//       listener: (context, state) async {
//         if (state is TwoFAGenerated) {
//           setState(() {
//             isLoading = false;
//           });

//           final result = await Navigator.push<bool>(
//             context,
//             MaterialPageRoute(
//               builder: (_) => Enable2FAScreen(
//                 qrCode: state.qrData,
//               ),
//             ),
//           );

//           if (result == true) {
//             setState(() {});
//           }
//         }

//         if (state is TurnOn2FASuccess) {
//           setState(() {
//             isLoading = false;
//           });
//         }

//         if (state is AuthError) {
//           setState(() {
//             isLoading = false;
//           });

//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(state.message)),
//           );
//         }
//       },
//       child: Scaffold(
//         backgroundColor: AppColors.background,
//         appBar: AppBar(
//           title: Text(local.security),
//           backgroundColor: AppColors.primary,
//           foregroundColor: Colors.white,
//           elevation: 0,
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   color: AppColors.surface,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: ListTile(
//                   leading: const CircleAvatar(
//                     backgroundColor: Color(0xFFE3F2FD),
//                     child: Icon(Icons.lock_outline, color: Colors.blue),
//                   ),
//                   title: Text(
//                     local.changePassword,
//                     style: AppTextStyles.titleMedium,
//                   ),
//                   subtitle: Text(local.enterPasswordToContinue),
//                   trailing: const Icon(Icons.chevron_right),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const ChangePasswordScreen(),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Container(
//                 decoration: BoxDecoration(
//                   color: AppColors.surface,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: SwitchListTile(
//                   value: user?.isTwoFAEnabled ?? false,
//                   activeColor: AppColors.primary,
//                   secondary: const CircleAvatar(
//                     backgroundColor: Color(0xFFE8F5E9),
//                     child: Icon(Icons.security, color: Colors.green),
//                   ),
//                   title: Text(
//                     local.twoFactorAuth,
//                     style: AppTextStyles.titleMedium,
//                   ),
//                   subtitle: Text(local.extraSecurityLayer),
//                   onChanged: isLoading
//                       ? null
//                       : (value) async {
//                           if (!value) {
//                             authCubit.disable2FA();
//                             return;
//                           }

//                           if (user == null) return;

//                           final password = await showDialog<String>(
//                             context: context,
//                             builder: (_) =>
//                                 const Enable2FAPasswordDialog(),
//                           );

//                           if (password == null || password.isEmpty) {
//                             return;
//                           }

//                           setState(() {
//                             isLoading = true;
//                           });

//                           authCubit.generate2FA(
//                             email: user.email,
//                             password: password,
//                           );
//                         },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }