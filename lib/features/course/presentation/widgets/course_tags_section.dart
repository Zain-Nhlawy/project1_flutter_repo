import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/course/presentation/cubit/course_cubit.dart';
import 'package:project1/features/course/presentation/cubit/course_state.dart';
import 'package:project1/features/course/presentation/widgets/tags_selector.dart';
import 'package:project1/l10n/app_localizations.dart';

class CourseTagsSection extends StatelessWidget {
  final Set<String> selectedTagIds;
  final ValueChanged<String> onToggle;
  final bool enabled;

  const CourseTagsSection({
    super.key,
    required this.selectedTagIds,
    required this.onToggle,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations.tags,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),

        BlocBuilder<CourseCubit, CourseState>(
          buildWhen: (previous, current) {
            return current is CourseTagsLoading ||
                current is CourseTagsLoaded ||
                current is CourseTagsError;
          },
          builder: (context, state) {
            if (state is CourseTagsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CourseTagsLoaded) {
              return TagsSelector(
                availableTags: state.tags,
                selectedTagIds: selectedTagIds,
                onToggle: onToggle,
                enabled: enabled,
                isLoading: false,
              );
            }

            if (state is CourseTagsError) {
              return Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              );
            }

            return const SizedBox();
          },
        ),
      ],
    );
  }
}