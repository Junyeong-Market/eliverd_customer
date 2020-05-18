import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:Eliverd/main.dart';

import 'package:Eliverd/common/string.dart';

void main() {
  testWidgets('Main Test', (WidgetTester tester) async {
    final splashScreenPageKey = Key('SplashScreenPage');
    final loginPageKey = Key('LoginPage');

    final idFieldKey = Key('IdField');
    final passwordFieldKey = Key('PasswordField');
    final signInButtonKey = Key('SignInButton');
    final signUpButtonKey = Key('SignUpButton');

    await tester.pumpWidget(EliverdCustomer());

    expect(find.byKey(splashScreenPageKey), findsOneWidget);

    expect(find.text(title), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.byKey(loginPageKey), findsOneWidget);

    expect(find.byKey(idFieldKey), findsOneWidget);
    expect(find.byKey(passwordFieldKey), findsOneWidget);
    expect(find.byKey(signInButtonKey), findsOneWidget);
    expect(find.byKey(signUpButtonKey), findsOneWidget);
  });
}
