import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_1_mocklogin/simple_app.dart';
import 'package:lab10_1_mocklogin/services/auth_service.dart';

void main() {
  testWidgets('Mock login validates, rejects and accepts credentials', (
    tester,
  ) async {
    await tester.pumpWidget(const SimpleApp(auth: MockAuthService()));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Login'));
    await tester.pump();
    expect(find.text('Enter your username/email'), findsOneWidget);
    await tester.enterText(
      find.byType(TextFormField).first,
      'student@example.com',
    );
    await tester.enterText(find.byType(TextFormField).last, 'password123');
    await tester.tap(find.text('Login'));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.text('Welcome, Student'), findsOneWidget);
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    expect(find.text('Login'), findsOneWidget);
  });
}
