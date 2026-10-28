import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab7_forms_validation/main.dart';

void main() {
  testWidgets('Empty fields block submission', (tester) async {
    await tester.pumpWidget(const SignupApp());
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();
    expect(find.text('Full name is required'), findsOneWidget);
    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
    expect(find.text('Confirm password is required'), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('Valid input shows success', (tester) async {
    await tester.pumpWidget(const SignupApp());
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Nguyen An');
    await tester.enterText(fields.at(1), 'an@example.com');
    await tester.enterText(fields.at(2), 'password1');
    await tester.enterText(fields.at(3), 'password1');
    await tester.ensureVisible(find.text('Submit'));
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();
    expect(
      find.text('Signup successful: Nguyen An (an@example.com)'),
      findsOneWidget,
    );
  });

  testWidgets('Invalid email and password are rejected', (tester) async {
    await tester.pumpWidget(const SignupApp());
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Nguyen An');
    await tester.enterText(fields.at(1), 'invalid');
    await tester.enterText(fields.at(2), 'short');
    await tester.enterText(fields.at(3), 'different');
    await tester.pumpAndSettle();
    expect(find.text('Enter a valid email'), findsOneWidget);
    expect(find.text('Use at least 8 characters'), findsOneWidget);
    expect(find.text('Passwords do not match'), findsOneWidget);
    await tester.enterText(fields.at(2), 'password');
    await tester.pumpAndSettle();
    expect(find.text('Include at least 1 digit'), findsOneWidget);
  });
}
