import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_5_notification/notification_app.dart';

void main() {
  testWidgets('Provides a manual notification action', (tester) async {
    await tester.pumpWidget(const NotificationApp());
    await tester.pumpAndSettle();
    expect(find.text('Show notification'), findsOneWidget);
  });
}
