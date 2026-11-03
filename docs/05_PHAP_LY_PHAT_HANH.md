# Pháp lý & chuẩn bị phát hành — BF-20261028-001

> Bản nháp kỹ thuật để soạn chính sách quyền riêng tư, điều khoản và khai báo Store.
> **Không phải văn bản pháp lý.** Nội dung chính sách/điều khoản cần người phụ trách
> pháp lý của dự án soạn và duyệt. Mọi mục "Cần quyết định" bên dưới chưa được chốt.

## 1. Dữ liệu app thu thập (đối chiếu code hiện tại)

| Nhóm | Ví dụ | Mục đích | Liên kết người dùng | Theo dõi/quảng cáo |
| --- | --- | --- | --- | --- |
| Tên | Tên hiển thị, nhãn gọi trong gia đình, tên bé | Vận hành tính năng | Có | Không |
| Số điện thoại | Đăng nhập OTP, đổi số | Đăng nhập, bảo mật | Có | Không |
| Email | Email từ Apple/Google (che khi hiển thị), email hỗ trợ | Đăng nhập, hỗ trợ | Có | Không |
| Ảnh/video | Ký ức, ảnh đại diện, ảnh tháng (nén trên máy, tải thẳng S3) | Vận hành tính năng | Có | Không |
| Âm thanh | Ký ức giọng nói | Vận hành tính năng | Có | Không |
| Nội dung người dùng | Ký ức, bình luận, Papa & Mama (check-in/câu hỏi mã hoá AES-256-GCM), báo cáo | Vận hành tính năng | Có | Không |
| ID người dùng | ID tài khoản/gia đình | Vận hành tính năng | Có | Không |
| ID thiết bị | Token đẩy FCM/APNs, phiên đăng nhập theo thiết bị | Thông báo, bảo mật | Có | Không |
| Lịch sử mua | Giao dịch IAP (xác minh receipt trên server) | Gói dịch vụ | Có | Không |

- Log server/metrics/báo lỗi chỉ ghi metadata (route, status, mã lỗi, tên job) — không ghi nội dung, body, header, userId hay dữ liệu trẻ (`baby-backend/docs/observability.md`).
- App không dùng SDK quảng cáo/analytics bên thứ ba ở thời điểm viết.
- AI 1.2 (BF-20261028-010): khi người dùng bấm và đã đồng ý, backend gửi phần văn bản tối thiểu (vài từ gõ / chú thích ký ức đã chọn / câu cần viết lại / ý đã chia sẻ trong Cầu nối) tới **OpenRouter** (và model bên thứ ba nó định tuyến). Không gửi ảnh, nhật ký riêng, nháp riêng. Cần ghi OpenRouter vào danh sách bên xử lý dữ liệu của chính sách quyền riêng tư; với `openrouter/free`, chính sách lưu dữ liệu của từng model miễn phí có thể khác nhau — cần kiểm tra trước khi phát hành.

## 2. Quyền dữ liệu đã có trong sản phẩm

- Xoá tài khoản trong app (SET-09, chờ 30 ngày, có huỷ), xoá gia đình cần cả hai Parent (§7.25).
- Xuất dữ liệu (SET-08), không khoá ký ức khi hết hạn gói (P9, C-08 giữ ~12 tháng có báo trước).
- Liên kết/gỡ Apple/Google, đổi số điện thoại cần xác thực lại.
- Đường dẫn pháp lý cấu hình bằng env backend `LEGAL_TERMS_URL`, `LEGAL_PRIVACY_URL`, `LEGAL_LICENSES_URL` (chưa đặt → app ẩn dòng tương ứng).

## 3. iOS Privacy Manifest

- `baby-family-app/ios/Runner/PrivacyInfo.xcprivacy` (đã thêm vào target Runner, Copy Bundle Resources): `NSPrivacyTracking = false`, khai các loại dữ liệu ở mục 1, mục đích App Functionality.
- `NSPrivacyAccessedAPITypes` của app để trống vì code Swift của app không gọi required-reason API; Flutter engine/plugin tự kèm manifest. Trước khi nộp: build Archive, chạy *Generate Privacy Report* trong Xcode và đối chiếu.
- Chưa build iOS được trên máy hiện tại (Flutter 3.44.5 + Xcode 27.1 lỗi `lipo -verify_arch`).

## 4. Google Play Data safety (đề xuất điền)

Thu thập: các nhóm ở mục 1; chia sẻ với bên thứ ba: không (nhà cung cấp hạ tầng là bên xử lý); mã hoá khi truyền: có (HTTPS); người dùng yêu cầu xoá được: có (trong app).

## 5. Phân loại độ tuổi

Đề xuất: app dành cho **phụ huynh/người lớn** (không phải app cho trẻ em), không có nội dung nhạy cảm; có nội dung do người dùng tạo trong nhóm gia đình kín và có báo cáo/chặn. Apple 4+ / Play "Everyone" kèm khai báo UGC — **cần quyết định**.

## 6. Cần quyết định trước khi phát hành

1. Ai soạn/duyệt chính sách quyền riêng tư và điều khoản; URL công khai đặt ở đâu.
2. Đối tượng mục tiêu và độ tuổi tối thiểu tạo tài khoản; có tham gia "Designed for Families" không.
3. Pháp nhân phát hành, email/hotline hỗ trợ công khai (`SUPPORT_CONTACT_*`).
4. Vùng lưu trữ dữ liệu (S3/PostgreSQL) và danh sách bên xử lý dữ liệu để ghi vào chính sách.
