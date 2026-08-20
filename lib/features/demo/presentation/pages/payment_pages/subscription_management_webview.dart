import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/l10n/app_localizations.dart';

class SubscriptionManagementWebViewScreen extends StatefulWidget {
  final String portalUrl;

  const SubscriptionManagementWebViewScreen({
    super.key,
    required this.portalUrl,
  });

  @override
  State<SubscriptionManagementWebViewScreen> createState() =>
      _SubscriptionManagementWebViewScreenState();
}

class _SubscriptionManagementWebViewScreenState
    extends State<SubscriptionManagementWebViewScreen> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textScale = MediaQuery.textScalerOf(context).scale(1);

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundOf(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close_rounded,
            color: AppColors.textPrimaryOf(context),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.managePlan,
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
            initialUrlRequest: URLRequest(url: WebUri(widget.portalUrl)),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              useHybridComposition: true,
              transparentBackground: true,
            ),
            onLoadStart: (_, _) {
              if (mounted) setState(() => _isLoading = true);
            },
            onLoadStop: (_, _) {
              if (mounted) setState(() => _isLoading = false);
            },
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                color: AppColors.primaryOf(context),
              ),
            ),
        ],
      ),
    );
  }
}
