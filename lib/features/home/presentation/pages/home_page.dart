import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/features/demo/domain/entities/demo_entity.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20cubit/demo_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20cubit/demo_state.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:project1/features/demo/domain/use%20case/demos_usecase.dart';
import 'package:project1/features/demo/presentation/widgets/demo_card_widgets/demo_card.dart';
import 'package:project1/features/home/presentation/widgets/main_header.dart';
import '../widgets/section_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) =>
          DemoCubit(getDemosUseCase: GetIt.instance<GetDemosUseCase>())
            ..fetchDemos(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundOf(context),
        body: RefreshIndicator(
          color: AppColors.primaryOf(context),
          backgroundColor: AppColors.surfaceOf(context),
          onRefresh: () async {
            await context.read<DemoCubit>().fetchDemos();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<DemoCubit, DemoState>(
                  builder: (context, state) {
                    int myCount = 0;
                    int enrolledCount = 0;
                    if (state is GetDemosLoaded) {
                      myCount = state.demos
                          .where((demo) => demo.isOwner == true)
                          .length;
                      enrolledCount = state.demos
                          .where((demo) => demo.isOwner == false)
                          .length;
                    }

                    return MainHeader(
                      myDemosCount: myCount,
                      enrolledDemosCount: enrolledCount,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    20,
                    26,
                    20,
                    116,
                  ),
                  child: BlocBuilder<DemoCubit, DemoState>(
                    builder: (context, state) {
                      List<DemoEntity> myDemosList = [];
                      List<DemoEntity> joinedDemosList = [];
                      if (state is GetDemosLoaded) {
                        myDemosList = state.demos
                            .where((demo) => demo.isOwner == true)
                            .toList();
                        joinedDemosList = state.demos
                            .where((demo) => demo.isOwner == false)
                            .toList();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionHeader(
                            title: localizations.myDemos,
                            demoList: myDemosList,
                          ),
                          const SizedBox(height: 14),
                          _buildSubContent(
                            context,
                            state,
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
                          ),
                          const SizedBox(height: 14),
                          _buildSubContent(
                            context,
                            state,
                            isOwnerList: false,
                            emptyMessage: localizations.noDemosAvailable,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubContent(
    BuildContext context,
    DemoState state, {
    required bool isOwnerList,
    required String emptyMessage,
  }) {
    if (state is GetDemosLoading) {
      return const _HomeLoadingCard();
    }
    if (state is GetDemosError) {
      return _HomeStatusCard(
        icon: Icons.error_outline_rounded,
        message: state.message,
        accentColor: AppColors.error,
      );
    }

    if (state is GetDemosLoaded) {
      final filteredList = state.demos
          .where((demo) => demo.isOwner == isOwnerList)
          .toList();
      return _buildDemosList(
        context,
        filteredList,
        emptyMessage,
        emptyIcon: isOwnerList
            ? Icons.dashboard_customize_outlined
            : Icons.school_outlined,
      );
    }

    final localizations = AppLocalizations.of(context)!;
    return _HomeStatusCard(
      icon: Icons.error_outline_rounded,
      message: localizations.somethingWentWrong,
      accentColor: AppColors.error,
    );
  }

  Widget _buildDemosList(
    BuildContext context,
    List<DemoEntity> demosList,
    String emptyMessage, {
    required IconData emptyIcon,
  }) {
    if (demosList.isEmpty) {
      return _HomeStatusCard(
        icon: emptyIcon,
        message: emptyMessage,
        accentColor: AppColors.primaryOf(context),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: demosList.length < 3 ? demosList.length : 3,
      itemBuilder: (context, index) {
        final item = demosList[index];
        return DemoCard(demo: item);
      },
    );
  }
}

class _HomeLoadingCard extends StatelessWidget {
  const _HomeLoadingCard();

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryOf(context);
    final placeholder = AppColors.textSecondaryOf(
      context,
    ).withValues(alpha: 0.10);

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
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(17),
            ),
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                color: primary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FractionallySizedBox(
                  widthFactor: 0.72,
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                    height: 11,
                    decoration: BoxDecoration(
                      color: placeholder,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FractionallySizedBox(
                  widthFactor: 0.94,
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                    height: 9,
                    decoration: BoxDecoration(
                      color: placeholder.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FractionallySizedBox(
                  widthFactor: 0.56,
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                    height: 9,
                    decoration: BoxDecoration(
                      color: placeholder.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
