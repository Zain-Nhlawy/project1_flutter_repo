import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/faq/domain/entities/course_faq_entity.dart';
import 'package:project1/features/faq/presentation/cubit/course_faq_cubit.dart';
import 'package:project1/features/faq/presentation/cubit/course_faq_state.dart';
import 'package:project1/features/faq/presentation/widgets/management/course_faq_tile.dart';
import 'package:project1/l10n/app_localizations.dart';

class CourseFaqManagementScreen extends StatelessWidget {
  final String courseId;
  final String courseTitle;

  const CourseFaqManagementScreen({
    super.key,
    required this.courseId,
    required this.courseTitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CourseFaqCubit>()..getCourseFaqs(courseId: courseId),
      child: _CourseFaqManagementView(
        courseId: courseId,
        courseTitle: courseTitle,
      ),
    );
  }
}

class _CourseFaqManagementView extends StatefulWidget {
  final String courseId;
  final String courseTitle;

  const _CourseFaqManagementView({
    required this.courseId,
    required this.courseTitle,
  });

  @override
  State<_CourseFaqManagementView> createState() =>
      _CourseFaqManagementViewState();
}

class _CourseFaqManagementViewState extends State<_CourseFaqManagementView> {
  bool _hasChanges = false;

  void _refresh() {
    context.read<CourseFaqCubit>().getCourseFaqs(courseId: widget.courseId);
  }

  Future<void> _openAddFaqSheet() async {
    final questionController = TextEditingController();
    final answerController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.addFaq,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: questionController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.question,
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppLocalizations.of(context)!.questionIsRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: answerController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.answer,
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppLocalizations.of(context)!.answerIsRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (formKey.currentState?.validate() != true) return;

                        context.read<CourseFaqCubit>().createCourseFaq(
                          courseId: widget.courseId,
                          question: questionController.text.trim(),
                          answer: answerController.text.trim(),
                        );
                        _hasChanges = true;
                        Navigator.pop(sheetContext);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.addFaq,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmDelete(CourseFaqEntity faq) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.deleteFaq),
        content: Text(l10n.deleteFaqConfirmation(faq.question)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _hasChanges = true;
      context.read<CourseFaqCubit>().deleteCourseFaq(
        courseId: widget.courseId,
        faqId: faq.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        Navigator.pop(context, _hasChanges);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context, _hasChanges),
          ),
          title: Text(
            AppLocalizations.of(context)!.faqs,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          onPressed: _openAddFaqSheet,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: Text(
            AppLocalizations.of(context)!.addFaq,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: BlocConsumer<CourseFaqCubit, CourseFaqState>(
          listener: (context, state) {
            if (state is CourseFaqActionSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
              _refresh();
            } else if (state is CourseFaqError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is CourseFaqLoading || state is CourseFaqInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CourseFaqError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 40,
                        color: AppColors.textSecondary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _refresh,
                        child: Text(AppLocalizations.of(context)!.retry),
                      ),
                    ],
                  ),
                ),
              );
            }

            List<CourseFaqEntity> faqs = [];
            if (state is CourseFaqLoaded) {
              faqs = state.faqs;
            }

            if (faqs.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.help_outline_rounded,
                        size: 48,
                        color: AppColors.textSecondary.withOpacity(0.4),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.noFaqsYet,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        AppLocalizations.of(context)!.tapToAddFaq,
                        style: TextStyle(
                          color: AppColors.textSecondary.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async => _refresh(),
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                itemCount: faqs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final faq = faqs[index];
                  return FaqTile(faq: faq, onDelete: () => _confirmDelete(faq));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
