import 'package:flutter/material.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/lesson/presentation/pages/create_lesson_screen.dart';
import 'package:project1/features/section/domain/entities/section_entity.dart';
import 'package:project1/features/section/presentation/widgets/section_card.dart';
import 'package:project1/l10n/app_localizations.dart';

class SectionManagementScreen extends StatefulWidget {
  final String courseTitle;

  const SectionManagementScreen({
    super.key,
    required this.courseTitle,
  });

  @override
  State<SectionManagementScreen> createState() => _SectionManagementScreenState();
}

class _SectionManagementScreenState extends State<SectionManagementScreen> {
  // dummy data 
  List<SectionEntity> sections = [
    const SectionEntity(
      id: 's1',
      title: 'Introduction',
      lessons: [
        LessonEntity(id: 'l1', title: 'Welcome to the course'),
        LessonEntity(id: 'l2', title: 'How Flutter works'),
      ],
    ),
    const SectionEntity(
      id: 's2',
      title: 'Widgets Basics',
      lessons: [
        LessonEntity(id: 'l3', title: 'Stateless vs Stateful'),
      ],
    ),
  ];

  Future<void> addLessonTo(SectionEntity section) async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const CreateLessonScreen(),
    ),
  );
}

  void editLesson(SectionEntity section, LessonEntity lesson) {
    // TODO
  }

  void manageQuestionsBank(SectionEntity section) {
    // TODO
  }

  void manageQuiz(SectionEntity section) {
    // TODO
  }

  Future<void> renameSection(SectionEntity section) async {
    final localizations = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: section.title);

    final newTitle = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(localizations.renameSection),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: localizations.sectionName,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              localizations.cancel,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              final cleaned = controller.text.trim();
              if (cleaned.isNotEmpty) {
                Navigator.pop(dialogContext, cleaned);
              }
            },
            child: Text(
              localizations.save,
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (newTitle != null && newTitle.isNotEmpty) {
      setState(() {
        final index = sections.indexWhere((s) => s.id == section.id);
        if (index != -1) {
          sections[index] = sections[index].copyWith(title: newTitle);
        }
      });
    }
  }

  Future<void> deleteSection(SectionEntity section) async {
    final localizations = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(localizations.deleteSection),
        content: Text(localizations.deleteSectionConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              localizations.cancel,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              localizations.deleteSection,
              style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        sections.removeWhere((s) => s.id == section.id);
      });
    }
  }

Future<void> addSection() async {
  final localizations = AppLocalizations.of(context)!;
  final controller = TextEditingController();

  final newTitle = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(localizations.addSection),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
          hintText: localizations.sectionName,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: Text(
            localizations.cancel,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
        TextButton(
          onPressed: () {
            final cleaned = controller.text.trim();
            if (cleaned.isNotEmpty) {
              Navigator.pop(dialogContext, cleaned);
            }
          },
          child: Text(
            localizations.add,
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );

  if (newTitle != null && newTitle.isNotEmpty) {
    setState(() {
      sections.add(
        SectionEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: newTitle,
          lessons: const [],
        ),
      );
    });
  }
}

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations.sections,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
      ),
      body: sections.isEmpty
          ? Center(
              child: Text(
                localizations.noSectionsYet,
                style: TextStyle(color: AppColors.textSecondary.withOpacity(0.7)),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final section = sections[index];
                return SectionCard(
                  section: section,
                  onAddLesson: () => addLessonTo(section),
                  onEditLesson: (lesson) => editLesson(section, lesson),
                  onManageQuestionsBank: () => manageQuestionsBank(section),
                  onManageQuiz: () => manageQuiz(section),
                  onRename: () => renameSection(section),
                  onDelete: () => deleteSection(section),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: addSection,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          localizations.addSection,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}