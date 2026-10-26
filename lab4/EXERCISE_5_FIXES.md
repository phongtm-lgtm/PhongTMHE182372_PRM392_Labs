# Exercise 5 – Giải thích sửa lỗi

1. **ListView trong Column:** ListView không có chiều cao giới hạn nếu đặt trực tiếp trong Column. Bọc ListView bằng Expanded để danh sách chiếm phần chiều cao còn lại của màn hình và cuộn được.
2. **Overflow trên màn hình nhỏ:** Column chứa nội dung dài có thể vượt chiều cao màn hình. Bọc nội dung bằng SingleChildScrollView để cuộn toàn bộ nội dung; không đặt Expanded trong Column này.
3. **Trạng thái không cập nhật trên UI:** Chỉ thay đổi biến không yêu cầu Flutter dựng lại giao diện. Thay đổi biến trong setState để giá trị mới được hiển thị.
4. **DatePicker lỗi context:** showDatePicker cần context nằm dưới MaterialApp với Navigator và Material localizations. Gọi picker từ State của màn hình đã được mở trong MaterialApp. Sau await, kiểm tra mounted và kết quả khác null trước khi cập nhật trạng thái.
