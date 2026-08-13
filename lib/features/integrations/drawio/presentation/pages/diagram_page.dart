import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/presentation/widgets/gradient_page_app_bar.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project1/features/integrations/drawio/data/diagram_storage.dart';
import 'xml_preview_page.dart';

enum _EditorStatus { loading, ready, saving }

class DrawioPage extends StatefulWidget {
  const DrawioPage({super.key});

  @override
  State<DrawioPage> createState() => _DrawioPageState();
}

class _DrawioPageState extends State<DrawioPage> {
  late final WebViewController _controller;
  final DiagramStorageService _storage = DiagramStorageService();

  bool _isPageLoading = true;
  _EditorStatus _status = _EditorStatus.loading;

  String? _savedXml;
  String? _savedFilePath;
  String? _pendingXml;
  String? _pendingPng;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (!mounted) return;

            setState(() {
              _isPageLoading = false;
              _status = _EditorStatus.loading;
            });

            _openEditor();
          },
        ),
      )
      ..addJavaScriptChannel(
        'FlutterBridge',
        onMessageReceived: (message) => _handleDrawioMessage(message.message),
      )
      ..loadFlutterAsset('assets/drawio.html');
  }

  Future<void> _handleDrawioMessage(String rawMessage) async {
    Map<String, dynamic> parsed;

    try {
      parsed = jsonDecode(rawMessage);
    } catch (_) {
      return;
    }

    final type = parsed['type'];
    final data = parsed['data'];

    if (type == 'status' && data is String) {
      _handleStatus(data);
      return;
    }

    if (data is! String) return;

    if (type == 'xml') {
      _pendingXml = data;
    } else if (type == 'png') {
      _pendingPng = data;
    }

    if (_pendingXml != null && _pendingPng != null) {
      final xml = _pendingXml!;
      final png = _pendingPng!;

      _pendingXml = null;
      _pendingPng = null;

      if (mounted) {
        setState(() {
          _status = _EditorStatus.ready;
        });
      }

      await _showSaveDialog(xml, png);
    }
  }

  void _handleStatus(String status) {
    if (!mounted) return;

    setState(() {
      switch (status) {
        case 'ready':
          _status = _EditorStatus.ready;
          break;

        case 'saving':
          _status = _EditorStatus.saving;
          break;

        default:
          _status = _EditorStatus.loading;
      }
    });
  }

  void _openEditor() {
    if (!mounted) return;

    setState(() {
      _status = _EditorStatus.loading;
    });

    final xmlArg = _savedXml != null ? jsonEncode(_savedXml) : 'null';

    _controller.runJavaScript('window.openEditor($xmlArg);');
  }

  Future<void> _showSaveDialog(String xml, String png) async {
    if (!mounted) return;

    final l10n = AppLocalizations.of(context);

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceOf(ctx),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titlePadding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
        contentPadding: const EdgeInsets.fromLTRB(22, 16, 22, 4),
        actionsPadding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
        title: Text(
          l10n?.saveDiagram ?? 'Save Diagram',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimaryOf(ctx),
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          l10n?.whatDoYouWantToSave ?? 'What do you want to save?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondaryOf(ctx),
            height: 1.45,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'xml'),
            child: Text(l10n?.xmlOnly ?? 'XML only'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'png'),
            child: Text(l10n?.pngOnly ?? 'PNG only'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOf(ctx),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, 'both'),
            child: Text(
              l10n?.both ?? 'Both',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'cancel'),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
        ],
      ),
    );

    if (result == null || result == 'cancel') return;

    if (await _requestPermission()) {
      if (result == 'xml' || result == 'both') {
        final path = await _storage.saveXml(xml);

        if (mounted) {
          setState(() {
            _savedXml = xml;
            _savedFilePath = path;
          });
        }

        _showToast(l10n?.xmlSaved ?? 'XML Saved');
      }

      if (result == 'png' || result == 'both') {
        await _storage.savePng(png);

        _showToast(l10n?.pngSaved ?? 'PNG Saved');
      }
    } else {
      _showToast(l10n?.storagePermissionDenied ?? 'Permission Denied');
    }
  }

  Future<bool> _requestPermission() async {
    return await Permission.storage.request().isGranted ||
        await Permission.manageExternalStorage.request().isGranted;
  }

  void _showToast(String msg) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isCompact = MediaQuery.sizeOf(context).shortestSide < 600;
    final isSaving = _status == _EditorStatus.saving;
    final isBusy = _isPageLoading || _status != _EditorStatus.ready;
    final shadowOpacity = Theme.of(context).brightness == Brightness.dark
        ? 0.2
        : 0.07;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: GradientPageAppBar(
        title: l10n?.diagramEditor ?? 'Diagram Editor',
        onBackPressed: () => Navigator.pop(context),
        bottomRadius: 0,
        actions: [
          if (_savedXml != null)
            _HeaderAction(
              icon: Icons.code_rounded,
              tooltip: l10n?.viewXml ?? 'View XML',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => XmlPreviewPage(
                    xml: _savedXml!,
                    filePath: _savedFilePath ?? '',
                  ),
                ),
              ),
            ),
          const SizedBox(width: 12),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: isCompact
              ? EdgeInsets.zero
              : const EdgeInsets.fromLTRB(16, 18, 16, 16),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.surfaceOf(context),
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
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                WebViewWidget(controller: _controller),
                if (isBusy)
                  _EditorLoadingView(
                    label: isSaving
                        ? (l10n?.saving ?? 'Saving...')
                        : (l10n?.loading ?? 'Loading...'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _HeaderAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 7),
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: Colors.white.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 38,
              height: 38,
              child: Icon(icon, color: Colors.white, size: 19),
            ),
          ),
        ),
      ),
    );
  }
}

class _EditorLoadingView extends StatelessWidget {
  final String label;

  const _EditorLoadingView({required this.label});

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);

    return ColoredBox(
      color: AppColors.surfaceOf(context).withValues(alpha: 0.94),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.backgroundOf(context),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.borderOf(context).withValues(alpha: 0.8),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  color: primary,
                  strokeWidth: 2.6,
                ),
              ),
              const SizedBox(height: 13),
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
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
