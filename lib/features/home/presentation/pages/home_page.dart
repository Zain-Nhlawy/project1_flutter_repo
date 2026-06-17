import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/features/demo/presentation/cubit/demo_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/demo_state.dart';
import 'package:project1/features/demo/presentation/widgets/demo_card_widgets/demo_card.dart';
import 'package:project1/features/home/presentation/widgets/main_header.dart';
import 'package:project1/features/home/presentation/widgets/section_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
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
                    return const Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (state is GetDemosError) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Center(child: Text(state.message)),
                    );
                  }

                  if (state is GetDemosLoaded) {
                    final demosList = state.demos.map((demo) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: size.height * 0.015),
                        child: DemoCard(
                          title: demo.name,
                          description: demo.id,
                          author: "Alex Johnson",
                          buttonText: "Manage",
                          usersCount: 0,
                        ),
                      );
                    }).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(title: "My Demos"),
                        SizedBox(height: size.height * 0.015),
                        ...demosList,

                        SizedBox(height: size.height * 0.02),

                        const SectionHeader(title: "Demos I'm In"),
                        SizedBox(height: size.height * 0.015),
                        ...demosList,

                        SizedBox(height: size.height * 0.12),
                      ],
                    );
                  }
                  return const Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
