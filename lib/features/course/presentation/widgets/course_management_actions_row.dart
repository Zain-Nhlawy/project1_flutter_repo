import 'package:flutter/material.dart';
import 'package:project1/features/course/presentation/pages/PlaceholderScreen.dart';
import 'package:project1/features/course/presentation/widgets/management_action_tile.dart';
import 'package:project1/features/section/presentation/pages/section_management_screen.dart';
import 'package:project1/l10n/app_localizations.dart';

class CourseManagementActionsRow extends StatelessWidget {
  final String courseTitle;

  const CourseManagementActionsRow({
    super.key,
    required this.courseTitle,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: ManagementActionTile(
            icon: Icons.help_outline_rounded,
            label: localizations.manageFaq,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlaceholderScreen(title: localizations.manageFaq),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ManagementActionTile(
            icon: Icons.view_list_rounded,
            label: localizations.manageSections,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SectionManagementScreen(courseTitle: courseTitle),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}