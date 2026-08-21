import 'package:flutter/material.dart';
import 'package:project1/core/dummy/dummy_entities.dart';
import 'package:project1/core/presentation/widgets/app_skeletonizer.dart';
import 'package:project1/features/attachment/domain/entities/lesson_attachment_entity.dart';
import 'package:project1/features/attachment/presentation/widgets/details/attachment_tile.dart';
import 'package:project1/l10n/app_localizations.dart';

class AttachmentsTab extends StatelessWidget {
  final List<LessonAttachmentEntity> attachments;
  final bool loading;

  const AttachmentsTab({
    super.key,
    required this.attachments,
    required this.loading,
  });

  String _fullAttachmentUrl(String path) {
    const baseUrl = 'https://lincostorage.blob.core.windows.net/uploads/';
    if (path.startsWith('http')) {
      return path;
    }
    return '$baseUrl$path';
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return AppSkeletonizer(
        child: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index) => AttachmentTile(
            title: dummyLessonAttachment.name,
            type: 'PDF',
            size: '1.2 MB',
            url: '',
          ),
        ),
      );
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
