import 'package:flutter/material.dart';
import 'diagram_page.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Page"),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Open Diagram"),
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