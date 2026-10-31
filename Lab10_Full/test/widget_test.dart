import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lab10_full/lab_app.dart';
import 'package:lab10_full/services/auth_service.dart';
import 'package:lab10_full/services/session_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Mock accepts demo credentials and rejects invalid ones', () async {
    final mock = MockAuthService();
    expect((await mock.login('student@example.com', 'password123')).token, 'mock-demo-token');
    expect(mock.login('wrong@example.com', 'bad'), throwsA(isA<AuthException>()));
  });

  test('API parses accessToken and handles errors', () async {
    final api = ApiAuthService(client: MockClient((request) async {
      expect(request.method, 'POST');
      expect(jsonDecode(request.body)['username'], 'emilys');
      return http.Response('{"accessToken":"token","username":"emilys"}', 200);
    }));
    expect((await api.login('emilys', 'emilyspass')).token, 'token');
    final rejected = ApiAuthService(client: MockClient((_) async => http.Response('{}', 401)));
    expect(rejected.login('bad', 'bad'), throwsA(isA<AuthException>()));
  });

  test('Session saves, restores, and clears token', () async {
    SharedPreferences.setMockInitialValues({});
    final store = SessionStore();
    expect(await store.load(), null);
    await store.save('emilys', 'token');
    expect(await store.load(), ('emilys', 'token'));
    await store.clear();
    expect(await store.load(), null);
  });

  testWidgets('Mock form validates and navigates to Home', (tester) async {
    await tester.pumpWidget(const LabApp(mode: LabMode.mock));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Login'));
    await tester.pump();
    expect(find.text('Enter your username/email'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).first, 'student@example.com');
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
