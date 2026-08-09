import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/course/presentation/cubit/tags_cubit.dart';
import 'package:project1/features/course/presentation/cubit/tags_state.dart';
import 'package:project1/l10n/app_localizations.dart';

class LibraryFilters extends StatefulWidget {
  final Function(List<String>?) onTagSelected;

  const LibraryFilters({super.key, required this.onTagSelected});

  @override
  State<LibraryFilters> createState() => _LibraryFiltersState();
}

class _LibraryFiltersState extends State<LibraryFilters> {
  final List<String> selectedIds = [];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SizedBox(
      height: 66,
      child: BlocBuilder<TagsCubit, TagsState>(
        builder: (context, state) {
          if (state is TagsLoaded) {
            if (state.tags.isEmpty) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    localizations.noTagsAvailable,
                    style: TextStyle(
                      color: AppColors.textSecondaryOf(context),
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }

            return ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 10, 8, 8),
              children: [
                _filter(
                  localizations.allFilters,
                  selectedIds.isEmpty,
                  Icons.tune_rounded,
                  () {
                    setState(() {
                      selectedIds.clear();
                    });
                    widget.onTagSelected(null);
                  },
                ),
                ...state.tags.map((tag) {
                  final isSelected = selectedIds.contains(tag.id);

                  return _filter(tag.name, isSelected, Icons.sell_outlined, () {
                    setState(() {
                      if (isSelected) {
                        selectedIds.remove(tag.id);
                      } else {
                        selectedIds.add(tag.id);
                      }
                    });

                    widget.onTagSelected(
                      selectedIds.isEmpty ? null : List.from(selectedIds),
                    );
                  });
                }),
              ],
            );
          }

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 10, 8, 8),
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, index) => Container(
              width: index == 0 ? 96 : 76,
              decoration: BoxDecoration(
                color: AppColors.surfaceOf(context),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderOf(context)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _filter(
    String text,
    bool selected,
    IconData icon,
    VoidCallback onTap,
  ) {
    final primaryColor = AppColors.primaryOf(context);

    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: Semantics(
        button: true,
        selected: selected,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: selected ? primaryColor : AppColors.surfaceOf(context),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected ? primaryColor : AppColors.borderOf(context),
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.18),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    selected ? Icons.check_rounded : icon,
                    size: 16,
                    color: selected
                        ? Colors.white
                        : AppColors.textSecondaryOf(context),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    text,
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : AppColors.textPrimaryOf(context),
                      fontSize: 12,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
