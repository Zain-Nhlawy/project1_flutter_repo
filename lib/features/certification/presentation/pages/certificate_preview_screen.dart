import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/presentation/widgets/gradient_page_app_bar.dart';
import 'package:project1/features/certification/data/models/certification_model.dart';
import 'package:project1/features/certification/presentation/widgets/download_button.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:public_file_saver/public_file_saver.dart';
import '../widgets/certificate_widget.dart';

class CertificatePreviewPage extends StatefulWidget {
  final CertificationModel certification;

  const CertificatePreviewPage({
    super.key,
    required this.certification,
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

      if (renderBox.width <= 0) {
        return null;
      }

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

    final l = AppLocalizations.of(context)!;

    setState(() {
      _isSavingImage = true;
    });

    try {
      final imageBytes = await _captureCertificate();

      if (imageBytes == null) {
        _showMessage(
          l.couldNotGenerateCertificateImage,
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
        _showMessage(
          l.certificateImageSavedSuccessfully,
        );
      } else {
        _showMessage(
          l.couldNotSaveCertificateImage,
          isError: true,
        );
      }
    } catch (e) {
      debugPrint('Save image error: $e');

      if (mounted) {
        _showMessage(
          l.somethingWentWrongSavingImage,
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

    final l = AppLocalizations.of(context)!;

    setState(() {
      _isSavingPdf = true;
    });

    try {
      final imageBytes = await _captureCertificate();

      if (imageBytes == null) {
        _showMessage(
          l.couldNotGenerateCertificate,
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
        _showMessage(
          l.certificatePdfSavedSuccessfully,
        );
      } else {
        _showMessage(
          l.couldNotSaveCertificatePdf,
          isError: true,
        );
      }
    } catch (e) {
      debugPrint('Save PDF error: $e');

      if (mounted) {
        _showMessage(
          l.somethingWentWrongCreatingPdf,
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
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor: isError
              ? Theme.of(context).colorScheme.error
              : AppColors.primaryOf(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Row(
            children: [
              Icon(
                isError
                    ? Icons.error_outline_rounded
                    : Icons.check_circle_outline_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isSaving = _isSavingImage || _isSavingPdf;
    final primaryColor = AppColors.primaryOf(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: GradientPageAppBar(
        title: l.certificatePreview,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  top: -100,
                  right: -80,
                  child: IgnorePointer(
                    child: Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -120,
                  left: -100,
                  child: IgnorePointer(
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor.withValues(alpha: 0.04),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      24,
                      20,
                      32,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: primaryColor.withValues(alpha: 0.12),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: primaryColor.withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.workspace_premium_outlined,
                                  color: primaryColor,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      l.certificatePreview,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          AppTextStyles.titleMedium.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      l.reviewCertificateBeforeDownloading,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style:
                                          AppTextStyles.bodyMedium.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color
                                            ?.withValues(alpha: 0.65),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.10),
                                blurRadius: 28,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: RepaintBoundary(
                              key: _certificateKey,
                              child: CertificateWidget(
                                certification: widget.certification,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              size: 16,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.color
                                  ?.withValues(alpha: 0.55),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                l.certificateDownloadHint,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color
                                      ?.withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
  top: false,
  child: Container(
    padding: const EdgeInsets.fromLTRB(
      20,
      16,
      20,
      20,
    ),
    decoration: BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      border: Border(
        top: BorderSide(
          color: Theme.of(context).dividerColor
              .withValues(alpha: 0.5),
        ),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 18,
          offset: const Offset(0, -4),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: DownloadButton(
            label: 'Image',
            icon: Icons.download_rounded,
            isLoading: _isSavingImage,
            isPrimary: true,
            onPressed: isSaving ? null : _downloadAsImage,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: DownloadButton(
            label: 'PDF',
            icon: Icons.download_rounded,
            isLoading: _isSavingPdf,
            isPrimary: true,
            onPressed: isSaving ? null : _downloadAsPdf,
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
