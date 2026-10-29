import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lab8b/models/weather.dart';
import 'package:lab8b/screens/weather_screen.dart';
import 'package:lab8b/services/weather_service.dart';

Map<String, dynamic> sample() => {
  'current': {
    'temperature_2m': 28,
    'apparent_temperature': 30,
    'relative_humidity_2m': 80,
    'wind_speed_10m': 12,
    'weather_code': 61,
    'time': '2026-11-02T12:00',
  },
  'daily': {
    'temperature_2m_min': [24],
    'temperature_2m_max': [32],
    'precipitation_probability_max': [80],
  },
};

void main() {
  test('Model parses values and provides practical advice', () {
    final weather = Weather.fromJson(sample());
    expect(weather.temperature, 28);
    expect(weather.umbrellaAdvice, contains('Nên mang ô'));
    expect(weather.outdoorAdvice, contains('trong nhà'));
    expect(() => Weather.fromJson({}), throwsFormatException);
  });

  test('Service sends coordinates and decodes the response', () async {
    final service = WeatherService(
      client: MockClient((request) async {
        expect(request.url.host, 'api.open-meteo.com');
        expect(request.url.queryParameters['latitude'], '21.0285');
        return http.Response(jsonEncode(sample()), 200);
      }),
    );
    expect((await service.fetchWeather(City.choices.first)).humidity, 80);
  });

  test('Service handles HTTP errors and empty data', () async {
    for (final response in [
      http.Response('{}', 500),
      http.Response('{}', 200),
      http.Response('', 200),
    ]) {
      final service = WeatherService(client: MockClient((_) async => response));
      await expectLater(
        service.fetchWeather(City.choices.first),
        throwsA(isA<WeatherException>()),
      );
    }
  });

  testWidgets('Loading, failure, retry, success and advice are visible', (
    tester,
  ) async {
    final pending = Completer<http.Response>();
    var calls = 0;
    final service = WeatherService(
      client: MockClient((_) {
        calls++;
        if (calls == 1) return pending.future;
        return Future.value(http.Response(jsonEncode(sample()), 200));
      }),
    );
    await tester.pumpWidget(MaterialApp(home: WeatherScreen(service: service)));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    pending.complete(http.Response('{}', 503));
    await tester.pumpAndSettle();
    expect(find.text('Không thể tải thời tiết'), findsOneWidget);
    await tester.tap(find.text('Thử lại'));
    await tester.pumpAndSettle();
    expect(find.text('28.0 °C'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Có cần mang ô?'),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.textContaining('Nên mang ô'), findsOneWidget);
  });
}
