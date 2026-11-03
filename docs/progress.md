# Tiến độ Deadline Mate

Sinh viên: SE194007. Firebase project: deadline-mate-feff4. App hiển thị: Deadline Mate. Repository nộp: PRM393_Lab03_SE194007.

## Có mã nguồn

MVVM + Provider; Google authentication/auth gate; deadline CRUD/realtime/query; Courses; Dashboard; Calendar; Study sessions transaction; PDF generation/upload/history; Remote Config; FCM inbox và routing; Analytics events; Crashlytics handlers và demo controls. Course form chọn dữ liệu môn học thật. Không coi có mã là có bằng chứng chạy dịch vụ thật.

## Đã kiểm chứng

- Flutter analyze: No issues found.
- 12 unit/widget tests pass.
- 10 Firestore Rules emulator tests pass (project demo-deadlinemate, localhost:8188).
- Đăng ký Android app trên Firebase project thật.
- Google provider Enabled đã xác minh trên Console; cấu hình mới có OAuth Android/web và SHA-1 khớp debug key của máy.
- APK debug build thành công sau khi tắt Kotlin incremental compilation để xử lý cache khác ổ C/D. Đã rebuild với config OAuth mới, cài và mở thành công; ảnh assets/evidence/android-login.png.
- Android emulator Pixel_4a đã khởi động, ADB thấy emulator-5554, sys.boot_completed=1.

## Còn phải hoàn thành và chứng minh

- Đã cài/chạy APK cập nhật và xem Login; còn đăng nhập bằng tài khoản test và kiểm tra UI/flows đầy đủ trên Android.
- Tạo Firestore database thật, deploy rules sau review; CRUD và dữ liệu Console.
- Storage adapter hiện là Firebase Storage, project Spark chưa có billing: cần chốt phương án storage; không tự nâng gói.
- Firebase Console evidence cho FCM các trạng thái, Remote Config đổi hành vi, Analytics DebugView, Crashlytics handled/test crash.
- Storage Rules tests; xử lý các phát hiện code review có thật.
- Figma/design LAB 2 cập nhật; đối chiếu từng màn hình, tokens/components và accessibility 360/412 dp.
- MobAI 10 scripts, full runs, healing và bug-catching; nếu thay ARTEMIS cần theo giảng viên.
- GitHub remote/PR review/merge, AI log có prompt nguyên văn và sinh viên xác nhận quyết định; report/slides/video.

Bài LAB chưa hoàn tất. Xem test-report.md để biết chính xác phạm vi kiểm chứng, không dùng unit tests thay bằng chứng E2E.


## Vòng review tiếp theo

Đã sửa 5 phát hiện review cục bộ, ghi trong code-review.md; chưa thay thế review PR GitHub. 13 Flutter tests pass, analyze sạch và APK đã rebuild. MobAI CLI/bridge hoạt động, login-gate DSL pass 3/3; .mob runner còn lỗi test-project initialization. Log pass và log lỗi đều lưu nguyên trong assets/evidence/mobai. Chưa hoàn thành 10 E2E scripts.
