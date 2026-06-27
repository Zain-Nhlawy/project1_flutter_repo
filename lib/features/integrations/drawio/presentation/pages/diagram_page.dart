import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project1/features/integrations/drawio/data/diagram_storage.dart';
import 'xml_preview_page.dart';

class DrawioPage extends StatefulWidget {
  const DrawioPage({super.key});

  @override
  State<DrawioPage> createState() => _DrawioPageState();
}

class _DrawioPageState extends State<DrawioPage> {
  late final WebViewController _controller;
  final DiagramStorageService _storage = DiagramStorageService();

  bool _isLoading = true;
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
          onPageFinished: (_) => setState(() => _isLoading = false),
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
      if (rawMessage.trim().startsWith('<')) {
        parsed = {'type': 'xml', 'data': rawMessage};
      } else {
        return;
      }
    }

    final type = parsed['type'];
    final data = parsed['data'];
    if (data == null) return;

    if (type == 'xml') _pendingXml = data;
    if (type == 'png') _pendingPng = data;

    if (_pendingXml != null && _pendingPng != null) {
      final xml = _pendingXml!;
      final png = _pendingPng!;
      _pendingXml = null;
      _pendingPng = null;
      await _showSaveDialog(xml, png);
    }
  }

  Future<void> _showSaveDialog(String xml, String png) async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n?.saveDiagram ?? 'Save Diagram', style: AppTextStyles.h3),
        content: Text(l10n?.whatDoYouWantToSave ?? 'What do you want to save?', style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, 'xml'), child: Text(l10n?.xmlOnly ?? 'XML only')),
          TextButton(onPressed: () => Navigator.pop(ctx, 'png'), child: Text(l10n?.pngOnly ?? 'PNG only')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.pop(ctx, 'both'),
            child: Text(l10n?.both ?? 'Both', style: const TextStyle(color: Colors.white)),
          ),
          TextButton(onPressed: () => Navigator.pop(ctx, 'cancel'), child: Text(l10n?.cancel ?? 'Cancel')),
        ],
      ),
    );

    if (result == null || result == 'cancel') return;

    if (await _requestPermission()) {
      if (result == 'xml' || result == 'both') {
        final path = await _storage.saveXml(xml);
        setState(() {
          _savedXml = xml;
          _savedFilePath = path;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n?.xmlSaved ?? 'XML Saved')));
      }
      if (result == 'png' || result == 'both') {
        await _storage.savePng(png);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n?.pngSaved ?? 'PNG Saved')));
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n?.storagePermissionDenied ?? 'Permission Denied')));
    }
  }

  Future<bool> _requestPermission() async {
    return await Permission.storage.request().isGranted || await Permission.manageExternalStorage.request().isGranted;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l10n?.diagramEditor ?? 'Diagram Editor', style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
        actions: [
          if (_savedXml != null)
            IconButton(
              icon: const Icon(Icons.visibility, color: Colors.white),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => XmlPreviewPage(xml: _savedXml!, filePath: _savedFilePath ?? ''))),
            ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        ],
      ),
    );
  }
}