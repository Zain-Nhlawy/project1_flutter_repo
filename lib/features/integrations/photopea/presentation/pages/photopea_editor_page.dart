import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:project1/l10n/app_localizations.dart';

class PhotopeaEditorPage extends StatefulWidget {
  const PhotopeaEditorPage({super.key});

  @override
  State<PhotopeaEditorPage> createState() => _PhotopeaEditorPageState();
}

class _PhotopeaEditorPageState extends State<PhotopeaEditorPage> {
  double _progress = 0;

  final String photopeaUrl = "https://www.photopea.com#%7%7B%22t";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.photopeaEditor,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(photopeaUrl)),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              useHybridComposition: true,
              hardwareAcceleration: true,
              javaScriptCanOpenWindowsAutomatically: true,
              iframeAllow: "camera; microphone; display-capture; geolocation",
              allowUniversalAccessFromFileURLs: true,
              allowFileAccessFromFileURLs: true,
            ),
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
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.blueAccent,
              ),
            ),
        ],
      ),
    );
  }
}
