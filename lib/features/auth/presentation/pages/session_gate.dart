import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project1/config/theme/app_colors.dart';
import 'package:project1/features/auth/presentation/cubit/session_cubit.dart';
import 'package:project1/features/auth/presentation/cubit/session_state.dart';
import 'package:project1/features/auth/presentation/pages/login_screen.dart';
import 'package:project1/features/auth/presentation/pages/unauthenticated_gate.dart';
import 'package:project1/features/home/presentation/pages/navigations_tabs.dart';
import 'package:project1/l10n/app_localizations.dart';

class SessionGate extends StatelessWidget {
  final WidgetBuilder? authenticatedBuilder;
  final WidgetBuilder? unauthenticatedBuilder;

  const SessionGate({
    super.key,
    this.authenticatedBuilder,
    this.unauthenticatedBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SessionCubit, SessionState>(
      listener: (context, state) {
        if (state is SessionAuthenticated || state is SessionUnauthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            Navigator.of(context).popUntil((route) => route.isFirst);
          });
        }
      },
      builder: (context, state) {
        if (state is SessionAuthenticated) {
          return authenticatedBuilder?.call(context) ?? const NavigationsTabs();
        }

        if (state is SessionUnauthenticated) {
          return unauthenticatedBuilder?.call(context) ??
              const UnauthenticatedGate();
        }

        if (state is SessionFailure) {
          return _SessionFailureView(errors: state.errors);
        }

        return const _SessionLoadingView();
      },
    );
  }
}

class _SessionLoadingView extends StatelessWidget {
  const _SessionLoadingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      body: const SafeArea(
        child: Center(
          child: CircularProgressIndicator(key: Key('session-loading')),
        ),
      ),
    );
  }
}

class _SessionFailureView extends StatelessWidget {
  final List<String> errors;

  const _SessionFailureView({required this.errors});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundOf(context),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.cloud_off_outlined,
                    size: 72,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    errors.isEmpty ? localizations.tryAgain : errors.first,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<SessionCubit>().restoreSession();
                      },
                      child: Text(localizations.retry),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<SessionCubit>().clearSession();
                    },
                    child: Text(localizations.logInBtn),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
