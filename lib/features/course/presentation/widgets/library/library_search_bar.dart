import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/l10n/app_localizations.dart';

class LibrarySearchBar extends StatefulWidget {
  final Function(String) onChanged;

  const LibrarySearchBar({super.key, required this.onChanged});

  @override
  State<LibrarySearchBar> createState() => _LibrarySearchBarState();
}

class _LibrarySearchBarState extends State<LibrarySearchBar> {
  Timer? _debounce;
  final TextEditingController _controller = TextEditingController();

  bool get _hasQuery => _controller.text.isNotEmpty;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onChanged(query);
    });
  }

  void _clearSearch() {
    _debounce?.cancel();
    _controller.clear();
    setState(() {});
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final borderColor = AppColors.borderOf(context);
    final primaryColor = AppColors.primaryOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _controller,
          onChanged: (value) {
            setState(() {});
            _onSearchChanged(value);
          },
          textInputAction: TextInputAction.search,
          style: TextStyle(
            color: AppColors.textPrimaryOf(context),
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: localizations.searchCourses,
            hintStyle: TextStyle(
              color: AppColors.textSecondaryOf(context),
              fontSize: 13,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: primaryColor,
              size: 22,
            ),
            suffixIcon: _hasQuery
                ? IconButton(
                    tooltip: MaterialLocalizations.of(
                      context,
                    ).deleteButtonTooltip,
                    onPressed: _clearSearch,
                    icon: Icon(
                      Icons.close_rounded,
                      color: AppColors.textSecondaryOf(context),
                      size: 20,
                    ),
                  )
                : null,
            filled: true,
            fillColor: AppColors.surfaceOf(context),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: primaryColor, width: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}
