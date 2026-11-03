# Remote Config — kiểm chứng hành vi thật

Vòng kiểm tra bắt đầu tối 03/11 và tiếp tục sau nửa đêm 04/11/2026 (Asia/Bangkok). Project deadline-mate-feff4; app Android đã đăng nhập. Không thay đổi production code trong vòng kiểm tra này.

## enable_pdf_export

Đã thực hiện và kiểm chứng chu trình true → false → true:

1. Báo cáo có nút Xuất báo cáo PDF enabled; assertion MobAI kiểm tra enabled=true. Log rc-export-enabled-before.json và ảnh android-rc-export-enabled-before.png.
2. Tải template server hiện tại ra file riêng, giữ nguyên các tham số/conditions. Chỉ đổi default enable_pdf_export thành false và deploy target remoteconfig, exit 0. Get lại xác nhận server=false.
3. Trong Profile bấm Tải cấu hình mới, app hiển thị enable_pdf_export:false và dashboard_item_limit:5. Chỉ giữ summary các dòng cấu hình trong rc-profile-disabled-summary.json; không đưa thông tin tài khoản vào artifact này.
4. Về Báo cáo: thấy thông báo Xuất PDF đang tắt theo cấu hình từ xa; assert nút disabled=true và không có cùng nút enabled=true. Log rc-export-disabled-live.json, ảnh android-rc-export-disabled.png.
5. Deploy lại template gốc rồi get server. So sánh JSON template lấy về với baseline đã lưu: khớp. Server enable_pdf_export=true.
6. Sau khoảng fetch tối thiểu, Profile refresh nhận true. Trở lại Báo cáo: assert export enabled và thông báo tắt không còn. Log rc-export-restored-live.json, summary rc-profile-restored-summary.json, ảnh android-rc-export-restored.png.

Các log ở assets/evidence/mobai. Summary Profile được ghi rõ là bản lọc; không trình bày nó như raw log đầy đủ. Raw local results nằm ngoài repository. Bộ ảnh Báo cáo không chứa email/name tài khoản.

Template ban đầu và template khôi phục chứa dashboard_item_limit=5, enable_pdf_export=true và study_banner mặc định. Không tuyên bố get response có version number vì CLI không xuất trường đó trong template.

## dashboard_item_limit

Đã kiểm chứng 5 → 2 → 5 trên sáu deadline tổng hợp RC Demo 1–6:

1. Seed qua app bằng create transaction và xác nhận detail cho từng title; 82/82 bước pass. Summary rc-seed-summary.json; script seed-rc-deadlines.json. Không replay script này mù vì sẽ sinh bản trùng.
2. Baseline limit=5: assert tổng 6 deadline chưa xong; scroll tới RC Demo 5, thấy mục 5 và không thấy 6. Summary rc-dashboard-five-before-summary.json; ảnh android-rc-dashboard-limit-five-before.png.
3. Publish chỉ dashboard_item_limit=2, giữ export=true; get server xác nhận. Profile refresh hiển thị 2/true, summary rc-profile-limit-two-summary.json.
4. Dashboard vẫn báo tổng 6, chỉ có RC Demo 1–2 và không có 3. Summary rc-dashboard-two-summary.json; ảnh android-rc-dashboard-limit-two.png. Dữ liệu nguồn không bị xóa khi giảm limit.
5. Deploy lại template baseline. Get server so sánh toàn bộ JSON khớp baseline. Sau interval tối thiểu, Profile refresh nhận 5/true; summary rc-profile-limit-five-restored-summary.json.
6. Trở lại Dashboard, assert tổng 6, thấy lại RC Demo 5 và không thấy 6. Summary rc-dashboard-five-restored-summary.json. Lệnh chụp ảnh restored cuối trả lỗi; kiểm tra ngay sau đó không còn adb device hoặc qemu process. Vì vậy **chưa có ảnh dashboard restored cuối**, không tính lệnh screenshot này là thành công. Log assertion trước khi emulator dừng vẫn được giữ.

Template public tải từ server trước/giữa/sau demo nằm ở assets/evidence/remote-config; restoration-check.json ghi SHA-256 thực tế của baseline và bản restore. Sáu deadline demo giữ lại cho bước PDF; phiên học completed trước đó vẫn giữ nguyên.

## Còn thiếu

Ảnh/video Console thay đổi giá trị, .mob scenarios và kiểm tra config defaults trong điều kiện mạng thật. Cả hai hành vi RC đã được kiểm tra bằng CLI publish/readback và app UI; chưa coi đó là đầy đủ hồ sơ Console/video. Unit tests của defaults không được coi là bằng chứng offline end-to-end.
