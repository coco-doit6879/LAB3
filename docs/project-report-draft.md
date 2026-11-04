# Deadline Mate — Báo cáo LAB 3 (bản nháp chưa nộp)

MSSV: SE194007. Tên ứng dụng: Deadline Mate. Ngày cập nhật: 04/11/2026.

Bản nháp này theo các nội dung tại mục 12.2 của đề LAB 3 chính. Chưa xuất bản DOCX/PDF và chưa xác minh số trang. Báo cáo chính yêu cầu khoảng 5–10 trang; hướng dẫn v5 yêu cầu 8–12 trang. Dự kiến dàn 8–10 trang sau khi bổ sung bằng chứng, nhưng cần đối chiếu chỉ dẫn cuối của giảng viên. Không dùng bản nháp này để tuyên bố bài đã hoàn tất.

## 1. Tổng quan, người dùng và ba luồng

Deadline Mate hỗ trợ sinh viên theo dõi hạn bài tập, lập phiên học và xuất báo cáo tiến độ. Người dùng mục tiêu là sinh viên có nhiều môn học, cần nhìn nhanh công việc sắp đến hạn và ghi lại việc học theo từng phiên. Đây là persona thiết kế được đề xuất cho đề tài mới, chưa phải kết quả phỏng vấn người dùng.

Sinh viên chọn đề tài Deadline Mate trong cuộc hội thoại làm bài. Thiết kế LAB 2 gốc và đường dẫn Figma chưa được cung cấp. Các tệp design/DESIGN.md, ux/user-flow.md và handoff/flutter-handoff.md là đặc tả mới được xây dựng cho đề tài này; không được trình bày chúng như bằng chứng đã chuyển đúng thiết kế LAB 2 gốc. Việc đổi đề tài cần sinh viên xác nhận với giảng viên.

Ba luồng được triển khai:

1. Quản lý deadline: danh sách → tạo → kiểm tra dữ liệu → lưu → chi tiết → đánh dấu hoàn thành. Form giữ dữ liệu khi lưu thất bại; bản nháp dùng ID ổn định để thử lại. Luồng chỉnh sửa và xóa có xác nhận cũng có trong app.
2. Hoàn thành phiên học: Lịch học → lập kế hoạch → bắt đầu → quay lại lịch → kết thúc có xác nhận → xem trạng thái completed và thời lượng thực tế. Bản sửa mới giữ draft ID khi thử lưu lại, có widget test; phục hồi mất acknowledgement trên Firestore thật còn phải kiểm tra.
3. Xuất báo cáo: bộ lọc deadline → Báo cáo → tạo PDF tiếng Việt → upload → lưu URL/metadata → lịch sử → mở tài liệu. Luồng thứ ba mới có mã và kiểm thử hợp đồng; chưa hoàn thành kiểm thử dịch vụ thật.

## 2. Kiến trúc và MVVM

View hiển thị state và gọi ViewModel; ViewModel kiểm tra đầu vào, quản lý loading/error/busy và điều phối repository. Service là nơi truy cập Firebase SDK hoặc HTTP. Các interface cho phép thay repository bằng fake trong unit/widget tests. Ví dụ: DeadlineFormScreen → DeadlinesViewModel → DeadlineRepository → FirestoreDeadlineService. Chi tiết trách nhiệm và collection ở [architecture.md](architecture.md).

BootstrapService khởi tạo Firebase và handlers. AuthViewModel nghe trạng thái Firebase Auth. AuthGate chỉ dựng cây nghiệp vụ khi có UID; cây Provider mang khóa UID và có Navigator riêng để khi đổi tài khoản hoặc đăng xuất, route stack và subscriptions của phiên cũ bị hủy. SessionNavigator chuyển Android Back vào Navigator bên trong; dialog và picker dùng useRootNavigator=false để thấy đúng Provider.

App dùng Provider, AppTheme và các widget chung như AppButton, AppField, DeadlineCard, AppNavigation, AppTopBar, AppDialog và các trạng thái loading/empty/error. Không khẳng định có ViewModel riêng cho mọi màn hình: Dashboard và Calendar hiện dùng nhiều ViewModel trong HomeShell. MaterialApp đã cấu hình tiếng Việt; widget test xác nhận lịch dùng tiếng Việt trên thiết bị locale en_US. Ảnh lịch native của bản mới còn thiếu.

## 3. Tích hợp Firebase và lưu PDF

Project thật: deadline-mate-feff4. Android package: vn.deadlinemate.deadline_mate. Google provider đã bật; cấu hình Android/web OAuth và SHA-1 debug đã đối chiếu. Google ID token được đổi thành Firebase credential; quyền truy cập dựa trên Firebase UID. Một lượt đăng nhập thật và các luồng dữ liệu đã được ghi nhận trước đây. Sau lần khởi động lại emulator mới nhất, app đang yêu cầu đăng nhập lại; chưa kết luận nguyên nhân và chưa tính là đã khôi phục phiên thành công.

Dữ liệu nằm dưới users/{uid}: deadlines, courses, study_sessions, reports và notifications. Deadlines hỗ trợ CRUD và listener thời gian thực; courses hỗ trợ tạo/danh sách; study_sessions dùng transaction cho planned → running → completed. Report metadata lưu tên file, URL, owner, số mục, public ID/provider và thời điểm tạo. Không mô tả Courses như đã hỗ trợ đủ CRUD.

Security Rules kiểm tra UID sở hữu cùng schema/kiểu/giới hạn trường và transition. Database Standard/freeTier tại asia-southeast1 đã tạo; Firestore Rules đã compile và deploy thật. 11 Firestore và 7 Storage emulator cases đã pass trên demo project. Storage là phương án thay thế, không phải adapter PDF đang dùng. Kiểm thử Rules cục bộ không thay thế bằng chứng đăng nhập hai tài khoản và cách ly dữ liệu trên app thật.

Theo lựa chọn của sinh viên, PDF dùng Cloudinary để tránh liên kết thanh toán. Đề chính cho phép lựa chọn này; v5 mô tả Firebase Storage. App chỉ chứa cloud name/unsigned preset công khai, không chứa API secret. PDF dùng font Noto Sans đóng gói để hỗ trợ tiếng Việt; adapter kiểm tra header và giới hạn 10 MiB trước HTTP. Cloudinary preset không hỗ trợ giới hạn dung lượng riêng, nên không gọi kiểm tra phía client là bảo vệ server.

Preset deadline_mate_pdf đã lưu Unsigned; Allowed formats=pdf còn chờ lưu/xác minh. Chưa có upload, metadata hay mở PDF thật. Link Cloudinary là bearer URL công khai; Rules của metadata không làm file riêng tư. Nếu upload thành công nhưng ghi metadata thất bại, có thể tồn tại asset mồ côi cần dọn thủ công vì unsigned client không có quyền xóa tùy ý.

FCM có handler foreground/background, initialMessage, tap routing và inbox. Payload kiểm tra owner_uid và target hợp lệ. Notification phải dùng nội dung demo chung vì hệ điều hành có thể hiển thị trước khi app kiểm tra owner. Chưa có bằng chứng đủ trạng thái nhận/tap. Không có backend lập lịch nhắc hạn tự động được tuyên bố trong phạm vi hiện tại.

## 4. Tính năng và ảnh thực tế

Các ảnh dưới đây đã có từ lượt chạy Android thật; chúng không bao phủ mọi tính năng và chưa được xác nhận ở 360×800 dp. Không thay thế bộ đối chiếu Figma.

| Tính năng | Bằng chứng hiện có | Phạm vi chưa chứng minh |
|---|---|---|
| Tạo môn | [Ảnh tạo môn](../assets/evidence/android-course-create-success.png) | Console data và hai tài khoản |
| Tạo deadline | [Ảnh chi tiết](../assets/evidence/android-deadline-created.png) | Offline/restart/second-client realtime |
| Sửa và hoàn thành | [Ảnh cập nhật](../assets/evidence/android-deadline-updated-completed.png) | Toàn bộ tổ hợp bộ lọc native |
| Xóa deadline demo | [Ảnh danh sách rỗng](../assets/evidence/android-deadline-deleted-empty.png) | Đây là trạng thái lịch sử trước khi tạo dữ liệu RC |
| Phiên học running/completed | [Running](../assets/evidence/android-study-running-calendar.png), [completed](../assets/evidence/android-study-completed-calendar.png) | Restart giữa phiên, transaction race |
| PDF/inbox/profile và toàn bộ màn hình khác | Chưa đủ bộ ảnh | Cần thu ảnh thật từng tính năng |

Phiên học demo kết thúc dưới một phút nên ghi nhận 0 phút thực tế; không sửa timestamp để tạo số liệu đẹp. Chi tiết các lượt fail/resume và kết quả thật ở [live-flow-results.md](live-flow-results.md).

## 5. Analytics, Crashlytics và Remote Config

Analytics có kế hoạch event/parameter trong [analytics-plan.md](analytics-plan.md): login/logout, screen_view, các thao tác deadline, export_pdf và start/complete_study_session. Không gửi title/email thành parameters. Chưa có DebugView receipt cho toàn bộ event; mã gọi logEvent không được coi là server đã nhận.

Crashlytics có handled-operation logging, global error handlers và nút test crash trong debug. Chưa có bằng chứng handled exception hoặc crash xuất hiện trên Console. Phải bổ sung receipt thực tế trước khi hoàn thiện mục này.

Hai hành vi Remote Config đã được kiểm chứng thật: enable_pdf_export true → false → true làm nút xuất đổi trạng thái và hiện/ẩn thông báo; dashboard_item_limit 5 → 2 → 5 làm số mục hiển thị thay đổi trên sáu deadline demo, trong khi tổng nguồn vẫn là sáu. Cấu hình server cuối được so toàn bộ JSON với baseline và khôi phục đúng. Ảnh và readback nằm trong [remote-config-demo.md](remote-config-demo.md). Ảnh dashboard restored cuối bị lỗi chụp vì emulator dừng, nên chỉ có assertion cho bước đó. Còn thiếu video/ảnh Console và kiểm thử defaults offline end-to-end.

## 6. Fidelity, thay đổi thiết kế và khả năng tiếp cận

Theme, components, ba luồng và navigation đã được đặc tả; các thay đổi có trong design-change-log.md. Widget tests có các trường hợp layout ở 360/412/800 dp. Những kiểm tra này không đủ để chứng minh mọi màn hình đạt fidelity hoặc accessibility. Cần Figma final frames, ảnh native cùng 360×800 dp, phép đo khác biệt, kiểm tra text scale, keyboard, TalkBack, tương phản và touch target. [fidelity-check.md](fidelity-check.md) còn là hồ sơ cần hoàn thiện.

## 7. Kiểm thử MobAI và AI review

Full Flutter suite gần nhất: 24 tests pass; flutter analyze --no-pub không có lỗi. APK đã build/cài thành công sau localization; bản sửa retry phiên học mới hơn chưa build/cài. Đây là kiểm thử state/widget và khả năng build, không thay thế E2E.

MobAI DSL đã ghi nhận login-gate smoke và các bước thao tác dữ liệu, gồm các lượt fail được giữ nguyên và lượt tiếp tục riêng. Chưa có mười .mob chạy sạch; test runner còn cần khởi tạo project. Healing và bài tập đưa bug vào để test bắt lỗi chưa hoàn tất. Không quy đổi các DSL pass thành mười bài .mob bắt buộc. Kịch bản/điều kiện ở live-verification-plan.md và kết quả thực tế ở test-report.md.

Review cục bộ đã tìm và sửa lỗi Provider scope của dialog, Android Back, xử lý query error, retry ID và Rules overwrite, cùng các phát hiện khác trong code-review.md. Chưa có GitHub remote/PR, external AI review hoặc merge. Phải dùng công cụ review theo đề, review cả firestore.rules, ghi vị trí/severity/quyết định sinh viên và bằng chứng fix thật. Các phát hiện cục bộ hiện có không được gắn nhãn là kết quả PR review.

## 8. AI hỗ trợ, khó khăn và bài học

Codex hỗ trợ đặc tả đề tài, xây mã MVVM, kiểm thử, chẩn đoán lỗi runtime và ghi tài liệu. implementation-ai-log.md ghi các tác nghiệp thật; nhiều lượt dựa trên cùng objective được tiếp tục tự động, chưa phải sáu prompt kỹ thuật độc lập do sinh viên nhập. Sinh viên cần đọc, hiểu và ghi quyết định của mình; không ký thay hoặc bịa chấp thuận.

Lỗi ProviderNotFound cho thấy dialog trên root Navigator có thể thoát phạm vi Provider của phiên. Regression được tái hiện trước khi sửa; đưa dialog về Navigator đúng phạm vi và chuyển Back bằng NavigatorPopHandler khắc phục hai vấn đề liên quan. Bài học là kiểm tra cả widget scope lẫn Back của Android, không chỉ nút trên AppBar.

Kotlin incremental compilation gặp cache khác ổ C/D; tắt incremental cho dự án giúp build thành công. Chuyển Cloudinary giúp theo lựa chọn không liên kết thanh toán, nhưng phải hiểu rõ unsigned upload, bearer URL và giới hạn cleanup. Remote Config cần đủ dữ liệu nguồn và đối chiếu hành vi, không chỉ hiển thị giá trị. Việc giữ log thất bại và ghi đúng phạm vi bằng chứng giúp tránh trình bày kiểm thử cục bộ như kết quả cloud đầy đủ.

Trước khi nộp còn phải hoàn thành PDF thật, các dịch vụ Console, đăng xuất/cách ly dữ liệu, Figma/accessibility, MobAI suite và hai bài tập, PR review/merge, quyết định sinh viên, bộ ảnh đầy đủ và video. Báo cáo này chỉ trở thành bản nộp sau khi bổ sung bằng chứng, dàn trang và kiểm tra bản render.
