# Trạng thái LAB 3 của SE194007

## Đã có mã nguồn

- Flutter Android project và dependencies Firebase/Provider.
- Theme, đặc tả 12 màn hình và 3 flow mới; chưa có Figma.
- Auth service Google Sign-In, AuthViewModel, Login/Profile và user-scoped Navigator.
- Deadline model, Firestore CRUD/orderBy/realtime service và ViewModel.
- UI danh sách, chi tiết, tạo/sửa, xác nhận bỏ form/xóa; loading/empty/error/retry.
- Firestore rules riêng cho deadlines, kiểm tra UID và schema. Chưa test emulator hoặc deploy; các collection chưa triển khai bị deny.

## Chưa được coi là hoàn thành

- Firebase project/config Android của sinh viên, SHA-1, Google provider; đăng nhập thật.
- Courses, dashboard, calendar, sessions, reports, notifications.
- PDF upload, FCM, Remote Config, Analytics, Crashlytics tích hợp thực tế.
- Build/run Android và bằng chứng Firebase Console.
- Rules emulator tests, 10 MobAI scripts thật/healing/bug-catching; quyết định MobAI/ARTEMIS.
- Figma/handoff cập nhật đúng đề tài và độ bám sát UI.
- GitHub/PR AI review, AI implementation log đầy đủ, báo cáo/slide/video.

## Môi trường kiểm tra thực tế

flutter doctor tìm thấy Java bundled trong Android Studio và Android SDK, nhưng thiếu Android cmdline-tools và chưa xác minh licenses. Chưa có Android device đang kết nối. Windows C++ toolchain không liên quan bản Android; không cần cài chỉ để làm LAB này.

Chạy analyze và unit/widget tests không chứng minh app đã hoạt động với Firebase thật.

## Cập nhật triển khai

Đã bổ sung mã Courses, Study sessions, Dashboard, Calendar, Reports PDF/Storage và Remote Config cùng các màn hình. Danh sách chưa hoàn thành phía trên phản ánh mốc trước; các mục vừa nêu hiện có mã nhưng vẫn chưa kiểm chứng Firebase thật. FCM, Analytics, Crashlytics và các yêu cầu nộp/bằng chứng vẫn còn thiếu. Tổng 10 unit/widget tests đã pass; chưa chạy E2E/rules tests.

