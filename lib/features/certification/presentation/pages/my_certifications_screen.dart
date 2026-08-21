import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/core/dummy/dummy_entities.dart';
import 'package:project1/core/presentation/widgets/app_skeletonizer.dart';
import 'package:project1/core/presentation/widgets/gradient_page_app_bar.dart';
import 'package:project1/features/certification/presentation/cubit/certification_cubit.dart';
import 'package:project1/features/certification/presentation/cubit/certification_state.dart';
import 'package:project1/features/certification/presentation/pages/certificate_preview_screen.dart';
import 'package:project1/features/certification/presentation/widgets/certificates_header.dart';
import 'package:project1/features/certification/presentation/widgets/certification_tile.dart';
import 'package:project1/l10n/app_localizations.dart';

class MyCertificationsPage extends StatefulWidget {
  const MyCertificationsPage({super.key});

  @override
  State<MyCertificationsPage> createState() => _MyCertificationsPageState();
}

class _MyCertificationsPageState extends State<MyCertificationsPage> {
  late final CertificationCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<CertificationCubit>();
    _cubit.fetchMyCertifications();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  String _formatDate(DateTime date, AppLocalizations localizations) {
    final months = [
      localizations.january,
      localizations.february,
      localizations.march,
      localizations.april,
      localizations.may,
      localizations.june,
      localizations.july,
      localizations.august,
      localizations.september,
      localizations.october,
      localizations.november,
      localizations.december,
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: GradientPageAppBar(title: l.myCertificates),
        body: BlocBuilder<CertificationCubit, CertificationState>(
          builder: (context, state) {
            if (state is CertificationLoading ||
                state is CertificationInitial) {
              return _CertificationsLoadingView(
                dateLabel: _formatDate(dummyCertification.issuedAt, l),
              );
            }

            if (state is CertificationError) {
              return _ErrorView(
                message: state.errors.join('\n'),
                retryLabel: l.retry,
                onRetry: _cubit.fetchMyCertifications,
              );
            }

            if (state is MyCertificationsLoaded) {
              final certifications = state.certifications;

              if (certifications.isEmpty) {
                return _EmptyCertificationsView(
                  message: l.noCertificatesYet,
                  onRefresh: _cubit.fetchMyCertifications,
                );
              }

              return RefreshIndicator(
                onRefresh: () => _cubit.fetchMyCertifications(),
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
                        child: CertificatesHeader(count: certifications.length),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                      sliver: SliverList.separated(
                        itemCount: certifications.length,
                        itemBuilder: (context, index) {
                          final certification = certifications[index];

                          return CertificationTile(
                            certification: certification,
                            dateLabel: _formatDate(certification.issuedAt, l),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CertificatePreviewPage(
                                    certification: certification,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _CertificationsLoadingView extends StatelessWidget {
  final String dateLabel;

  const _CertificationsLoadingView({required this.dateLabel});

  @override
  Widget build(BuildContext context) {
    return AppSkeletonizer(
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 22, 20, 18),
              child: CertificatesHeader(count: 3),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            sliver: SliverList.separated(
              itemCount: 3,
              itemBuilder: (context, index) => CertificationTile(
                certification: dummyCertification,
                dateLabel: dateLabel,
                onTap: () {},
              ),
              separatorBuilder: (_, __) => const SizedBox(height: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryOf(context);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 420),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.45),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.error.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  color: Theme.of(context).colorScheme.error,
                  size: 34,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                message,
                textAlign: TextAlign.center,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: Text(
                    retryLabel,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCertificationsView extends StatelessWidget {
  final String message;
  final Future<void> Function() onRefresh;

  const _EmptyCertificationsView({
    required this.message,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryOf(context);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 420),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 34,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.10),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 82,
                          height: 82,
                          decoration: BoxDecoration(
                            color: primaryColor.withValues(alpha: 0.09),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.workspace_premium_outlined,
                            size: 42,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
