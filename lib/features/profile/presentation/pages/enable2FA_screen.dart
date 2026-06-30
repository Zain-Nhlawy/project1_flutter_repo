import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:project1/features/auth/presentation/cubit/auth_state.dart';
import 'package:project1/l10n/app_localizations.dart';

class Enable2FAScreen extends StatefulWidget {
  final String qrCode;

  const Enable2FAScreen({
    super.key,
    required this.qrCode,
  });

  @override
  State<Enable2FAScreen> createState() => _Enable2FAScreenState();
}

class _Enable2FAScreenState extends State<Enable2FAScreen> {
  final TextEditingController codeController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    final base64String = widget.qrCode.split(',').last;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is TurnOn2FASuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(local.twoFactorEnabledSuccessfully),
            ),
          );

          Navigator.pop(context, true);
        }

        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          title: Text(local.enableTwoFactorAuthentication),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                local.scanQrCode,
                style: AppTextStyles.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                local.scanQrCodeDescription,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.memory(
                  base64Decode(base64String),
                  width: 220,
                  height: 220,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: codeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: local.authenticationCode,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().turnOn2FA(
                          tfaCode: codeController.text.trim(),
                        );
                  },
                  child: Text(local.enable),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}