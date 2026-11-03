# Deadline Mate — SE194007

Tên repository nộp: **PRM393_Lab03_SE194007**. Đây là mã nguồn đang phát triển, chưa phải bài nộp hoàn tất. Không có Firebase project/config của sinh viên trong repository hiện tại.

## Đã triển khai trong mã nguồn

- Android Flutter, MVVM + Provider, theme và đặc tả mới cho Deadline Mate.
- Google Sign-In, auth gate, Login/Profile, xóa route stack và providers theo phiên đăng nhập.
- Firestore deadlines CRUD, realtime orderBy dueAt; UI list/detail/create/edit, validation và recovery.
- Courses list/create; study sessions plan/start/finish bằng transaction, thời gian dựa trên timestamps.
- Tổng quan, Lịch học, bottom navigation và màn hình Báo cáo.
- PDF tiếng Việt với Noto Sans, upload Firebase Storage có progress, lưu URL/metadata và mở báo cáo.
- Remote Config: dashboard_item_limit, enable_pdf_export, study_banner; defaults và Profile refresh.
- Firestore/Storage rules có schema và kiểm soát UID; chưa test emulator hoặc deploy.

## Kiểm chứng hiện có

10 unit/widget tests pass: auth state, khởi tạo lỗi, validation, chống gửi trùng, filter realtime, giữ form khi lỗi, duration phiên học, lỗi chuyển trạng thái, config fallback và export failure. Các test dùng fake repositories, chưa chứng minh Firebase hoặc upload thật hoạt động. Chưa chạy MobAI.

Chưa build/run Android. flutter doctor thấy Java bundled và Android SDK nhưng thiếu cmdline-tools, licenses chưa xác minh, không có Android device đang kết nối.

## Còn phải hoàn thành

FCM/Notification Center, Analytics và Crashlytics; courses selection trong form; token/component/fidelity/accessibility audit; Firebase config và các minh chứng Console; build/run Android; rules emulator tests; Figma cập nhật; AI log đầy đủ; GitHub/PR review; MobAI và hai bài tập; báo cáo, slide, video. Không coi chức năng có mã là đã kiểm chứng thực tế.

## Cách chạy khi đã cấu hình

Flutter cục bộ: D:\PRM\tools\flutter\bin\flutter.bat. Chạy flutter pub get, flutter analyze, flutter test. Tạo Firebase project của sinh viên, bật Analytics và Google provider, đăng ký Android **vn.deadlinemate.deadline_mate**, cấu hình SHA-1 và chạy flutterfire configure. Cần nối firebase_options.dart được sinh vào bootstrap và cấu hình Google Services/Crashlytics Gradle. Sau đó flutter run trên Android có Google Play services.

Không dùng config Firebase giả. Chưa bật billing; phương án Firebase Storage cần tài khoản phù hợp hoặc thống nhất chuyển Cloudinary theo đề chính. Download URL là bearer link: không công khai URL báo cáo cá nhân trong bằng chứng nộp.

## Tài liệu

- design/DESIGN.md: visual specification mới, chưa có Figma.
- ux/user-flow.md: ba luồng và nhánh phục hồi.
- handoff/flutter-handoff.md: screen handoff dự kiến; một số phần chưa hiện thực đầy đủ.
- docs/progress.md: trạng thái và phần còn thiếu.
- ../lab3-workspace/docs/: khung tài liệu nộp bài, chưa điền bằng chứng giả.

Font: Noto Sans từ notofonts/noto-fonts, giấy phép trong assets/fonts/OFL.txt.
