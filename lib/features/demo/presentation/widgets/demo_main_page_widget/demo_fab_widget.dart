import 'package:flutter/material.dart';
import 'package:project1/features/demo/domain/entities/demo_entity.dart';
import 'package:project1/features/demo/presentation/widgets/demo_main_page_widget/main_action_sheet.dart';

class DemoFabWidget extends StatelessWidget {
  final DemoEntity demo;

  const DemoFabWidget({super.key, required this.demo});

  @override
  Widget build(BuildContext context) {
    if (demo.isOwner != true) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return FloatingActionButton.extended(
      backgroundColor: theme.colorScheme.tertiary,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32),
      ),
      onPressed: () {
        showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          context: context,
          builder: (BuildContext context) {
            return MainActionsSheet(demoId: demo.id!);
          },
        );
      },
      label: const Icon(Icons.adjust_outlined, color: Colors.white),
    );
  }
}
