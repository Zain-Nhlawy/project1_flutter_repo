import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/course/domain/entities/tag_entity.dart';
import 'package:project1/features/course/presentation/widgets/course_tag.dart';
import 'package:project1/l10n/app_localizations.dart';

class TagsSelector extends StatelessWidget {
  final List<TagEntity> availableTags;
  final Set<String> selectedTagIds;
  final ValueChanged<String> onToggle;
  final bool enabled;
  final bool isLoading;

  const TagsSelector({
    super.key,
    required this.availableTags,
    required this.selectedTagIds,
    required this.onToggle,
    this.enabled = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (availableTags.isEmpty) {
      return Text(
        localizations.noTagsAvailable,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textSecondaryOf(context).withValues(alpha: 0.6),
        ),
      );
    }

    return IgnorePointer(
      ignoring: !enabled,
      child: Opacity(
        opacity: enabled ? 1 : 0.6,
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: availableTags.map((tag) {
            final selected = selectedTagIds.contains(tag.id);
            return CourseTag(
              text: tag.name,
              selected: selected,
              onTap: () => onToggle(tag.id),
            );
          }).toList(),
        ),
      ),
    );
  }
}
