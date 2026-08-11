import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:public_file_saver/public_file_saver.dart';
import '../widgets/certificate_widget.dart';
import 'package:flutter/rendering.dart';

class CertificatePreviewPage extends StatefulWidget {
  const CertificatePreviewPage({
    super.key,
  });

  @override
  State<CertificatePreviewPage> createState() =>
      _CertificatePreviewPageState();
}

class _CertificatePreviewPageState extends State<CertificatePreviewPage> {
  final GlobalKey _certificateKey = GlobalKey();

  bool _isSavingImage = false;
  bool _isSavingPdf = false;

  Future<Uint8List?> _captureCertificate() async {
    try {
      final boundary = _certificateKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;

      if (boundary == null) {
        return null;
      }

      final renderBox = boundary.size;
      final pixelRatio = 1402 / renderBox.width;

      final image = await boundary.toImage(
        pixelRatio: pixelRatio,
      );

      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      image.dispose();

      if (byteData == null) {
        return null;
      }

      return byteData.buffer.asUint8List();
    } catch (e) {
      debugPrint('Certificate capture error: $e');
      return null;
    }
  }

  Future<void> _downloadAsImage() async {
    if (_isSavingImage || _isSavingPdf) {
      return;
    }

    setState(() {
      _isSavingImage = true;
    });

    try {
      final imageBytes = await _captureCertificate();

      if (imageBytes == null) {
        _showMessage(
          'Could not generate the certificate image.',
          isError: true,
        );
        return;
      }

      final result = await PublicFileSaver().saveBytes(
        bytes: imageBytes,
        fileName: 'certificate_${DateTime.now().millisecondsSinceEpoch}.png',
        mimeType: 'image/png',
        subDir: 'Certificates',
      );

      if (!mounted) {
        return;
      }

      if (result != null && result.isSuccess) {
        _showMessage('Certificate image saved successfully.');
      } else {
        _showMessage(
          'Could not save the certificate image.',
          isError: true,
        );
      }
    } catch (e) {
      debugPrint('Save image error: $e');

      if (mounted) {
        _showMessage(
          'Something went wrong while saving the image.',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSavingImage = false;
        });
      }
    }
  }

  Future<void> _downloadAsPdf() async {
    if (_isSavingImage || _isSavingPdf) {
      return;
    }

    setState(() {
      _isSavingPdf = true;
    });

    try {
      final imageBytes = await _captureCertificate();

      if (imageBytes == null) {
        _showMessage(
          'Could not generate the certificate.',
          isError: true,
        );
        return;
      }

      final pdf = pw.Document();

      const certificateWidth = 1402.0;
      const certificateHeight = 1122.0;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat(
            certificateWidth,
            certificateHeight,
            marginAll: 0,
          ),
          margin: pw.EdgeInsets.zero,
          build: (context) {
            return pw.Image(
              pw.MemoryImage(imageBytes),
              width: certificateWidth,
              height: certificateHeight,
              fit: pw.BoxFit.fill,
            );
          },
        ),
      );

      final pdfBytes = await pdf.save();

      final result = await PublicFileSaver().saveBytes(
        bytes: pdfBytes,
        fileName: 'certificate_${DateTime.now().millisecondsSinceEpoch}.pdf',
        mimeType: 'application/pdf',
        subDir: 'Certificates',
      );

      if (!mounted) {
        return;
      }

      if (result != null && result.isSuccess) {
        _showMessage('Certificate PDF saved successfully.');
      } else {
        _showMessage(
          'Could not save the certificate PDF.',
          isError: true,
        );
      }
    } catch (e) {
      debugPrint('Save PDF error: $e');

      if (mounted) {
        _showMessage(
          'Something went wrong while creating the PDF.',
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSavingPdf = false;
        });
      }
    }
  }

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = _isSavingImage || _isSavingPdf;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate Preview'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: RepaintBoundary(
                  key: _certificateKey,
                  child: const CertificateWidget(),
                ),
              ),
            ),
          ),

          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isSaving ? null : _downloadAsImage,
                      icon: _isSavingImage
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.image_outlined),
                      label: Text(
                        _isSavingImage
                            ? 'Saving...'
                            : 'Download Image',
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isSaving ? null : _downloadAsPdf,
                      icon: _isSavingPdf
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.picture_as_pdf_outlined),
                      label: Text(
                        _isSavingPdf
                            ? 'Saving...'
                            : 'Download PDF',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
