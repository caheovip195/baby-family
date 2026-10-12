# Baby Family — lịch sử phân tích và quyết định sản phẩm

Mỗi câu hỏi/yêu cầu có một entry cùng mã với [SESSIONS.md](SESSIONS.md), kể cả task kỹ thuật không đổi UX. Phân biệt quan sát, quyết định và giả thuyết; không coi test pass là bằng chứng metric sản phẩm cải thiện. Múi giờ: `Asia/Ho_Chi_Minh` (`UTC+07:00`). [Quy tắc ghi](.agents/skills/baby-family-team/references/history-templates.md).

Mục 001–005 được ghi bù ngày 2026-10-11 từ hội thoại/context hiện có; ngày/giờ làm gốc chưa xác định. Role là phân loại hồi cứu, không khẳng định review độc lập đã xảy ra. Chưa có dataset analytics được cung cấp trong các yêu cầu này.

<a id="bf-20261011-001"></a>
## BF-20261011-001 — Nền tảng backend cho Baby Family

- Ngày ghi bù: 2026-10-11; ngày/giờ làm gốc chưa xác định.
- Yêu cầu: Tạo base Node.js/PostgreSQL/Prisma, three-layer, interfaces, DI và generator sau nghiên cứu.
- Role: Phân loại hồi cứu BACKEND, ARCHITECT, DBA, DEVOPS, QUALITY.
- Vấn đề / mục tiêu: Có nền tảng server nhất quán để phát triển nghiệp vụ gia đình và bé.
- Quan sát: Người dùng yêu cầu base mới; code hiện có thể hiện API Note mẫu, DI, schema/migration và Docker. Base không chứng minh nghiệp vụ đặc tả đã hoàn tất.
- Phân tích / quyết định: Chọn stack tương thích và stable Prisma; thiết lập conventions và đường chạy local/CI. Cấu trúc cuối tuân theo quyết định 004.
- Tác động: Cung cấp hạ tầng phát triển API và persistence; chưa có thay đổi trải nghiệm sản phẩm thật được xác minh.
- Giả thuyết / đo lường: Chuẩn hóa base có thể giảm lỗi tích hợp về sau; đây là giả thuyết. Chưa có dữ liệu đo, không thêm tracking.
- Kết quả / trạng thái: Base đã triển khai, checks lịch sử dẫn ở session; chưa có metric sản phẩm.
- Theo dõi: Kiểm tra phân quyền/family-child scope khi thêm nghiệp vụ thật; không suy ra tenant isolation từ CRUD mẫu.
- Session: [BF-20261011-001](SESSIONS.md#bf-20261011-001).

<a id="bf-20261011-002"></a>
## BF-20261011-002 — TypeScript làm chuẩn backend

- Ngày ghi bù: 2026-10-11; ngày/giờ làm gốc chưa xác định.
- Yêu cầu: Sử dụng TypeScript.
- Role: Phân loại hồi cứu BACKEND, ARCHITECT, QUALITY.
- Vấn đề / mục tiêu: Contracts dễ đọc và phát hiện sai kiểu khi phát triển backend.
- Quan sát: User yêu cầu trực tiếp; source/tsconfig/generator hiện dùng TypeScript strict.
- Phân tích / quyết định: Dùng typed interfaces + runtime Symbol tokens cho Nest DI; không dựa vào interface tại runtime.
- Tác động: Quy ước triển khai và khả năng bảo trì; không đổi hành vi sản phẩm.
- Giả thuyết / đo lường: Giảm lỗi kiểu là mục tiêu kỹ thuật, chưa có thống kê trước/sau; chưa có dữ liệu đo, không thêm tracking.
- Kết quả / trạng thái: TypeScript đã áp dụng; không có kết luận định lượng về chất lượng sản phẩm.
- Theo dõi: Giữ strict/contracts khi sinh resource mới.
- Session: [BF-20261011-002](SESSIONS.md#bf-20261011-002).

<a id="bf-20261011-003"></a>
## BF-20261011-003 — Phản hồi cấu trúc khó nhìn và câu hỏi MVC

- Ngày ghi bù: 2026-10-11; ngày/giờ làm gốc chưa xác định.
- Yêu cầu: So sánh với MVC vì cấu trúc hiện tại gây rối.
- Role: Phân loại hồi cứu ARCHITECT, BACKEND.
- Vấn đề / mục tiêu: Chủ dự án muốn tự bảo trì dễ dàng khi quy mô tăng.
- Quan sát: Phản hồi trực tiếp của user là bằng chứng định tính về khó hiểu cấu trúc; không phải kết quả nghiên cứu nhiều người dùng.
- Phân tích / quyết định: Ưu tiên cấu trúc phù hợp người bảo trì; quyết định cụ thể được chốt ở 004. Không dựng lại nội dung tư vấn cũ khi thiếu bản ghi.
- Tác động: Định hướng kỹ thuật/onboarding đội phát triển; không đổi UI hay nghiệp vụ sản phẩm.
- Giả thuyết / đo lường: Cấu trúc theo role có thể dễ tìm file hơn với người dùng này; chưa có dữ liệu đo.
- Kết quả / trạng thái: Yêu cầu tiếp theo xác định mô hình OOP cần dùng.
- Theo dõi: Dùng quyết định 004 làm chuẩn, tránh tái giới thiệu cấu trúc đã bị phản đối.
- Session: [BF-20261011-003](SESSIONS.md#bf-20261011-003).

<a id="bf-20261011-004"></a>
## BF-20261011-004 — Chốt kiến trúc dễ bảo trì theo role

- Ngày ghi bù: 2026-10-11; ngày/giờ làm gốc chưa xác định.
- Yêu cầu: Controller → Service → Repository → Model; interface/implementation cho repo/service, DI, nghiệp vụ tại service và CRUD tại repo.
- Role: Phân loại hồi cứu ARCHITECT, BACKEND, TESTER, QUALITY.
- Vấn đề / mục tiêu: Cấu trúc rõ ràng, giữ trách nhiệm mỗi lớp và dễ tìm implementation khi bảo trì.
- Quan sát: User nêu chính xác mô hình mong muốn; conventions và code cuối đã theo mô hình này.
- Phân tích / quyết định: Global folders theo loại; service/repository abstractions có token DI; repository trả model instances; generator/lint/docs phải đồng bộ.
- Tác động: Thay đổi tổ chức code và extension workflow; chưa có thay đổi business behavior được yêu cầu.
- Giả thuyết / đo lường: Khả năng bảo trì tốt hơn theo mong muốn user; chưa có số đo thời gian sửa lỗi hoặc onboarding.
- Kết quả / trạng thái: Refactor và checks lịch sử đã hoàn tất theo session; không có metric sản phẩm mới.
- Theo dõi: Feature mới phải theo cùng cấu trúc; đánh giá lại chỉ khi user yêu cầu.
- Session: [BF-20261011-004](SESSIONS.md#bf-20261011-004).

<a id="bf-20261011-005"></a>
## BF-20261011-005 — Làm rõ cấu hình và ranh giới integration

- Ngày ghi bù: 2026-10-11; ngày/giờ làm gốc chưa xác định.
- Yêu cầu: Giải thích env/config và cách thêm Mongo, Redis, storage.
- Role: Phân loại hồi cứu BACKEND, DEVOPS, INTEGRATION, TECH_WRITER.
- Vấn đề / mục tiêu: Người bảo trì hiểu cách mở rộng dịch vụ mà vẫn giữ cấu hình có kiểm tra.
- Quan sát: Backend hiện dùng PostgreSQL qua Prisma; config có Zod và ConfigService. User hỏi cách mở rộng, chưa yêu cầu chọn vendor/provider.
- Phân tích / quyết định: Giải thích env loading/precedence/validation và nhu cầu SDK + provider + lifecycle; không coi thêm biến env là đã có kết nối.
- Tác động: Không đổi hành vi sản phẩm, schema hoặc hạ tầng đang chạy.
- Giả thuyết / đo lường: Tài liệu rõ có thể giảm lỗi config; chưa có dữ liệu đo, không thêm tracking.
- Kết quả / trạng thái: Đã giải thích; Mongo/Redis/storage chưa được cài trong task này.
- Theo dõi: Khi triển khai thực tế cần xác định use case, provider, secrets, timeout/retry và health/lifecycle tương ứng.
- Session: [BF-20261011-005](SESSIONS.md#bf-20261011-005).

<a id="bf-20261011-006"></a>
## BF-20261011-006 — Điều phối chuyên môn và lưu quyết định dự án

- Ngày làm: 2026-10-11 (Asia/Ho_Chi_Minh).
- Yêu cầu: Cài bộ role liên quan dự án, phân tích kỹ mỗi task và ghi cả hai nhật ký theo từng câu hỏi/ngày làm.
- Role: ORCHESTRATOR/TECH_WRITER/DATA_ANALYST do agent chính áp dụng; PM/BA/ARCHITECT qua agent catalog; TESTER/QUALITY qua reviewer độc lập.
- Vấn đề / mục tiêu: Giữ kiến thức và quyết định qua các phiên; mỗi task có người chịu trách nhiệm và đủ góc nhìn chuyên môn.
- Quan sát: Root AGENTS.md và SESSION.md đang trống lúc kiểm tra; backend/mobile có conventions riêng; mobile có SESSION lịch sử cần giữ.
- Phân tích / quyết định: Project skill + AGENTS bắt buộc chọn role; 17 role chính và AI_ENGINEER khi task thực sự chạm AI. Từng câu hỏi có entry cùng mã trong hai file; primary agent là log writer duy nhất; ghi bù có nhãn nguồn/giới hạn.
- Tác động: Quy trình làm việc, bảo trì và truy vết quyết định. Không đổi UX, API hoặc schema; không cài analytics SDK.
- Giả thuyết / đo lường: Có thể giảm thất lạc quyết định và thiếu review; chưa có dữ liệu đo. Kiểm chứng trước mắt bằng validation skill, link/history checks và mô phỏng chọn role, không suy ra KPI sử dụng app.
- Kết quả / trạng thái: Hoàn thành catalog/rules/templates/skill metadata và hai nhật ký. Skill validation, metadata, 52 local links, 7 mã khớp và trường bắt buộc đạt; review độc lập không còn must-fix. Sáu tình huống routing được mô phỏng theo tài liệu, không phải runtime test hoặc nghiên cứu người dùng. Lịch sử mobile cũ được bảo toàn.
- Theo dõi: Các task sau tiếp tục chọn role theo tác động và ghi quyết định/kết quả thực tế; chưa có dữ liệu để đánh giá hiệu quả quy trình dài hạn.
- Session: [BF-20261011-006](SESSIONS.md#bf-20261011-006).

<a id="bf-20261011-007"></a>
## BF-20261011-007 — Giữ repository sạch và tránh commit dữ liệu local

- Ngày làm: 2026-10-11 (Asia/Ho_Chi_Minh).
- Yêu cầu: Bổ sung .gitignore trong khi cài bộ role.
- Role: DEVOPS, QUALITY/TESTER; ORCHESTRATOR/DATA_ANALYST tổng hợp impact.
- Vấn đề / mục tiêu: Loại local env, dependencies và build noise khỏi các file mới Git phát hiện, vẫn chia sẻ mẫu cấu hình và tri thức dự án.
- Quan sát: Chưa có root .gitignore; child backend có rule `.env.*` rộng; `.DS_Store` đã được tracked trước task.
- Phân tích / quyết định: Tạo ignore chung, scope build theo ứng dụng, giữ env examples và tài liệu/roles/logs; mở thêm backend `.env.*.example`. Không untrack/xóa/stage file đã có.
- Tác động: Vệ sinh repository và giảm nguy cơ commit nhầm env/credential mới; không đổi hành vi sản phẩm. Ignore không thay thế quản lý secrets và không gỡ file đã tracked.
- Giả thuyết / đo lường: Chưa có dữ liệu đo sản phẩm, không thêm tracking. Kiểm chứng bằng git check-ignore đối với mẫu đường dẫn cần ignore/giữ.
- Kết quả / trạng thái: Hoàn thành. Root rules đạt 48 assertions; 28 checks cuối gồm env mẫu backend/source/migrations/roles/logs đạt và được review độc lập. Không đổi dependency ứng dụng, không untrack/xóa/stage file.
- Theo dõi: File đã tracked không tự bị loại; `.DS_Store` hiện thuộc trường hợp này. Không khẳng định đã làm sạch toàn bộ lịch sử Git, không có metric sản phẩm mới.
- Session: [BF-20261011-007](SESSIONS.md#bf-20261011-007).
