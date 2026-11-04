# Tiến độ Deadline Mate

Sinh viên: SE194007. Firebase project: deadline-mate-feff4. App hiển thị: Deadline Mate. Repository nộp: PRM393_Lab03_SE194007.

## Có mã nguồn

MVVM + Provider; Google authentication/auth gate; deadline CRUD/realtime/query; Courses; Dashboard; Calendar; Study sessions transaction; PDF generation/upload/history; Remote Config; FCM inbox và routing; Analytics events; Crashlytics handlers và demo controls. Course form chọn dữ liệu môn học thật. Không coi có mã là có bằng chứng chạy dịch vụ thật.

## Đã kiểm chứng

Trạng thái thiết bị gần nhất: sau khi hoàn tất assertions RC 5→2→5, emulator đã dừng (adb devices rỗng, không có qemu process); ảnh dashboard restored cuối chưa chụp được. Các ảnh trước đó và log pass đã lưu. Cần mở lại emulator cho bước kiểm thử tiếp theo; không coi dòng kiểm chứng lịch sử dưới đây là xác nhận thiết bị vẫn đang chạy.

- Flutter analyze: No issues found.
- 22 unit/widget tests pass, gồm navigation/card tại 360/412/800 dp, tìm kiếm và regression dialog/provider với Navigator lồng nhau.
- 18 Rules emulator tests pass: 11 Firestore và 7 Storage (project demo-deadlinemate).
- Đăng ký Android app trên Firebase project thật.
- Google provider Enabled đã xác minh trên Console; cấu hình mới có OAuth Android/web và SHA-1 khớp debug key của máy.
- APK debug build thành công sau khi tắt Kotlin incremental compilation để xử lý cache khác ổ C/D. Đã rebuild với config OAuth mới, cài và mở thành công; ảnh assets/evidence/android-login.png.
- Android emulator Pixel_4a đã khởi động, ADB thấy emulator-5554, sys.boot_completed=1.

## Còn phải hoàn thành và chứng minh

- Đã đăng nhập Google, tạo/list môn demo; Deadline CRUD/complete/cancel-delete và Study plan/start/finish/cancel đã chạy trên app Firebase thật. Xem live-flow-results.md; còn PDF, lỗi mạng, Console evidence, logout/isolation và suite .mob.
- Database thật đã tạo (Standard/freeTier, asia-southeast1) và Rules đã deploy; còn kiểm chứng cách ly giữa hai tài khoản và dữ liệu Console. Hai hành vi Remote Config đã có bằng chứng app phản ứng và khôi phục baseline; xem remote-config-demo.md.
- Đã chuyển adapter PDF sang Cloudinary theo lựa chọn sinh viên; preset Unsigned đã lưu. Còn lưu/xác minh Allowed formats=pdf, upload và mở PDF thật. Preset không hỗ trợ giới hạn dung lượng riêng; app kiểm tra 10 MiB trước HTTP.
- Hai hành vi Remote Config đã kiểm thử thật và khôi phục baseline (remote-config-demo.md). Còn ảnh/video Console, FCM các trạng thái, Analytics DebugView và Crashlytics handled/test crash.
- Đã kiểm thử Storage Rules và sửa lỗi ghi đè; còn đưa bằng chứng review vào PR thật.
- Figma/design LAB 2 cập nhật; đối chiếu từng màn hình, tokens/components và accessibility 360/412 dp.
- MobAI 10 scripts, full runs, healing và bug-catching; nếu thay ARTEMIS cần theo giảng viên.
- GitHub remote/PR review/merge; implementation-ai-log.md đã có sáu mục tác nghiệp từ yêu cầu thật, ghi rõ objective lặp lại và chưa có quyết định sinh viên; còn xác nhận/hoàn thiện log và report/slides/video.

Bài LAB chưa hoàn tất. Xem test-report.md để biết chính xác phạm vi kiểm chứng, không dùng unit tests thay bằng chứng E2E.


## Lịch sử các vòng trước (không phải trạng thái hiện tại)

Bản Cloudinary đã build thành công bằng `--no-pub --dart-define-from-file=config/cloudinary.json`, cài cập nhật vào emulator-5554 với kết quả Success và gửi lệnh mở MainActivity. Chưa có bằng chứng đăng nhập hay upload thật từ bản này. Tài liệu design-change-log.md và handoff-gaps.md đã được bổ sung, vẫn ghi rõ Figma và kiểm chứng cloud còn thiếu.

Đã sửa 5 phát hiện review cục bộ, ghi trong code-review.md; chưa thay thế review PR GitHub. 13 Flutter tests pass, analyze sạch và APK đã rebuild. MobAI CLI/bridge hoạt động, login-gate DSL pass 3/3; .mob runner còn lỗi test-project initialization. Log pass và log lỗi đều lưu nguyên trong assets/evidence/mobai. Chưa hoàn thành 10 E2E scripts.

## Cập nhật mã nguồn 2026-11-04

Đã cấu hình MaterialApp dùng tiếng Việt và localization delegates từ Flutter SDK để lịch/dialog không theo tiếng Anh của thiết bị. Full suite mới: 23 tests pass; analyze không có lỗi. Chưa build/cài bản sửa này và chưa có ảnh emulator tiếng Việt; APK đã cài trước đó vẫn là bản cũ. Các ảnh lịch tiếng Anh lịch sử không được thay bằng tuyên bố đã kiểm chứng native mới.

Cập nhật tiếp: APK tiếng Việt đã build, cài -r thành công và gửi lệnh mở MainActivity trên Pixel_4a sau khi boot hoàn tất. Hash và phạm vi bằng chứng ghi ở test-report.md. Chưa quan sát UI bản mới; không coi lệnh mở app là chứng minh màn hình/calendar đã hiển thị đúng.
