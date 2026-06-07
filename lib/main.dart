import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project1/config/theme/app_theme.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:project1/features/auth/presentation/pages/login_screen.dart';
import 'package:project1/features/auth/presentation/pages/signup_screen.dart';
import 'package:project1/features/courses/presentation/pages/course_details_screen.dart';
import 'package:project1/features/home/presentation/pages/Navigations_tabs.dart';
import 'package:project1/features/quizzes/presentation/pages/quiz_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  setupDI();
  runApp(
    BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      title: 'App',
      home: SignupScreen(),
    );
  }
}