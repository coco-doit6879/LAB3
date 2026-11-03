# Kết quả chạy Android với Firebase thật

Ngày chạy: 03/11/2026. Project: deadline-mate-feff4. Thiết bị: emulator-5554, APK debug sau commit f19b22a. Tài khoản đã được sinh viên đăng nhập thủ công. Không dùng repository giả trong những lần chạy dưới đây.

Các JSON là kết quả **MobAI DSL**, chưa phải suite mười file `.mob`. Một số kịch bản được tiếp tục từ trạng thái vừa quan sát sau lỗi locator; không gọi tất cả các file đầy đủ là đã replay pass. Không có thay đổi mã production trong vòng này.

## Flow 1: Deadline

| Bước và kết quả thật | Log trong assets/evidence/mobai |
|---|---|
| Mở form tạo: pass 6/6 | deadline-form-open.json |
| Save title rỗng hiện lỗi; nhập title giữ được. Run dừng ở selector dropdown vì nhãn accessibility kèm thông báo lỗi: **fail** 5 bước đã thực hiện | deadline-validation-and-course.json |
| Mở dropdown bằng locator nhận cả error semantics: pass 3/3 | deadline-course-options.json |
| Chọn môn PRM393, lưu LAB3 Demo A, vào detail và assert tên môn: pass 8/8 | deadline-create-live.json |
| Edit title thành LAB3 Demo A - updated; complete; listener đổi status và nút thành Đánh dấu chưa xong: pass 13/13 | deadline-edit-complete-live.json |
| Xóa → Giữ lại: record vẫn còn; mở xác nhận lại: pass 9/9 | deadline-delete-cancel.json |
| Xác nhận xóa đúng fixture vừa tạo; vào Deadline list, thấy empty và không còn title: pass 8/8 | deadline-delete-live.json |

Ảnh thật: android-deadline-created.png, android-deadline-updated-completed.png, android-deadline-deleted-empty.png. Đã xem lại ảnh completed, title/course/status/actions đúng và không thấy overflow ở kích thước capture này.

Điều đã chứng minh: create/update/complete/delete được app chờ xác nhận service và hiển thị qua listener; validation error và cancel-delete hoạt động. Điều chưa chứng minh: ảnh Firestore Console trước/sau, cập nhật từ client thứ hai, phục hồi lỗi mạng thật, account isolation và mười bài .mob.

## Flow 2: Phiên học

| Bước và kết quả thật | Log trong assets/evidence/mobai |
|---|---|
| Từ Calendar vào form plan: pass 8/8 | study-plan-open.json |
| Tạo Ôn LAB3 Demo, mặc định 25 phút, save xong list có planned. Run dừng vì exact-text title không khớp merged card semantics: **fail**, chưa chạy Start trong file này | study-plan-start-live.json |
| Tiếp tục trên record đã tồn tại; assert planned, Start transaction, quay về Calendar và thấy running: pass 9/9 | study-start-return-calendar.json |
| End → Học tiếp giữ running; mở lại xác nhận: pass 10/10 | study-finish-cancel.json |
| Xác nhận End, thấy completed, quay về Calendar thấy trạng thái và phút thực tế: pass 9/9 | study-finish-live.json |

Ảnh thật: android-study-running-calendar.png và android-study-completed-calendar.png. Thời gian thực tế hiển thị **0 phút** vì phiên chạy dưới một phút; không sửa timestamps để tạo số đẹp. Đã xem lại ảnh completed: card xuống dòng và hiển thị đầy đủ nội dung ở kích thước capture hiện tại.

Điều đã chứng minh: plan/start/finish qua service thật, cancel finish, rời màn hình vẫn giữ running và Calendar phản ánh completed. Chưa chứng minh restart thiết bị giữa session, transaction race giữa hai client, lỗi mạng và trạng thái Console bằng ảnh.

## Kích thước và giới hạn ảnh

Ảnh gốc vòng này là 1080×2340 px. Chưa xác minh chúng tương ứng 360×800 dp, nên không dùng làm bằng chứng hoàn thành fidelity cùng kích thước Figma. Cần chụp bộ riêng ở kích thước yêu cầu. Calendar native picker hiện hiển thị tháng/ngày bằng tiếng Anh theo locale thiết bị; đây là khác biệt cần xử lý/ghi nhận khi đối chiếu thiết kế tiếng Việt.

## Chưa hoàn tất

Flow 3 PDF/upload/open; live Remote Config change; FCM foreground/background/terminated; DebugView; Crashlytics handled/crash; logout/isolation; Console screenshots; Figma comparisons; mười `.mob` và hai bài tập; PR review/merge và hồ sơ cuối. Các pass ở đây không thay thế những yêu cầu đó.
