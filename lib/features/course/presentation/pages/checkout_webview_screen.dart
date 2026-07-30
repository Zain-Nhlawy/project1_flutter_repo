import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:project1/features/course/presentation/pages/course_purchase_success_screen.dart';

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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => CoursePurchaseSuccessScreen(
                    courseTitle: widget.courseTitle,
                  ),
                ),
              );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}