import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/demo/domain/entities/demo_report_entity.dart';
import 'package:project1/l10n/app_localizations.dart';

class DemoReportHero extends StatelessWidget {
  final String demoName;
  final DemoReportOverviewEntity overview;

  const DemoReportHero({
    super.key,
    required this.demoName,
    required this.overview,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final generatedAt = overview.generatedAt?.toLocal();
    final generatedLabel = generatedAt == null
        ? null
        : l10n.demoReportGeneratedAt(
            MaterialLocalizations.of(context).formatMediumDate(generatedAt),
            MaterialLocalizations.of(
              context,
            ).formatTimeOfDay(TimeOfDay.fromDateTime(generatedAt)),
          );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradientOf(context),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryOf(context).withValues(alpha: 0.24),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: Colors.white,
                  size: 25,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      demoName,
                      style: AppTextStyles.h3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      l10n.demoReportSubtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.82),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (generatedLabel != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    color: Colors.white.withValues(alpha: 0.86),
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      generatedLabel,
                      style: AppTextStyles.label.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 18),
          Divider(color: Colors.white.withValues(alpha: 0.18), height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _HeroStat(
                  value: _formatNumber(context, overview.totalMembers),
                  label: l10n.demoReportTotalMembers,
                ),
              ),
              _HeroDivider(),
              Expanded(
                child: _HeroStat(
                  value: _formatNumber(context, overview.totalCourses),
                  label: l10n.demoReportTotalCourses,
                ),
              ),
              _HeroDivider(),
              Expanded(
                child: _HeroStat(
                  value: _formatNumber(context, overview.totalDepartments),
                  label: l10n.demoReportDepartments,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DemoReportSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final int? count;

  const DemoReportSectionHeader({
    super.key,
    required this.title,
    required this.icon,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: primary, size: 19),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimaryOf(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (count != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _formatNumber(context, count!),
              style: AppTextStyles.label.copyWith(
                color: primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}

class DemoReportMetricGrid extends StatelessWidget {
  final DemoReportOverviewEntity overview;

  const DemoReportMetricGrid({super.key, required this.overview});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final metrics = [
      _MetricData(
        l10n.demoReportTotalMembers,
        _formatNumber(context, overview.totalMembers),
        Icons.people_alt_rounded,
        AppColors.primaryOf(context),
        l10n.demoReportNewMembers,
        _formatNumber(context, overview.newMembers),
      ),
      _MetricData(
        l10n.demoReportTotalCourses,
        _formatNumber(context, overview.totalCourses),
        Icons.menu_book_rounded,
        const Color(0xFF7C3AED),
        l10n.demoReportPublishedCourses,
        _formatNumber(context, overview.publishedCourses),
      ),
      _MetricData(
        l10n.demoReportDepartments,
        _formatNumber(context, overview.totalDepartments),
        Icons.account_tree_rounded,
        const Color(0xFF0891B2),
        null,
        null,
      ),
      _MetricData(
        l10n.demoReportCertifications,
        _formatNumber(context, overview.totalCertifications),
        Icons.workspace_premium_rounded,
        AppColors.success,
        l10n.demoReportCertificationRate,
        _formatPercent(context, overview.certificationRate),
      ),
      _MetricData(
        l10n.demoReportExamAttempts,
        _formatNumber(context, overview.totalExamAttempts),
        Icons.fact_check_rounded,
        AppColors.warning,
        l10n.demoReportExamPassRate,
        _formatPercent(context, overview.examPassRate),
      ),
      _MetricData(
        l10n.demoReportAverageScore,
        _formatPercent(context, overview.averageExamScore),
        Icons.analytics_rounded,
        const Color(0xFFDB2777),
        null,
        null,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth >= 760 ? 3 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: metrics.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: constraints.maxWidth >= 760 ? 1.65 : 1.12,
          ),
          itemBuilder: (context, index) => _MetricCard(data: metrics[index]),
        );
      },
    );
  }
}

class DemoReportPerformanceCard extends StatelessWidget {
  final DemoReportOverviewEntity overview;

  const DemoReportPerformanceCard({super.key, required this.overview});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final publishingRate = overview.totalCourses == 0
        ? 0.0
        : overview.publishedCourses / overview.totalCourses * 100;

    return _ReportSurface(
      child: Column(
        children: [
          _ProgressMetric(
            label: l10n.demoReportPublishingRate,
            value: publishingRate,
            color: AppColors.primaryOf(context),
          ),
          const SizedBox(height: 18),
          _ProgressMetric(
            label: l10n.demoReportExamPassRate,
            value: overview.examPassRate,
            color: AppColors.success,
          ),
          const SizedBox(height: 18),
          _ProgressMetric(
            label: l10n.demoReportCertificationRate,
            value: overview.certificationRate,
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }
}

class DemoReportCourseCard extends StatelessWidget {
  final DemoReportCourseEntity course;

  const DemoReportCourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statusColor = course.isPublished
        ? AppColors.success
        : AppColors.warning;
    final duration = Duration(seconds: course.totalDuration);
    final durationLabel = duration.inHours > 0
        ? l10n.demoReportHoursMinutes(
            duration.inHours,
            duration.inMinutes.remainder(60),
          )
        : l10n.demoReportMinutes(duration.inMinutes);

    return _ReportSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: AppColors.primaryOf(context).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.school_rounded,
                  color: AppColors.primaryOf(context),
                  size: 20,
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Text(
                  course.courseTitle,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimaryOf(context),
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              _Badge(
                label: course.isPublished
                    ? l10n.demoReportPublished
                    : l10n.demoReportDraft,
                color: statusColor,
                icon: course.isPublished
                    ? Icons.public_rounded
                    : Icons.edit_note_rounded,
              ),
              _Badge(
                label: course.visibility.toUpperCase() == 'PRIVATE'
                    ? l10n.visibilityPrivate
                    : l10n.visibilityPublic,
                color: AppColors.primaryOf(context),
                icon: course.visibility.toUpperCase() == 'PRIVATE'
                    ? Icons.lock_outline_rounded
                    : Icons.visibility_outlined,
              ),
              _Badge(
                label: durationLabel,
                color: AppColors.textSecondaryOf(context),
                icon: Icons.schedule_rounded,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _CompactStat(
                icon: Icons.people_outline_rounded,
                label: l10n.demoReportAssignedMembers,
                value: _formatNumber(context, course.assignedMemberCount),
              ),
              _CompactStat(
                icon: Icons.view_list_rounded,
                label: l10n.demoReportSectionsAndLessons(
                  course.sectionCount,
                  course.lessonCount,
                ),
                value: '',
              ),
              _CompactStat(
                icon: Icons.fact_check_outlined,
                label: l10n.demoReportExamsAndAttempts(
                  course.examCount,
                  course.totalAttempts,
                ),
                value: '',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: AppColors.borderOf(context), height: 1),
          const SizedBox(height: 14),
          _ProgressMetric(
            label: l10n.demoReportAverageScore,
            value: course.averageScore,
            color: AppColors.primaryOf(context),
            compact: true,
          ),
          const SizedBox(height: 12),
          _ProgressMetric(
            label: l10n.demoReportPassRate,
            value: course.passRate,
            color: AppColors.success,
            compact: true,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.workspace_premium_outlined,
                size: 17,
                color: AppColors.warning,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  l10n.demoReportIssuedCertificates,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondaryOf(context),
                  ),
                ),
              ),
              Text(
                _formatNumber(context, course.certificationsIssued),
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimaryOf(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DemoReportMemberCard extends StatelessWidget {
  final DemoReportMemberEntity member;

  const DemoReportMemberCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final joinedAt = member.joinedAt?.toLocal();
    final joinedLabel = joinedAt == null
        ? null
        : l10n.demoReportJoinedDate(
            MaterialLocalizations.of(context).formatMediumDate(joinedAt),
          );

    return _ReportSurface(
      child: Column(
        children: [
          Row(
            children: [
              _MemberAvatar(member: member),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.fullName.isEmpty ? member.email : member.fullName,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.textPrimaryOf(context),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      member.email,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondaryOf(context),
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (joinedLabel != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        joinedLabel,
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.textSecondaryOf(context),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _Badge(
                label: _roleLabel(l10n, member.demoRole),
                color: AppColors.primaryOf(context),
                icon: Icons.verified_user_outlined,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _CompactStat(
                icon: Icons.menu_book_outlined,
                label: l10n.demoReportAssignedCourses,
                value: _formatNumber(context, member.assignedCourses),
              ),
              _CompactStat(
                icon: Icons.fact_check_outlined,
                label: l10n.demoReportExams,
                value: _formatNumber(context, member.examAttempts),
              ),
              _CompactStat(
                icon: Icons.workspace_premium_outlined,
                label: l10n.demoReportCertifications,
                value: _formatNumber(context, member.certificationsEarned),
              ),
              _CompactStat(
                icon: Icons.forum_outlined,
                label: l10n.demoReportEngagement,
                value: _formatNumber(context, member.engagementCount),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _ScoreTile(
                  label: l10n.demoReportAverageScore,
                  value: member.averageScore,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ScoreTile(
                  label: l10n.demoReportHighestScore,
                  value: member.highestScore,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DemoReportDepartmentCard extends StatelessWidget {
  final DemoReportDepartmentEntity department;

  const DemoReportDepartmentCard({super.key, required this.department});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _ReportSurface(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryOf(context).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              Icons.account_tree_rounded,
              color: AppColors.primaryOf(context),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              department.departmentName.isEmpty
                  ? l10n.department
                  : department.departmentName,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimaryOf(context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _CompactStat(
            icon: Icons.people_outline_rounded,
            label: l10n.demoReportMembersCount,
            value: _formatNumber(context, department.memberCount),
          ),
          const SizedBox(width: 7),
          _CompactStat(
            icon: Icons.menu_book_outlined,
            label: l10n.demoReportCoursesCount,
            value: _formatNumber(context, department.courseCount),
          ),
        ],
      ),
    );
  }
}

class DemoReportEmptySection extends StatelessWidget {
  final String message;
  final IconData icon;

  const DemoReportEmptySection({
    super.key,
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return _ReportSurface(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Icon(
              icon,
              size: 34,
              color: AppColors.textSecondaryOf(context).withValues(alpha: 0.5),
            ),
            const SizedBox(height: 9),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondaryOf(context),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportSurface extends StatelessWidget {
  final Widget child;

  const _ReportSurface({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.75),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : AppColors.primaryOf(context).withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _MetricCard extends StatelessWidget {
  final _MetricData data;

  const _MetricCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceOf(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(data.icon, color: data.color, size: 19),
          ),
          const SizedBox(height: 8),
          Text(
            data.value,
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textPrimaryOf(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            data.label,
            style: AppTextStyles.label.copyWith(
              color: AppColors.textSecondaryOf(context),
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (data.detailLabel != null && data.detailValue != null) ...[
            const SizedBox(height: 5),
            Text(
              '${data.detailLabel}: ${data.detailValue}',
              style: AppTextStyles.label.copyWith(
                color: data.color,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class _ProgressMetric extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final bool compact;

  const _ProgressMetric({
    required this.label,
    required this.value,
    required this.color,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final normalized = value.clamp(0, 100).toDouble();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style:
                    (compact ? AppTextStyles.label : AppTextStyles.bodyMedium)
                        .copyWith(
                          color: AppColors.textPrimaryOf(context),
                          fontWeight: FontWeight.w600,
                        ),
              ),
            ),
            Text(
              _formatPercent(context, normalized),
              style: AppTextStyles.label.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            minHeight: compact ? 6 : 8,
            value: normalized / 100,
            color: color,
            backgroundColor: color.withValues(alpha: 0.12),
          ),
        ),
      ],
    );
  }
}

class _MemberAvatar extends StatelessWidget {
  final DemoReportMemberEntity member;

  const _MemberAvatar({required this.member});

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      color: AppColors.primaryOf(context).withValues(alpha: 0.1),
      alignment: Alignment.center,
      child: Text(
        _initials(member.fullName),
        style: AppTextStyles.titleMedium.copyWith(
          color: AppColors.primaryOf(context),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    final imagePath = member.imagePath;

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryOf(context).withValues(alpha: 0.18),
          width: 1.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: imagePath == null
          ? fallback
          : Image.network(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => fallback,
            ),
    );
  }
}

class _ScoreTile extends StatelessWidget {
  final String label;
  final double value;

  const _ScoreTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.primaryOf(context).withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            _formatPercent(context, value),
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.primaryOf(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: AppColors.textSecondaryOf(context),
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _CompactStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _CompactStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.backgroundOf(context),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: AppColors.borderOf(context).withValues(alpha: 0.6),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primaryOf(context)),
          const SizedBox(width: 5),
          if (value.isNotEmpty) ...[
            Text(
              value,
              style: AppTextStyles.label.copyWith(
                color: AppColors.textPrimaryOf(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: AppColors.textSecondaryOf(context),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _Badge({required this.label, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.label.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final String value;
  final String label;

  const _HeroStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.h3.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: AppTextStyles.label.copyWith(
            color: Colors.white.withValues(alpha: 0.75),
            fontSize: 10,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _HeroDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 34,
      color: Colors.white.withValues(alpha: 0.17),
    );
  }
}

class _MetricData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? detailLabel;
  final String? detailValue;

  const _MetricData(
    this.label,
    this.value,
    this.icon,
    this.color,
    this.detailLabel,
    this.detailValue,
  );
}

String _formatNumber(BuildContext context, num value) {
  return NumberFormat.compact(
    locale: Localizations.localeOf(context).toLanguageTag(),
  ).format(value);
}

String _formatPercent(BuildContext context, double value) {
  final formatter = NumberFormat.decimalPattern(
    Localizations.localeOf(context).toLanguageTag(),
  )..maximumFractionDigits = value % 1 == 0 ? 0 : 1;
  return '${formatter.format(value)}%';
}

String _initials(String fullName) {
  final parts = fullName
      .trim()
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts.first.characters.first.toUpperCase();
  return '${parts.first.characters.first}${parts.last.characters.first}'
      .toUpperCase();
}

String _roleLabel(AppLocalizations localizations, String role) {
  return switch (role.trim().toUpperCase()) {
    'OWNER' => localizations.demoReportOwnerRole,
    'MANAGER' || 'ADMIN' => localizations.demoReportManagerRole,
    'MEMBER' || 'USER' => localizations.demoReportMemberRole,
    _ => role,
  };
}
