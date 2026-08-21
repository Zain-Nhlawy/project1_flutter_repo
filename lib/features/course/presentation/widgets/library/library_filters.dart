import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/presentation/widgets/gradient_action_button.dart';
import 'package:project1/core/presentation/widgets/app_skeletonizer.dart';
import 'package:project1/features/course/domain/entities/tag_entity.dart';
import 'package:project1/features/course/presentation/cubit/tags_cubit.dart';
import 'package:project1/features/course/presentation/cubit/tags_state.dart';
import 'package:project1/l10n/app_localizations.dart';

class LibraryFilters extends StatefulWidget {
  final ValueChanged<List<String>?> onTagSelected;

  const LibraryFilters({super.key, required this.onTagSelected});

  @override
  State<LibraryFilters> createState() => _LibraryFiltersState();
}

class _LibraryFiltersState extends State<LibraryFilters> {
  final Set<String> _selectedIds = <String>{};

  bool _sameSelection(Set<String> other) {
    return other.length == _selectedIds.length &&
        other.every(_selectedIds.contains);
  }

  Future<void> _openTagPicker(List<TagEntity> tags) async {
    final availableIds = tags.map((tag) => tag.id).toSet();
    final initialSelection = _selectedIds.intersection(availableIds);

    final result = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.42),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
          ),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.72,
            minChildSize: 0.48,
            maxChildSize: 0.92,
            builder: (context, scrollController) {
              return _TagPickerSheet(
                tags: tags,
                initialSelectedIds: initialSelection,
                scrollController: scrollController,
              );
            },
          ),
        );
      },
    );

    if (result == null || !mounted || _sameSelection(result)) return;

    setState(() {
      _selectedIds
        ..clear()
        ..addAll(result);
    });
    widget.onTagSelected(_selectedIds.isEmpty ? null : _selectedIds.toList());
  }

  void _clearSelection() {
    if (_selectedIds.isEmpty) return;

    setState(_selectedIds.clear);
    widget.onTagSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SizedBox(
      height: 78,
      child: BlocBuilder<TagsCubit, TagsState>(
        builder: (context, state) {
          if (state is TagsLoaded && state.tags.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: _TagFilterControl(
                selectedCount: _selectedIds.length,
                onTap: () => _openTagPicker(state.tags),
                onClear: _selectedIds.isEmpty ? null : _clearSelection,
              ),
            );
          }

          if (state is TagsLoaded) {
            return _TagFilterStatus(
              icon: Icons.sell_outlined,
              message: localizations.noTagsAvailable,
            );
          }

          if (state is TagsError) {
            return _TagFilterStatus(
              icon: Icons.refresh_rounded,
              message: state.errors.isEmpty
                  ? localizations.retry
                  : state.errors.first,
              onTap: () => context.read<TagsCubit>().fetchTags(),
            );
          }

          return const Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: _TagFilterLoading(),
          );
        },
      ),
    );
  }
}

class _TagFilterControl extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _TagFilterControl({
    required this.selectedCount,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final primary = AppColors.primaryOf(context);
    final hasSelection = selectedCount > 0;

    return Semantics(
      button: true,
      label: localizations.tags,
      value: hasSelection
          ? localizations.selectedTagsCount(selectedCount)
          : localizations.allFilters,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsetsDirectional.fromSTEB(13, 8, 8, 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceOf(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: hasSelection
                    ? primary.withValues(alpha: 0.34)
                    : AppColors.borderOf(context),
                width: hasSelection ? 1.2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: hasSelection ? 0.09 : 0.035),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.filter_alt_outlined,
                    color: primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.tags,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimaryOf(context),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        hasSelection
                            ? localizations.selectedTagsCount(selectedCount)
                            : localizations.allFilters,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondaryOf(context),
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasSelection)
                  Container(
                    constraints: const BoxConstraints(minWidth: 30),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.buttonGradientOf(context),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$selectedCount',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                const SizedBox(width: 4),
                if (onClear != null)
                  IconButton(
                    tooltip: localizations.clearAll,
                    onPressed: onClear,
                    visualDensity: VisualDensity.compact,
                    icon: Icon(
                      Icons.close_rounded,
                      color: AppColors.textSecondaryOf(context),
                      size: 19,
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.textSecondaryOf(context),
                      size: 22,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TagFilterLoading extends StatelessWidget {
  const _TagFilterLoading();

  @override
  Widget build(BuildContext context) {
    return AppSkeletonizer(
      child: _TagFilterControl(selectedCount: 0, onTap: () {}, onClear: null),
    );
  }
}

class _TagFilterStatus extends StatelessWidget {
  final IconData icon;
  final String message;
  final VoidCallback? onTap;

  const _TagFilterStatus({
    required this.icon,
    required this.message,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceOf(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderOf(context)),
            ),
            child: Row(
              children: [
                Icon(icon, color: AppColors.textSecondaryOf(context), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondaryOf(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TagPickerSheet extends StatefulWidget {
  final List<TagEntity> tags;
  final Set<String> initialSelectedIds;
  final ScrollController scrollController;

  const _TagPickerSheet({
    required this.tags,
    required this.initialSelectedIds,
    required this.scrollController,
  });

  @override
  State<_TagPickerSheet> createState() => _TagPickerSheetState();
}

class _TagPickerSheetState extends State<_TagPickerSheet> {
  late final Set<String> _draftSelectedIds;
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _draftSelectedIds = {...widget.initialSelectedIds};
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TagEntity> get _visibleTags {
    final normalizedQuery = _query.trim().toLowerCase();
    final visible = widget.tags.where((tag) {
      return normalizedQuery.isEmpty ||
          tag.name.toLowerCase().contains(normalizedQuery);
    }).toList();

    visible.sort(
      (first, second) =>
          first.name.toLowerCase().compareTo(second.name.toLowerCase()),
    );
    return visible;
  }

  void _toggle(String id) {
    setState(() {
      if (_draftSelectedIds.contains(id)) {
        _draftSelectedIds.remove(id);
      } else {
        _draftSelectedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final primary = AppColors.primaryOf(context);
    final visibleTags = _visibleTags;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderOf(context),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 10, 10),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.filter_alt_outlined,
                    color: primary,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.tags,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.textPrimaryOf(context),
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        localizations.selectedTagsCount(
                          _draftSelectedIds.length,
                        ),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondaryOf(context),
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: _draftSelectedIds.isEmpty
                      ? null
                      : () => setState(_draftSelectedIds.clear),
                  child: Text(localizations.clearAll),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: TextField(
              controller: _searchController,
              autofocus: false,
              textInputAction: TextInputAction.search,
              onChanged: (value) => setState(() => _query = value),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimaryOf(context),
              ),
              decoration: InputDecoration(
                hintText: localizations.searchTags,
                hintStyle: TextStyle(color: AppColors.textSecondaryOf(context)),
                prefixIcon: Icon(Icons.search_rounded, color: primary),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
                filled: true,
                fillColor: AppColors.backgroundOf(context),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: AppColors.borderOf(context)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: AppColors.borderOf(context)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: primary, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: visibleTags.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        localizations.noTagsAvailable,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondaryOf(context),
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    controller: widget.scrollController,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
                    itemCount: visibleTags.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final tag = visibleTags[index];
                      final selected = _draftSelectedIds.contains(tag.id);
                      return _TagPickerTile(
                        tag: tag,
                        selected: selected,
                        onTap: () => _toggle(tag.id),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceOf(context),
              border: Border(
                top: BorderSide(color: AppColors.borderOf(context)),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimaryOf(context),
                        side: BorderSide(color: AppColors.borderOf(context)),
                        minimumSize: const Size.fromHeight(54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(localizations.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GradientActionButton(
                      label: localizations.applyFilters,
                      icon: Icons.check_rounded,
                      expand: true,
                      onPressed: () => Navigator.pop(
                        context,
                        Set<String>.of(_draftSelectedIds),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TagPickerTile extends StatelessWidget {
  final TagEntity tag;
  final bool selected;
  final VoidCallback onTap;

  const _TagPickerTile({
    required this.tag,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);

    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 170),
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
            decoration: BoxDecoration(
              color: selected
                  ? primary.withValues(alpha: 0.07)
                  : AppColors.backgroundOf(context).withValues(alpha: 0.68),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: selected
                    ? primary.withValues(alpha: 0.34)
                    : AppColors.borderOf(context),
                width: selected ? 1.2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.09),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(Icons.sell_outlined, color: primary, size: 18),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Text(
                    tag.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimaryOf(context),
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 170),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: selected ? primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selected ? primary : AppColors.borderOf(context),
                      width: 1.4,
                    ),
                  ),
                  child: selected
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
