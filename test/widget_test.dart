// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:store_management/main.dart';
import 'package:store_management/services/auth_repository.dart';

void main() {
  testWidgets('shows auth screen by default', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(authRepository: FakeAuthRepository()));

    expect(find.text('Sign in'), findsWidgets);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('opens forgot password screen', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(authRepository: FakeAuthRepository()));

    await tester.tap(find.text('Forgot password?'));
    await tester.pumpAndSettle();

    expect(find.text('Forgot password?'), findsOneWidget);
    expect(find.text('Send reset link'), findsOneWidget);
  });
}
