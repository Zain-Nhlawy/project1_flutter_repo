import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/demo/domain/use%20case/demo_payment_usecase.dart';
import 'package:project1/features/demo/presentation/cubit/payment%20for%20demo/demo_payment_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/payment%20for%20demo/demo_payment_state.dart';
import 'package:project1/features/demo/presentation/pages/payment_pages/payment_success_screen.dart';
import 'package:animations/animations.dart';

class PaymentWebViewScreen extends StatelessWidget {
  final String paymentUrl;

  const PaymentWebViewScreen({super.key, required this.paymentUrl});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentWebViewCubit(
        requestPaymentUseCase: getIt<DemoPaymentUseCase>(),
      ),
      child: _PaymentWebViewContent(paymentUrl: paymentUrl),
    );
  }
}

class _PaymentWebViewContent extends StatefulWidget {
  final String paymentUrl;

  const _PaymentWebViewContent({required this.paymentUrl});

  @override
  State<_PaymentWebViewContent> createState() => _PaymentWebViewContentState();
}

class _PaymentWebViewContentState extends State<_PaymentWebViewContent> {
  @override
  Widget build(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    final cubit = context.read<PaymentWebViewCubit>();

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundOf(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: AppColors.textPrimaryOf(context)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Secure Checkout',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimaryOf(context),
            fontWeight: FontWeight.bold,
            fontSize: 18 * textScale,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(widget.paymentUrl),
            ),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              useHybridComposition: true,
              transparentBackground: true,
            ),
            onLoadStart: (controller, url) {
              cubit.pageStarted();
            },
            onLoadStop: (controller, url) {
              cubit.pageFinished();
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final url = navigationAction.request.url?.toString() ?? '';
              if (url.startsWith('https://lincolms.me/payment-success')) {
                final uri = Uri.parse(url);
                final sessionId = uri.queryParameters['session_id'] ?? '';

                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        BlocProvider(
                          create: (context) => PaymentWebViewCubit(
                            requestPaymentUseCase: getIt<DemoPaymentUseCase>(),
                          ),
                          child: PaymentSuccessScreen(sessionId: sessionId),
                        ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                          return FadeThroughTransition(
                            animation: animation,
                            secondaryAnimation: secondaryAnimation,
                            child: child,
                          );
                        },
                  ),
                );
                return NavigationActionPolicy.CANCEL;
              }
              return NavigationActionPolicy.ALLOW;
            },
          ),
          BlocBuilder<PaymentWebViewCubit, PaymentWebViewState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
