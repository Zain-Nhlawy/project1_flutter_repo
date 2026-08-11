import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:public_file_saver/public_file_saver.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/l10n/app_localizations.dart';

class AttachmentTile extends StatefulWidget {
  final String title;
  final String type;
  final String size;
  final String url;

  const AttachmentTile({
    super.key,
    required this.title,
    required this.type,
    required this.size,
    required this.url,
  });

  @override
  State<AttachmentTile> createState() => _AttachmentTileState();
}

class _AttachmentTileState extends State<AttachmentTile> {
  final Dio _dio = Dio();

  bool _isOpening = false;
  bool _isDownloading = false;

  IconData _icon() {
    switch (widget.type.toUpperCase()) {
      case 'PDF':
        return Icons.picture_as_pdf;
      case 'ZIP':
        return Icons.folder_zip;
      case 'PPT':
      case 'PPTX':
        return Icons.slideshow;
      case 'DOC':
      case 'DOCX':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  String get _fileName {
    final uri = Uri.tryParse(widget.url);

    final lastSegment =
        (uri != null && uri.pathSegments.isNotEmpty)
            ? uri.pathSegments.last
            : null;

    final originalName =
        lastSegment != null && lastSegment.contains('.')
            ? lastSegment
            : '${widget.title}.${widget.type.toLowerCase()}';

    final dotIndex = originalName.lastIndexOf('.');

    if (dotIndex == -1) {
      return '${originalName}_${DateTime.now().millisecondsSinceEpoch}';
    }

    final name = originalName.substring(0, dotIndex);
    final extension = originalName.substring(dotIndex);

    return '${name}_${DateTime.now().millisecondsSinceEpoch}$extension';
  }

  String _getMimeType() {
    switch (widget.type.toUpperCase()) {
      case 'PDF':
        return 'application/pdf';
      case 'ZIP':
        return 'application/zip';
      case 'PPT':
        return 'application/vnd.ms-powerpoint';
      case 'PPTX':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case 'DOC':
        return 'application/msword';
      case 'DOCX':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      default:
        return 'application/octet-stream';
    }
  }

  Future<String> _downloadTo(Directory dir) async {
    final savePath = '${dir.path}/$_fileName';
    await _dio.download(widget.url, savePath);
    return savePath;
  }

  Future<void> _openAttachment() async {
    if (_isOpening) return;

    final localizations = AppLocalizations.of(context)!;

    setState(() => _isOpening = true);

    try {
      final cacheDir = await getTemporaryDirectory();
      final path = await _downloadTo(cacheDir);

      final result = await OpenFilex.open(path);

      if (result.type != ResultType.done && mounted) {
        SnackbarTheme().newSnackBarError(
          context,
          localizations.failedToOpenAttachment,
        );
      }
    } catch (_) {
      if (mounted) {
        SnackbarTheme().newSnackBarError(
          context,
          localizations.failedToOpenAttachment,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isOpening = false);
      }
    }
  }

  Future<void> _downloadAttachment() async {
    if (_isDownloading) return;

    final localizations = AppLocalizations.of(context)!;

    setState(() => _isDownloading = true);

    try {
      final response = await _dio.get<List<int>>(
        widget.url,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      if (response.data == null) {
        throw Exception('Empty response');
      }

      final bytes = Uint8List.fromList(response.data!);

      final result = await PublicFileSaver().saveBytes(
        bytes: bytes,
        fileName: _fileName,
        mimeType: _getMimeType(),
        subDir: 'Attachments',
      );

      if (!mounted) return;

      if (result != null && result.isSuccess) {
        SnackbarTheme().newSnackBarSuccess(
          context,
          localizations.attachmentDownloaded,
        );
      } else {
        SnackbarTheme().newSnackBarError(
          context,
          localizations.failedToDownloadAttachment,
        );
      }
    } catch (e) {
      debugPrint('Download attachment error: $e');

      if (mounted) {
        SnackbarTheme().newSnackBarError(
          context,
          localizations.failedToDownloadAttachment,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final subtitle =
        widget.size.isNotEmpty
            ? '${widget.type} • ${widget.size}'
            : widget.type;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: Colors.grey.withOpacity(.2),
        ),
      ),
      child: ListTile(
        leading: Icon(
          _icon(),
          size: 30,
          color: AppColors.primary,
        ),
        title: Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(subtitle),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _isOpening
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: _openAttachment,
                    icon: const Icon(
                      Icons.open_in_new_rounded,
                      color: AppColors.primary,
                    ),
                  ),
            _isDownloading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: _downloadAttachment,
                    icon: const Icon(
                      Icons.download_rounded,
                      color: AppColors.primary,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}