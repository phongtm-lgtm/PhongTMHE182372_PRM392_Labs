import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_3_autologin_logout/services/auth_service.dart';
import 'package:lab10_3_autologin_logout/services/prefs_session.dart';
import 'package:lab10_3_autologin_logout/simple_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Saved token routes to Home and logout returns to Login', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final store = PrefsSession();
    await store.save(const AuthSession('emilys', 'token'));
    await tester.pumpWidget(SimpleApp(auth: MockAuthService(), session: store));
    await tester.pumpAndSettle();
    expect(find.text('Welcome, emilys'), findsOneWidget);
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    expect(find.text('Login'), findsOneWidget);
    expect(await store.load(), null);
  });
}
