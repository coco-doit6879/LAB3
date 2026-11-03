# Kịch bản kiểm chứng trên dịch vụ thật

Đây là kế hoạch thực thi, chưa phải kết quả pass. Dùng tài khoản Google riêng cho test và dữ liệu tổng hợp. Không lưu credentials trong script/repository. Firestore/Rules và ba tham số Remote Config đã triển khai; xem backend-deployment.md.

## Thứ tự chạy và dữ liệu đầu vào

1. Hoàn tất Google login thủ công trong emulator; xác nhận Tổng quan rồi xem đúng user ở Authentication. Ghi UID riêng trong ghi chú test, không ghi password/OTP. Không tự động hóa form Google khi có hạn chế của công cụ.
2. Tạo môn `PRM393` / `Flutter và Firebase`. Tạo môn thứ hai `SWT301` / `Kiểm thử phần mềm` để kiểm tra lọc. Course IDs phải lấy từ dữ liệu được tạo thật, không giả định bằng mã môn.
3. Tạo deadline `LAB3 Demo A`, hạn ngày đang demo; tạo `LAB3 Demo B` cho môn thứ hai. Xác nhận title/course/due/status ở app và users/{uid}/deadlines trong Console. Thử title rỗng trước khi tạo để thu lỗi validation và chứng minh không sinh document.
4. Sửa A thành `LAB3 Demo A - updated`, hoàn thành, lọc status/course/search rồi clear. Dùng client thứ hai hoặc Console thay đổi một trường hợp demo và xác nhận listener đổi UI mà không mở lại app. Cuối cùng xóa một deadline demo sau xác nhận.
5. Từ Lịch học lập `Ôn LAB3 Demo`, 25 phút. Start → rời màn hình → quay lại → End → Học tiếp để kiểm tra cancel, sau đó End → Kết thúc. Kiểm tra status và timestamps/thời lượng ở app + Firestore. Có thể thu 0 phút thực tế nếu demo dưới một phút; không sửa timestamp để tạo kết quả đẹp.
6. Chọn bộ lọc deadline trước khi vào Báo cáo. Xuất PDF, theo dõi tiến trình, xác nhận thông báo thành công/history/open và metadata ownerId/provider/public ID trên Firestore. Mở file, kiểm tra tiếng Việt và nội dung đúng scope. Nếu Cloudinary preset chưa chỉ cho phép pdf hoặc URL không mở được, ghi fail và sửa trước khi tính pass.
7. Trong Profile xem Remote Config; publish dashboard limit khác và enable_pdf_export=false, chờ interval/fetch rồi xác minh thay đổi thật. Ghi hình cả Console và app. Trả cấu hình về giá trị dùng demo, refresh và kiểm chứng lần nữa. Nếu dữ liệu ít hơn limit, tạo đủ dữ liệu tổng hợp để quan sát thay đổi.
8. Theo fcm-demo.md gửi message có owner_uid/target đúng. Thu foreground, background/tap và app đóng/tap. Nội dung chung, không đưa thông tin riêng vào notification. Bằng chứng công khai phải ẩn token.
9. Bật Analytics DebugView cho package, thực hiện các trigger trong analytics-plan.md và kiểm tra parameter từng event. Profile ghi handled error, tạo test crash debug sau khi lưu công việc; mở lại để gửi report và xác nhận Console nhận. Không xem thao tác bấm nút là bằng chứng server đã nhận.
10. Sign out; kiểm tra Login và Back không vào route cũ. Đăng nhập tài khoản test thứ hai để kiểm tra dữ liệu riêng. Không dùng admin SDK/owner CLI để thay thế kiểm tra Security Rules của client.

## Mười bài MobAI bắt buộc

| Bài | Starting state cần ghi | Kết quả nhìn thấy cần assert |
|---|---|---|
| 01 Google login | Signed out, dedicated test account; bước Google có thể ghi manual nếu không được tự động hóa | Tổng quan sau login |
| 02 Flow 1 | Signed in, môn có sẵn, title demo riêng | Tạo → detail → completed xuất hiện trong list/detail |
| 03 Flow 2 | Signed in, không có session chạy trùng tên | Plan/start/end → completed, thời lượng hợp lệ |
| 04 Flow 3 | Signed in, scope dữ liệu được ghi rõ, preset/config sẵn sàng | Export → history/open → PDF đúng dữ liệu |
| 05 Recovery | Form đang tạo, nêu cách gây lỗi có thể lặp | Thấy lỗi, input giữ nguyên, sửa/thử lại thực sự thành công |
| 06 CRUD | Có môn, chưa có record trùng tên test | Create/edit/delete đều hiện đúng kết quả |
| 07 Navigation | Signed in, seed data xác định | Tổng quan/Deadline/Lịch học/Báo cáo có nội dung hoặc state đúng |
| 08 Profile/config | Signed in, RC published | Profile đúng tài khoản và RC values; hành vi khớp cấu hình |
| 09 PDF | Signed in, export enabled, dữ liệu demo | Upload/metadata xong, có open action hoạt động |
| 10 Logout | Signed in | Login, route cũ không truy cập được |

Mỗi bài cần một .mob được viết từ UI đã quan sát, chạy thật và lưu kết quả. Bảng này chưa phải 10 script hoặc 10 pass. Smoke DSL login trước đó chỉ là bổ sung.

Healing: đổi một label trên nhánh/bản build riêng → chạy test bị ảnh hưởng → giữ log fail → MobAI sửa locator → review diff và kết quả pass. Không bỏ assertion kết quả nghiệp vụ.

Bug-catching: làm save bỏ qua ghi dữ liệu trong bản demo lỗi riêng → test phải fail vì kết quả không tồn tại → phục hồi code đúng → rebuild/rerun pass. Không đưa defect vào bản nộp; giữ diff và log để giải thích.

## Hồ sơ cuối cùng

Thu ảnh thật từng màn hình ở 360×800 và kiểm tra thêm 412 dp; ghép với Figma final frames. Báo cáo chính yêu cầu khoảng 5–10 trang, v5 yêu cầu 8–12: dùng 8–10 trang nếu không có chỉ dẫn khác. Video chính 3–5 phút, v5 5–10: nhắm khoảng 5 phút, chưa khẳng định giảng viên chấp nhận cách xử lý này. Slides 12–15 theo v5. Chỉ điền kết quả đã có bằng chứng; Figma, MobAI runner, PR/AI review và quyết định sinh viên trong AI log vẫn phải hoàn thành thật.
