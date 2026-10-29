# LAB 8 — Flutter + REST API

Ứng dụng lấy bài viết từ `https://jsonplaceholder.typicode.com/posts`.

## Chạy ứng dụng

```sh
flutter pub get
flutter run -d chrome
```

Hoặc mở thư mục này trong Android Studio / VS Code, chọn thiết bị Android rồi chạy `flutter run`.

## Chức năng

- GET bằng package `http`, giải mã bằng `json.decode()`.
- Model `Post` có factory `fromJson()` kiểm tra cấu trúc dữ liệu.
- `ApiService` riêng, hỗ trợ inject `http.Client` và timeout 15 giây.
- `FutureBuilder<List<Post>>`, loading, lỗi thân thiện, danh sách rỗng.
- `ListView.builder` hiển thị ID, title, body.
- Nút thử lại, kéo xuống tải lại, màn hình chi tiết.
- Quyền Internet cho Android đã được khai báo.

## Cấu trúc

```text
lib/main.dart                      MaterialApp
lib/models/post.dart               Model và JSON parsing
lib/services/api_service.dart      HTTP GET, timeout, exception
lib/screens/post_list_screen.dart  Danh sách và chi tiết
test/                              Unit test và widget test
```

## Kiểm tra

```sh
flutter analyze
flutter test
flutter build web
```

Các bài test dùng `MockClient`, không phụ thuộc mạng thật.

## Ảnh nộp bài

Chụp ba trạng thái: đang tải, lỗi, danh sách thành công.
Để xem trạng thái lỗi, ngắt mạng rồi nhấn tải lại (có thể cần chờ timeout).
Để chụp loading dễ hơn, dùng network throttling trong Chrome DevTools.

## DartPad

Project này được tổ chức nhiều file để nộp ZIP. Để chạy trên DartPad Flutter,
gộp nội dung các file trong `lib/` vào một editor, đưa toàn bộ import lên đầu,
bỏ các import tương đối giữa các file. Giữ import Flutter, `http`,
`dart:async` và `dart:convert`. DartPad cần hỗ trợ package `http`.

POST là phần tùy chọn và chưa được triển khai.
