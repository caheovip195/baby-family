# Baby Family — quy tắc làm việc của agent

## Bắt buộc cho mọi yêu cầu

- Trả lời bằng tiếng Việt. Chỉ làm trong phạm vi người dùng giao; giữ nguyên thay đổi đang có của người dùng.
- Trước khi phân tích hoặc thực hiện **mỗi câu hỏi/task**, đọc [baby-family-team](.agents/skills/baby-family-team/SKILL.md), chọn các role liên quan từ [catalog](.agents/skills/baby-family-team/references/roles.md), và đọc lịch sử gần nhất/liên quan trong hai file bên dưới. Áp dụng cả với câu hỏi giải thích, review, làm rõ và yêu cầu bổ sung giữa lúc đang làm.
- Đọc `AGENTS.md` của thư mục bị tác động và các skill/tài liệu mà nó yêu cầu. Quy tắc chung này áp dụng cho mọi thư mục con; quy tắc kiến trúc riêng vẫn có hiệu lực. Chỉ dẫn trực tiếp mới nhất của người dùng được ưu tiên khi có xung đột.
- Agent chính đóng vai `ORCHESTRATOR`: xác định role chủ trì, role hỗ trợ/review, phạm vi, tiêu chí hoàn thành và các điểm cần xác minh. Task có nhiều phần độc lập thì giao sub-agent theo role để phân tích sâu song song khi công cụ cho phép; mỗi agent có phạm vi file rõ ràng. Task nhỏ có thể áp dụng góc nhìn role trực tiếp, không cần tạo cả đội.
- Ghi ngắn gọn các role đang dùng và mục đích trong cập nhật tiến độ. Không gọi tất cả role cho mọi task. Khi phạm vi đổi, đánh giá lại role.

## Hai nhật ký bắt buộc

1. [SESSIONS.md](SESSIONS.md): **mỗi câu hỏi/yêu cầu của người dùng** có một entry riêng gồm mã yêu cầu, ngày làm, câu hỏi, role, phân tích tóm tắt, kết quả, bằng chứng kiểm tra và việc còn lại.
2. [PRODUCT_ANALYTICS_HISTORY.md](PRODUCT_ANALYTICS_HISTORY.md): entry cùng mã cho **mỗi yêu cầu**, ghi vấn đề/mục tiêu, tác động sản phẩm/dữ liệu, quyết định và cơ sở, cách kiểm chứng/đo lường, kết quả và việc cần theo dõi. Task thuần kỹ thuật ghi rõ nếu không đổi hành vi sản phẩm và chưa có dữ liệu đo.

- Dùng [mẫu và quy tắc ghi](.agents/skills/baby-family-team/references/history-templates.md). Ngày/giờ theo `Asia/Ho_Chi_Minh` (`UTC+07:00`); không tự đoán thời gian lịch sử.
- Khi bắt đầu, tạo entry trạng thái `Đang thực hiện` cho từng yêu cầu mới trong **cả hai file**. Trước câu trả lời cuối, cập nhật entry với kết quả thực tế và trạng thái đúng. Task chưa xong phải ghi phần chưa xong.
- Agent chính là **người ghi duy nhất** hai nhật ký trong một task; sub-agent gửi kết quả về, không tự ghi. Mã đã cấp không đổi; giữ entry cũ và đánh dấu rõ ghi bù/đính chính. Không gộp mất câu hỏi tiếp theo của người dùng.
- Không ghi secrets, dữ liệu cá nhân của trẻ/gia đình, suy nghĩ nội bộ từng bước, số liệu bịa hoặc tuyên bố test/review chưa thực hiện. Ghi lập luận tóm tắt, quyết định và bằng chứng đủ để bảo trì.
- `SESSION.md` số ít là lịch sử cũ, không thay thế `SESSIONS.md`. Giữ lịch sử cũ; task mobile còn phải cập nhật `baby-family-app/SESSION.md` theo hướng dẫn tại đó, tham chiếu mã yêu cầu chung.

## Bối cảnh và kiến trúc cần giữ

- [Đặc tả nghiệp vụ](docs/01_DAC_TA_NGHIEP_VU_BABY_FAMILY_v3.md), [tài liệu kỹ thuật](docs/02_TAI_LIEU_KY_THUAT_BABY_FAMILY_v3.md): đọc đúng phần liên quan; đối chiếu với quyết định mới nhất của người dùng và code thực tế. Không coi tính năng ghi trong đặc tả là đã được triển khai.
- Backend: [baby-backend/AGENTS.md](baby-backend/AGENTS.md). TypeScript, NestJS, Prisma/PostgreSQL; `controller → service → repository → model`, interface service/repository và DI. Nghiệp vụ ở service, CRUD ở repository, model là thuộc tính và helper. Giữ cấu trúc thư mục theo role.
- Mobile: [baby-family-app/AGENTS.md](baby-family-app/AGENTS.md). Flutter; đọc `.skills/index.md` và **toàn bộ skill được liệt kê**, cùng `SESSION.md` tại đó trước task mobile. Giữ luồng Page → Controller → Service → Repository → API/LocalStore, l10n và Design System.
- `baby-admin/`, `baby-database/`, `baby-storage/`: kiểm tra hiện trạng trước khi chọn công nghệ hoặc tạo cấu trúc. Thiết kế hiện có ở `desgin/`; không tự đổi tên thư mục.

## Kiểm tra trước khi bàn giao

- `TESTER` xác minh hành vi và edge case phù hợp; `QUALITY` kiểm tra diff, kiến trúc, tiêu chí hoàn thành và tính trung thực của bằng chứng. Task tài liệu/giải thích dùng kiểm tra tương ứng, không chạy bộ test không liên quan chỉ để đủ thủ tục.
- Đối chiếu mã yêu cầu giữa hai nhật ký; kiểm tra ngày, role, kết quả và trạng thái đều được ghi. Không kết thúc một task mà bỏ thiếu nhật ký.
- Nếu kiểm tra không chạy được, nêu rõ nguyên nhân và giới hạn; không ghi thành công. Không tự tạo bước xin phép ngoài phạm vi yêu cầu của người dùng hoặc quy định thực sự áp dụng.
