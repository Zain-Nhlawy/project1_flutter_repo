import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project1/features/integrations/drawio/data/diagram_storage.dart';
import 'xml_preview_page.dart';

enum _EditorStatus { idle, loading, ready, saving, error }

class DrawioPage extends StatefulWidget {
  const DrawioPage({super.key});

  @override
  State<DrawioPage> createState() => _DrawioPageState();
}

class _DrawioPageState extends State<DrawioPage> {
  late final WebViewController _controller;
  final DiagramStorageService _storage = DiagramStorageService();

  bool _isPageLoading = true;
  bool _isEditorOpen = true;
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
              _isEditorOpen = true;
              _status = _EditorStatus.loading;
            });

            _openEditor();
          },
        ),
      )
      ..addJavaScriptChannel(
        'FlutterBridge',
        onMessageReceived: (message) =>
            _handleDrawioMessage(message.message),
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

    if (data == null) return;

    if (type == 'status') {
      _handleStatus(data as String);
      return;
    }

    if (type == 'xml') {
      _pendingXml = data;
    }

    if (type == 'png') {
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
          _isEditorOpen = true;
          break;

        case 'saving':
          _status = _EditorStatus.saving;
          break;

        default:
          _status = _EditorStatus.idle;
      }
    });
  }

  void _openEditor() {
    if (!mounted) return;

    setState(() {
      _isEditorOpen = true;
      _status = _EditorStatus.loading;
    });

    final xmlArg = _savedXml != null ? jsonEncode(_savedXml) : 'null';

    _controller.runJavaScript(
      'window.openEditor($xmlArg);',
    );
  }

  void _clearDiagram() {
    _controller.runJavaScript('window.clearEditor();');

    if (!mounted) return;

    setState(() {
      _savedXml = null;
      _savedFilePath = null;
      _status = _EditorStatus.loading;
    });

    _showToast(
      AppLocalizations.of(context)?.cleared ?? 'Cleared',
    );
  }

  Future<void> _showSaveDialog(String xml, String png) async {
    if (!mounted) return;

    final l10n = AppLocalizations.of(context);

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          l10n?.saveDiagram ?? 'Save Diagram',
          style: AppTextStyles.h3,
        ),
        content: Text(
          l10n?.whatDoYouWantToSave ??
              'What do you want to save?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'xml'),
            child: Text(
              l10n?.xmlOnly ?? 'XML only',
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'png'),
            child: Text(
              l10n?.pngOnly ?? 'PNG only',
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            onPressed: () => Navigator.pop(ctx, 'both'),
            child: Text(
              l10n?.both ?? 'Both',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, 'cancel'),
            child: Text(
              l10n?.cancel ?? 'Cancel',
            ),
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

        _showToast(
          l10n?.xmlSaved ?? 'XML Saved',
        );
      }

      if (result == 'png' || result == 'both') {
        await _storage.savePng(png);

        _showToast(
          l10n?.pngSaved ?? 'PNG Saved',
        );
      }
    } else {
      _showToast(
        l10n?.storagePermissionDenied ??
            'Permission Denied',
      );
    }
  }

  Future<bool> _requestPermission() async {
    return await Permission.storage.request().isGranted ||
        await Permission.manageExternalStorage.request().isGranted;
  }

  void _showToast(String msg) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  Color get _statusColor {
    switch (_status) {
      case _EditorStatus.ready:
        return Colors.green;

      case _EditorStatus.loading:
        return Colors.orange;

      case _EditorStatus.saving:
        return Colors.blue;

      case _EditorStatus.error:
        return Colors.red;

      case _EditorStatus.idle:
        return Colors.grey;
    }
  }

  String _statusText(AppLocalizations? l10n) {
    switch (_status) {
      case _EditorStatus.ready:
        return l10n?.ready ?? 'Ready';

      case _EditorStatus.loading:
        return l10n?.loading ?? 'Loading...';

      case _EditorStatus.saving:
        return l10n?.saving ?? 'Saving...';

      case _EditorStatus.error:
        return l10n?.error ?? 'Error';

      case _EditorStatus.idle:
        return l10n?.readyIdle ?? 'Ready';
    }
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
          l10n?.diagramEditor ?? 'Diagram Editor',
          style: AppTextStyles.titleLarge.copyWith(
            color: Colors.white,
          ),
        ),
        actions: [
          if (_isEditorOpen)
            IconButton(
              tooltip: l10n?.clear ?? 'Clear',
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.white,
              ),
              onPressed: _clearDiagram,
            ),
          if (_savedXml != null)
            IconButton(
              tooltip: l10n?.viewXml ?? 'View XML',
              icon: const Icon(
                Icons.visibility,
                color: Colors.white,
              ),
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
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 36,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _statusText(l10n),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(
                  controller: _controller,
                ),
                if (_isPageLoading ||
                    _status == _EditorStatus.loading)
                  Container(
                    color: Colors.white70,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            l10n?.loading ?? 'Loading...',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}