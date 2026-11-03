# Deadline Mate — SE194007

Ứng dụng Android quản lý deadline và phiên học. Tên hiển thị: **Deadline Mate**. Firebase project: **deadline-mate-feff4**. Repository nộp theo đề: **PRM393_Lab03_SE194007**.

## Trạng thái đã kiểm chứng

- Flutter analyze: No issues found.
- 22 unit/widget tests pass; 18 Rules emulator tests pass (11 Firestore, 7 Storage).
- APK debug build thành công và đã cài/mở trên emulator-5554. Ảnh thật: assets/evidence/android-login.png.
- Android app được đăng ký trên Firebase; Google provider Enabled; google-services.json mới có OAuth Android/web và SHA-1 khớp máy.

Đã đăng nhập Google, tạo môn, chạy Deadline CRUD/complete và Study plan/start/finish trên Android với Firebase thật; log và giới hạn ở docs/live-flow-results.md. Còn flow PDF và nhiều bằng chứng dịch vụ, chưa chạy đủ MobAI bắt buộc; runner .mob chưa khởi tạo test project. Bài LAB chưa hoàn tất.

## Mã nguồn hiện có

MVVM + Provider; theme; Login/Profile và auth gate theo UID; deadline CRUD/realtime/sort/filter, list/detail/create/edit; Courses; Dashboard; Calendar; Study sessions plan/start/finish; PDF tiếng Việt/upload/history; Remote Config; FCM inbox/routing; Analytics; Crashlytics handlers/demo. Có mã không đồng nghĩa tính năng đã pass trên dịch vụ thật.

## Chạy và kiểm tra

Flutter cục bộ: D:\PRM\tools\flutter\bin\flutter.bat. Java: C:\Program Files\Android\Android Studio\jbr. Android package: vn.deadlinemate.deadline_mate.

Chạy flutter pub get, flutter analyze, flutter test. Build với `flutter build apk --debug --dart-define-from-file=config/cloudinary.json`; chạy với `flutter run -d emulator-5554 --dart-define-from-file=config/cloudinary.json`. Android cần Google Play services để đăng nhập. Kotlin incremental compilation đã tắt để tránh lỗi cache khi package ở ổ C và dự án ở ổ D.

Rules tests dùng demo project, không chạm dữ liệu thật; lệnh trong docs/test-report.md. Adapter PDF đang dùng Cloudinary; Storage Rules được giữ và kiểm thử cho phương án Firebase thay thế.

## Tài liệu

- docs/architecture.md: giải thích MVVM, dữ liệu, ba luồng và giới hạn hiện có để vấn đáp.
- docs/backend-deployment.md: database/Rules và Remote Config đã triển khai thật, cùng phần còn cần kiểm chứng.
- docs/implementation-ai-log.md: nhật ký thật theo yêu cầu/lượt tiếp tục; quyết định của sinh viên còn chờ xác nhận.
- docs/live-verification-plan.md: thứ tự thu bằng chứng và điều kiện cho mười bài MobAI; chưa phải kết quả pass.
- docs/live-flow-results.md: các bước đã chạy thật, log pass/fail và phạm vi chưa kiểm chứng.
- docs/components.md: mapping thư viện widget, trạng thái và các ngoại lệ cần đối chiếu Figma.
- docs/progress.md: phạm vi hoàn thành và còn thiếu.
- docs/firebase-setup.md: cấu hình thật, SHA-1 và dịch vụ còn phải bật.
- docs/cloudinary-setup.md: cấu hình PDF không cần API secret, trạng thái Console và giới hạn triển khai.
- docs/analytics-plan.md: events/triggers/parameters.
- docs/fcm-demo.md: Console test payload và bảo vệ thông báo theo người dùng.
- docs/test-report.md: kết quả thực tế và giới hạn kiểm chứng.
- design/DESIGN.md, ux/user-flow.md, handoff/flutter-handoff.md: đặc tả mới; Figma còn phải cập nhật.
- ../lab3-workspace/docs/: tài liệu chuẩn bị ban đầu, chưa phải hồ sơ nộp hoàn chỉnh.

Database/Rules và ba tham số Remote Config đã triển khai thật; còn xác minh Auth/CRUD/PDF/FCM/Remote Config trong app/DebugView/Crashlytics, Figma fidelity/accessibility, MobAI exercises, PR review, AI log và báo cáo/slide/video. Sinh viên đã chọn Cloudinary theo đề chính để tránh liên kết thanh toán; giới hạn định dạng preset và upload thật còn phải kiểm chứng.

Không commit credentials hoặc private keys. Public Firebase app config không thay thế Security Rules. Không công khai bearer download URL/token thiết bị trong bằng chứng nộp. Font Noto Sans và giấy phép ở assets/fonts/.

