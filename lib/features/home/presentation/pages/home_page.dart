import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/dummy/dummy_entities.dart';
import 'package:project1/core/presentation/widgets/app_skeletonizer.dart';
import 'package:project1/features/auth/presentation/cubit/user_cubit.dart';
import 'package:project1/features/demo/domain/entities/demo_entity.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20cubit/demo_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20cubit/demo_state.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:project1/features/demo/presentation/widgets/demo_card_widgets/demo_card.dart';
import 'package:project1/features/home/presentation/widgets/main_header.dart';
import '../widgets/section_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<DemoCubit>().fetchDemos();
  }

  Future<void> _handleRefresh() async {
    final errors = await Future.wait<String?>([
      context.read<DemoCubit>().refreshDemos(),
      context.read<UserCubit>().refreshUser(),
    ]);

    if (!mounted) return;

    final messages = errors.whereType<String>().toSet().toList();
    if (messages.isEmpty) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(messages.join('\n'))));
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final topPadding = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      body: RefreshIndicator(
        color: AppColors.primaryOf(context),
        backgroundColor: AppColors.surfaceOf(context),
        edgeOffset: topPadding,
        displacement: 40,
        onRefresh: _handleRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: ClampingScrollPhysics(),
          ),
          child: BlocBuilder<DemoCubit, DemoState>(
            builder: (context, state) {
              final isInitialLoading =
                  state is GetDemosLoading && !state.isRefresh;
              final initialErrorMessage =
                  state is GetDemosError && !state.isRefresh
                  ? state.message
                  : null;
              final visibleDemos = switch (state) {
                GetDemosLoaded(:final demos) => demos,
                GetDemosLoading(:final previousDemos) => previousDemos,
                GetDemosError(:final previousDemos) => previousDemos,
                _ => const <DemoEntity>[],
              };
              final myDemosList = visibleDemos
                  .where((demo) => demo.isOwner == true)
                  .toList();
              final joinedDemosList = visibleDemos
                  .where((demo) => demo.isOwner == false)
                  .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSkeletonizer(
                    enabled: isInitialLoading,
                    child: MainHeader(
                      myDemosCount: myDemosList.length,
                      enrolledDemosCount: joinedDemosList.length,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      20,
                      26,
                      20,
                      32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: initialErrorMessage != null
                          ? [
                              _HomeStatusCard(
                                icon: Icons.error_outline_rounded,
                                message: initialErrorMessage,
                                accentColor: AppColors.error,
                              ),
                            ]
                          : [
                              SectionHeader(
                                title: localizations.myDemos,
                                demoList: myDemosList,
                                isOwner: true,
                              ),
                              const SizedBox(height: 14),
                              _buildDemosSection(
                                context,
                                demos: myDemosList,
                                isLoading: isInitialLoading,
                                isOwnerList: true,
                                emptyMessage: localizations.noDemosAvailable,
                              ),
                              const SizedBox(height: 14),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: AppColors.borderOf(
                                  context,
                                ).withValues(alpha: 0.72),
                              ),
                              const SizedBox(height: 28),
                              SectionHeader(
                                title: localizations.demosImIn,
                                demoList: joinedDemosList,
                                isOwner: false,
                              ),
                              const SizedBox(height: 14),
                              _buildDemosSection(
                                context,
                                demos: joinedDemosList,
                                isLoading: isInitialLoading,
                                isOwnerList: false,
                                emptyMessage: localizations.noDemosAvailable,
                              ),
                            ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDemosSection(
    BuildContext context, {
    required List<DemoEntity> demos,
    required bool isLoading,
    required bool isOwnerList,
    required String emptyMessage,
  }) {
    if (isLoading) {
      return Column(
        children: const [
          _HomeLoadingCard(),
          SizedBox(height: 12),
          _HomeLoadingCard(),
        ],
      );
    }

    if (demos.isEmpty) {
      return _HomeStatusCard(
        icon: isOwnerList
            ? Icons.dashboard_customize_outlined
            : Icons.school_outlined,
        message: emptyMessage,
        accentColor: AppColors.primaryOf(context),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: demos.length < 3 ? demos.length : 3,
      itemBuilder: (context, index) {
        final item = demos[index];
        return DemoCard(demo: item);
      },
    );
  }
}

class _HomeLoadingCard extends StatelessWidget {
  const _HomeLoadingCard();

  @override
  Widget build(BuildContext context) {
    return AppSkeletonizer(child: DemoCard(demo: dummyDemo));
  }
}

class _HomeStatusCard extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color accentColor;

  const _HomeStatusCard({
    required this.icon,
    required this.message,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 112),
      padding: const EdgeInsets.all(18),
      decoration: _contentCardDecoration(context),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.09),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(icon, color: accentColor, size: 25),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondaryOf(context),
                fontWeight: FontWeight.w600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _contentCardDecoration(BuildContext context) {
  return BoxDecoration(
    color: AppColors.surfaceOf(context),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: AppColors.borderOf(context).withValues(alpha: 0.72),
    ),
    boxShadow: [
      BoxShadow(
        color: AppColors.textSecondaryOf(context).withValues(alpha: 0.08),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ],
  );
}
