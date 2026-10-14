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

<a id="bf-20261012-001"></a>

## BF-20261012-001 — Hoàn thiện bộ màn còn thiếu (đợt 3)

- Ngày làm: 2026-10-12 (Asia/Ho_Chi_Minh); entry tạo lúc 2026-10-12T19:20:00+07:00.
- Yêu cầu: Vẽ và code các màn còn lại của đặc tả mục 9 (đợt 3).
- Role: ORCHESTRATOR, DESIGN, MOBILE, BA, SECURITY_PRIVACY, DATA_ANALYST.
- Vấn đề / mục tiêu: Mọi lối vào trong app mở được màn thật đúng thiết kế (hết "Sắp ra mắt"), đủ luồng Papa & Mama (Cầu nối), người thân (Circle), gói dịch vụ và quản trị dữ liệu.
- Quan sát: Đặc tả mục 9 liệt kê ~36 màn chưa có thiết kế/app sau đợt 2; app đang chạy dữ liệu mock.
- Phân tích / quyết định: Giữ quy trình thiết kế trước rồi code; nhánh an toàn chỉ dùng số chính thức 111/113/115; người thân có thanh tab riêng theo đặc tả 9.14.
- Tác động: Thêm màn/luồng UI mock; chưa đổi API/backend; không thêm tracking.
- Giả thuyết / đo lường: Chưa có dữ liệu đo (mock UI).
- Kết quả / trạng thái: Đang thực hiện.
- Theo dõi: Cập nhật sau khi code và kiểm thử xong.
- Session: [BF-20261012-001](SESSIONS.md#bf-20261012-001).

<a id="bf-20261012-002"></a>

## BF-20261012-002 — Đồng bộ thiết kế và dữ liệu mẫu, xử lý việc tồn

- Ngày làm: 2026-10-12 (Asia/Ho_Chi_Minh); entry tạo lúc 2026-10-12T19:20:00+07:00.
- Yêu cầu: Xử lý các việc tồn của đợt 2.
- Role: MOBILE, DESIGN, ORCHESTRATOR, DATA_ANALYST.
- Vấn đề / mục tiêu: Thiết kế và app hiển thị cùng một câu chuyện/số liệu; bổ sung font và trường dữ liệu còn thiếu.
- Quan sát: Nhiều chỗ lệch số giữa frame và dữ liệu mock (mã mời, ngày hết dùng thử, số tên, bộ đếm story, số cột mốc).
- Phân tích / quyết định: Dữ liệu thật là nguồn đúng; sửa chữ Pencil cho khớp. Dùng thử hết hạn 05/01/2027 (hôm nay + 90 ngày).
- Tác động: Không đổi hành vi nghiệp vụ; chỉ UI/dữ liệu mock và font.
- Giả thuyết / đo lường: Chưa có dữ liệu đo.
- Kết quả / trạng thái: Đang thực hiện.
- Theo dõi: Cập nhật khi xong.
- Session: [BF-20261012-002](SESSIONS.md#bf-20261012-002).

<a id="bf-20261013-001"></a>

## BF-20261013-001 — Vòng đời database độc lập và dữ liệu có thể backup

- Ngày làm: 2026-10-13 (Asia/Ho_Chi_Minh).
- Yêu cầu: Tách DB khỏi backend Compose, mount data host để giữ dữ liệu khi Docker/Compose bị xóa và dễ backup.
- Role: DEVOPS, DBA, ARCHITECT, BACKEND, TESTER, QUALITY; ORCHESTRATOR/DATA_ANALYST tổng hợp.
- Vấn đề / mục tiêu: Backend có thể rebuild/down độc lập; data nằm trong thư mục host dễ nhận diện và sao lưu.
- Quan sát: DB hiện thuộc baby-backend, sử dụng named volume; có hai application/test databases. Các folder dự án đã được người dùng phân chia riêng.
- Phân tích / quyết định: Standalone database Compose + bind mount PostgreSQL 18 đúng target; mạng chia sẻ, backend chỉ API/migrations. Backup logical trước cutover; copy cluster sau shutdown sạch, giữ nguồn cũ; kiểm thử recreate và restore có trọng tâm.
- Tác động: Vận hành và persistence; không đổi hành vi nghiệp vụ, schema hoặc tracking. Dữ liệu host vẫn cần backup riêng để chống xóa thư mục/hỏng ổ.
- Giả thuyết / đo lường: Chưa có dữ liệu analytics sản phẩm. Xác minh kỹ thuật bằng dữ liệu/số lượng/migration trước-sau, mount type, recreate container, backup/restore và kết nối API.
- Kết quả / trạng thái: Hoàn thành. DB standalone healthy trên bind host; cutover giữ 3 DB/roles/4 table digests, nguồn cũ giữ nguyên. Container thực sự bị xóa/tạo lại bằng down --volumes/up và dữ liệu vẫn khớp; backup/restore DB mới, missing-path fail, integration 1/1, API CRUD và backend down không dừng DB đều đạt. Hai reviewer độc lập không có must-fix. Không có số liệu KPI sản phẩm được đo hoặc suy diễn từ các checks này.
- Theo dõi: Backup thường là application DB + globals, restore vào DB mới bỏ owner/ACL gốc theo runbook; production PITR/full-cluster recovery cần scope riêng. Khi chọn ổ rời, chuyển offline đúng quy trình; data/backups cùng host không bảo vệ khỏi xóa chính thư mục hoặc hỏng ổ. Bản cluster cũ chỉ phản ánh trước cutover.
- Session: [BF-20261013-001](SESSIONS.md#bf-20261013-001).

<a id="bf-20261013-002"></a>

## BF-20261013-002 — Giữ database trong folder đã phân chia

- Ngày làm: 2026-10-13 (Asia/Ho_Chi_Minh).
- Yêu cầu: Đặt Compose database trong thư mục database hiện có.
- Role: DEVOPS, DBA, ORCHESTRATOR, QUALITY.
- Vấn đề / mục tiêu: Cấu trúc dự án đúng trách nhiệm và dễ tìm/cấu hình khi bảo trì.
- Quan sát: baby-database tồn tại; chưa có ổ ngoài vật lý được mount hoặc đường dẫn ổ riêng được chỉ định.
- Phân tích / quyết định: Đặt Compose tại baby-database/compose.yaml; mặc định ./data và ./backups tương đối với folder này, có env đổi vị trí. Không tự tạo folder mới theo lỗi gõ.
- Tác động: Tổ chức hạ tầng và thao tác vận hành; không đổi UX/API/schema.
- Giả thuyết / đo lường: Chưa có dữ liệu đo sản phẩm; kiểm chứng đường dẫn, Compose config và Docker inspect.
- Kết quả / trạng thái: Hoàn thành cùng 001: Compose đúng baby-database, Docker inspect xác nhận host path, backup từ repository root ghi đúng DB folder; data/backups/env ignored và source/env mẫu vẫn versionable. Không đổi UX/API/schema hoặc thêm tracking.
- Theo dõi: Giữ database server độc lập với backend; cấu hình env rõ ràng khi thay vị trí data/backup. Chưa có ổ rời vật lý được chỉ định, hiện dùng thư mục host như đã thông báo.
- Session: [BF-20261013-002](SESSIONS.md#bf-20261013-002).

<a id="bf-20261013-003"></a>

## BF-20261013-003 — Chuẩn lịch sử dữ liệu và khả năng truy vết background job

- Ngày làm: 2026-10-13 (Asia/Ho_Chi_Minh).
- Yêu cầu: Bắt buộc created_at/updated_at/deleted_at trong quy tắc role và làm rõ lưu DB/xử lý cron job thất bại.
- Role: DBA, ARCHITECT, BACKEND, DEVOPS, TESTER, QUALITY, TECH_WRITER; ORCHESTRATOR/DATA_ANALYST tổng hợp.
- Vấn đề / mục tiêu: Schema nhất quán, truy vết tạo/sửa/xóa và biết background task chạy thành công hay lỗi để xử lý đúng.
- Quan sát: Note/schema/generator thiếu deleted_at, repository hard delete; base chưa cài scheduler/queue và chưa có bảng job history. Đặc tả đề cập timestamp trigger, outbox và BullMQ nhưng đó không phải bằng chứng đã triển khai.
- Phân tích / quyết định: Quy định toàn bộ bảng dự án gồm join/job/history có 3 cột; soft delete mặc định và timestamp được bảo đảm ở DB khi có nhiều writer. Cron cần durable job/run record, retry có giới hạn, idempotency, distributed lease và recovery cho worker crash/DB outage. Viết chính sách/tài liệu trong scope này, không tự triển khai Redis/BullMQ hoặc thay dữ liệu đang chạy.
- Tác động: Chuẩn phát triển và thiết kế vận hành; chưa đổi schema/hành vi API đang chạy, không thêm tracking.
- Giả thuyết / đo lường: Chưa có dữ liệu analytics sản phẩm. Khi triển khai jobs có thể đo success/failure/stale/queue lag theo định nghĩa có nguồn; task này chỉ kiểm chứng chính sách và hiện trạng.
- Kết quả / trạng thái: Hoàn thành. Đã cập nhật catalog role, skill/AGENTS, chuẩn database/jobs, README và đặc tả; static format/link/skill validation đạt, hai reviewer QUALITY/TESTER và BACKEND/DEVOPS độc lập không có must-fix. Không thay schema, API/runtime, queue hoặc dữ liệu; chưa có metric sản phẩm được đo. Quy tắc phân biệt lỗi tạm thời/vĩnh viễn, retry, worker crash và DB outage; không khẳng định tự persist/retry hay exactly-once.
- Theo dõi: Note/generator hiện thiếu deleted_at, repository hard delete và chưa có DB trigger; khi triển khai cần source/generator đồng bộ, forward migration và kiểm thử persistence. Khi triển khai jobs cần run/attempt history, idempotency, external monitoring và recovery; đặc tả BullMQ/outbox chưa phải implementation. Cần metric định nghĩa theo run/attempt riêng để không đếm retry thành nhiều job thành công.
- Session: [BF-20261013-003](SESSIONS.md#bf-20261013-003).

<a id="bf-20261013-004"></a>

## BF-20261013-004 — Nền tảng dữ liệu theo family và quyền lợi gói

- Ngày làm: 2026-10-13 (Asia/Ho_Chi_Minh). Hoàn thành/cập nhật kết quả lúc 2026-10-14T07:28:29+07:00.
- Yêu cầu: Thiết kế database bám docs/desgin, hiệu quả và dễ mở rộng; license/Pro đi theo family, không theo user.
- Role: BA, PRODUCT, DESIGN, DBA, ARCHITECT, BACKEND, INTEGRATION, SECURITY_PRIVACY, TESTER/QUALITY; ORCHESTRATOR/DATA_ANALYST tổng hợp.
- Vấn đề / mục tiêu: Dữ liệu phục vụ đủ luồng sản phẩm, bảo toàn quyền riêng tư và quota của gia đình, tránh gắn nhầm quyền lợi vào người thanh toán.
- Quan sát: Có đặc tả nghiệp vụ/kỹ thuật và canvas Pencil; backend runtime hiện mới có resource Note mẫu. Quy tắc audit ba cột đã ban hành, chưa rollout vào runtime.
- Phân tích / quyết định: Family là tenant/quyền lợi; purchaser và store ownership là thông tin giao dịch riêng. Đối chiếu màn→luồng→bảng/constraint/query, phân biệt phase, yêu cầu đã chốt và giả định cần hỏi.
- Tác động: Thiết kế cấu trúc dữ liệu, billing/entitlement, khả năng vận hành và mở rộng; chưa đổi dữ liệu người dùng hoặc bật tracking.
- Giả thuyết / đo lường: Chưa có dataset/KPI sản phẩm. Đánh giá kỹ thuật qua coverage màn/BR, tính toàn vẹn quan hệ, tenant isolation, idempotency, quota và kiểm chứng DDL/schema cách ly; không suy diễn cải thiện metric.
- Kết quả / trạng thái: Hoàn thành thiết kế và persistence nền: 123 bảng/model/contracts/repos, DI; coverage docs/canvas và 47 kịch bản toàn vẹn đạt trên PostgreSQL cách ly. Data dictionary chỉ đọc metadata. Không áp migration/seed ứng dụng, không có KPI được đo.
- Theo dõi: Đã chốt license/trial qua BF-20261013-005; các gap family deletion/retention và phase được ghi requirements. Authorization, Store verifier, workers và load/performance cần kiểm chứng khi triển khai tính năng thực.
- Session: [BF-20261013-004](SESSIONS.md#bf-20261013-004).

<a id="bf-20261013-005"></a>

## BF-20261013-005 — Cấu hình trial và gói theo family, thiết kế có khả năng mở rộng

- Ngày làm: 2026-10-13 (Asia/Ho_Chi_Minh). Hoàn thành/cập nhật kết quả lúc 2026-10-14T07:28:29+07:00.
- Yêu cầu: Trial7ngày; giữ House/Family và cho thêm gói; nguyên tắc mở rộng bắt buộc backend/frontend; license không chuyển family, renew hợp lệ vẫn thuộc family gốc sau payer xóa account.
- Role: PRODUCT, BA, ARCHITECT, DBA, BACKEND, FRONTEND/MOBILE, TESTER/QUALITY; ORCHESTRATOR/DATA_ANALYST tổng hợp.
- Vấn đề / mục tiêu: Chủ động thay đổi catalog/thương mại mà không sửa enum/câu lệnh theo tên gói; quyền lợi gia đình ổn định và truy vết được khi đổi người thanh toán.
- Quan sát: Người dùng trực tiếp xác nhận ba câu billing; 90ngày trong docs/canvas là nguồn cũ bị thay thế. Không có dữ liệu conversion hoặc chi phí để suy ra hiệu quả trial7ngày.
- Phân tích / quyết định: Catalog plans/versions/products; versioned trial policy mặc định 7 ngày; grant lưu thời hạn đã cấp, không hồi tố khi config đổi. Immutable familybinding; purchasernullable, paidrenew vẫn familygốc. Client hiển thị catalog/capability từ server, contract typed/versioned và fallback an toàn.
- Tác động: Thiết kế/catalog/rules đã cập nhật trong backend và docs; quyền lợi, thanh toán và UI runtime chưa rollout. Không thêm analytics SDK.
- Giả thuyết / đo lường: Khi rollout có thể đo activation→purchase/trialexpiry theo policyversion; hiện chưa có dataset/KPI và không thêm analyticsSDK.
- Kết quả / trạng thái: Hoàn thành: catalog mở rộng, trial mặc định 7 ngày versioned, binding family bất biến và paid renewal sau payer detach đã được kiểm bằng SQL cách ly. Seed bootstrap chạy riêng/idempotent; standards mở rộng áp dụng bắt buộc backend/frontend/mobile. Không có số liệu conversion để kết luận hiệu quả trial.
- Theo dõi: Triển khai server capabilities/Store verification và cập nhật copy canvas/UI khi làm feature; đo activation→purchase/trialexpiry theo policy version sau rollout có dữ liệu.
- Session: [BF-20261013-005](SESSIONS.md#bf-20261013-005).

<a id="bf-20261013-006"></a>

## BF-20261013-006 — Backend sở hữu schema và migration

- Ngày làm: 2026-10-13 (Asia/Ho_Chi_Minh). Hoàn thành/cập nhật kết quả lúc 2026-10-14T07:28:29+07:00.
- Yêu cầu: Đặt lại schema/migrations vào backend để đúng workflow Prisma, database folder chỉ vận hành server/data/backup.
- Role: BACKEND, DBA, TESTER/QUALITY; ORCHESTRATOR/DATA_ANALYST tổng hợp.
- Vấn đề / mục tiêu: Một nguồn cấu trúc DB có version, deploy/review/rollback rõ, không phải chạy SQL tay ở folder hạ tầng.
- Quan sát: Candidate SQL nằm baby-database/design nhưng chưa áp live; backend vẫn chỉ có Prisma Note mẫu và migration init.
- Phân tích / quyết định: Chuyển cấu trúc vào baby-backend/prisma/schema.prisma và forward migration; giữ init đã có, validation bằng Prisma CLI trên DB ephemeral. Test/design docs dẫn cùng nguồn; không sửa dữ liệu người dùng.
- Tác động: Workflow phát triển/triển khai và khả năng bảo trì; chưa có thay đổi thương mại/tracking runtime.
- Giả thuyết / đo lường: Không có KPI sản phẩm; đo đúng bằng migration replay, schema/client consistency và checks thực tế.
- Kết quả / trạng thái: Hoàn thành: backend Prisma sở hữu 123 models và migration forward DDL; server/data/backup riêng baby-database. Replay hai migrations, validate/generate và DB→Prisma diff đều đạt; DB ứng dụng không bị áp migration/seed.
- Theo dõi: Docs/scripts thống nhất nguồn backend; giữ init đã có. Schema deploy và seed là các bước riêng theo môi trường; không có KPI sản phẩm mới.
- Session: [BF-20261013-006](SESSIONS.md#bf-20261013-006).

<a id="bf-20261014-001"></a>

## BF-20261014-001 — Migration cấu trúc tách khỏi seed dữ liệu

- Ngày làm: 2026-10-14 (Asia/Ho_Chi_Minh). Hoàn thành/cập nhật kết quả lúc 2026-10-14T07:28:29+07:00.
- Yêu cầu: Cấm CRUD/INSERT dữ liệu trong migration, seed riêng backend.
- Role: BACKEND, DBA, TESTER/QUALITY; ORCHESTRATOR/DATA_ANALYST tổng hợp.
- Vấn đề / mục tiêu: Migration có nhiệm vụ cấu trúc rõ ràng, không tự thay chính sách/catalog khi deploy; seed được chạy và kiểm chứng riêng.
- Quan sát: Migration forward chưa áp ứng dụng đang chứa catalog INSERT; user yêu cầu loại bỏ.
- Phân tích / quyết định: DDL-only migration, versioned/idempotent seed lệnh riêng; giữ initial migration và DB ứng dụng nguyên trạng.
- Tác động: Quy trình phát triển và vận hành, chưa đổi quyền lợi thực hoặc analytics.
- Giả thuyết / đo lường: Không có KPI sản phẩm; kiểm chứng DML audit, replay migration, catalog trống trước seed và ổn định sau chạy seed lặp.
- Kết quả / trạng thái: Hoàn thành: migration không CRUD/seed; bootstrap catalog TypeScript/JSON chạy riêng, idempotent và không ghi đè config đang có. Replay để catalog trống, seed hai lần digest giữ nguyên, 6 nhóm policy regression và 47 kịch bản domain đạt. Review độc lập đạt; guard tĩnh cần đi kèm SQL review.
- Theo dõi: Không tự seed khi migrate/start/Compose. Catalog update/backfill dùng service/command riêng có version và kiểm chứng; không thay đổi quyền lợi thực trong task.
- Session: [BF-20261014-001](SESSIONS.md#bf-20261014-001).

<a id="bf-20261014-002"></a>

## BF-20261014-002 — Persistence classes nhất quán với schema

- Ngày làm: 2026-10-14 (Asia/Ho_Chi_Minh). Hoàn thành/cập nhật kết quả lúc 2026-10-14T07:28:29+07:00.
- Yêu cầu: Có model/repository tương ứng các bảng, interfaces và DI theo kiến trúc đã chọn.
- Role: BACKEND, DBA, TESTER/QUALITY; ORCHESTRATOR/DATA_ANALYST tổng hợp.
- Vấn đề / mục tiêu: Cấu trúc dữ liệu đi kèm code có thể dùng/bảo trì, không dừng ở SQL/thiết kế.
- Quan sát: Backend đang chỉ có Note; model/repo domain còn thiếu.
- Phân tích / quyết định: Sinh class/contract/provider theo metadata Prisma, audit/soft delete/composite keys đúng; append-only ledger không mở mutation tùy ý. Domain API/business services vẫn cần triển khai theo luồng/quyền, không coi persistence scaffolding là toàn bộ tính năng.
- Tác động: Nền tảng backend và khả năng bảo trì, không thay UI/tracking/thanh toán thật.
- Giả thuyết / đo lường: Không có dataset sản phẩm; xác minh coverage model/table/providers, typecheck và các đường persistence đại diện.
- Kết quả / trạng thái: Hoàn thành 123 bộ model/I-repository/concrete repo, DI domain 122 providers, tenant/privileged scopes, 18 append-only. Coverage và chống Prisma-type leakage đạt; check đủ 24 unit, 10 generator, 6 policy và 10 e2e tests, integration 2/2 trên PostgreSQL cách ly, generator 369 files không drift. Không có số liệu cải thiện KPI sản phẩm được đo.
- Theo dõi: Business service/API, authorization và workers vẫn là công việc tính năng riêng. Hash guard và CI ngăn source drift; quyết định retention/transition phải ở service, không generic mutation ledger.
- Session: [BF-20261014-002](SESSIONS.md#bf-20261014-002).
