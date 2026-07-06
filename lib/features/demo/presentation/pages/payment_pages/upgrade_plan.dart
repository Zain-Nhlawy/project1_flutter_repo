import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/demo/domain/use%20case/demo_payment_usecase.dart';
import 'package:project1/features/demo/presentation/cubit/payment%20for%20demo/demo_payment_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/payment%20for%20demo/demo_payment_state.dart';
import 'package:project1/features/demo/presentation/pages/payment_pages/payment_webview.dart';
import 'package:project1/features/department/presentation/pages/demo_main_page.dart'
    as di;
import 'package:project1/l10n/app_localizations.dart';

class UpgradePlanScreen extends StatefulWidget {
  final String demoId;
  const UpgradePlanScreen({required this.demoId, super.key});

  @override
  State<UpgradePlanScreen> createState() => UpgradePlanScreenState();
}

class UpgradePlanScreenState extends State<UpgradePlanScreen> {
  String _selectedPlan = 'PRO';

  @override
  Widget build(BuildContext context) {
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
                      final isSelected = _selectedPlan == plan["id"];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPlan = plan["id"] as String;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: EdgeInsets.only(bottom: size.height * 0.02),
                          padding: EdgeInsets.all(size.width * 0.04),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withOpacity(0.1)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textSecondary.withOpacity(0.2),
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.1),
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
                                      : AppColors.textSecondary.withOpacity(
                                          0.1,
                                        ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  plan["icon"] as IconData,
                                  color: isSelected
                                      ? AppColors.surface
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
                                        color: AppColors.textPrimary,
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
                SafeArea(
                  child: Container(
                    padding: EdgeInsets.all(size.width * 0.06),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textSecondary.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, -5),
                        ),
                      ],
                    ),
                    child: BlocBuilder<PaymentWebViewCubit, PaymentWebViewState>(
                      builder: (context, state) {
                        return InkWell(
                          onTap: //state.isLoading
                              // null
                              () async {
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
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            PaymentWebViewScreen(
                                              paymentUrl: paymentUrl,
                                            ),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(e.toString()),
                                        backgroundColor: Colors.red,
                                      ),
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
                              gradient: //state.isLoading
                                  //     ? null
                                  AppColors.buttonGradient,
                              color: // state.isLoading
                                  //? AppColors.textSecondary.withOpacity(0.3)
                                  null,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: state.isLoading
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(
                                          0.3,
                                        ),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                            ),
                            child: Center(
                              child: // state.isLoading
                                  //     ? SizedBox(
                                  //         height: 20 * textScale,
                                  //         width: 20 * textScale,
                                  //         child: const CircularProgressIndicator(
                                  //           color: AppColors.surface,
                                  //           strokeWidth: 2,
                                  //         ),
                                  //       )
                                  Text(
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
