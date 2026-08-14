import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/presentation/widgets/gradient_page_app_bar.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:project1/features/integrations/photopea/data/photopea_storage_service.dart';

class PhotopeaEditorPage extends StatefulWidget {
  const PhotopeaEditorPage({super.key});

  @override
  State<PhotopeaEditorPage> createState() => _PhotopeaEditorPageState();
}

class _PhotopeaEditorPageState extends State<PhotopeaEditorPage> {
  static const _editorBackground = Color(0xFF1A1A1A);

  double _progress = 0;

  final PhotopeaStorageService _storage = PhotopeaStorageService();

  Future<bool> _requestPermission() async {
    return await Permission.storage.request().isGranted ||
        await Permission.manageExternalStorage.request().isGranted;
  }

  Future<void> _handleExport(String base64Data) async {
    final l10n = AppLocalizations.of(context);

    try {
      if (await _requestPermission()) {
        final path = await _storage.savePng(base64Data);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n?.pngSaved ?? 'PNG saved'}: $path')),
        );
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n?.storagePermissionDenied ?? 'Storage permission denied',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n?.saveFailed ?? 'Save failed'}: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isCompact = MediaQuery.sizeOf(context).shortestSide < 600;
    final shadowOpacity = Theme.of(context).brightness == Brightness.dark
        ? 0.24
        : 0.1;

    return Scaffold(
      // The app bar has rounded bottom corners. Matching the Scaffold to the
      // editor prevents a light surface from showing through those corners.
      backgroundColor: _editorBackground,
      appBar: GradientPageAppBar(
        title: l10n?.photopeaEditor ?? 'Photopea Editor',
        onBackPressed: () => Navigator.pop(context),
        bottomRadius: 0,
      ),
      body: ColoredBox(
        color: isCompact ? _editorBackground : AppColors.backgroundOf(context),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: isCompact
                ? EdgeInsets.zero
                : const EdgeInsets.fromLTRB(16, 18, 16, 16),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: _editorBackground,
                borderRadius: isCompact
                    ? BorderRadius.zero
                    : BorderRadius.circular(22),
                border: isCompact
                    ? null
                    : Border.all(
                        color: AppColors.borderOf(
                          context,
                        ).withValues(alpha: 0.82),
                      ),
                boxShadow: isCompact
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: shadowOpacity),
                          blurRadius: 22,
                          offset: const Offset(0, 9),
                        ),
                      ],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: WebUri(
                        'file:///android_asset/flutter_assets/assets/photopea.html',
                      ),
                    ),
                    initialSettings: InAppWebViewSettings(
                      javaScriptEnabled: true,
                      useHybridComposition: true,
                      hardwareAcceleration: true,
                      javaScriptCanOpenWindowsAutomatically: true,
                      allowUniversalAccessFromFileURLs: true,
                      allowFileAccessFromFileURLs: true,
                      transparentBackground: true,
                    ),
                    onWebViewCreated: (controller) {
                      controller.addJavaScriptHandler(
                        handlerName: 'onPhotopeaExport',
                        callback: (args) async {
                          final base64Data = args[0] as String;

                          await _handleExport(base64Data);

                          return null;
                        },
                      );

                      controller.addJavaScriptHandler(
                        handlerName: 'onPhotopeaEvent',
                        callback: (args) {
                          debugPrint('Photopea event: ${args[0]}');

                          return null;
                        },
                      );
                    },
                    onProgressChanged: (controller, progress) {
                      if (!mounted) return;

                      setState(() {
                        _progress = progress / 100;
                      });
                    },
                  ),
                  if (_progress < 1.0)
                    _PhotopeaLoadingView(
                      progress: _progress,
                      label: l10n?.loading ?? 'Loading...',
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PhotopeaLoadingView extends StatelessWidget {
  final double progress;
  final String label;

  const _PhotopeaLoadingView({required this.progress, required this.label});

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);
    final normalizedProgress = progress.clamp(0.0, 1.0);

    return ColoredBox(
      color: AppColors.surfaceOf(context).withValues(alpha: 0.96),
      child: Center(
        child: Container(
          width: 210,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.backgroundOf(context),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppColors.borderOf(context).withValues(alpha: 0.82),
            ),
            boxShadow: [
              BoxShadow(
                color: primary.withValues(alpha: 0.1),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppColors.buttonGradientOf(context),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.auto_fix_high_rounded,
                  color: Colors.white,
                  size: 23,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimaryOf(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 13),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: normalizedProgress,
                  minHeight: 7,
                  backgroundColor: primary.withValues(alpha: 0.12),
                  valueColor: AlwaysStoppedAnimation<Color>(primary),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${(normalizedProgress * 100).round()}%',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondaryOf(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
