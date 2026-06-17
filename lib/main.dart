import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project1/config/theme/app_theme.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:project1/features/auth/presentation/pages/login_screen.dart';
import 'package:project1/features/auth/presentation/pages/reset_password_screen.dart';
import 'package:project1/features/home/presentation/pages/Navigations_tabs.dart' show NavigationsTabs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  setupDI();

  String? initialToken;

  try {
    final appLinks = AppLinks();
    final Uri? uri = await appLinks.getInitialLink();

    if (uri != null && uri.path.contains('reset-password')) {
      initialToken = uri.queryParameters['token'];
    }
  } catch (_) {}

  runApp(
    BlocProvider<AuthCubit>(
      create: (_) => getIt<AuthCubit>(),
      child: MyApp(initialToken: initialToken),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? initialToken;

  const MyApp({
    super.key,
    this.initialToken,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      title: 'App',
      home: initialToken != null && initialToken!.isNotEmpty
          ? ResetPasswordScreen(token: initialToken!)
          : const NavigationsTabs(
            ),
    );
  }
}