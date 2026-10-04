# Lab 5 — Movie Detail App

Ứng dụng Flutter hai màn hình, dữ liệu tĩnh, không gọi API phim.

## Chức năng

- Home: `ListView.builder` hiển thị poster, tên và rating.
- `Navigator.push` + `MaterialPageRoute` truyền đối tượng `Movie` sang Detail.
- Detail: banner gradient, tên, genre chips, overview, action buttons và trailers.
- Favorite toggle và chấm điểm 1–10 sử dụng `setState()`.
- Favorite/điểm chỉ tồn tại khi màn hình Detail còn mở, không lưu lâu dài.
- Share: xem/sao chép thông tin, không mở bảng chia sẻ hệ thống.
- Trailer: xem/sao chép URL, không phát video trực tiếp.
- Back mặc định trở về Home; Detail cuộn được và giới hạn chiều rộng trên web.
- Giữ code happy case: không xử lý loading/lỗi ảnh. Poster cần URL đúng và Internet.

## Chạy

```sh
flutter pub get
flutter run
```

Sửa dữ liệu tại `lib/data/sample_data.dart`. Danh sách hiện có hai phim do người dùng
nhập, phù hợp số lượng 2–3 trong hướng dẫn. Rating là điểm mẫu.
Thay URL trailer `youtube.com` bằng URL video cụ thể và hoàn thiện overview trước
khi nộp. Chưa xác minh thông tin phim, thể loại hay lịch chiếu.

## DartPad

Dán `dartpad/main.dart` vào DartPad Flutter. Dữ liệu trong bản này được sao chép
từ project; cần sửa tương ứng nếu thay dữ liệu sau đó. Clipboard tùy quyền trình
duyệt, có thể chọn văn bản để copy thủ công.

## Kiểm tra và nộp bài

```sh
flutter analyze
flutter test
```

Test chỉ kiểm tra model và số lượng phim mẫu. Kiểm tra thủ công: chọn từng phim,
Favorite, Rate/Lưu/Hủy, Share, trailer, cuộn, Back, màn hình nhỏ và DartPad.
Nộp ZIP project hoặc link DartPad, có thể kèm ảnh/video demo.
Chưa có Figures 8.12–8.18 để xác nhận thiết kế giống chính xác sách.
