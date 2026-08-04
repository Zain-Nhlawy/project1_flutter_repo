import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:project1/features/course/presentation/pages/course_purchase_success_screen.dart';
import 'package:project1/features/course/presentation/cubit/payment_cubit.dart';
import 'package:project1/features/course/presentation/cubit/payment_state.dart';

class CheckoutWebViewScreen extends StatefulWidget {
  final String checkoutUrl;
  final String successUrlPrefix;
  final String cancelUrlPrefix;
  final String? courseTitle;

  const CheckoutWebViewScreen({
    super.key,
    required this.checkoutUrl,
    this.successUrlPrefix = 'https://lincolms.me/payment-success',
    this.cancelUrlPrefix = 'https://lincolms.me/payment-cancel',
    this.courseTitle,
  });

  @override
  State<CheckoutWebViewScreen> createState() => _CheckoutWebViewScreenState();
}

class _CheckoutWebViewScreenState extends State<CheckoutWebViewScreen> {
  late final WebViewController _controller;
  bool _loading = true;
  bool _isConfirming = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _loading = true),
          onPageFinished: (_) => setState(() => _loading = false),
          onNavigationRequest: (request) {
            if (request.url.startsWith(widget.successUrlPrefix)) {
              _handleSuccessRedirect(request.url);
              return NavigationDecision.prevent;
            }
            if (request.url.startsWith(widget.cancelUrlPrefix)) {
              Navigator.pop(context, false);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));
  }

  Future<void> _handleSuccessRedirect(String url) async {
    if (_isConfirming) return;

    final sessionId = Uri.parse(url).queryParameters['session_id'];

    if (sessionId == null || sessionId.isEmpty) {
      _showErrorAndClose('Missing session id in redirect URL');
      return;
    }

    _isConfirming = true;

    if (!mounted) return;

    await context.read<PaymentCubit>().confirmPayment(sessionId);
  }

  void _showErrorAndClose(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentConfirmSuccess) {
          final isPaid = state.status == 'paid';

          if (isPaid) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => CoursePurchaseSuccessScreen(
                  courseTitle: widget.courseTitle,
                ),
              ),
            );
          } else {
            _isConfirming = false;
            _showErrorAndClose('Payment status: ${state.status}');
          }
        } else if (state is PaymentConfirmError) {
          _isConfirming = false;
          _showErrorAndClose('Payment confirmation failed: ${state.message}');
        }
      },
      child: Scaffold(
        appBar: AppBar(
  leading: IconButton(
    icon: const Icon(
      Icons.close,
      color: Colors.white,
    ),
    onPressed: () => Navigator.pop(context, false),
  ),
  title: const Text(
    "Checkout",
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
  flexibleSpace: Container(
    decoration: const BoxDecoration(
      gradient: AppColors.primaryGradient,
    ),
  ),
),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_loading) const Center(child: CircularProgressIndicator()),
            BlocBuilder<PaymentCubit, PaymentState>(
              builder: (context, state) {
                if (state is PaymentConfirmLoading) {
                  return Container(
                    color: Colors.black26,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}