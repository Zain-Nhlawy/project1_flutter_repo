import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:project1/config/theme/app_theme.dart';
import 'package:project1/config/theme/app_text_styles.dart';
import 'package:project1/core/di/service_locator.dart';
import 'package:project1/core/services/app_language_service.dart';
import 'package:project1/features/auth/domain/use_case/verify_email_usecase.dart';
import 'package:project1/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:project1/features/auth/presentation/cubit/session_cubit.dart';
import 'package:project1/features/auth/presentation/cubit/user_cubit.dart';
import 'package:project1/features/demo/presentation/cubit/demo%20cubit/demo_cubit.dart';
import 'package:project1/features/auth/presentation/pages/reset_password_screen.dart';
import 'package:project1/features/auth/presentation/pages/session_gate.dart';
import 'package:project1/core/storage/secure_storage.dart';
import 'package:project1/features/profile/presentation/cubit/notification_cubit.dart';
import 'package:project1/features/profile/presentation/cubit/locale_cubit.dart';
import 'package:project1/features/profile/presentation/cubit/theme_cubit.dart';
import 'package:project1/l10n/app_localizations.dart';
import 'package:project1/l10n/l10n.dart';
import 'package:project1/features/auth/presentation/cubit/user_state.dart';
import 'package:project1/features/notifications/data/data_sources/notification_storage_service.dart';
import 'package:project1/features/notifications/presentation/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project1/core/storage/storage_keys.dart';
import 'package:project1/firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await dotenv.load();
  setupDI();
  print("DI DONE");

  final languageService = getIt<AppLanguageService>();
  await languageService.initialize();

  await getIt<NotificationService>().initialize();

  final storage = getIt<AppSecureStorage>();

  String? savedTheme;
  try {
    savedTheme = await storage.read(StorageKeys.theme);
  } catch (_) {}

  final initialTheme = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;

  String? initialResetToken;

  try {
    final appLinks = AppLinks();
    final uri = await appLinks.getInitialLink();

    if (uri != null) {
      if (uri.path.contains('reset-password')) {
        initialResetToken = uri.queryParameters['token'];
      } else if (uri.path.contains('verify-email')) {
        final token = uri.queryParameters['token'];

        if (token != null && token.isNotEmpty) {
          await getIt<VerifyEmailUseCase>()(token);
        }
      }
    }
  } catch (_) {}

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(create: (_) => getIt<UserCubit>()),
        BlocProvider<SessionCubit>(
          create: (_) => getIt<SessionCubit>()..restoreSession(),
        ),
        BlocProvider<DemoCubit>(create: (_) => getIt<DemoCubit>()),
        BlocProvider<AuthCubit>(
          create: (_) {
            return getIt<AuthCubit>();
          },
        ),

        BlocProvider<LocaleCubit>(
          create: (_) => LocaleCubit(languageService: languageService),
        ),
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(
            storage: storage,
            initialTheme: initialTheme,
          ),
        ),
        BlocProvider<NotificationCubit>(
          create: (_) =>
              NotificationCubit(storage: storage)
                ..loadPreference(),
        ),
      ],
      child: MyApp(initialResetToken: initialResetToken),
    ),
  );
}

class MyApp extends StatefulWidget {
  final String? initialResetToken;

  const MyApp({super.key, this.initialResetToken});

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

    _sub = _appLinks.uriLinkStream.listen((uri) async {
      if (uri.path.contains('reset-password')) {
        final token = uri.queryParameters['token'];

        if (token != null && token.isNotEmpty) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (_) => ResetPasswordScreen(token: token),
            ),
          );
        }
      } else if (uri.path.contains('verify-email')) {
        final token = uri.queryParameters['token'];

        if (token != null && token.isNotEmpty) {
          try {
            await getIt<VerifyEmailUseCase>()(token);
          } catch (_) {}

          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const SessionGate()),
            (route) => false,
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
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        final fontFamily = locale.languageCode == 'ar'
            ? AppTextStyles.arabicFontFamily
            : AppTextStyles.fontFamily;
        return BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MultiBlocListener(
              listeners: [
                BlocListener<UserCubit, UserState>(
                  listener: (context, state) {
                    if (state is UserLoaded) {
                      getIt<NotificationStorageService>().setCurrentUserId(state.user.id);
                      getIt<NotificationService>().registerToken();
                    } else if (state is UserInitial) {
                      getIt<NotificationStorageService>().clearCurrentUser();
                    }
                  },
                ),
              ],
              child: MaterialApp(
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme(fontFamily),
                darkTheme: AppTheme.darkTheme(fontFamily),
                themeMode: themeMode,
                title: 'App',
                supportedLocales: L10n.all,
                locale: locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                home:
                    widget.initialResetToken != null &&
                        widget.initialResetToken!.isNotEmpty
                    ? ResetPasswordScreen(token: widget.initialResetToken!)
                    : const SessionGate(),
              ),
            );
          },
        );
      },
    );
  }
}
