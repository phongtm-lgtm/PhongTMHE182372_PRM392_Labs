import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather.dart';

class WeatherException implements Exception {
  const WeatherException(this.message);
  final String message;
  @override
  String toString() => message;
}

class WeatherService {
  WeatherService({http.Client? client})
    : _client = client ?? http.Client(),
      _ownsClient = client == null;
  final http.Client _client;
  final bool _ownsClient;

  Future<Weather> fetchWeather(City city) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '${city.latitude}',
      'longitude': '${city.longitude}',
      'current': 'temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m',
      'daily':
          'temperature_2m_max,temperature_2m_min,precipitation_probability_max',
      'timezone': 'auto',
      'forecast_days': '1',
    });
    try {
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        throw WeatherException(
          'Máy chủ trả về lỗi ${response.statusCode}. Vui lòng thử lại.',
        );
      }
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data is! Map<String, dynamic>) throw const FormatException();
      return Weather.fromJson(data);
    } on TimeoutException {
      throw const WeatherException('Kết nối quá lâu. Hãy thử lại.');
    } on http.ClientException {
      throw const WeatherException(
        'Không thể kết nối. Kiểm tra mạng rồi thử lại.',
      );
    } on FormatException {
      throw const WeatherException(
        'Không có dữ liệu thời tiết hợp lệ cho địa điểm này.',
      );
    }
  }

  void close() {
    if (_ownsClient) _client.close();
  }
}
