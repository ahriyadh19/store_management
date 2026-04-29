// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:store_management/localization/locale_controller.dart';
import 'package:store_management/main.dart';
import 'package:store_management/services/auth_repository.dart';

void main() {
  testWidgets('opens drawer on authenticated home screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MyApp(
        authRepository: FakeAuthRepository(seedEmail: 'owner@store.com'),
        localeController: LocaleController(initialLocale: const Locale('en')),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    expect(find.text('Menu'), findsOneWidget);
    expect(find.text('Products'), findsOneWidget);
  });

  testWidgets('shows auth screen by default', (WidgetTester tester) async {
    await tester.pumpWidget(
      MyApp(
        authRepository: FakeAuthRepository(),
        localeController: LocaleController(initialLocale: const Locale('en')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Sign in'), findsWidgets);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('opens forgot password screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MyApp(
        authRepository: FakeAuthRepository(),
        localeController: LocaleController(initialLocale: const Locale('en')),
      ),
    );
    await tester.pumpAndSettle();

    final forgotPasswordButton = find.text('Forgot password?');
    await tester.ensureVisible(forgotPasswordButton);
    await tester.tap(forgotPasswordButton);
    await tester.pumpAndSettle();

    expect(find.text('Forgot password?'), findsOneWidget);
    expect(find.text('Send reset link'), findsOneWidget);
  });

  testWidgets('shows reset completion fields after sending reset link', (WidgetTester tester) async {
    await tester.pumpWidget(
      MyApp(
        authRepository: FakeAuthRepository(),
        localeController: LocaleController(initialLocale: const Locale('en')),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Email'), 'owner@store.com');
    await tester.tap(find.widgetWithText(FilledButton, 'Send reset link'));
    await tester.pumpAndSettle();

    expect(find.text('Update password'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Reset link'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Password'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Confirm password'), findsOneWidget);
  });

  testWidgets('completes password reset flow from pasted link', (WidgetTester tester) async {
    await tester.pumpWidget(
      MyApp(
        authRepository: FakeAuthRepository(),
        localeController: LocaleController(initialLocale: const Locale('en')),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Email'), 'owner@store.com');
    await tester.tap(find.widgetWithText(FilledButton, 'Send reset link'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Reset link'), 'https://example.com/#access_token=token&type=recovery');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'secret12');
    await tester.enterText(find.widgetWithText(TextField, 'Confirm password'), 'secret12');

    final updatePasswordButton = find.widgetWithText(FilledButton, 'Update password');
    await tester.ensureVisible(updatePasswordButton);
    await tester.tap(updatePasswordButton);
    await tester.pumpAndSettle();

    expect(find.text('Welcome to Store Management!'), findsOneWidget);
  });

  testWidgets('shows username field on sign up', (WidgetTester tester) async {
    await tester.pumpWidget(
      MyApp(
        authRepository: FakeAuthRepository(),
        localeController: LocaleController(initialLocale: const Locale('en')),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm password'), findsOneWidget);
  });

  testWidgets('toggles password visibility on sign up', (WidgetTester tester) async {
    await tester.pumpWidget(
      MyApp(
        authRepository: FakeAuthRepository(),
        localeController: LocaleController(initialLocale: const Locale('en')),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.visibility_off_rounded), findsNWidgets(2));

    final passwordField = find.widgetWithText(TextField, 'Password');
    await tester.ensureVisible(passwordField);

    final passwordVisibilityButton = find.descendant(of: passwordField, matching: find.byType(IconButton));

    await tester.ensureVisible(passwordVisibilityButton);
    await tester.tap(passwordVisibilityButton);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.visibility_rounded), findsOneWidget);
  });

  testWidgets('shows error when sign up passwords do not match', (WidgetTester tester) async {
    await tester.pumpWidget(
      MyApp(
        authRepository: FakeAuthRepository(),
        localeController: LocaleController(initialLocale: const Locale('en')),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Store Owner');
    await tester.enterText(find.widgetWithText(TextField, 'Username'), 'store_owner');
    await tester.enterText(find.widgetWithText(TextField, 'Email'), 'owner@store.com');
    await tester.enterText(find.widgetWithText(TextField, 'Password'), 'secret12');
    await tester.enterText(find.widgetWithText(TextField, 'Confirm password'), 'secret13');

    final submitButton = find.widgetWithText(FilledButton, 'Create account');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(find.text('Passwords do not match.'), findsOneWidget);
  });

  testWidgets('renders auth screen in Arabic', (WidgetTester tester) async {
    await tester.pumpWidget(
      MyApp(
        authRepository: FakeAuthRepository(),
        localeController: LocaleController(initialLocale: const Locale('ar')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('تسجيل الدخول'), findsWidgets);
    expect(find.text('البريد الإلكتروني'), findsOneWidget);
    expect(find.text('كلمة المرور'), findsOneWidget);
    expect(Directionality.of(tester.element(find.text('تسجيل الدخول').first)), TextDirection.rtl);
  });
}
