# Lab 6 — Responsive Movie Genre Browsing Screen

Toàn bộ ứng dụng trong `lib/main.dart`, chỉ import Flutter Material.
Dán trực tiếp file này vào DartPad → New Flutter để chạy.

## Các phần của lab

- **6.1:** Hero gradient, heading “Find a Movie”, font/padding thay đổi theo kích thước.
- **6.2:** Search không phân biệt hoa/thường, genre chips bật/tắt bằng `Wrap`, sort dropdown.
- **6.3:** LayoutBuilder chuyển list 1 cột thành grid 2 cột khi vùng hiển thị >=800 px.
  LayoutBuilder trong card điều chỉnh kích thước poster. MediaQuery đọc chiều rộng màn hình.

Sáu phim Việt dùng dữ liệu minh họa, điểm mẫu và ảnh placeholder từ picsum.photos,
không phải poster thật hoặc thông tin được xác minh. Có thể sửa `allMovies` trong main.dart.

## Quy tắc lọc và sắp xếp

- Tìm chuỗi trong tên phim (case-insensitive).
- Không chọn thể loại: hiện tất cả phim phù hợp tìm kiếm.
- Chọn nhiều thể loại: phim khớp ít nhất một thể loại (OR).
- Kết hợp tìm kiếm và thể loại bằng AND.
- A–Z/Z–A dùng so sánh chuỗi Dart, không phải sắp xếp ngôn ngữ tiếng Việt chuyên biệt.
- Year: mới nhất trước. Rating: điểm cao nhất trước.
- Bonus: số thể loại đã chọn, rating, Clear filters và poster thích ứng.

Toàn trang cuộn để không tràn phần bộ lọc khi xoay ngang hoặc mở bàn phím.
SafeArea tránh vùng tai thỏ. Ảnh cần Internet; giữ code happy case, không thêm xử lý ảnh lỗi.
Không dùng package ngoài trong ứng dụng; flutter_test/flutter_lints chỉ phục vụ phát triển.

## Chạy và kiểm tra

```sh
flutter pub get
flutter run
flutter run -d chrome
flutter analyze
flutter test
```

Test kiểm tra tìm kiếm, genre OR/AND, reset, sort và viewport 320/799/800/1200 px,
bao gồm chế độ ngang. Cần kiểm tra thủ công ảnh trên Internet và chạy DartPad/Android.

## Nộp bài

Nộp ZIP project (không cần build/, .dart_tool/) hoặc link chia sẻ DartPad.
Ảnh/video nên thể hiện list trên điện thoại, grid trên tablet/web, tìm kiếm, chip và sort.
Thiết kế bám chức năng đề bài; chưa có Figures 6.1–6.9 để đối chiếu trực tiếp sách.
