# Kiểm thử trực tiếp trên Edge — 04/11/2026

App release tại localhost:8085, cùng Firebase deadline-mate-feff4. Đây là thao tác UI thật qua công cụ Windows Computer Use, không phải MobAI .mob, không phải test tự động có assertion machine-readable và không thay bằng chứng Android.

## Lịch và phiên học

1. Từ Dashboard mở Lịch học: thấy tháng 11 năm 2026, T2–T7/CN và ngày 04/11/2026. Native Material calendar trên web đã dùng tiếng Việt.
2. Mở Phiên học: record completed từ lượt Android trước đó vẫn có trong danh sách. Mở Lập phiên học.
3. Bấm Lưu khi title trống: form hiển thị yêu cầu tiêu đề 1–120 ký tự/thời lượng 5–180 phút và vẫn ở form. Không kiểm tra Console ở bước này nên không tuyên bố có bằng chứng server không phát sinh document.
4. Nhập `Ôn LAB3 Edge 04-11`, giữ 25 phút và thời điểm form đã lấy. Lưu: thấy loading rồi trở lại list, record mới hiển thị Đã lên kế hoạch. [Ảnh planned](../assets/evidence/web-study-planned.jpg).
5. Bấm Bắt đầu học: thấy trạng thái Đang học, nút Kết thúc phiên học. [Ảnh running](../assets/evidence/web-study-running.jpg).
6. Mở xác nhận kết thúc rồi chọn Học tiếp: dialog đóng, vẫn Đang học. [Ảnh cancel](../assets/evidence/web-study-cancel-finish.jpg).
7. Mở xác nhận lần nữa và chọn Kết thúc: list chuyển Đã kết thúc, không còn nút kết thúc trên record này. [Ảnh completed](../assets/evidence/web-study-completed.jpg).
8. Back về Calendar: ngày 04/11 có card phiên mới, Đã hoàn thành · 25 phút dự kiến · 0 phút thực tế. [Ảnh lịch](../assets/evidence/web-calendar-vietnamese-completed.jpg). 0 phút là kết quả thật của lượt chạy dưới một phút; không sửa timestamp.

Ảnh JPG là screenshot nguyên bản của cửa sổ Edge, lưu từ công cụ và đã xem trực tiếp. Kích thước 826×934 px gồm browser chrome; không mô tả chúng là Figma 360×800 dp hoặc ảnh Android. Bộ ảnh không chứa email/UID/token tài khoản. Không replay tạo lại fixture mù vì sẽ sinh phiên khác có cùng title.

## Giới hạn còn lại

Chưa kiểm chứng lost-acknowledgement retry transaction, offline/reconnect, reload giữa phiên running, race giữa hai client, timezone khác, dữ liệu Console hoặc logout/isolation trên web. Các ảnh cho thấy UI qua các thao tác; không thay thế log transaction/Console. Chưa có PDF upload/open thật, browser push hoặc Crashlytics web. Suite .mob và các yêu cầu LAB còn thiếu được giữ trong progress.md.
