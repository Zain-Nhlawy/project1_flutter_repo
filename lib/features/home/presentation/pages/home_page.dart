import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:project1/features/demo/domain/use%20case/get_demos_usecase.dart';
import 'package:project1/features/demo/presentation/cubit/demo_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/demo_state.dart';
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DashboardHeader(),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.06,
                  vertical: size.height * 0.02,
                ),
                child: BlocBuilder<DemoCubit, DemoState>(
                  builder: (context, state) {
                    if (state is GetDemosLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state is GetDemosError) {
                      return Center(
                        child: Text(localizations.somethingWentWrong),
                      );
                    }

                    if (state is GetDemosLoaded) {
                      final myDemos = state.demos.where((demo) => demo.isOwner == true).toList();
                      final joinedDemos = state.demos.where((demo) => demo.isOwner == false).toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionHeader(title: localizations.myDemos),
                          SizedBox(height: size.height * 0.015),
                          _buildDemosList(myDemos, localizations.noDemosAvailable),

                          SizedBox(height: size.height * 0.03),


                          SectionHeader(title: localizations.demosImIn),
                          SizedBox(height: size.height * 0.015),
                          _buildDemosList(joinedDemos, localizations.noDemosAvailable),

                          SizedBox(height: size.height * 0.12),
                        ],
                      );
                    }

                    return Center(
                      child: Text(localizations.somethingWentWrong),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
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
      physics: const NeverScrollableScrollPhysics(),
      itemCount: demosList.length < 2 ? demosList.length : 2,
      itemBuilder: (context, index) {
        final item = demosList[index];
        return DemoCard(demo: item);
      },
    );
  }
}