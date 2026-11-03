# Thư viện component

Đối chiếu với thư viện dự kiến trong handoff, ngày 03/11/2026. Đây là mapping mã nguồn; không phải chứng nhận giống Figma vì chưa có frame/component Figma để so sánh.

| Component | File trong lib/widgets | Biến thể và trạng thái | Nơi dùng |
|---|---|---|---|
| AppButton | app_button.dart | Nút có/không icon; enabled/pressed/disabled theo Material; loading khóa callback, hiện spinner và live-region | Login, deadline form/detail, course dialog, study, reports, profile, setup và status actions |
| AppField | app_field.dart | Controller; enabled/disabled; focus/filled theo Material; validator/error từ Form; maxLength và keyboard tùy ngữ cảnh | Deadline title/search, course name/code, study title/minutes |
| DeadlineCard | deadline_card.dart | Pending/completed có icon và chữ; tap; title tự xuống dòng | Dashboard và Deadline list |
| AppNavigation | app_navigation.dart | Bốn destination; selected/unselected; bottom bar dưới 600 dp, rail từ 600 dp | HomeShell |
| AppTopBar | app_top_bar.dart | Title; actions tùy chọn; Back tự suy ra từ Navigator | Các màn hình nghiệp vụ và profile |
| AppDialog | app_dialog.dart | Title/content/actions; nội dung cuộn; xác nhận, cảnh báo xóa/bỏ thay đổi/crash, form môn học | Deadline, study, courses, profile |
| LoadingState | status_panel.dart | Spinner và thông điệp, semantics liveRegion | StatusPanel khi loading |
| EmptyState | status_panel.dart | Icon inbox, thông điệp, action tùy chọn | StatusPanel khi không có dữ liệu/kết quả |
| ErrorState | status_panel.dart | Icon error và màu error; thông điệp liveRegion, retry tùy chọn | StatusPanel lỗi ở Courses, Deadline list/detail |

## Ngoại lệ có chủ đích

- Nút phụ OutlinedButton/TextButton, IconButton và floating action button vẫn là Material widgets được cấu hình bằng AppTheme; AppButton dành cho primary action. Cần ghi nhận cách map các variant này khi Figma chốt.
- Dropdown môn học, date/time picker, segmented filter và progress tuyến tính sử dụng Material controls; AppField dành cho ô nhập văn bản.
- Course/report/notification/calendar cards vẫn là Card/ListTile với nội dung riêng; DeadlineCard dành cho bản tóm tắt Deadline.
- Lỗi ghi inline, lỗi cấu hình và lỗi lịch sử báo cáo có thể cần giữ cạnh action liên quan thay vì thay toàn bộ màn hình bằng ErrorState. Chưa hoàn thành kiểm tra variants trên toàn bộ screen.
- AppDialog dựa trên AlertDialog để giữ điều hướng bàn phím, semantics và bố trí action mặc định; chưa có style riêng cho destructive/error button ngoài văn bản cảnh báo/xác nhận.

## Kiểm chứng và việc còn lại

Sau toàn bộ thay đổi component và loading, full suite 21 test đã pass; analyze không có lỗi. Các ca gồm validation form, giữ input khi lỗi, retry mở detail, bộ lọc khi mở bàn phím và navigation/card 360/412/800 dp.

Trước khi nộp: so sánh từng variant với Figma, kiểm tra focus/pressed/disabled/loading thật, TalkBack, text scaling và target trên tất cả màn hình Android. Các test hiện tại không bao phủ đầy đủ những trạng thái này.
