import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lab8_networking/screens/post_list_screen.dart';
import 'package:lab8_networking/services/api_service.dart';

void main() {
  testWidgets('Shows loading, then posts and detail screen', (tester) async {
    final response = Completer<http.Response>();
    final client = MockClient((_) => response.future);
    addTearDown(client.close);

    await tester.pumpWidget(
      MaterialApp(
        home: PostListScreen(apiService: ApiService(client: client)),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    response.complete(
      http.Response(
        '[{"userId":1,"id":1,"title":"Hello API","body":"Post content"}]',
        200,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Hello API'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);

    await tester.tap(find.text('Hello API'));
    await tester.pumpAndSettle();
    expect(find.text('Bài viết #1'), findsOneWidget);
  });

  testWidgets('Shows error and supports retry', (tester) async {
    var requests = 0;
    final client = MockClient((_) async {
      requests++;
      return requests == 1
          ? http.Response('Server error', 500)
          : http.Response('[]', 200);
    });
    addTearDown(client.close);

    await tester.pumpWidget(
      MaterialApp(
        home: PostListScreen(apiService: ApiService(client: client)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Không thể tải bài viết'), findsOneWidget);

    await tester.tap(find.text('Thử lại'));
    await tester.pumpAndSettle();
    expect(requests, 2);
    expect(find.text('Chưa có bài viết'), findsOneWidget);
  });
}
