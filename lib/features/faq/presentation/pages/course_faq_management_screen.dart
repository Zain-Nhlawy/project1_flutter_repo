import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/config/theme/snackbar_theme.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/core/presentation/widgets/gradient_action_button.dart';
import 'package:project1/core/presentation/widgets/gradient_page_app_bar.dart';
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
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            decoration: BoxDecoration(
              color: AppColors.surfaceOf(sheetContext),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
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
                        color: AppColors.borderOf(sheetContext),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primaryOf(
                            sheetContext,
                          ).withValues(alpha: 0.09),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.help_outline_rounded,
                          color: AppColors.primaryOf(sheetContext),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.addFaq,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimaryOf(sheetContext),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: questionController,
                    maxLines: 2,
                    style: TextStyle(
                      color: AppColors.textPrimaryOf(sheetContext),
                    ),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.question,
                      prefixIcon: Icon(
                        Icons.quiz_outlined,
                        color: AppColors.primaryOf(sheetContext),
                      ),
                      filled: true,
                      fillColor: AppColors.backgroundOf(sheetContext),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: AppColors.borderOf(sheetContext),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: AppColors.borderOf(sheetContext),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: AppColors.primaryOf(sheetContext),
                          width: 1.7,
                        ),
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
                    style: TextStyle(
                      color: AppColors.textPrimaryOf(sheetContext),
                    ),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.answer,
                      prefixIcon: Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: AppColors.primaryOf(sheetContext),
                      ),
                      filled: true,
                      fillColor: AppColors.backgroundOf(sheetContext),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: AppColors.borderOf(sheetContext),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: AppColors.borderOf(sheetContext),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: AppColors.primaryOf(sheetContext),
                          width: 1.7,
                        ),
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
                  GradientActionButton(
                    label: AppLocalizations.of(context)!.addFaq,
                    icon: Icons.add_rounded,
                    expand: true,
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

    if (!mounted) return;

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
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _hasChanges);
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundOf(context),
        appBar: GradientPageAppBar(
          title: AppLocalizations.of(context)!.faqs,
          subtitle: widget.courseTitle,
          onBackPressed: () => Navigator.pop(context, _hasChanges),
        ),
        floatingActionButton: GradientActionButton(
          onPressed: _openAddFaqSheet,
          icon: Icons.add_rounded,
          label: AppLocalizations.of(context)!.addFaq,
        ),
        body: BlocConsumer<CourseFaqCubit, CourseFaqState>(
          listener: (context, state) {
            if (state is CourseFaqActionSuccess) {
              SnackbarTheme().newSnackBarInfo(context, state.message);
              _refresh();
            } else if (state is CourseFaqError) {
              SnackbarTheme().newSnackBarError(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is CourseFaqLoading || state is CourseFaqInitial) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryOf(context),
                ),
              );
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
                        color: AppColors.textSecondaryOf(
                          context,
                        ).withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondaryOf(context),
                        ),
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
                child: Container(
                  margin: const EdgeInsets.all(28),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 30,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceOf(context),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.borderOf(context)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 66,
                        height: 66,
                        decoration: BoxDecoration(
                          color: AppColors.primaryOf(
                            context,
                          ).withValues(alpha: 0.09),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.help_outline_rounded,
                          size: 31,
                          color: AppColors.primaryOf(context),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        AppLocalizations.of(context)!.noFaqsYet,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryOf(context),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        AppLocalizations.of(context)!.tapToAddFaq,
                        style: TextStyle(
                          color: AppColors.textSecondaryOf(
                            context,
                          ).withValues(alpha: 0.82),
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
                padding: const EdgeInsets.fromLTRB(18, 24, 18, 100),
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
