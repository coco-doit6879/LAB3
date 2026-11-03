# Nhật ký triển khai có hỗ trợ AI

Sinh viên: SE194007. Ứng dụng: Deadline Mate. Công cụ AI: Codex trong cuộc trò chuyện này. Ngày thực hiện các mục dưới đây: 03/11/2026. Không có bằng chứng sử dụng Copilot/CodeRabbit trong editor hoặc PR; không ghi các công cụ đó là đã dùng.

## Nguồn prompt và giới hạn của nhật ký

Sinh viên đặt một mục tiêu chung. Codex tiếp tục tự động qua nhiều lượt, nhận lại nguyên văn objective này. Các mục 2–6 ghi đúng cùng objective, **không phải sáu prompt kỹ thuật khác nhau do sinh viên đã viết**. Bối cảnh từng lượt gồm file LAB, lựa chọn trước đó, mã nguồn và kết quả công cụ. Không dựng lại những prompt chi tiết chưa từng tồn tại.

Đây là nhật ký tác nghiệp của AI dựa trên yêu cầu và commit thật. Quyết định của agent không đồng nghĩa sinh viên đã đọc, hiểu và chấp nhận. Trường quyết định sinh viên đang chờ xác nhận; nhật ký chưa hoàn chỉnh cho bản nộp cuối. Nếu giảng viên yêu cầu sáu prompt kỹ thuật riêng, cần thực hiện những lượt hướng dẫn/kiểm chứng thật tiếp theo và bổ sung nguyên văn, không đổi lời nhắc chung thành các prompt giả.

## 1. Chuyển lưu PDF sang Cloudinary

Prompt/định hướng nguyên văn của sinh viên khi chọn phương án:

> Cloudinary — ưu tiên không liên kết thanh toán

Đầu ra: CloudinaryFileStorage dùng unsigned multipart raw upload; public build config cloud name/preset; Firestore lưu URL, public ID và storageProvider sau upload. Không có API secret trong app. Trace: commit `55b135f`.

Kiểm chứng thực tế: test multipart/no-secret, lỗi HTTP/URL, cấu hình thiếu; suite tại commit có 19 Flutter tests pass và 18 Rules tests pass sau phần responsive đi kèm. Live upload chưa chạy. Đã ghi rõ link công khai và khả năng asset mồ côi khi metadata thất bại.

Quyết định agent: chấp nhận lựa chọn provider, giới hạn phạm vi ở unsigned upload và metadata; không tự bật billing. **Quyết định sinh viên: chờ đọc/giải thích/chấp nhận, sửa hoặc bỏ cùng lý do.**

## 2. Token theme và bố cục thích ứng

Prompt objective được chuyển nguyên văn vào lượt tiếp tục:

> bạn xem giúp tôi yêu cầu của LAB 3 và có thể làm giúp tôi 1 cách chuẩn chỉ nhất có thể có các bước đúng như giảng viên yêu cầu đọc hết qua tất cả các file có trong đó và làm giúp tôi nhé

Đầu ra: AppTheme định nghĩa màu/typography/radius/target; DeadlineCard dùng chung; AppNavigation chuyển bottom bar sang rail từ 600 dp và giới hạn nội dung 640 dp. Trace: `55b135f`.

Kiểm chứng thực tế: analyze sạch; 19 test pass, gồm navigation/card với tiêu đề dài ở 360/412/800 dp; APK build và cài thành công. Tính contrast từ token cho các cặp đã ghi trong fidelity-check.md. Chưa đối chiếu Figma hoặc đo đầy đủ màn hình Android.

Quyết định agent: giữ các token theo đặc tả mới và dùng control Material cho state nền tảng; không nhận là đã giống Figma. **Quyết định sinh viên: chờ xác nhận và lý do.**

## 3. Tìm kiếm và lọc deadline

Prompt objective nguyên văn:

> bạn xem giúp tôi yêu cầu của LAB 3 và có thể làm giúp tôi 1 cách chuẩn chỉ nhất có thể có các bước đúng như giảng viên yêu cầu đọc hết qua tất cả các file có trong đó và làm giúp tôi nhé

Đầu ra: kết hợp tìm title, course và status ở DeadlinesViewModel; course options lấy từ repository thật; reset khi không có kết quả; controls cùng vùng cuộn. Trace: `98168bc`.

Kiểm chứng thực tế: 21 tests pass, analyze sạch, APK build/cài thành công. Ca mới kiểm tra filter intersection, cập nhật stream giữ bộ lọc, reset không mất nguồn; widget 360×800 với keyboard inset 280 px kiểm tra phục hồi. Repository trong test là fake, chưa chứng minh cloud CRUD.

Quyết định agent: bổ sung phần đã có trong handoff nhưng thiếu trong UI; giữ query Firestore orderBy dueAt và lọc client trên dữ liệu theo UID. **Quyết định sinh viên: chờ xác nhận và lý do.**

## 4. Sửa kết quả cuối luồng deadline và phiên học

Prompt objective nguyên văn:

> bạn xem giúp tôi yêu cầu của LAB 3 và có thể làm giúp tôi 1 cách chuẩn chỉ nhất có thể có các bước đúng như giảng viên yêu cầu đọc hết qua tất cả các file có trong đó và làm giúp tôi nhé

Đầu ra: tạo mới mở detail bằng pushReplacement; edit vẫn pop về detail cũ; Calendar hiển thị trạng thái và phút thực tế khi session completed. Viết architecture.md theo mã nguồn. Trace: `66bb348`.

Kiểm chứng thực tế: mở rộng case form failed-save → retry thành công với snapshot giả, thấy Chi tiết deadline và Sửa deadline; full suite 21 pass, analyze sạch, APK build thành công. Chưa có video luồng cloud. Thời lượng dùng timestamp, không dùng số lần rebuild.

Quyết định agent: sửa mã theo flow đã viết, không đổi đặc tả để hợp thức hóa hành vi sai. **Quyết định sinh viên: chờ xác nhận và lý do.**

## 5. Thư viện component và trạng thái phục hồi

Prompt objective nguyên văn:

> bạn xem giúp tôi yêu cầu của LAB 3 và có thể làm giúp tôi 1 cách chuẩn chỉ nhất có thể có các bước đúng như giảng viên yêu cầu đọc hết qua tất cả các file có trong đó và làm giúp tôi nhé

Đầu ra: AppButton/AppField/AppTopBar/AppDialog dùng trên các screen; LoadingState/EmptyState/ErrorState qua StatusPanel; loading khóa callback và hiện spinner. components.md ghi mapping và ngoại lệ. Trace: `9c6a60d`.

Kiểm chứng thực tế: full suite 21 pass sau tích hợp, analyze sạch; APK build và cài Success. Tìm mã xác nhận screen đã dùng wrapper tương ứng. Chưa kiểm tra mọi focus/pressed/disabled state bằng ảnh hoặc TalkBack.

Quyết định agent: dùng native Material control bên trong wrapper để giữ validation và semantics; giữ các loại control khác như dropdown/date picker/nút phụ và ghi ngoại lệ. **Quyết định sinh viên: chờ xác nhận và lý do.**

## 6. Triển khai Firestore và Remote Config thật

Prompt objective nguyên văn, tiếp tục trong bối cảnh sinh viên vừa hoàn tất Firebase CLI login:

> bạn xem giúp tôi yêu cầu của LAB 3 và có thể làm giúp tôi 1 cách chuẩn chỉ nhất có thể có các bước đúng như giảng viên yêu cầu đọc hết qua tất cả các file có trong đó và làm giúp tôi nhé

Đầu ra: cấu hình default database asia-southeast1; deploy chỉ firestore:rules; template Remote Config gồm dashboard_item_limit, enable_pdf_export, study_banner; triển khai target remoteconfig. Trace: `7656b53`.

Kiểm chứng thực tế: CLI ban đầu báo API disabled; deploy bật API/tạo database/compile và release Rules, exit 0. Get database xác nhận Standard/freeTier đúng region. Remote Config trước deploy `{}`, sau deploy tải lại đúng ba giá trị và kiểu. Không bật billing. Chưa đăng nhập Google trong app, chưa chứng minh CRUD hay RC thay đổi hành vi.

Quyết định agent: triển khai các target cần cho LAB trên project đã được sinh viên cung cấp; giữ Cloudinary làm storage. **Quyết định sinh viên: chờ xác nhận và lý do.**

## Việc sinh viên cần hoàn tất thật

Với từng mục, đọc các file được nhắc, chạy/quan sát luồng liên quan và bổ sung quyết định chấp nhận/sửa/bỏ có lý do. Ghi những gì thực sự đã hiểu hoặc chưa hiểu; giữ kết quả lỗi và giới hạn kiểm chứng. Khi chạy các dịch vụ, MobAI, healing, bug-catching và PR review, thêm prompt/kết quả nguyên văn mới theo diễn biến thật. Không thay các trường đang chờ bằng câu xác nhận hộ sinh viên.
