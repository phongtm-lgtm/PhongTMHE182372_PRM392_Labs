import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_4_firebasegooglesignin/google_app.dart';

void main() {
  testWidgets('Shows Google sign-in screen while initializing', (
    tester,
  ) async {
    await tester.pumpWidget(const GoogleApp());
    await tester.pump();
    expect(find.textContaining('Google Sign-In'), findsOneWidget);
  });
}
