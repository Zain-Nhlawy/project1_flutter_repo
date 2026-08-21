import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/demo/domain/use%20case/demo_payment_usecase.dart';
import 'package:project1/features/demo/presentation/cubit/payment%20for%20demo/demo_payment_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/payment%20for%20demo/demo_payment_state.dart';
import 'package:project1/features/demo/presentation/pages/payment_pages/subscription_management_webview.dart';
import 'package:project1/l10n/app_localizations.dart';

class ManagePlanScreen extends StatelessWidget {
  final String demoId;

  const ManagePlanScreen({super.key, required this.demoId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentWebViewCubit(
        requestPaymentUseCase: getIt<DemoPaymentUseCase>(),
      ),
      child: _ManagePlanContent(demoId: demoId),
    );
  }
}

class _ManagePlanContent extends StatefulWidget {
  final String demoId;

  const _ManagePlanContent({required this.demoId});

  @override
  State<_ManagePlanContent> createState() => _ManagePlanContentState();
}

class _ManagePlanContentState extends State<_ManagePlanContent> {
  bool _portalOpened = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PaymentWebViewCubit>().requestSubscriptionManagement(
          widget.demoId,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primary = AppColors.primaryOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundOf(context),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_rounded, color: textPrimary),
        ),
        title: Text(
          l10n.managePlan,
          style: AppTextStyles.titleLarge.copyWith(
            color: textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<PaymentWebViewCubit, PaymentWebViewState>(
        listener: (context, state) {
          final portalUrl = state.managementUrl;
          if (_portalOpened || portalUrl == null) return;

          _portalOpened = true;
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  SubscriptionManagementWebViewScreen(portalUrl: portalUrl),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) =>
                      FadeThroughTransition(
                        animation: animation,
                        secondaryAnimation: secondaryAnimation,
                        child: child,
                      ),
            ),
          );
        },
        builder: (context, state) {
          if (state.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: Theme.of(context).colorScheme.error,
                      size: 56,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.subscriptionPortalError,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.errorMessage!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => context
                          .read<PaymentWebViewCubit>()
                          .requestSubscriptionManagement(widget.demoId),
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            );
          }

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: primary),
                const SizedBox(height: 16),
                Text(
                  l10n.openingSubscriptionPortal,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: textSecondary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
