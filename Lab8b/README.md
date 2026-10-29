# Lab 8B — Weather Companion

## Mô tả ứng dụng

Chọn kịch bản A: thời tiết. Người dùng chọn một trong năm thành phố Việt Nam để xem nhiệt độ hiện tại, cảm giác như, độ ẩm, gió, khoảng nhiệt độ và khả năng mưa trong ngày. Ứng dụng đưa ra gợi ý mang ô, mặc áo khoác hoặc lựa chọn hoạt động ngoài trời bằng các ngưỡng đơn giản. Đây là gợi ý tham khảo, không phải cảnh báo an toàn chính thức.

## Chạy và kiểm tra

```sh
flutter pub get
flutter run
flutter analyze
flutter test
```

Hoặc chạy trên Chrome: `flutter run -d chrome`. Không cần API key hoặc tài khoản. Android đã khai báo quyền Internet. Open-Meteo là API thực, cần kết nối mạng.

## Cấu trúc

- `lib/models/weather.dart`: model City/Weather, fromJson, gợi ý.
- `lib/services/weather_service.dart`: HTTP GET, giải mã JSON, timeout 15 giây, xử lý lỗi.
- `lib/screens/weather_screen.dart`: chọn thành phố, FutureBuilder, loading/lỗi/thử lại, thẻ dữ liệu và gợi ý, kéo để tải lại.
- `lib/main.dart`: MaterialApp.

API: `https://api.open-meteo.com/v1/forecast`. Tham số latitude/longitude, current, daily, timezone=auto, forecast_days=1. Tài liệu: https://open-meteo.com/en/docs . Đơn vị mặc định: °C, km/h. Khả năng mưa là giá trị dự báo cao nhất trong ngày, không phải xác suất mưa ngay tại thời điểm hiện tại.

## Ảnh nộp bài

1. Loading: giảm tốc mạng trong Chrome DevTools rồi nhấn Tải lại.
2. Error + Thử lại: tắt mạng (hoặc bật Offline trong DevTools), nhấn Tải lại; có thể cần đợi timeout.
3. Success: bật mạng, nhấn Thử lại, chụp các thẻ thời tiết.
4. Gợi ý: cuộn xuống chụp phần mang ô/hoạt động nếu chưa thấy trong ảnh thành công.

Nộp project hoặc repository link kèm mô tả trên và ảnh chụp thực tế. Tests dùng HTTP giả để kiểm tra model, service và loading/error/retry/success; không thay thế kiểm tra API thật trên thiết bị.
