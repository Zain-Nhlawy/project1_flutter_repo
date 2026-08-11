import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:project1/features/integrations/photopea/data/photopea_storage_service.dart';

class PhotopeaEditorPage extends StatefulWidget {
  const PhotopeaEditorPage({super.key});

  @override
  State<PhotopeaEditorPage> createState() => _PhotopeaEditorPageState();
}

class _PhotopeaEditorPageState extends State<PhotopeaEditorPage> {
  double _progress = 0;
  InAppWebViewController? _webViewController;
  bool _isSaving = false;

  final PhotopeaStorageService _storage = PhotopeaStorageService();

  Future<bool> _requestPermission() async {
    return await Permission.storage.request().isGranted ||
        await Permission.manageExternalStorage.request().isGranted;
  }

  Future<void> _handleExport(String base64Data) async {
    final l10n = AppLocalizations.of(context);

    setState(() => _isSaving = true);

    try {
      if (await _requestPermission()) {
        final path = await _storage.savePng(base64Data);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${l10n?.pngSaved ?? 'PNG saved'}: $path',
            ),
          ),
        );
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n?.storagePermissionDenied ??
                  'Storage permission denied',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${l10n?.saveFailed ?? 'Save failed'}: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _triggerManualSave() {
    _webViewController?.evaluateJavascript(
      source:
          "runPhotopeaScript(\"app.activeDocument.saveToOE('png');\");",
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n?.photopeaEditor ?? 'Photopea Editor',
          style: AppTextStyles.titleLarge.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: _isSaving ? null : _triggerManualSave,
        icon: _isSaving
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(
                Icons.save,
                color: Colors.white,
              ),
        label: Text(
          _isSaving
              ? (l10n?.save ?? 'Saving...')
              : (l10n?.saveDiagram ?? 'Save Now'),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
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
            ),
            onWebViewCreated: (controller) {
              _webViewController = controller;

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
                  debugPrint(
                    'Photopea event: ${args[0]}',
                  );

                  return null;
                },
              );
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                _progress = progress / 100;
              });
            },
          ),
          if (_progress < 1.0)
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.black12,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }
}