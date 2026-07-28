import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/department/presentation/cubit/roadmap_cubit/roadmap_cubit.dart';
import 'package:project1/l10n/app_localizations.dart';

class RoadmapGenerateDialog extends StatefulWidget {
  final String departmentId;
  final String demoId;

  const RoadmapGenerateDialog({
    super.key,
    required this.departmentId,
    required this.demoId,
  });

  static Future<void> show(
    BuildContext context, {
    required String departmentId,
    required String demoId,
  }) {
    final cubit = context.read<RoadmapCubit>();
    return showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: RoadmapGenerateDialog(
          departmentId: departmentId,
          demoId: demoId,
        ),
      ),
    );
  }

  @override
  State<RoadmapGenerateDialog> createState() => _RoadmapGenerateDialogState();
}

class _RoadmapGenerateDialogState extends State<RoadmapGenerateDialog> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final surfaceColor = AppColors.surfaceOf(context);
    final textPrimary = AppColors.textPrimaryOf(context);

    return AlertDialog(
      scrollable: true,
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppColors.headerGradientOf(context),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.generateRoadmap,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.generateRoadmapDesc,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondaryOf(context),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              autofocus: true,
              style: TextStyle(color: textPrimary),
              decoration: InputDecoration(
                labelText: l10n.roadmapTitleOrRole,
                hintText: l10n.roadmapTitleHint,
                hintStyle: TextStyle(color: AppColors.textSecondaryOf(context)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.primaryOf(context),
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            l10n.cancel,
            style: TextStyle(color: AppColors.textSecondaryOf(context)),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              final title = _titleController.text.trim();
              if (title.isNotEmpty) {
                final cubit = context.read<RoadmapCubit>();
                Navigator.pop(context);
                cubit.createRoadmap(widget.departmentId, widget.demoId, title);
              }
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                gradient: AppColors.headerGradientOf(context),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bolt_rounded, size: 18, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(
                    l10n.generate,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
