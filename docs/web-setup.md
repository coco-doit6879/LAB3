# Chạy Deadline Mate trên Edge

Theo yêu cầu sinh viên ngày 04/11/2026, app có thêm nền tảng web để thao tác trên máy Windows mà không chạy emulator. Bản Android vẫn giữ cho yêu cầu LAB. Không coi chuyển sang Edge là đã hoàn tất bằng chứng Android.

## Mở và chạy lại

Khi server đang chạy, mở http://localhost:8085 trong Edge. Địa chỉ này chỉ dùng trên chính máy tính đang chạy server; không phải link triển khai công khai và không mở từ iPhone được bằng localhost.

Nếu đã dừng server, mở `scripts/run-edge.cmd` từ File Explorer. Script dùng Flutter tại thư mục tools của workspace, hoặc lệnh flutter trong PATH trên máy khác. Để cửa sổ chạy server mở trong lúc dùng app. Nếu cổng 8085 đã có server của phiên trước, dùng trang đang chạy thay vì mở thêm server trùng cổng. Tại terminal của Flutter, q dừng phiên chạy.

Lệnh tương đương từ thư mục dự án:

```powershell
D:\PRM\tools\flutter\bin\flutter.bat run -d edge --release --web-hostname localhost --web-port 8085 --dart-define-from-file=config/cloudinary.json
```

Bấm Tiếp tục với Google và tự chọn tài khoản trong popup. Không chia sẻ mật khẩu/OTP. Nếu người dùng đóng popup thì có thể thử lại từ nút đăng nhập. Không tự động hóa form Google.

## Cấu hình và kết quả thật

- Firebase Web app đã đăng ký: `1:106147478931:web:5c79d7763400c99037fc66`, tên Deadline Mate Web, cùng project deadline-mate-feff4. SDK config lấy từ Firebase CLI, không tự suy đoán app ID/API key.
- Authorized domains đã đọc lại: localhost, deadline-mate-feff4.firebaseapp.com và deadline-mate-feff4.web.app. Không thay đổi danh sách này trong vòng cấu hình web.
- Google sign-in web dùng FirebaseAuth.signInWithPopup(GoogleAuthProvider()); Android giữ luồng Google ID token hiện có. Theo [hướng dẫn Firebase](https://firebase.google.com/docs/auth/flutter/federated-auth).
- flutter build web --no-pub --dart-define-from-file=config/cloudinary.json thành công; flutter run -d edge --release cũng build và mở trang thành công. Analyze không có lỗi; full Flutter tests 24 pass. Đây là suite unit/widget hiện có, không phải 24 E2E web tests.
- Đã quan sát trực tiếp Edge tại localhost:8085 sau đăng nhập thủ công: Dashboard hiển thị sáu deadline chưa xong, tên môn PRM393 — Flutter và Firebase và RC Demo 1–3 trong vùng nhìn thấy. Đây là bằng chứng đăng nhập và đọc dữ liệu thật trên web; chưa chứng minh đủ CRUD/PDF/RC/notifications trên web.
- Emulator đã nhận lệnh emu kill với kết quả OK để giảm tải máy. Phiên Edge dùng release để tránh chi phí debug trong lúc thao tác.

## Khác biệt nền tảng

Firestore CRUD/realtime, Courses, Study, Reports và Remote Config dùng chung service và dữ liệu theo UID. Cần kiểm thử riêng từng luồng trên web; không suy từ Android đã pass sang web đã pass. PDF browser upload/open còn chưa kiểm chứng; preset Cloudinary vẫn cần xác nhận Allowed formats=pdf.

Crashlytics trong dự án này không có implementation web. Web bỏ cài Crashlytics handlers/identity/errors, ẩn test crash và vô hiệu nút handled-demo kèm giải thích; Analytics vẫn được gọi. Không báo đã gửi Crashlytics trên web.

Web vẫn đọc inbox Firestore nhưng chưa cấu hình service worker/VAPID cho browser push. Không đăng ký native background handler hoặc gọi getInitialMessage trên web; nút xin quyền/token bị vô hiệu và có giải thích. Thông báo Android vẫn giữ nguyên triển khai và cần kiểm thử theo LAB. Không tự động cấp quyền trình duyệt.

Google login và Dashboard web thành công không thay thế các yêu cầu còn thiếu: FCM Android nhiều trạng thái, DebugView/Crashlytics receipt, mười MobAI scripts và hai bài tập, fidelity/Figma, PR review/merge, report/video cuối.
