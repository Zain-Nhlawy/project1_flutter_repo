import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project1/features/auth/presentation/widgets/password_requirements_hint.dart';
import 'package:project1/l10n/app_localizations.dart';

void main() {
  testWidgets('shows only the missing requirements while typing', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: PasswordRequirementsHint(controller: controller)),
      ),
    );

    expect(find.textContaining('Missing'), findsNothing);

    controller.text = 'password';
    await tester.pump();

    expect(find.textContaining('an uppercase letter'), findsOneWidget);
    expect(find.textContaining('a number'), findsOneWidget);
    expect(find.textContaining('a special character'), findsOneWidget);
    expect(find.textContaining('a lowercase letter'), findsNothing);
    expect(find.textContaining('at least 8 characters'), findsNothing);

    controller.text = 'Password1!';
    await tester.pump();

    expect(find.textContaining('Missing'), findsNothing);
  });
}
