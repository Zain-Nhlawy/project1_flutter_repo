import 'package:flutter/material.dart';
import 'package:project1/features/attachment/domain/entities/lesson_attachment_entity.dart';
import 'package:project1/features/attachment/presentation/widgets/details/attachment_tile.dart';
import 'package:project1/l10n/app_localizations.dart';

class AttachmentsTab extends StatelessWidget {
  final List<LessonAttachmentEntity> attachments;
  final bool loading;

  const AttachmentsTab({
    required this.attachments,
    required this.loading,
  });

  String _fullAttachmentUrl(String path) {
  const baseUrl =
      'https://lincostorage.blob.core.windows.net/uploads/';
  if (path.startsWith('http')) {
    return path;
  }
  return '$baseUrl$path';
}

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (attachments.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noAttachments));
    }

    return ListView.builder(
      itemCount: attachments.length,
      itemBuilder: (context, index) {
        final attachment = attachments[index];
        final extension = attachment.path.split('.').last.toUpperCase();

        return AttachmentTile(
          title: attachment.name,
          type: extension,
          size: '',
          url: _fullAttachmentUrl(attachment.path),
        );
      },
    );
  }
}