import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab6/main.dart';

void main() {
  Future<void> openApp(WidgetTester tester, Size size) async {
    // Mock ảnh trong test; không gọi mạng thật hoặc thay đổi code ứng dụng.
    HttpOverrides.global = _ImageHttpOverrides();
    addTearDown(() => HttpOverrides.global = null);
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const ResponsiveMovieApp());
  }

  List<String> titles(WidgetTester tester) => tester
      .widgetList<MovieCard>(find.byType(MovieCard))
      .map((card) => card.movie.title)
      .toList();

  testWidgets(
    'Search is case-insensitive; genres use OR and combine with search',
    (tester) async {
      await openApp(tester, const Size(390, 844));
      expect(find.text('Find a Movie'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'mAI');
      await tester.pump();
      expect(titles(tester), ['Mai']);
      await tester.tap(find.widgetWithText(FilterChip, 'Action'));
      await tester.pump();
      expect(find.text('Không tìm thấy phim phù hợp.'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilterChip, 'Romance'));
      await tester.pump();
      expect(titles(tester), ['Mai']);
      await tester.tap(find.text('Clear filters'));
      await tester.pump();
      expect(titles(tester), hasLength(6));
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        '',
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('All sort options order the movie cards', (tester) async {
    await openApp(tester, const Size(1000, 900));
    expect(titles(tester).first, 'Bố Già');
    for (final entry in {
      'Z–A': 'Tiệc Trăng Máu',
      'Year': 'Mai',
      'Rating': 'Mai',
    }.entries) {
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text(entry.key).last);
      await tester.pumpAndSettle();
      expect(titles(tester).first, entry.value);
    }
    expect(tester.takeException(), isNull);
  });

  for (final size in [
    const Size(320, 568),
    const Size(799, 600),
    const Size(800, 600),
    const Size(1200, 800),
    const Size(844, 390),
  ]) {
    testWidgets('Responsive layout at ${size.width} x ${size.height}', (
      tester,
    ) async {
      await openApp(tester, size);
      if (size.width < 800) {
        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(GridView), findsNothing);
      } else {
        final grid = tester.widget<GridView>(find.byType(GridView));
        final delegate =
            grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
        expect(delegate.crossAxisCount, 2);
      }
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -800),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  }
}

class _ImageHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _ImageClient();
}

class _ImageClient implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _ImageRequest();
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _ImageRequest implements HttpClientRequest {
  @override
  final HttpHeaders headers = _ImageHeaders();
  @override
  Future<HttpClientResponse> close() async => _ImageResponse();
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _ImageHeaders implements HttpHeaders {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _ImageResponse extends Stream<List<int>> implements HttpClientResponse {
  final bytes = base64Decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aD1sAAAAASUVORK5CYII=',
  );
  @override
  int get statusCode => 200;
  @override
  int get contentLength => bytes.length;
  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;
  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int>)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) => Stream<List<int>>.value(bytes).listen(
    onData,
    onError: onError,
    onDone: onDone,
    cancelOnError: cancelOnError,
  );
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}
