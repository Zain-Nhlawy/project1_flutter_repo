import 'package:flutter/material.dart';
import 'diagram_page.dart';
import 'package:project1/l10n/app_localizations.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.testPage),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text(AppLocalizations.of(context)!.openDiagram),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const DrawioPage(),
              ),
            );
          },
        ),
      ),
    );
  }
}