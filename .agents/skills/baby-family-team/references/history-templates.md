# Mẫu lịch sử bắt buộc

## Mã, ngày và quyền ghi

- Hai file chuẩn ở repository root: `SESSIONS.md` và `PRODUCT_ANALYTICS_HISTORY.md`.
- Mỗi câu hỏi/yêu cầu mới dùng `BF-YYYYMMDD-NNN`, ngày cấp mã theo `Asia/Ho_Chi_Minh`. Lấy số tiếp theo chưa dùng từ **cả hai file**, không reset theo chat. Mỗi mã có đúng một entry ở mỗi file; khi nhiều chat cùng chạy, đọc lại mã ngay trước khi ghi và xử lý xung đột, không ghi đè.
- Ghi ngày làm bắt buộc, ưu tiên giờ ISO 8601 có `+07:00`, ví dụ `2026-10-11T09:00:00+07:00`. Chỉ ghi giờ có nguồn thực tế. Ghi bù lịch sử phải nêu ngày ghi bù, nguồn và phần không biết; không đoán ngày/giờ làm trước đó.
- Mỗi task có một agent chính sở hữu việc ghi. Sub-agent báo kết quả về. Câu hỏi tiếp theo có mã mới và trường `Liên quan` trỏ mã trước; một câu hỏi có nhiều đầu việc vẫn có thể dùng chung mã.
- Thêm entry theo thứ tự cấp mã. Trong entry đang làm được cập nhật trạng thái/kết quả; sau khi hoàn thành, mọi đính chính phải ghi ngày và lý do, giữ thông tin quyết định cũ có ý nghĩa. Không xóa/đổi mã hoặc viết lại lịch sử như thể đã biết từ đầu.
- Nếu bị gián đoạn: giữ `Đang thực hiện`, ghi phần đã làm và việc tiếp theo khi có thể. Nếu một file ghi lỗi, sửa đồng bộ hai file trước bàn giao; không tạo entry trùng để lấp lỗi.
- Chỉ lưu tóm tắt yêu cầu và phân tích có thể chia sẻ. Che secrets/PII trong câu hỏi, lệnh và đầu ra. Không lưu chain-of-thought, bản dump log dài hoặc dữ liệu của trẻ/gia đình.

## SESSIONS.md

```markdown
<a id="bf-yyyymmdd-nnn"></a>
## BF-YYYYMMDD-NNN — Tiêu đề yêu cầu

- Ngày làm: YYYY-MM-DDTHH:mm:ss+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: Tóm tắt đầy đủ câu hỏi/yêu cầu; có thể trích nguyên văn nếu không chứa dữ liệu nhạy cảm.
- Liên quan: Mã trước hoặc Không.
- Role: Chủ trì ROLE; hỗ trợ ROLE; review ROLE. Nêu sub-agent độc lập hay góc nhìn do agent chính áp dụng.
- Trạng thái: Đang thực hiện / Hoàn thành / Chưa hoàn tất / Chờ thông tin.
- Phân tích: Hiện trạng, yêu cầu/AC, lựa chọn và lý do tóm tắt, tác động/edge case đáng chú ý.
- Kết quả: Việc đã thực hiện hoặc câu trả lời/kết luận có căn cứ; dẫn file phù hợp.
- Kiểm chứng: Lệnh/nguồn và kết quả thực tế; ghi rõ không chạy/chưa kiểm tra nếu có.
- Còn lại: Việc tiếp theo, giới hạn hoặc Không trong phạm vi yêu cầu.
- Product history: [BF-YYYYMMDD-NNN](PRODUCT_ANALYTICS_HISTORY.md#bf-yyyymmdd-nnn).
```

Dùng anchor HTML `<a id="bf-yyyymmdd-nnn"></a>` ngay trước heading ở cả hai file để link không phụ thuộc tiêu đề. Khi ghi bù, thêm dòng `Nguồn ghi bù` và ghi rõ vai trò chỉ là phân loại hồi cứu nếu trước đó chưa có role log.

## PRODUCT_ANALYTICS_HISTORY.md

```markdown
<a id="bf-yyyymmdd-nnn"></a>
## BF-YYYYMMDD-NNN — Tiêu đề quyết định/phân tích

- Ngày làm: YYYY-MM-DDTHH:mm:ss+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: Tóm tắt cùng yêu cầu trong SESSIONS.md.
- Role: Role thực sự tham gia phân tích sản phẩm/dữ liệu/kỹ thuật.
- Vấn đề / mục tiêu: Người dùng/luồng chịu tác động và kết quả cần đạt.
- Quan sát: Sự thật có nguồn từ code, đặc tả, yêu cầu hoặc dữ liệu; phân biệt với giả định.
- Phân tích / quyết định: Quyết định, cơ sở, yêu cầu/BR/AC liên quan nếu có.
- Tác động: Hành vi sản phẩm, UX, API/dữ liệu, quyền riêng tư hoặc vận hành; ghi Không đổi hành vi sản phẩm khi phù hợp.
- Giả thuyết / đo lường: Giả thuyết nếu có; metric/event/định nghĩa và cách xác minh nếu task cần. Ghi Chưa có dữ liệu đo; không thêm tracking cho task không yêu cầu.
- Kết quả / trạng thái: Thực tế đã triển khai/đã giải thích/chưa hoàn tất; không suy ra metric cải thiện từ kiểm thử.
- Theo dõi: Việc còn lại hoặc Không trong phạm vi yêu cầu.
- Session: [BF-YYYYMMDD-NNN](SESSIONS.md#bf-yyyymmdd-nnn).
```

## Kiểm tra trước câu trả lời cuối

1. Mọi câu hỏi mới có entry ở **cả hai file**, cùng mã, ngày làm và yêu cầu; không trùng mã trong cùng file.
2. Role, phân tích, kết quả và bằng chứng được ghi đủ; trạng thái đúng với thực tế. Mọi link local/anchor được kiểm tra khi tạo mới.
3. Phân biệt `đã quan sát`, `giả thuyết`, `chưa đo`; không dùng số liệu giả để lấp template. Task kỹ thuật vẫn có entry product, với tác động và trạng thái đo rõ ràng.
4. Không sửa log ngoài phạm vi yêu cầu, không ghi secrets; mobile giữ cập nhật SESSION cũ với mã tham chiếu.
