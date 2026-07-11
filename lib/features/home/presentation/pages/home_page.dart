import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
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
    final size = MediaQuery.sizeOf(context);
    final localizations = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) =>
          DemoCubit(getDemosUseCase: GetIt.instance<GetDemosUseCase>())
            ..fetchDemos(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: RefreshIndicator(
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
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.06,
                    vertical: size.height * 0.02,
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
                          SizedBox(height: size.height * 0.015),
                          _buildSubContent(
                            context,
                            state,
                            isOwnerList: true,
                            emptyMessage: localizations.noDemosAvailable,
                          ),

                          SizedBox(height: size.height * 0.03),

                          SectionHeader(
                            title: localizations.demosImIn,
                            demoList: joinedDemosList,
                          ),
                          SizedBox(height: size.height * 0.015),
                          _buildSubContent(
                            context,
                            state,
                            isOwnerList: false,
                            emptyMessage: localizations.noDemosAvailable,
                          ),

                          SizedBox(height: size.height * 0.12),
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
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (state is GetDemosError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            state.message,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (state is GetDemosLoaded) {
      final filteredList = state.demos
          .where((demo) => demo.isOwner == isOwnerList)
          .toList();
      return _buildDemosList(filteredList, emptyMessage);
    }

    final localizations = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Text(localizations.somethingWentWrong),
      ),
    );
  }

  Widget _buildDemosList(List demosList, String emptyMessage) {
    if (demosList.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(emptyMessage),
        ),
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
