# Deadline Mate — SE194007

Ứng dụng Android quản lý deadline và phiên học. Tên hiển thị: **Deadline Mate**. Firebase project: **deadline-mate-feff4**. Repository nộp theo đề: **PRM393_Lab03_SE194007**.

## Trạng thái đã kiểm chứng

- Flutter analyze: No issues found.
- 13 unit/widget tests pass; 10 Firestore Rules emulator tests pass.
- APK debug build thành công và đã cài/mở trên emulator-5554. Ảnh thật: assets/evidence/android-login.png.
- Android app được đăng ký trên Firebase; Google provider Enabled; google-services.json mới có OAuth Android/web và SHA-1 khớp máy.

Chưa đăng nhập tài khoản Google trên Android, chưa kiểm chứng dữ liệu/dịch vụ Firebase thật hoặc chạy đủ bộ MobAI bắt buộc. Có smoke MobAI DSL pass 3/3; runner .mob chưa khởi tạo test project. Bài LAB chưa hoàn tất.

## Mã nguồn hiện có

MVVM + Provider; theme; Login/Profile và auth gate theo UID; deadline CRUD/realtime/sort/filter, list/detail/create/edit; Courses; Dashboard; Calendar; Study sessions plan/start/finish; PDF tiếng Việt/upload/history; Remote Config; FCM inbox/routing; Analytics; Crashlytics handlers/demo. Có mã không đồng nghĩa tính năng đã pass trên dịch vụ thật.

## Chạy và kiểm tra

Flutter cục bộ: D:\PRM\tools\flutter\bin\flutter.bat. Java: C:\Program Files\Android\Android Studio\jbr. Android package: vn.deadlinemate.deadline_mate.

Chạy flutter pub get, flutter analyze, flutter test; flutter build apk --debug; flutter run -d emulator-5554. Android cần Google Play services để đăng nhập. Kotlin incremental compilation đã tắt để tránh lỗi cache khi package ở ổ C và dự án ở ổ D.

Rules tests dùng localhost:8188 với demo project, không chạm dữ liệu thật; lệnh trong docs/test-report.md. Storage Rules chưa kiểm thử.

## Tài liệu

- docs/progress.md: phạm vi hoàn thành và còn thiếu.
- docs/firebase-setup.md: cấu hình thật, SHA-1 và dịch vụ còn phải bật.
- docs/analytics-plan.md: events/triggers/parameters.
- docs/fcm-demo.md: Console test payload và bảo vệ thông báo theo người dùng.
- docs/test-report.md: kết quả thực tế và giới hạn kiểm chứng.
- design/DESIGN.md, ux/user-flow.md, handoff/flutter-handoff.md: đặc tả mới; Figma còn phải cập nhật.
- ../lab3-workspace/docs/: tài liệu chuẩn bị ban đầu, chưa phải hồ sơ nộp hoàn chỉnh.

Còn thiếu cloud database/rules deployment, xác minh Auth/CRUD/PDF/FCM/Remote Config/DebugView/Crashlytics, Figma fidelity/accessibility, MobAI exercises, PR review, AI log và báo cáo/slide/video. Storage adapter là Firebase Storage nhưng project Spark chưa bật billing; chưa quyết định nâng gói hay chuyển Cloudinary theo đề chính.

Không commit credentials hoặc private keys. Public Firebase app config không thay thế Security Rules. Không công khai bearer download URL/token thiết bị trong bằng chứng nộp. Font Noto Sans và giấy phép ở assets/fonts/.

