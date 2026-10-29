class City {
  const City(this.name, this.latitude, this.longitude);
  final String name;
  final double latitude;
  final double longitude;

  static const choices = [
    City('Hà Nội', 21.0285, 105.8542),
    City('TP. Hồ Chí Minh', 10.8231, 106.6297),
    City('Đà Nẵng', 16.0544, 108.2022),
    City('Đà Lạt', 11.9404, 108.4583),
    City('Huế', 16.4637, 107.5909),
  ];
}

class Weather {
  const Weather({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.wind,
    required this.code,
    required this.rainChance,
    required this.minimum,
    required this.maximum,
    required this.time,
  });

  final double temperature, feelsLike, wind, minimum, maximum;
  final int humidity, code, rainChance;
  final String time;

  factory Weather.fromJson(Map<String, dynamic> json) {
    try {
      final current = json['current'] as Map<String, dynamic>;
      final daily = json['daily'] as Map<String, dynamic>;
      double dayValue(String key) =>
          ((daily[key] as List).first as num).toDouble();
      final result = Weather(
        temperature: (current['temperature_2m'] as num).toDouble(),
        feelsLike: (current['apparent_temperature'] as num).toDouble(),
        humidity: (current['relative_humidity_2m'] as num).toInt(),
        wind: (current['wind_speed_10m'] as num).toDouble(),
        code: (current['weather_code'] as num).toInt(),
        rainChance: dayValue('precipitation_probability_max').toInt(),
        minimum: dayValue('temperature_2m_min'),
        maximum: dayValue('temperature_2m_max'),
        time: current['time'] as String,
      );
      if (result.humidity < 0 ||
          result.humidity > 100 ||
          result.rainChance < 0 ||
          result.rainChance > 100) {
        throw const FormatException('Invalid weather range');
      }
      return result;
    } catch (_) {
      throw const FormatException('Weather data is missing or invalid');
    }
  }

  bool get rainy =>
      (code >= 51 && code <= 67) || (code >= 80 && code <= 82) || code >= 95;

  String get description {
    if (code == 0) return 'Trời quang';
    if (code <= 3) return 'Có mây';
    if (code == 45 || code == 48) return 'Sương mù';
    if (code >= 95) return 'Có giông';
    if (rainy) return 'Có mưa';
    if ((code >= 71 && code <= 77) || code == 85 || code == 86) {
      return 'Có tuyết';
    }
    return 'Thời tiết thay đổi';
  }

  String get umbrellaAdvice => rainy || rainChance >= 50
      ? 'Nên mang ô: hôm nay có khả năng mưa.'
      : 'Khả năng mưa thấp, chưa cần mang ô.';

  String get outdoorAdvice {
    if (code >= 95) return 'Có giông: tránh hoạt động ngoài trời.';
    if (wind >= 40) return 'Gió mạnh: hạn chế hoạt động ngoài trời.';
    if (maximum >= 35) {
      return 'Trời nóng: tránh vận động ngoài trời vào giữa ngày, nhớ uống nước.';
    }
    if (minimum <= 15) return 'Trời lạnh: mang áo khoác khi ra ngoài.';
    if (rainy || rainChance >= 50) {
      return 'Ưu tiên hoạt động trong nhà hoặc kiểm tra lại trước khi đi.';
    }
    return 'Thời tiết khá thuận lợi cho một buổi đi dạo.';
  }
}
