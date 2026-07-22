import 'package:flutter/material.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/l10n/app_localizations.dart';

class AttachmentTile extends StatelessWidget {
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

  IconData _icon() {
    switch (type.toUpperCase()) {
      case "PDF":
        return Icons.picture_as_pdf;
      case "ZIP":
        return Icons.folder_zip;
      case "PPT":
      case "PPTX":
        return Icons.slideshow;
      case "DOC":
      case "DOCX":
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  Future<void> _openAttachment(BuildContext context) async {
    final localizations = AppLocalizations.of(context)!;
    final uri = Uri.tryParse(url);

    if (uri == null || !await canLaunchUrl(uri)) {
      if (context.mounted) {
        SnackbarTheme().newSnackBarError(
          context,
          localizations.failedToOpenAttachment,
        );
      }
      return;
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = size.isNotEmpty ? "$type • $size" : type;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.withOpacity(.2)),
      ),
      child: ListTile(
        onTap: () => _openAttachment(context),
        leading: Icon(_icon(), size: 30, color: AppColors.primary),
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.download_rounded, color: AppColors.primary),
      ),
    );
  }
}
