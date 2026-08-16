import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/core/storage/secure_storage.dart';
import 'package:project1/core/storage/storage_keys.dart';
import 'package:project1/features/auth/presentation/pages/login_screen.dart';
import 'package:project1/features/onboarding/presentation/pages/onboarding_screen.dart';

class UnauthenticatedGate extends StatefulWidget {
  const UnauthenticatedGate({super.key});

  @override
  State<UnauthenticatedGate> createState() => _UnauthenticatedGateState();
}

class _UnauthenticatedGateState extends State<UnauthenticatedGate> {
  bool _isLoading = true;
  bool _hasSeenOnboarding = false;

  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    try {
      final storage = getIt<AppSecureStorage>();
      final seen = await storage.read(StorageKeys.hasSeenOnboarding);
      if (mounted) {
        setState(() {
          _hasSeenOnboarding = seen == 'true';
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _hasSeenOnboarding = true;
          _isLoading = false;
        });
      }
    }
  }

  void _onFinishOnboarding() {
    if (mounted) {
      setState(() {
        _hasSeenOnboarding = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.backgroundOf(context),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_hasSeenOnboarding) {
      return OnboardingScreen(onFinish: _onFinishOnboarding);
    }

    return const LoginScreen();
  }
}
