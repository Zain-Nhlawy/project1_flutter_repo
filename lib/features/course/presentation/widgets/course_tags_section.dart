import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/core/dummy/dummy_entities.dart';
import 'package:project1/core/presentation/widgets/app_skeletonizer.dart';
import 'package:project1/features/course/presentation/cubit/tags_cubit.dart';
import 'package:project1/features/course/presentation/cubit/tags_state.dart';
import 'package:project1/features/course/presentation/widgets/tags_selector.dart';
import 'package:project1/l10n/app_localizations.dart';

class CourseTagsSection extends StatelessWidget {
  final Set<String> selectedTagIds;
  final ValueChanged<String> onToggle;
  final bool enabled;
  final bool showTitle;

  const CourseTagsSection({
    super.key,
    required this.selectedTagIds,
    required this.onToggle,
    required this.enabled,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle) ...[
          Text(
            localizations.tags,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.textPrimaryOf(context),
            ),
          ),
          const SizedBox(height: 10),
        ],

        BlocBuilder<TagsCubit, TagsState>(
          builder: (context, state) {
            if (state is TagsLoading) {
              return AppSkeletonizer(
                child: TagsSelector(
                  availableTags: List.filled(4, dummyTag),
                  selectedTagIds: const {},
                  onToggle: (_) {},
                  enabled: false,
                ),
              );
            }

            if (state is TagsLoaded) {
              return TagsSelector(
                availableTags: state.tags,
                selectedTagIds: selectedTagIds,
                onToggle: onToggle,
                enabled: enabled,
                isLoading: false,
              );
            }

            if (state is TagsError) {
              return Text(
                state.errors.isNotEmpty ? state.errors.first : '',
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
