import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:project1/config/theme/app_theme.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:project1/features/auth/presentation/pages/login_screen.dart';
import 'package:project1/features/auth/presentation/pages/reset_password_screen.dart';
import 'package:media_kit/media_kit.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  await dotenv.load();
  setupDI();

  String? initialToken;

  try {
    final appLinks = AppLinks();
    final uri = await appLinks.getInitialLink();

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

class MyApp extends StatefulWidget {
  final String? initialToken;

  const MyApp({
    super.key,
    this.initialToken,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _sub;

  @override
  void initState() {
    super.initState();

    _appLinks = AppLinks();

    _sub = _appLinks.uriLinkStream.listen((uri) {
      if (uri.path.contains('reset-password')) {
        final token = uri.queryParameters['token'];

        if (token != null && token.isNotEmpty) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (_) => ResetPasswordScreen(token: token),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      title: 'App',
      home: widget.initialToken != null &&
              widget.initialToken!.isNotEmpty
          ? ResetPasswordScreen(token: widget.initialToken!)
          : const LoginScreen(),
    );
  }
}