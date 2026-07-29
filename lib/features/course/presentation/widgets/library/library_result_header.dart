import 'package:flutter/material.dart';
import 'package:project1/l10n/app_localizations.dart';

class LibraryResultHeader extends StatelessWidget {
  final int count;

  const LibraryResultHeader({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            localizations.showingResults(count),
            softWrap: true,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}