import 'package:flutter/material.dart';

import '../models/weather.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key, this.service});
  final WeatherService? service;
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late final service = widget.service ?? WeatherService();
  City city = City.choices.first;
  late Future<Weather> weather;

  @override
  void initState() {
    super.initState();
    weather = service.fetchWeather(city);
  }

  Future<void> _reload() async {
    final next = service.fetchWeather(city);
    setState(() {
      weather = next;
    });
    try {
      await next;
    } catch (_) {
      /* FutureBuilder displays errors. */
    }
  }

  @override
  void dispose() {
    if (widget.service == null) service.close();
    super.dispose();
  }

  Widget _card(IconData icon, String title, String value) => Card(
    child: ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Weather Companion'),
      actions: [
        IconButton(
          onPressed: _reload,
          tooltip: 'Tải lại',
          icon: const Icon(Icons.refresh),
        ),
      ],
    ),
    body: SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: DropdownButtonFormField<City>(
              initialValue: city,
              decoration: const InputDecoration(
                labelText: 'Chọn thành phố',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final value in City.choices)
                  DropdownMenuItem(value: value, child: Text(value.name)),
              ],
              onChanged: (value) {
                if (value == null) return;
                city = value;
                _reload();
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<Weather>(
              future: weather,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Đang tải thời tiết…'),
                      ],
                    ),
                  );
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.cloud_off, size: 56),
                          const Text(
                            'Không thể tải thời tiết',
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            snapshot.error is WeatherException
                                ? (snapshot.error as WeatherException).message
                                : 'Dữ liệu trống hoặc đã có lỗi xảy ra.',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          FilledButton(
                            onPressed: _reload,
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                final data = snapshot.data!;
                return RefreshIndicator(
                  onRefresh: _reload,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    children: [
                      Card(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Icon(
                                data.rainy
                                    ? Icons.umbrella
                                    : Icons.cloud_outlined,
                                size: 56,
                              ),
                              Text(
                                city.name,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                '${data.temperature.toStringAsFixed(1)} °C',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium,
                              ),
                              Text(data.description),
                              Text(
                                'Cập nhật: ${data.time.replaceFirst('T', ' ')} (giờ địa phương)',
                              ),
                            ],
                          ),
                        ),
                      ),
                      _card(
                        Icons.thermostat,
                        'Cảm giác như',
                        '${data.feelsLike.toStringAsFixed(1)} °C',
                      ),
                      _card(
                        Icons.water_drop_outlined,
                        'Độ ẩm / Khả năng mưa hôm nay',
                        '${data.humidity}% / ${data.rainChance}%',
                      ),
                      _card(
                        Icons.air,
                        'Tốc độ gió',
                        '${data.wind.toStringAsFixed(1)} km/h',
                      ),
                      _card(
                        Icons.wb_sunny_outlined,
                        'Nhiệt độ hôm nay',
                        '${data.minimum.toStringAsFixed(1)} – ${data.maximum.toStringAsFixed(1)} °C',
                      ),
                      _card(
                        Icons.umbrella_outlined,
                        'Có cần mang ô?',
                        data.umbrellaAdvice,
                      ),
                      _card(
                        Icons.directions_walk,
                        'Gợi ý hoạt động',
                        data.outdoorAdvice,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'Nguồn: Open-Meteo • Gợi ý dựa trên ngưỡng đơn giản, chỉ mang tính tham khảo.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
