import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/course/presentation/cubit/tags_cubit.dart';
import 'package:project1/features/course/presentation/cubit/tags_state.dart';

class LibraryFilters extends StatefulWidget {
  final Function(List<String>?) onTagSelected;

  const LibraryFilters({
    super.key,
    required this.onTagSelected,
  });

  @override
  State<LibraryFilters> createState() => _LibraryFiltersState();
}

class _LibraryFiltersState extends State<LibraryFilters> {
  final List<String> selectedIds = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: BlocBuilder<TagsCubit, TagsState>(
        builder: (context, state) {
          if (state is TagsLoaded) {
            return ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(12),
              children: [
                _filter(
                  "All",
                  selectedIds.isEmpty,
                  () {
                    setState(() {
                      selectedIds.clear();
                    });
                    widget.onTagSelected(null);
                  },
                ),
                ...state.tags.map((tag) {
                  final isSelected = selectedIds.contains(tag.id);

                  return _filter(
                    tag.name,
                    isSelected,
                    () {
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
                    },
                  );
                }),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _filter(
    String text,
    bool selected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}