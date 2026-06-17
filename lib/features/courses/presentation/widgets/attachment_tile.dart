import 'package:flutter/material.dart';

class AttachmentTile extends StatelessWidget {
  final String title;
  final String type;
  final String size;

  const AttachmentTile({
    super.key,
    required this.title,
    required this.type,
    required this.size,
  });

  IconData _icon() {
    switch (type) {
      case "PDF":
        return Icons.picture_as_pdf;
      case "ZIP":
        return Icons.folder_zip;
      case "PPTX":
        return Icons.slideshow;
      case "DOCX":
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  @override
  Widget build(BuildContext context) {
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
        ),
        title: Text(title),
        subtitle: Text("$type • $size"),
        trailing: const Icon(
          Icons.download_rounded,
        ),
      ),
    );
  }
}