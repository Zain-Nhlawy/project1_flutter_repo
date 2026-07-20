import 'package:flutter/material.dart';
import 'package:project1/features/course/presentation/widgets/management/management_action_tile.dart';
import 'package:project1/features/faq/presentation/pages/course_faq_management_screen.dart';
import 'package:project1/features/section/presentation/pages/section_management_screen.dart';
import 'package:project1/l10n/app_localizations.dart';

class CourseManagementActionsRow extends StatelessWidget {
  final String courseId;
  final String courseTitle;
  final VoidCallback onSectionsChanged;

  const CourseManagementActionsRow({
    super.key,
    required this.courseId,
    required this.courseTitle,
    required this.onSectionsChanged,
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
                  builder: (_) => CourseFaqManagementScreen(
                    courseId: courseId,
                    courseTitle: courseTitle,
                  ),
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
            onTap: () async {
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => SectionManagementScreen(
                    courseId: courseId,
                    courseTitle: courseTitle,
                  ),
                ),
              );
              if (result == true) {
                onSectionsChanged();
              }
            },
          ),
        ),
      ],
    );
  }
}
