import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/demo/domain/entities/demo_report_entity.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20report/demo_report_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20report/demo_report_state.dart';
import 'package:project1/features/demo/presentation/widgets/demo_report_widgets/demo_report_widgets.dart';
import 'package:project1/l10n/app_localizations.dart';

class DemoStatsPage extends StatelessWidget {
  final String demoId;
  final String demoName;

  const DemoStatsPage({
    super.key,
    required this.demoId,
    required this.demoName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DemoReportCubit>()..fetchReport(demoId),
      child: _DemoStatsView(demoId: demoId, demoName: demoName),
    );
  }
}

class _DemoStatsView extends StatelessWidget {
  final String demoId;
  final String demoName;

  const _DemoStatsView({required this.demoId, required this.demoName});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.backgroundOf(context),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimaryOf(context),
          ),
        ),
        title: Text(
          l10n.demoStats,
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimaryOf(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<DemoReportCubit, DemoReportState>(
        builder: (context, state) {
          if (state is DemoReportInitial || state is DemoReportLoading) {
            return _LoadingState(label: l10n.loading);
          }
          if (state is DemoReportError) {
            return _ErrorState(
              message: state.message,
              onRetry: () =>
                  context.read<DemoReportCubit>().fetchReport(demoId),
            );
          }
          if (state is DemoReportLoaded) {
            return _ReportBody(
              demoId: demoId,
              demoName: demoName,
              report: state.report,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ReportBody extends StatelessWidget {
  final String demoId;
  final String demoName;
  final DemoOwnerReportEntity report;

  const _ReportBody({
    required this.demoId,
    required this.demoName,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return RefreshIndicator(
      color: AppColors.primaryOf(context),
      backgroundColor: AppColors.surfaceOf(context),
      onRefresh: () => context.read<DemoReportCubit>().fetchReport(demoId),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 36),
        children: [
          DemoReportHero(demoName: demoName, overview: report.overview),
          const SizedBox(height: 26),
          DemoReportSectionHeader(
            title: l10n.demoReportOverview,
            icon: Icons.dashboard_customize_rounded,
          ),
          const SizedBox(height: 12),
          DemoReportMetricGrid(overview: report.overview),
          const SizedBox(height: 26),
          DemoReportSectionHeader(
            title: l10n.demoReportPerformance,
            icon: Icons.speed_rounded,
          ),
          const SizedBox(height: 12),
          DemoReportPerformanceCard(overview: report.overview),
          const SizedBox(height: 26),
          DemoReportSectionHeader(
            title: l10n.demoReportCoursePerformance,
            icon: Icons.menu_book_rounded,
            count: report.courses.length,
          ),
          const SizedBox(height: 12),
          if (report.courses.isEmpty)
            DemoReportEmptySection(
              message: l10n.demoReportNoCourses,
              icon: Icons.menu_book_outlined,
            )
          else
            ..._withSpacing(
              report.courses.map(
                (course) => DemoReportCourseCard(course: course),
              ),
            ),
          const SizedBox(height: 26),
          DemoReportSectionHeader(
            title: l10n.demoReportMemberActivity,
            icon: Icons.groups_rounded,
            count: report.members.length,
          ),
          const SizedBox(height: 12),
          if (report.members.isEmpty)
            DemoReportEmptySection(
              message: l10n.demoReportNoMembers,
              icon: Icons.group_off_outlined,
            )
          else
            ..._withSpacing(
              report.members.map(
                (member) => DemoReportMemberCard(member: member),
              ),
            ),
          const SizedBox(height: 26),
          DemoReportSectionHeader(
            title: l10n.demoReportDepartmentBreakdown,
            icon: Icons.account_tree_rounded,
            count: report.departments.length,
          ),
          const SizedBox(height: 12),
          if (report.departments.isEmpty)
            DemoReportEmptySection(
              message: l10n.demoReportNoDepartments,
              icon: Icons.account_tree_outlined,
            )
          else
            ..._withSpacing(
              report.departments.map(
                (department) =>
                    DemoReportDepartmentCard(department: department),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _withSpacing(Iterable<Widget> children) {
    final result = <Widget>[];
    for (final child in children) {
      if (result.isNotEmpty) result.add(const SizedBox(height: 12));
      result.add(child);
    }
    return result;
  }
}

class _LoadingState extends StatelessWidget {
  final String label;

  const _LoadingState({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: AppColors.primaryOf(context)),
          const SizedBox(height: 14),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondaryOf(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.query_stats_rounded,
                color: Theme.of(context).colorScheme.error,
                size: 38,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.demoReportLoadError,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textPrimaryOf(context),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondaryOf(context),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
