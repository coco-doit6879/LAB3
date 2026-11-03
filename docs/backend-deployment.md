# Triển khai backend thật

Ngày 03/11/2026. Project `deadline-mate-feff4`. Đây là kết quả CLI thật, chưa thay thế các ảnh Console hoặc chứng minh luồng app đã đăng nhập.

## Firestore

Sau khi sinh viên đăng nhập Firebase CLI, truy vấn database ban đầu trả HTTP 403 vì Firestore API chưa bật. Firebase deploy đã bật API, tạo database mặc định và compile/release Rules thành công:

```powershell
firebase deploy --only firestore:rules --project deadline-mate-feff4 --non-interactive
```

CLI kết thúc exit code 0, `rules file firebase/firestore.rules compiled successfully`, `released rules ... to cloud.firestore`, `Deploy complete!`.

Truy vấn lại `firestore:databases:get '(default)' --project deadline-mate-feff4 --json` trả:

| Thuộc tính | Kết quả server |
|---|---|
| database | projects/deadline-mate-feff4/databases/(default) |
| locationId | asia-southeast1 |
| type | FIRESTORE_NATIVE |
| databaseEdition | STANDARD |
| freeTier | true |
| createTime | 2026-11-03T16:23:41.361252Z |

Rules tại lần deploy có SHA-256 `13935315009FCCE9D87BCB206D23F61A6F744B92B200E7AC8FF7759137EF391E`. Bộ Rules này đã có 11 Firestore emulator tests pass trước deploy. Chưa có kiểm thử đọc/ghi bằng Firebase UID trên database thật; deploy thành công không chứng minh CRUD thành công.

## Remote Config

Template tải về trước deploy là `{}`. Ba tham số trong `firebase/remoteconfig.template.json` đã được publish bằng deploy chỉ target remoteconfig, exit code 0. Tải lại từ server xác nhận:

| Tên | Kiểu | Giá trị |
|---|---|---|
| dashboard_item_limit | NUMBER | 5 |
| enable_pdf_export | BOOLEAN | true |
| study_banner | STRING | Một việc mỗi lúc. Một bước gần mục tiêu hơn. |

Firebase CLI get xuất template không kèm version number trong kết quả này; không suy đoán số phiên bản. Còn phải refresh trong Profile và chứng minh đổi giá trị thật làm thay đổi dashboard/export. Khi chỉnh cấu hình về sau, tải template hiện tại và giữ các tham số/conditions khác thay vì ghi đè mù.

## Các bước xác minh còn lại

1. Đăng nhập Google bằng tài khoản test trên app Android; kiểm tra user xuất hiện ở Authentication.
2. Tạo môn và deadline trong app, xem đúng đường dẫn users/{uid}/deadlines trên Firestore Console; sửa, hoàn thành, xóa và kiểm tra realtime.
3. Plan/start/finish phiên học; tạo PDF qua Cloudinary và mở URL; thử lỗi và phục hồi.
4. Kiểm tra Remote Config trong Profile; đổi limit/export và ghi lại hành vi thật trước/sau, sau đó trả cấu hình demo về giá trị mong muốn.
5. Thu bằng chứng FCM, Analytics DebugView và Crashlytics; triển khai Rules không tạo ra các bằng chứng này.

Không bật billing hoặc triển khai Firebase Storage trong các lệnh trên. Cloudinary tiếp tục là adapter PDF.
