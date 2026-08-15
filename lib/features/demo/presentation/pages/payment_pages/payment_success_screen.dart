import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20cubit/demo_cubit.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:project1/features/demo/presentation/cubit/payment%20for%20demo/demo_payment_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/payment%20for%20demo/demo_payment_state.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final String sessionId;

  const PaymentSuccessScreen({super.key, required this.sessionId});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentWebViewCubit>().handlePaymentSuccess(widget.sessionId);
    // Trigger demo cards refresh
    if (getIt.isRegistered<DemoCubit>()) {
      getIt<DemoCubit>().fetchDemos();
    }
  }

  void _onBackToHome() {
    if (getIt.isRegistered<DemoCubit>()) {
      getIt<DemoCubit>().fetchDemos();
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final localizations = AppLocalizations.of(context)!;

    final primary = AppColors.primaryOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);
    final textSecondary = AppColors.textSecondaryOf(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      body: SafeArea(
        child: BlocConsumer<PaymentWebViewCubit, PaymentWebViewState>(
          listener: (context, state) {
            if (state.status?.toLowerCase() == 'complete') {
              if (getIt.isRegistered<DemoCubit>()) {
                getIt<DemoCubit>().fetchDemos();
              }
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: primary),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      localizations.processingPayment,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state.errorMessage != null) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        state.errorMessage!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: size.height * 0.04),
                      ElevatedButton(
                        onPressed: _onBackToHome,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: AppColors.buttonGradientOf(context),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: primary.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.02,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              localizations.backToHome,
                              style: AppTextStyles.titleMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16 * textScale,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.06),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(size.width * 0.06),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      padding: EdgeInsets.all(size.width * 0.04),
                      decoration: BoxDecoration(
                        gradient: AppColors.buttonGradientOf(context),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.4),
                            blurRadius: 20,
                            spreadRadius: -5,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 60 * textScale,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  Text(
                    localizations.paymentSuccessful,
                    style: AppTextStyles.h2.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 24 * textScale,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text(
                    localizations.paymentSuccessMessage,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: textSecondary,
                      fontSize: 14 * textScale,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.06),
                  ElevatedButton(
                    onPressed: _onBackToHome,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: AppColors.buttonGradientOf(context),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.02,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          localizations.backToHome,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16 * textScale,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
