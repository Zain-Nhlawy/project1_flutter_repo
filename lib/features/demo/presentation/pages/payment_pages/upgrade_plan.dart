import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/demo/domain/use%20case/demo_payment_usecase.dart';
import 'package:project1/features/demo/presentation/cubit/payment%20for%20demo/demo_payment_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/payment%20for%20demo/demo_payment_state.dart';
import 'package:project1/features/demo/presentation/pages/payment_pages/payment_webview.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:animations/animations.dart';

class UpgradePlanScreen extends StatefulWidget {
  final String demoId;
  final String? currentPlan;

  const UpgradePlanScreen({
    required this.demoId,
    this.currentPlan,
    super.key,
  });

  @override
  State<UpgradePlanScreen> createState() => UpgradePlanScreenState();
}

class UpgradePlanScreenState extends State<UpgradePlanScreen> {
  String _selectedPlan = 'PRO';

  int _getPlanRank(String? plan) {
    if (plan == null) return 0;
    final p = plan.trim().toUpperCase();
    if (p == 'ENTERPRISE') return 3;
    if (p == 'PRO') return 2;
    if (p == 'STARTER') return 1;
    return 0; // FREE, starter trial, or unassigned
  }

  @override
  void initState() {
    super.initState();
    final currentRank = _getPlanRank(widget.currentPlan);
    if (currentRank == 0) {
      _selectedPlan = 'STARTER';
    } else if (currentRank == 1) {
      _selectedPlan = 'PRO';
    } else if (currentRank == 2) {
      _selectedPlan = 'ENTERPRISE';
    } else {
      _selectedPlan = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentRank = _getPlanRank(widget.currentPlan);
    final isEnterprise = currentRank >= 3;

    return BlocProvider(
      create: (context) => PaymentWebViewCubit(
        requestPaymentUseCase: getIt<DemoPaymentUseCase>(),
      ),
      child: Builder(
        builder: (context) {
          final size = MediaQuery.sizeOf(context);
          final textScale = MediaQuery.textScalerOf(context).scale(1);
          final localizations = AppLocalizations.of(context)!;

          final plans = [
            {
              "id": "STARTER",
              "title": "Starter",
              "members": "Up to 20 members",
              "sections": "5 sections",
              "price": "\$20/mo",
              "icon": Icons.rocket_launch_outlined,
            },
            {
              "id": "PRO",
              "title": "Pro",
              "members": "Up to 100 members",
              "sections": "Unlimited sections",
              "price": "\$100/mo",
              "icon": Icons.star_border_rounded,
            },
            {
              "id": "ENTERPRISE",
              "title": "Enterprise",
              "members": "Unlimited members",
              "sections": "Unlimited sections",
              "price": "\$200/mo",
              "icon": Icons.business_center_outlined,
            },
          ];

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.textPrimary,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                localizations.upgradePlan,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(size.width * 0.06),
                    itemCount: plans.length,
                    itemBuilder: (context, index) {
                      final plan = plans[index];
                      final planId = plan["id"] as String;
                      final planRank = _getPlanRank(planId);
                      final isCurrentPlan = currentRank > 0 && planRank == currentRank;
                      final isRestricted = currentRank > 0 && planRank <= currentRank;
                      final isSelected = _selectedPlan == planId && !isRestricted;

                      return GestureDetector(
                        onTap: isRestricted
                            ? null
                            : () {
                                setState(() {
                                  _selectedPlan = planId;
                                });
                              },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: EdgeInsets.only(bottom: size.height * 0.02),
                          padding: EdgeInsets.all(size.width * 0.04),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : isCurrentPlan
                                    ? AppColors.primary.withValues(alpha: 0.06)
                                    : isRestricted
                                        ? AppColors.surface.withValues(alpha: 0.5)
                                        : AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : isCurrentPlan
                                      ? AppColors.primary.withValues(alpha: 0.4)
                                      : AppColors.textSecondary.withValues(alpha: 0.2),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : isCurrentPlan
                                          ? AppColors.primary.withValues(alpha: 0.15)
                                          : AppColors.textSecondary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  plan["icon"] as IconData,
                                  color: isSelected
                                      ? AppColors.surface
                                      : isCurrentPlan
                                          ? AppColors.primary
                                          : isRestricted
                                              ? Colors.grey
                                              : AppColors.textSecondary,
                                  size: 24 * textScale,
                                ),
                              ),
                              SizedBox(width: size.width * 0.04),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      plan["title"] as String,
                                      style: AppTextStyles.titleMedium.copyWith(
                                        color: isRestricted && !isCurrentPlan
                                            ? AppColors.textSecondary
                                            : AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${plan["members"]} • ${plan["sections"]}',
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                        fontSize: 12 * textScale,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isCurrentPlan)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    localizations.currentPlan,
                                    style: AppTextStyles.label.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12 * textScale,
                                    ),
                                  ),
                                )
                              else if (isRestricted)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.lock_outline,
                                        size: 12,
                                        color: Colors.redAccent,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        localizations.restricted,
                                        style: AppTextStyles.label.copyWith(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12 * textScale,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Text(
                                  plan["price"] as String,
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16 * textScale,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (!isEnterprise)
                  SafeArea(
                    child: Container(
                      padding: EdgeInsets.all(size.width * 0.06),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textSecondary.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: BlocBuilder<PaymentWebViewCubit, PaymentWebViewState>(
                        builder: (context, state) {
                          return InkWell(
                            onTap: _selectedPlan.isEmpty
                                ? null
                                : () async {
                                    try {
                                      final paymentUrl = await context
                                          .read<PaymentWebViewCubit>()
                                          .requestPayment(
                                            widget.demoId,
                                            _selectedPlan,
                                          );

                                      if (context.mounted) {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration:
                                                const Duration(milliseconds: 300),
                                            pageBuilder: (
                                              context,
                                              animation,
                                              secondaryAnimation,
                                            ) => PaymentWebViewScreen(
                                              paymentUrl: paymentUrl,
                                            ),
                                            transitionsBuilder: (
                                              context,
                                              animation,
                                              secondaryAnimation,
                                              child,
                                            ) {
                                              return FadeThroughTransition(
                                                animation: animation,
                                                secondaryAnimation:
                                                    secondaryAnimation,
                                                child: child,
                                              );
                                            },
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        SnackbarTheme().newSnackBarError(
                                          context,
                                          e.toString(),
                                        );
                                      }
                                    }
                                  },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.02,
                              ),
                              decoration: BoxDecoration(
                                gradient: AppColors.buttonGradient,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: state.isLoading
                                    ? []
                                    : [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                              ),
                              child: Center(
                                child: Text(
                                  localizations.continueToPayment,
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.surface,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16 * textScale,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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
