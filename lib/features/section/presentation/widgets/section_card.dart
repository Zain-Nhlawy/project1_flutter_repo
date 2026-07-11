import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/section/domain/entities/section_entity.dart';
import 'package:project1/features/section/presentation/widgets/section_sub_row.dart';
import 'package:project1/l10n/app_localizations.dart';

class SectionCard extends StatefulWidget {
  final SectionEntity section;

  final VoidCallback onAddLesson;
  final VoidCallback onEditLesson;
  final VoidCallback onManageQuestionsBank;
  final VoidCallback onManageQuiz;
  final VoidCallback onRename;
  final VoidCallback onDelete;

  const SectionCard({
    super.key,
    required this.section,
    required this.onAddLesson,
    required this.onEditLesson,
    required this.onManageQuestionsBank,
    required this.onManageQuiz,
    required this.onRename,
    required this.onDelete,
  });

  @override
  State<SectionCard> createState() => _SectionCardState();
}

class _SectionCardState extends State<SectionCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => setState(() => expanded = !expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.folder_copy_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      widget.section.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),

                  Text(
                    "#${widget.section.order}",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary.withOpacity(.7),
                    ),
                  ),

                  const SizedBox(width: 6),

                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    splashRadius: 18,
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'rename':
                          widget.onRename();
                          break;

                        case 'delete':
                          widget.onDelete();
                          break;
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 'rename',
                        child: Row(
                          children: [
                            const Icon(
                              Icons.drive_file_rename_outline_rounded,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 10),
                            Text(localizations.renameSection),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline_rounded,
                              size: 18,
                              color: Colors.red.shade400,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              localizations.deleteSection,
                              style: TextStyle(
                                color: Colors.red.shade400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  AnimatedRotation(
                    turns: expanded ? .5 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          AnimatedCrossFade(
            duration: const Duration(milliseconds: 220),
            sizeCurve: Curves.easeInOut,
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(
              width: double.infinity,
              height: 0,
            ),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: AppColors.border,
                    height: 1,
                  ),

                  const SizedBox(height: 16),

                  InkWell(
                    onTap: widget.onAddLesson,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(.3),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            localizations.addLesson,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  SectionSubRow(
                    icon: Icons.quiz_outlined,
                    label: localizations.questionsBank,
                    onEdit: widget.onManageQuestionsBank,
                  ),

                  const SizedBox(height: 8),

                  SectionSubRow(
                    icon: Icons.fact_check_outlined,
                    label: localizations.quiz,
                    onEdit: widget.onManageQuiz,
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