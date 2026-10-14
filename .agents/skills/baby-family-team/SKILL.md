---
name: baby-family-team
description: "Điều phối role và ghi lịch sử bắt buộc cho mọi task/câu hỏi trong repository Baby Family: backend, Flutter mobile, frontend, database, product analytics, PM, BA, design, QA và vận hành. Dùng cả khi giải thích, review, làm rõ hoặc nhận yêu cầu bổ sung; không áp dụng cho dự án khác."
---

# Baby Family team

## Bắt đầu mỗi yêu cầu

1. Xác định repository root chứa `AGENTS.md`, `SESSIONS.md`, `PRODUCT_ANALYTICS_HISTORY.md`. Mọi đường dẫn lịch sử trong skill đều tính từ root, dù đang làm trong thư mục con.
2. Đọc root `AGENTS.md`, các entry gần nhất và entry liên quan trong cả hai nhật ký. Tìm theo tính năng/mã BR/AC/mã yêu cầu thay vì đọc toàn bộ lịch sử dài. Đọc chỉ dẫn và nguồn sự thật tại thư mục đang tác động.
3. Đọc bảng định tuyến và hợp đồng các role cần dùng trong [roles.md](references/roles.md). Chọn một role chủ trì cùng role hỗ trợ/review theo tác động thực tế; `ORCHESTRATOR` tổng hợp xuyên suốt. Giải thích lựa chọn ngắn gọn cho người dùng.
4. Cấp mã cho **từng lượt hỏi/yêu cầu mới**, kể cả làm rõ và thay đổi giữa task; ghi entry ban đầu ở **cả hai nhật ký** theo [history-templates.md](references/history-templates.md). Chỉ tạo liên kết tới task gốc nếu là yêu cầu tiếp theo, không dùng lại mã cũ.

## Phân tích và giao việc

- Trước khi code, xác định mục tiêu người dùng, hiện trạng đã kiểm tra, yêu cầu/tiêu chí hoàn thành, phần bị tác động, ràng buộc kiến trúc, rủi ro thực tế và cách xác minh. Phân biệt điều đã biết với giả định. Mức chi tiết tương xứng với task.
- Với tính năng nghiệp vụ: `BA` làm rõ luồng/quy tắc/AC; `PRODUCT` hoặc `PM` tham gia khi có quyết định ưu tiên/phạm vi; `ARCHITECT` tham gia khi đổi hợp đồng hoặc thiết kế nhiều thành phần. Chọn role triển khai đúng nền tảng, thêm DBA/DESIGN/SECURITY_PRIVACY/DATA_ANALYST theo trigger trong catalog.
- Với task kỹ thuật hoặc câu hỏi: dùng role chuyên môn trực tiếp; không bắt BA/PM tham gia hình thức nếu không có quyết định nghiệp vụ.
- Khi có phần độc lập hữu ích, dùng công cụ sub-agent sẵn có để giao phân tích, triển khai hoặc review song song. Giao rõ role, mục tiêu, file được sửa, tiêu chí, đầu ra và phụ thuộc. Không tạo chat/task riêng bằng `create_thread` chỉ để mô phỏng role.
- Chia quyền sửa file để tránh xung đột; agent chính giữ quyền ghi nhật ký. Agent triển khai có thể không là reviewer độc lập của chính thay đổi đó. Dùng reviewer khác cho thay đổi có ý nghĩa khi công cụ cho phép.
- Nếu không có sub-agent, áp dụng tuần tự các góc nhìn cần thiết và ghi đúng là tự review; không tuyên bố có review độc lập. Tên role là hợp đồng trách nhiệm, không phải bảo đảm đã có người/agent riêng chạy.
- Khi có câu hỏi mới giữa task, ghi mã mới, đánh giá lại scope/role và tiếp tục mục tiêu cũ trừ khi người dùng hủy/thay thế rõ ràng. Không coi thời gian chờ là sự chấp thuận.

## Triển khai và xác minh

- Bảo toàn backend OOP/DI theo `baby-backend/AGENTS.md`; không chuyển sang functional/feature architecture khi chưa được yêu cầu. Giữ toàn bộ quy tắc Flutter trong chỉ dẫn/skills mobile.
- Không giả định frontend/storage/database tools đã được cài vì có thư mục. Kiểm tra code và cấu hình trước khi chọn framework, SDK hoặc migration.
- Khi tác động database, migration, repository, generator hoặc cron/job, đọc và áp dụng [database-standards.md](references/database-standards.md): mọi bảng dự án bắt buộc có `created_at`, `updated_at`, `deleted_at`; kiểm tra cả soft delete, timestamp của mọi writer và lịch sử/recovery của job.
- Khi thiết kế hoặc thay đổi backend/frontend/mobile/database và contract, đọc [extensibility-standards.md](references/extensibility-standards.md). Bắt buộc phân biệt catalog/config với logic, giữ version/compatibility và kiểm tra mở rộng; không fix cứng gói/quota/trial trong nhiều nơi.
- Mỗi role trả về: phát hiện có căn cứ, đề xuất/việc đã làm, file/tài liệu liên quan, kiểm tra thực sự chạy + kết quả, vấn đề còn lại và người nhận bàn giao. Hợp nhất quyết định giữa các role trước khi kết luận.
- `TESTER` kiểm tra luồng chính, lỗi và edge case liên quan. `QUALITY` đối chiếu diff với yêu cầu và kiến trúc, tránh thay đổi thừa, xác nhận kết quả có bằng chứng. Nếu yêu cầu chỉ giải thích/tài liệu, kiểm tra nguồn, link, ví dụ và tính nhất quán thay cho runtime test.

## Đóng task

1. Tổng hợp kết quả các role; xử lý lỗi trong phạm vi đã giao. Nêu rõ phần chưa xác minh hoặc phụ thuộc chưa có.
2. Cập nhật kết quả và ngày/giờ thực tế trong **SESSIONS.md** cho từng mã liên quan. Ghi lệnh kiểm tra nếu đã chạy, nguồn/code nếu là giải thích; không biến kiểm tra cũ thành kiểm tra mới.
3. Cập nhật **PRODUCT_ANALYTICS_HISTORY.md** cùng mã: quyết định, tác động, quan sát, giả thuyết, cách đo, trạng thái đo. Không tự tạo tracking/SDK hoặc tuyên bố cải thiện metric chỉ vì sửa code.
4. Task mobile: cập nhật thêm `baby-family-app/SESSION.md` bằng tóm tắt và mã chung; giữ lịch sử cũ.
5. Rà lại hai file có đủ mọi câu hỏi mới, không trùng mã, không thiếu ngày, không lộ secrets và không ghi quá phạm vi bằng chứng. Chỉ đánh dấu hoàn thành khi phần được giao thực sự hoàn tất.
6. Trả lời tiếng Việt, dẫn file kết quả, kiểm tra chính và giới hạn còn lại. Không yêu cầu người dùng nhắc lại việc ghi nhật ký.
