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
- Tác động: Thêm màn/luồng UI mock; chưa đổi API/backend; không thêm tracking. Mọi lối vào đợt 3 mở màn thật (bỏ “Sắp ra mắt”); người thân có shell 4 tab riêng; quyền người thân được giữ khi lệch với frame (CIR-04 chỉ hiện bé được phép đóng góp).
- Giả thuyết / đo lường: Chưa có dữ liệu đo (mock UI). Khi nối backend nên đo: tỉ lệ mở Cầu nối → gửi lời mời → đóng phiên; số báo cáo/chặn trên mỗi gia đình; tỉ lệ ảnh người thân được duyệt; tỉ lệ khôi phục từ Thùng rác.
- Kết quả / trạng thái: Hoàn thành (2026-10-15). Kiểm chứng: `make check` 679/679, build iOS simulator thành công, kiểm tra thủ công vài màn trên simulator.
- Theo dõi: Người dùng chốt quyền đóng góp ảnh của Bà ngoại cho Hana (CIR-04/fixture `pp-meo`), báo cáo nội dung AI, câu “Đến hết ngày” ở ONB-ACT, lối vào MEM-19 trên FAM-01/NOTI-01, ảnh Haru đúng tuổi.
- Session: [BF-20261012-001](SESSIONS.md#bf-20261012-001).

<a id="bf-20261012-002"></a>

## BF-20261012-002 — Đồng bộ thiết kế và dữ liệu mẫu, xử lý việc tồn

- Ngày làm: 2026-10-12 (Asia/Ho_Chi_Minh); entry tạo lúc 2026-10-12T19:20:00+07:00.
- Yêu cầu: Xử lý các việc tồn của đợt 2.
- Role: MOBILE, DESIGN, ORCHESTRATOR, DATA_ANALYST.
- Vấn đề / mục tiêu: Thiết kế và app hiển thị cùng một câu chuyện/số liệu; bổ sung font và trường dữ liệu còn thiếu.
- Quan sát: Nhiều chỗ lệch số giữa frame và dữ liệu mock (mã mời, ngày hết dùng thử, số tên, bộ đếm story, số cột mốc).
- Phân tích / quyết định: Dữ liệu thật là nguồn đúng; sửa chữ Pencil cho khớp. Dùng thử hết hạn 05/01/2027 (hôm nay + 90 ngày).
- Tác động: Không đổi hành vi nghiệp vụ; chỉ UI/dữ liệu mock và font (Dancing Script, giấy phép OFL, đóng gói kèm file giấy phép).
- Giả thuyết / đo lường: Chưa có dữ liệu đo.
- Kết quả / trạng thái: Hoàn thành (2026-10-15). Quyết định “dùng thử 90 ngày, hết hạn 05/01/2027” đã bị **thay thế** bởi BF-20261013-005 (7 ngày), áp dụng ở BF-20261015-002.
- Theo dõi: Ảnh Haru vẫn trông lớn hơn 18 tháng.
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

<a id="bf-20261014-003"></a>

## BF-20261014-003 — API và business service trên persistence nền

- Ngày làm: 2026-10-14 (Asia/Ho_Chi_Minh); bắt đầu 2026-10-14T19:11:55+07:00. Cập nhật kết quả lúc 2026-10-14T19:44:32+07:00.
- Yêu cầu: Triển khai tiếp tầng service và controller.
- Role: BACKEND, ARCHITECT, BA, SECURITY_PRIVACY, DBA/INTEGRATION, TESTER/QUALITY; ORCHESTRATOR/DATA_ANALYST tổng hợp.
- Vấn đề / mục tiêu: Code persistence có đường sử dụng qua service/interface và HTTP boundary, bảo trì theo kiến trúc đã chọn.
- Quan sát: Lúc tiếp nhận có 123 models/repos, domain chưa có service/controller và Note là mẫu HTTP. Persistence inputs chứa fields nội bộ; bản triển khai đã tách HTTP DTO/projection và chỉ đăng ký controller theo luồng.
- Phân tích / quyết định: Typed DTO allowlist, xác thực principal và tenant/self scope tại server; controller→IService→IRepository→model. Nội bộ billing/history/jobs không public generic CRUD. Phân biệt tầng nền với từng workflow tích hợp/worker chưa triển khai.
- Tác động: Bổ sung service/interface/DI cho domain và 7 nhóm API có xác thực/session/quyền, validation nghiệp vụ và projection. Không đổi UI, tracking, Store thanh toán hoặc DB ứng dụng; chưa có KPI sản phẩm được đo.
- Giả thuyết / đo lường: Chưa có dataset/KPI sản phẩm. Xác minh bằng DI/typecheck, HTTP validation, auth/privacy và PostgreSQL integration; không suy diễn metric sản phẩm.
- Kết quả / trạng thái: Hoàn thành tầng nền: 122 domain service/interface (117 internal scaffolding +5 manual business services), 7 controllers, JWT/session/Parent/license gate và catalog/quyền lợi theo family. Final check 115 unit, 34 HTTP, 10 generator tests và 6 migration policy groups đạt; 17 PostgreSQL integration tests thực đạt, gồm Pregnancy POST đồng thời không tái dùng seqNo và chống mass assignment. Review độc lập và production audit đạt; container kiểm thử đã dọn. Không suy diễn cải thiện retention/conversion hoặc claim full app.
- Theo dõi: [API scope](baby-backend/docs/api.md) phân biệt implemented/planned và contract base page/limit với cursor/envelope/If-Match/idempotency trong spec. Cấu hình public key issuer trước khi dùng domain API; token issuance, Store, Circle/private ACL, jobs và workflow nhiều bảng triển khai theo tính năng. Migration/seed vẫn là bước backend riêng, không tự deploy; chưa có dữ liệu KPI để đánh giá tác động sản phẩm.
- Session: [BF-20261014-003](SESSIONS.md#bf-20261014-003).

<a id="bf-20261014-004"></a>

## BF-20261014-004 — Nâng TypeScript 7.0.2 và đánh giá tương thích

- Ngày làm: 2026-10-14T21:26:07+07:00; hoàn tất 2026-10-15T19:10:55+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: Muốn dùng TypeScript7 thay6; hỏi bản7.0.2 có gì mới và áp dụng vào project có ổn không.
- Role: BACKEND, ARCHITECT, TESTER/QUALITY, DEVOPS; ORCHESTRATOR/DATA_ANALYST tổng hợp.
- Vấn đề / mục tiêu: Compiler mới phù hợp codebase và pipeline hiện tại, giữ bảo trì/DI/runtime ổn định.
- Quan sát: Nguồn Microsoft xác nhận 7.0.2 là stable đầu tiên 7.0; native Go compiler và API compatibility6 chạy song song. npm dependency tree hợp lệ, API6.0.3 được khóa; fresh Prisma NodeNext sinh .js specifiers cần resolver khi tooling chạy source.ts.
- Phân tích / quyết định: Áp dụng recipe alias chính thức: CLI7 cho build/typecheck/watch; giữ API6 cho Jest/typed ESLint/generator/seed. Chuyển main config sang NodeNext, seed/tools và test transformer cấu hình riêng; thêm kiểm tra actual dist metadata/DI và regression resolver. Không ép peer dependencies hoặc làm yếu strict checks.
- Tác động: Toolchain local/CI/Docker và thời gian typecheck; giữ kiến trúc OOP/DI, API nghiệp vụ/UI/schema. Không chạy migration/seed lên DB ứng dụng và không thêm tracking/SDK.
- Giả thuyết / đo lường: Đã đo kỹ thuật trên Apple M1 Max/macOSarm64/Node26.11.1: cùng tsconfig/source/tests/fresh Prisma, 1 warmup mỗi compiler +3 lượt xen kẽ, noEmit, CLI startup tính trong thời gian và filesystem cache ấm. Median TS6.0.3 5.2054s, TS7.0.2 1.0873s (~4.79×). Mẫu nhỏ một máy; không phải benchmark cold build/CI/Jest/runtime hoặc KPI sản phẩm.
- Kết quả / trạng thái: Hoàn thành nâng native compiler7.0.2. Fullcheck PASS: 115 unit +34 HTTP +17 PostgreSQL integration (riêng) và generator/migration/compiler/runner/actual dist contracts. Docker build, explicit seed, API readiness/Note CRUD trên DB kiểm thử và actual native watch PASS. Review độc lập đạt; dependency tree hợp lệ, production image không có compiler, môi trường kiểm thử đã dọn. Chưa có dữ liệu retention/conversion/latency sản phẩm; không suy cải thiện KPI từ compiler.
- Theo dõi: [Chi tiết và nguồn](baby-backend/docs/typescript-7.md). API6 còn cần cho tooling; Windows watch chưa chạy runtime; warning DEP0180 từ ts-node trên Node26 không làm seed fail. Lượt14 bị gián đoạn trước mutation, hoàn tất lượt15; DB ứng dụng healthy và không đổi dữ liệu.
- Session: [BF-20261014-004](SESSIONS.md#bf-20261014-004).

<a id="bf-20261015-001"></a>

## BF-20261015-001 — Tiếp tục nâng TypeScript 7.0.2

- Ngày làm: 2026-10-15T18:39:45+07:00; hoàn tất 2026-10-15T19:10:55+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: Tiếp tục yêu cầu nâng/đánh giá TypeScript7.0.2 sau lượt bị gián đoạn.
- Role: BACKEND, ARCHITECT, TESTER/QUALITY, DEVOPS; ORCHESTRATOR/DATA_ANALYST tổng hợp.
- Vấn đề / mục tiêu: Compiler mới phù hợp codebase và pipeline hiện tại, giữ bảo trì/DI/runtime ổn định.
- Quan sát: Nguồn Microsoft xác nhận 7.0.2 là stable đầu tiên 7.0; native Go compiler và API compatibility6 chạy song song. npm dependency tree hợp lệ, API6.0.3 được khóa; fresh Prisma NodeNext sinh .js specifiers cần resolver khi tooling chạy source.ts.
- Phân tích / quyết định: Áp dụng recipe alias chính thức: CLI7 cho build/typecheck/watch; giữ API6 cho Jest/typed ESLint/generator/seed. Chuyển main config sang NodeNext, seed/tools và test transformer cấu hình riêng; thêm kiểm tra actual dist metadata/DI và regression resolver. Không ép peer dependencies hoặc làm yếu strict checks.
- Tác động: Toolchain local/CI/Docker và thời gian typecheck; giữ kiến trúc OOP/DI, API nghiệp vụ/UI/schema. Không chạy migration/seed lên DB ứng dụng và không thêm tracking/SDK.
- Giả thuyết / đo lường: Đã đo kỹ thuật trên Apple M1 Max/macOSarm64/Node26.11.1: cùng tsconfig/source/tests/fresh Prisma, 1 warmup mỗi compiler +3 lượt xen kẽ, noEmit, CLI startup tính trong thời gian và filesystem cache ấm. Median TS6.0.3 5.2054s, TS7.0.2 1.0873s (~4.79×). Mẫu nhỏ một máy; không phải benchmark cold build/CI/Jest/runtime hoặc KPI sản phẩm.
- Kết quả / trạng thái: Hoàn thành nâng native compiler7.0.2. Fullcheck PASS: 115 unit +34 HTTP +17 PostgreSQL integration (riêng) và generator/migration/compiler/runner/actual dist contracts. Docker build, explicit seed, API readiness/Note CRUD trên DB kiểm thử và actual native watch PASS. Review độc lập đạt; dependency tree hợp lệ, production image không có compiler, môi trường kiểm thử đã dọn. Chưa có dữ liệu retention/conversion/latency sản phẩm; không suy cải thiện KPI từ compiler.
- Theo dõi: [Chi tiết và nguồn](baby-backend/docs/typescript-7.md). API6 còn cần cho tooling; Windows watch chưa chạy runtime; warning DEP0180 từ ts-node trên Node26 không làm seed fail. Lượt14 bị gián đoạn trước mutation, hoàn tất lượt15; DB ứng dụng healthy và không đổi dữ liệu.
- Session: [BF-20261015-001](SESSIONS.md#bf-20261015-001).

<a id="bf-20261015-002"></a>
## BF-20261015-002 — Hoàn tất đợt 3 UI và đồng bộ trial 7 ngày trên mock

- Ngày làm: 2026-10-15 (Asia/Ho_Chi_Minh); entry tạo lúc 2026-10-15T19:05:41+07:00.
- Yêu cầu: Tiếp tục hoàn tất đợt 3 UI Flutter sau gián đoạn.
- Role: ORCHESTRATOR, MOBILE, DESIGN, SECURITY_PRIVACY, DATA_ANALYST.
- Vấn đề / mục tiêu: Hoàn tất các màn đợt 3 và để UI mock phản ánh quyết định trial 7 ngày.
- Quan sát: BF-20261013-005 đổi trial mặc định thành 7 ngày; app mock và canvas còn copy 90 ngày / 3 tháng.
- Phân tích / quyết định: Theo quyết định mới nhất của người dùng: copy và dữ liệu mock dùng 7 ngày.
- Tác động: Chỉ UI/dữ liệu mock; không đổi backend/API. Số ngày dùng thử không còn viết cứng: lấy từ `trialPolicy` (có `code`/`version`) trong catalog; grant đã cấp giữ thời lượng của nó khi policy đổi.
- Giả thuyết / đo lường: Chưa có dữ liệu đo. Khi có backend nên đo tỉ lệ chuyển từ dùng thử 7 ngày sang trả phí và thời điểm rời bỏ trong 7 ngày.
- Kết quả / trạng thái: Hoàn thành (2026-10-15). `make check` 679/679; build simulator thành công; Pencil đã đổi 10 chỗ ghi 90 ngày.
- Theo dõi: Model `PlanInfo` trên app chưa có trường phiên bản policy; cần thêm khi nối API.
- Session: [BF-20261015-002](SESSIONS.md#bf-20261015-002).

<a id="bf-20261015-003"></a>
## BF-20261015-003 — Đánh giá độ sẵn sàng backend/DB cho tính năng app

- Ngày làm: 2026-10-15 (Asia/Ho_Chi_Minh); entry tạo lúc 2026-10-15T19:30:00+07:00, cập nhật lúc 2026-10-15T19:50:00+07:00.
- Yêu cầu: Rà backend/DB, xác định thành phần còn thiếu (service, cache, storage…) để đáp ứng tính năng app; môi trường Docker local.
- Role: ARCHITECT, DBA, DEVOPS, INTEGRATION, SECURITY_PRIVACY, DATA_ANALYST.
- Vấn đề / mục tiêu: App có đủ màn trên mock nhưng chưa có backend thật để nối; cần biết khoảng trống trước khi tích hợp.
- Quan sát: Backend có khoảng 16 endpoint (me, settings, family, children, pregnancies, billing catalog/projection); chưa phát token đăng nhập nên app chưa đăng nhập thật được. Chưa có storage, Redis, worker. Migration domain chưa áp dụng ở DB local.
- Phân tích / quyết định: Thứ tự đề xuất: migration + seed → auth → storage + media → Redis + worker/outbox → API theo luồng (onboarding/trial → ký ức → nhiệm vụ/Hearts → Circle → Papa & Mama → billing Store → xuất/xoá). Giữ PostgreSQL là nguồn sự thật; không thêm MongoDB lúc này vì inbox/notification đã nằm trong PG.
- Tác động: Không đổi hành vi sản phẩm (chỉ đánh giá). Quyết định thứ tự ảnh hưởng thời điểm app thoát mock.
- Giả thuyết / đo lường: Chưa có dữ liệu đo. Khi luồng onboarding chạy thật mới đo được tỉ lệ hoàn tất onboarding và kích hoạt trial.
- Kết quả / trạng thái: Đã giải thích; chưa triển khai hạng mục nào.
- Theo dõi: Người dùng chọn hạng mục; nếu thêm storage cần quyết định dịch vụ S3 local (MinIO/thay thế) theo rủi ro đặc tả §10.8.
- Session: [BF-20261015-003](SESSIONS.md#bf-20261015-003).

<a id="bf-20261015-004"></a>
## BF-20261015-004 — Quy trình dùng agent ngoài

- Ngày làm: 2026-10-15T19:52:00+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: Có thể gọi agent Gemini (Antigravity) / ChatGPT qua CLI để tiết kiệm token.
- Role: ORCHESTRATOR.
- Vấn đề / mục tiêu: Giảm chi phí token khi phân tích.
- Quan sát: Có `agy` trên máy; chưa thấy CLI ChatGPT.
- Phân tích / quyết định: Dùng cho phần đọc/phân tích độc lập; kết quả agent ngoài được agent chính kiểm lại trước khi kết luận.
- Tác động: Không đổi hành vi sản phẩm; chỉ quy trình làm việc.
- Giả thuyết / đo lường: Chưa có dữ liệu đo.
- Kết quả / trạng thái: Đã ghi nhận.
- Theo dõi: Xác nhận lệnh CLI của ChatGPT.
- Session: [BF-20261015-004](SESSIONS.md#bf-20261015-004).

<a id="bf-20261015-005"></a>
## BF-20261015-005 — Hạ tầng local: schema domain, cache/queue, object storage, mail

- Ngày làm: 2026-10-15 (Asia/Ho_Chi_Minh); entry tạo lúc 2026-10-15T20:00:00+07:00, hoàn thành khoảng 2026-10-15T20:15:00+07:00.
- Yêu cầu: Áp migration + seed DB local; dựng Valkey, MinIO, Mailpit ở baby-storage.
- Role: DEVOPS, DBA, BACKEND, SECURITY_PRIVACY, DATA_ANALYST.
- Vấn đề / mục tiêu: Có nền hạ tầng local để triển khai auth, upload ký ức, hàng đợi và email.
- Quan sát: DB local trước đó chỉ có migration init. Image MinIO chính thức đã ngừng phát hành.
- Phân tích / quyết định: Dùng MinIO bản Chainguard pin digest chỉ cho local; backend chỉ dùng S3 API chuẩn để có thể đổi provider. Bucket ảnh gia đình và nhật ký riêng tách nhau, private; chỉ bf-public cho tải công khai.
- Tác động: Không đổi hành vi sản phẩm. DB local có đủ schema domain và catalog gói/trial 7 ngày từ seed. Dữ liệu riêng tư chưa được ghi vào storage.
- Giả thuyết / đo lường: Chưa có dữ liệu đo.
- Kết quả / trạng thái: Đã triển khai và kiểm tra trên local (xem Session).
- Theo dõi: Quyết định object storage cho production; adapter S3/Redis/SMTP trong backend.
- Session: [BF-20261015-005](SESSIONS.md#bf-20261015-005).

<a id="bf-20261015-006"></a>
## BF-20261015-006 — Adapter cache/object storage/mail cho backend

- Ngày làm: 2026-10-15 (Asia/Ho_Chi_Minh); entry tạo lúc 2026-10-15T19:50:00+07:00, hoàn thành lúc 2026-10-15T20:02:42+07:00.
- Yêu cầu: Thêm adapter Valkey/S3/SMTP, readiness và rate limit lưu ở Valkey trong baby-backend.
- Role: BACKEND, SECURITY_PRIVACY, DEVOPS; QUALITY review qua Codex CLI.
- Vấn đề / mục tiêu: Có lớp hạ tầng để triển khai upload ký ức, OTP/email và rate limit nhiều instance.
- Quan sát: Trước task, backend có biến REDIS/S3/SMTP nhưng không dùng; rate limit chỉ in-memory theo instance. AWS SDK mặc định sinh presigned PUT kèm checksum và không ký content-type.
- Phân tích / quyết định: Dịch vụ phụ trợ là tùy chọn và fail-closed (503), không âm thầm bỏ qua; PostgreSQL vẫn là nguồn sự thật. Presigned PUT ký content-type để app không lưu file khác loại đã được duyệt; giới hạn dung lượng vẫn phải kiểm ở bước complete (§10.2). URL được ký bằng endpoint công khai cho app. Rate limit dùng sliding log trên Valkey cho nhiều instance, dự phòng in-memory khi Valkey lỗi.
- Tác động: Chưa đổi hành vi sản phẩm hay API nghiệp vụ. `/health/ready` có thêm trường `cache`, `objectStorage`. Rate limit dùng chung giữa các replica khi có REDIS_URL. Chưa ghi dữ liệu người dùng vào storage.
- Giả thuyết / đo lường: Chưa có dữ liệu đo.
- Kết quả / trạng thái: Đã triển khai; `npm run check` đạt và integration test đạt với stack local (xem Session).
- Theo dõi: API upload-intent/complete và ký URL xem theo quyền; cache OTP/AccessContext; BullMQ/worker; thêm dịch vụ phụ trợ vào CI.
- Session: [BF-20261015-006](SESSIONS.md#bf-20261015-006).

<a id="bf-20261015-007"></a>
## BF-20261015-007 — Dùng Codex/Antigravity CLI để giảm token

- Ngày làm: 2026-10-15T19:52:17+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: Dùng thêm codex hoặc agy CLI để tra cứu.
- Role: ORCHESTRATOR.
- Vấn đề / mục tiêu: Giảm chi phí token khi tra cứu/review.
- Quan sát: Có `codex` (0.162.1) và `agy` trên máy.
- Phân tích / quyết định: Giao tra cứu/review đọc-only cho codex; agent chính xác minh lại trước khi kết luận.
- Tác động: Không đổi hành vi sản phẩm; chỉ quy trình làm việc.
- Giả thuyết / đo lường: Chưa có dữ liệu đo.
- Kết quả / trạng thái: Đã ghi nhận và áp dụng.
- Theo dõi: Không.
- Session: [BF-20261015-007](SESSIONS.md#bf-20261015-007).

<a id="bf-20261015-008"></a>
## BF-20261015-008 — Chạy adapter dịch vụ phụ trợ trong container API

- Ngày làm: 2026-10-15 (Asia/Ho_Chi_Minh); entry tạo lúc 2026-10-15T20:11:18+07:00, hoàn thành lúc 2026-10-15T20:17:14+07:00.
- Yêu cầu: Tiếp tục sau BF-20261015-006.
- Role: DEVOPS, BACKEND.
- Vấn đề / mục tiêu: API chạy trong Docker dùng được Valkey/MinIO/Mailpit.
- Quan sát: Quy tắc TLS cho production đã chặn compose local khởi động API (fail-fast đúng thiết kế), vì Mailpit không hỗ trợ TLS.
- Phân tích / quyết định: Giữ mặc định an toàn (bắt buộc TLS), thêm opt-out tường minh `SMTP_ALLOW_INSECURE` chỉ bật ở `.env` local.
- Tác động: Không đổi hành vi sản phẩm.
- Giả thuyết / đo lường: Chưa có dữ liệu đo.
- Kết quả / trạng thái: API trong Docker dùng được Valkey/MinIO/Mailpit; readiness và rate limit đã kiểm tra thực tế (xem Session).
- Theo dõi: Chọn hạng mục tiếp theo; cấu hình SMTP TLS thật khi triển khai.
- Session: [BF-20261015-008](SESSIONS.md#bf-20261015-008).

<a id="bf-20261015-009"></a>
## BF-20261015-009 — Upload media và URL xem theo quyền

- Ngày làm: 2026-10-15 (Asia/Ho_Chi_Minh); entry tạo lúc 2026-10-15T20:23:45+07:00, hoàn thành lúc 2026-10-15T20:42:03+07:00.
- Yêu cầu: API upload-intent/complete và ký URL xem media theo quyền (§10.2, §10.5).
- Role: BACKEND, BA, SECURITY_PRIVACY, DBA.
- Vấn đề / mục tiêu: Parent tải ảnh/video/âm thanh trực tiếp lên object storage có kiểm quota gói, và chỉ người có quyền xem mới nhận URL.
- Quan sát: Schema đã có đủ bảng asset/reservation/usage/idempotency/outbox nên không cần migration. Chưa có worker nên asset dừng ở UPLOADED và chưa có biến thể để xem.
- Phân tích / quyết định: Chặn tải lên khi vượt dung lượng gói (402), đúng quy tắc nghiệp vụ "vượt dung lượng gói: chặn tải ảnh/video mới, không xóa gì". Quota giữ chỗ cả 5 % dung sai để không vượt tổng. Chỉ phục vụ biến thể đã xử lý, không phục vụ bản gốc (có thể chứa GPS). Media của ký ức PRIVATE của bạn đời, thư niêm phong và ký ức trong thùng rác không được ký URL; trả 404 để không lộ sự tồn tại. Dedup chỉ dùng nội dung đã xác minh.
- Tác động: API mới cho app thay mock upload; chưa đổi UI mobile. Dữ liệu: asset, reservation, family_usage, idempotency_records, outbox. Quyền riêng tư: URL ký ngắn hạn (PUT 15 phút, part/xem 1 giờ), không trả storage key.
- Giả thuyết / đo lường: Chưa có dữ liệu đo.
- Kết quả / trạng thái: Đã triển khai và kiểm thử trên stack local (xem Session). Chưa đo hành vi người dùng.
- Theo dõi: Khi có worker và app nối API, có thể đo tỉ lệ upload complete/intent, tỉ lệ FAILED theo lý do, số lần chạm quota (402) theo gói. Chưa thêm tracking.
- Session: [BF-20261015-009](SESSIONS.md#bf-20261015-009).

<a id="bf-20261015-010"></a>
## BF-20261015-010 — Xử lý media nền và dọn upload mồ côi

- Ngày làm: 2026-10-15 (Asia/Ho_Chi_Minh); entry tạo lúc 2026-10-15T20:51:13+07:00, hoàn thành lúc 2026-10-15T21:42:45+07:00.
- Yêu cầu: Worker media (xác minh SHA-256, biến thể, READY), purge-orphans, reconcile-uploads; người dùng duyệt thư mục `workers/`.
- Role: BACKEND, DEVOPS, DBA, SECURITY_PRIVACY.
- Vấn đề / mục tiêu: Ảnh/video/âm thanh đã tải lên được xử lý thành bản xem được, bỏ metadata vị trí; upload bỏ dở không giữ quota mãi.
- Quan sát: Trước task, asset dừng ở UPLOADED và không có bản xem; upload bỏ dở giữ quota mãi. Bucket media bật versioning nên ghi đè/xóa thường vẫn giữ bản thô (có GPS) 30 ngày.
- Phân tích / quyết định: Mọi bản phục vụ người dùng không có metadata vị trí; bản thô bị xóa mọi version sau khi xử lý xong. Gói có quyền lợi giữ bản gốc (`media.keepOriginal`, đọc từ catalog, không theo tên gói) giữ nguyên pixel. Nội dung sai hash, hỏng hoặc vượt thời lượng gói bị đánh FAILED, không retry. Upload hết hạn/FAILED được dọn và hoàn quota; dọn asset chưa gắn ký ức tạm tắt để không xóa ảnh người dùng khi chưa có API tạo ký ức.
- Tác động: Ảnh/video/âm thanh tải lên có thể chuyển READY và có URL xem (BF-20261015-009). Quyền riêng tư: GPS/EXIF bị loại khỏi mọi bản lưu trữ phục vụ. Vận hành: thêm container worker; Valkey giữ hàng đợi, PostgreSQL giữ lịch sử job.
- Giả thuyết / đo lường: Chưa có dữ liệu đo.
- Kết quả / trạng thái: Đã triển khai và kiểm thử trên stack local (xem Session). Chưa đo hành vi người dùng.
- Theo dõi: Khi app nối API có thể đo thời gian từ complete tới READY, tỉ lệ FAILED theo mã lỗi, số job retry/hết lượt, dung lượng hoàn trả từ purge. Chưa thêm tracking; cần monitoring/alert cho job FAILED và outbox tồn lâu.
- Session: [BF-20261015-010](SESSIONS.md#bf-20261015-010).

<a id="bf-20261015-011"></a>
## BF-20261015-011 — Commit hạ tầng media/worker

- Ngày làm: 2026-10-15 (Asia/Ho_Chi_Minh); entry tạo lúc 2026-10-15T21:45:26+07:00, dừng lúc 2026-10-15T21:46:26+07:00.
- Yêu cầu: Commit thay đổi BF-20261015-006 → 010 trên branch mới.
- Role: DEVOPS, QUALITY.
- Vấn đề / mục tiêu: Lưu lại công việc đã kiểm thử thành lịch sử git để review/merge.
- Quan sát: Thay đổi 006–010 phụ thuộc phần chưa commit của TS7 và BF-005.
- Phân tích / quyết định: Người dùng tự commit; task commit được hủy.
- Tác động: Không đổi hành vi sản phẩm.
- Giả thuyết / đo lường: Chưa có dữ liệu đo.
- Kết quả / trạng thái: Đã hủy theo yêu cầu, không commit.
- Theo dõi: Không.
- Session: [BF-20261015-011](SESSIONS.md#bf-20261015-011).

<a id="bf-20261015-012"></a>
## BF-20261015-012 — Đăng nhập/onboarding thật và app thoát mock

- Ngày làm: 2026-10-15 → 2026-10-16 (Asia/Ho_Chi_Minh); hoàn thành khoảng 2026-10-16T05:00:00+07:00.
- Yêu cầu: Tiếp tục tính năng backend và nối API với mobile.
- Role: ARCHITECT, BACKEND, MOBILE, INTEGRATION, SECURITY_PRIVACY, BA, DATA_ANALYST.
- Vấn đề / mục tiêu: Người dùng phải đăng nhập, tạo gia đình, mời bạn đời và kích hoạt dùng thử thật thay vì mock.
- Quan sát: Trước đợt này backend không phát token, app gọi 3 endpoint không tồn tại; giờ luồng AUTH-01→ONB-ACT chạy với server local.
- Phân tích / quyết định: OTP số điện thoại trước (Apple/Google cần credential). Server là nguồn sự thật cho phiên, vai trò, gia đình, lời mời và quyền lợi; app chỉ phản chiếu. Mặc định “xác nhận lần cuối” bật (§7.3). Trial cấp tự động một lần mỗi người/identity (BR-054), không phụ thuộc người mua.
- Tác động: Đổi hành vi khi chạy với `BABY_FAMILY_API_URL`: đăng nhập/onboarding thật; bản mock giữ nguyên. API đổi sang envelope `{data}`. Không ghi số điện thoại thô vào cache/log (HMAC); mã mời chỉ lưu hash.
- Giả thuyết / đo lường: Chưa có dữ liệu đo. Khi có analytics (§27.3) nên đo: tỉ lệ hoàn tất OTP, % gửi lời mời bạn đời trong 7 ngày (mục tiêu ≥ 50%), % lời mời được chấp nhận trong 7 ngày (≥ 60%), tỉ lệ bị từ chối ở bước xác nhận lần cuối.
- Kết quả / trạng thái: Đã triển khai và kiểm chứng local (xem Session).
- Theo dõi: Apple/Google; Circle; ONB-04/05 lên server; i18n message lỗi; quyết định có cần sự kiện analytics cho funnel onboarding.
- Session: [BF-20261015-012](SESSIONS.md#bf-20261015-012).

<a id="bf-20261016-001"></a>
## BF-20261016-001 — Tự lập lộ trình tích hợp backend ↔ app

- Ngày làm: 2026-10-16 (Asia/Ho_Chi_Minh).
- Yêu cầu: Tự vạch task tiếp, làm cả backend và frontend, không hỏi lại.
- Role: ORCHESTRATOR/PM, BACKEND, MOBILE, DATA_ANALYST.
- Vấn đề / mục tiêu: Tiến tới app dùng dữ liệu thật theo thứ tự phụ thuộc mà không cần người dùng duyệt từng bước.
- Quan sát: Đăng nhập/onboarding là phụ thuộc đầu tiên của mọi tính năng; các domain khác (ký ức, nhiệm vụ, Papa & Mama) cần family ACTIVE thật.
- Phân tích / quyết định: Thứ tự đề xuất tiếp: ONB-04/05 + Bé/thai kỳ → Ký ức + upload → Nhiệm vụ/Hearts → Người thân → Papa & Mama → Store billing.
- Tác động: Không đổi thêm hành vi ngoài BF-20261015-012.
- Giả thuyết / đo lường: Chưa có dữ liệu đo.
- Kết quả / trạng thái: Hoàn thành đợt 1 (BF-20261015-012).
- Theo dõi: Đợt 2 theo thứ tự trên.
- Session: [BF-20261016-001](SESSIONS.md#bf-20261016-001).

<a id="bf-20261016-002"></a>
## BF-20261016-002 — Bé/Thai kỳ và Ký ức có ảnh dùng dữ liệu thật

- Ngày làm: 2026-10-16T06:09:59+07:00 → 2026-10-16T06:56:02+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: Tích hợp đợt 2: tạo/sửa bé, thai kỳ và đăng/xem ký ức có ảnh qua API.
- Role: ARCHITECT, BACKEND, MOBILE, INTEGRATION, SECURITY_PRIVACY, QUALITY.
- Vấn đề / mục tiêu: Sau onboarding thật, hồ sơ bé và ký ức (giá trị cốt lõi) vẫn ghi mock; cần lưu server để hai cha mẹ cùng thấy và không mất khi đổi máy.
- Quan sát: Trước đợt này app không có photo picker và chỉ hiển thị ảnh mẫu trong app; backend có upload/worker nhưng chưa có API ký ức. Nay luồng tạo bé → chọn ảnh → đăng → feed chạy với server local.
- Phân tích / quyết định: Server là nguồn sự thật cho bé/thai kỳ (`bootstrap.subjects`) và ký ức (feed). Ký ức có ảnh hiển thị ngay cho người đăng từ file trên máy, bạn đời chỉ thấy khi server xử lý xong (`PUBLISHED`) — tránh ảnh vỡ. Gói không có Circle lưu “Cả nhà” thành “Chỉ Papa & Mama” (§11.5 (4)); giới hạn số ảnh theo catalog gói. Chỉ mở các loại ký ức chưa cần workflow riêng (Ảnh, Nhật ký, Kỷ vật, Câu nói).
- Tác động: Đổi hành vi khi chạy với `BABY_FAMILY_API_URL`: bé/thai kỳ và ký ức loại trên lưu server; bản mock không đổi. API mới `/memories`, `/families/:fid/feed`; outbox `memory.created`/`memory.published` (chưa có consumer). Quyền riêng tư: ảnh không qua API server, chỉ phát URL ký của biến thể đã bỏ metadata; ký ức người khác ẩn/không tồn tại đều 404; thư niêm phong không lộ metadata.
- Giả thuyết / đo lường: Chưa có dữ liệu đo. Khi có analytics (§27.3) nên đo: thời gian từ kích hoạt tới ký ức đầu tiên, % gia đình có ≥ 1 ký ức có ảnh trong 7 ngày dùng thử, tỉ lệ đăng lỗi/thử lại, thời gian `PROCESSING → PUBLISHED`.
- Kết quả / trạng thái: Đã triển khai và kiểm chứng local (xem Session); chưa đo sản phẩm.
- Theo dõi: Các điểm review còn mở (gỡ ký ức bị xoá, dedup ảnh giữa hai Parent, đọc khi EXPIRED, quota `memoryCount`, phân trang feed, tự làm mới khi đang xử lý); video/ghi âm/ảnh tháng; số liệu “Tuần này” còn là dữ liệu mẫu.
- Session: [BF-20261016-002](SESSIONS.md#bf-20261016-002).

<a id="bf-20261017-001"></a>
## BF-20261017-001 — Ảnh trùng giữa hai Parent, đọc khi hết hạn, quota ký ức và đồng bộ feed

- Ngày làm: 2026-10-17T00:49:54+07:00 → 2026-10-17T01:02:49+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: Xử lý 6 điểm review còn mở của BF-20261016-002 (dedup ảnh giữa hai Parent, đọc ký ức khi gói hết hạn, quota `memoryCount`, phân trang feed app, gỡ ký ức đã xoá/ẩn, tự làm mới ký ức đang xử lý).
- Role: BACKEND, DBA, SECURITY_PRIVACY, MOBILE, TESTER, QUALITY (tự review).
- Vấn đề / mục tiêu: (a) Khi bố/mẹ chọn cùng một ảnh mà người kia đã tải, đăng ký ức thất bại (`MEMORY_ASSET_INVALID`); (b) gia đình hết gói không mở được ký ức để tải dữ liệu về (§6.5); (c) gói có giới hạn số ký ức chưa được thực thi; (d) app chỉ thấy 50 ký ức mới nhất, vẫn hiện ký ức đã bị xoá/ẩn, và ảnh đang xử lý không tự hiện khi đứng yên màn hình.
- Quan sát: Index dedup cũ gom theo cả gia đình; dedup trả id asset của người kia kể cả khi nó nằm trong ký ức riêng tư hoặc chưa gắn ký ức (lộ tín hiệu "người kia có ảnh này"). Catalog seed hiện không có key `memoryCount`. App đồng bộ feed một trang, không có cơ chế xoá bản sao.
- Phân tích / quyết định: Dedup theo người tải; chỉ dùng chung bản `READY` mà người tải đã được xem (ACL §6.3) — biết SHA-256 không cấp quyền xem. Đổi index là DDL (migration mới, không sửa migration cũ). Mode `download` chỉ mở `GET /memories/:id` + URL ký; các API nghiệp vụ khác vẫn 402. `memoryCount` thiếu = không giới hạn, có thì kiểm/cộng nguyên tử. App: đồng bộ đủ trang + đối soát định kỳ (2 phút), hỏi lại khi còn ký ức PROCESSING (tối đa 10 phút) và trước khi URL hết hạn; dừng khi không còn gì cần làm mới hoặc không còn màn nào xem.
- Tác động: Đăng ảnh trùng giữa hai Parent không còn lỗi; ảnh trùng với nội dung riêng tư/chưa chia sẻ của người kia tốn thêm dung lượng (mỗi người một bản) — đánh đổi có chủ đích vì quyền riêng tư. Gia đình hết hạn xem được chi tiết ký ức và ảnh. Gói nào đặt `memoryCount` sẽ bị chặn 402 `QUOTA_MEMORY_COUNT_EXCEEDED`. App phản ánh đúng ký ức bị xoá/ẩn sau ≤ 2 phút, ảnh xử lý xong tự hiện sau ~10 giây; số request feed tăng theo số trang mỗi 2 phút. Bản mock không đổi hành vi.
- Giả thuyết / đo lường: Chưa có dữ liệu đo. Khi có analytics nên theo dõi: tỉ lệ lỗi `MEMORY_ASSET_INVALID`/`QUOTA_MEMORY_COUNT_EXCEEDED` khi đăng ký ức, tỉ lệ upload được dedup, số request feed/phiên và thời gian từ đăng tới khi ảnh hiện trên máy bạn đời.
- Kết quả / trạng thái: Đã triển khai, kiểm chứng bằng test tự động (xem Session); chưa chạy trên simulator, chưa đo sản phẩm.
- Theo dõi: Áp migration cho môi trường dev/staging; trừ `memory_count` khi có API xoá; `download-urls`/`media-grid` cho gói hết hạn; cân nhắc delta-sync/tombstone (`sync_tombstones`) thay cho quét đủ trang khi số ký ức lớn.
- Session: [BF-20261017-001](SESSIONS.md#bf-20261017-001).

<a id="bf-20261018-001"></a>
## BF-20261018-001 — Checklist toàn bộ tính năng và tự bắt đầu làm task

- Ngày làm: 2026-10-18T07:25:28+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Hãy liệt kê tất cả các tính năng cần làm vào 1 file document sau đó nếu làm được xong tính năng nào thì tick vào đã xong tính năng đó cho t. Tự start với các task cho tôi nha."
- Liên quan: BF-20261017-001.
- Role: PM/BA (phạm vi, ưu tiên theo §16.1), BACKEND, MOBILE, SECURITY_PRIVACY, TESTER, QUALITY.
- Vấn đề / mục tiêu: Người dùng cần một nơi theo dõi toàn bộ tính năng và tiến độ thật (khác UI mock); bắt đầu lấp phần MVP còn thiếu theo vòng lặp Ký ức. Task đầu: xoá ký ức trên app chế độ server chỉ xoá trên máy, bạn đời vẫn thấy; không có thùng rác/khôi phục trên server.
- Quan sát: 28/159 dòng checklist đã xong sau task (trước: 26). Thùng rác: đặc tả §7.8.3/MEM-17 (30 ngày, Parent thấy mọi ký ức bị xoá của gia đình), §6.2 `canDeleteMemory`.
- Phân tích / quyết định: Checklist tick chỉ khi BE + App + kiểm chứng. Thùng rác theo đúng đối tượng xem §6.3 (không lộ ký ức riêng tư của bạn đời); ảnh thu nhỏ trong thùng rác vẫn ký được tới khi hết hạn (đổi quyết định cũ “thùng rác không phải view”); xoá trả lại 1 lượt quota `memoryCount`, khôi phục kiểm lại quota; xoá hẳn tự động mỗi giờ, asset không còn ký ức nào dùng được thu hồi dung lượng.
- Tác động: Chế độ server: xoá ký ức có hiệu lực cho cả hai Parent, khôi phục được trong 30 ngày, xoá vĩnh viễn giải phóng dung lượng gói. API mới: 4 route thùng rác; outbox `memory.trashed/restored/purged`. Bản mock không đổi.
- Giả thuyết / đo lường: Chưa có dữ liệu đo. Gợi ý: tỉ lệ ký ức bị xoá, tỉ lệ khôi phục trong 30 ngày, dung lượng thu hồi từ xoá vĩnh viễn.
- Kết quả / trạng thái: Đã triển khai + test tự động; chưa chạy trên simulator, chưa đo. Kết thúc 2026-10-18T07:41:40+07:00.
- Theo dõi: Task kế tiếp MEM-09 sửa ký ức; cập nhật checklist sau mỗi task.
- Session: [BF-20261018-001](SESSIONS.md#bf-20261018-001).

<a id="bf-20261018-002"></a>
## BF-20261018-002 — MEM-09 sửa ký ức (màn sửa + PATCH /memories/:id If-Match)

- Ngày làm: 2026-10-18T07:49:33+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp task kế tiếp trong checklist: MEM-09 sửa ký ức (màn sửa + PATCH /memories/:id If-Match), xong thì tick checklist."
- Liên quan: BF-20261018-001.
- Role: BACKEND, MOBILE, SECURITY_PRIVACY, DESIGN, TESTER, QUALITY.
- Vấn đề / mục tiêu: Người dùng không sửa được ký ức đã đăng (gõ sai chú thích, gắn nhầm bé, chọn sai người xem) — phải xoá và đăng lại.
- Quan sát: Đặc tả §7.8.3, §6.2 `canEditMemory`, §13.3 (hai người sửa cùng lúc: người lưu sau thắng từng trường); trước task app không có màn MEM-09.
- Phân tích / quyết định: Dùng lại form MEM-05; tác giả sửa nội dung + ngày + bé + người xem, bạn đời chỉ bé + người xem (không ẩn ký ức của người kia thành riêng tư); `If-Match` chống ghi đè mù, app chỉ gửi trường đã đổi để trường người kia vừa sửa không bị ghi đè. Chưa cho đổi ảnh khi sửa (cần luồng upload + quota riêng).
- Tác động: Chế độ server và mock: MEM-07 ⋯ có “Sửa ký ức”. API mới `PATCH /memories/:id`; outbox `memory.updated`.
- Giả thuyết / đo lường: Chưa có dữ liệu đo. Gợi ý: số lần sửa/ký ức, tỉ lệ xoá-rồi-đăng-lại giảm, tỉ lệ lỗi 412.
- Kết quả / trạng thái: Đã triển khai + test tự động; chưa chạy simulator, chưa đo. Kết thúc 2026-10-18T08:02:17+07:00.
- Theo dõi: Đổi ảnh khi sửa; cảnh báo người thân mất quyền xem khi có Circle; task kế tiếp MEM-10.
- Session: [BF-20261018-002](SESSIONS.md#bf-20261018-002).

<a id="bf-20261018-003"></a>
## BF-20261018-003 — Bình luận + cảm xúc trên ký ức (MEM-10, §7.12)

- Ngày làm: 2026-10-18T08:03:32+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp task kế tiếp trong checklist: bình luận + cảm xúc trên ký ức (MEM-10, §7.12), xong thì tick checklist."
- Liên quan: BF-20261018-002.
- Role: BACKEND, MOBILE, SECURITY_PRIVACY, TESTER, QUALITY.
- Vấn đề / mục tiêu: Ở chế độ server, bình luận và thả cảm xúc chỉ lưu trên máy — bạn đời không thấy; mock còn cho thả nhiều lần (sai đặc tả 7.12).
- Quan sát: Đặc tả 7.12, MEM-10; tài liệu kỹ thuật bảng route MEM-07/10; schema có sẵn bảng.
- Phân tích / quyết định: 1 cảm xúc/người (chạm lại để bỏ); trả lời của trả lời gắn vào bình luận gốc; Parent xoá được mọi bình luận, trả lời đi theo; quyền đọc/ghi = xem được ký ức.
- Tác động: Chế độ server: bình luận/cảm xúc đồng bộ giữa hai Parent; mock: cảm xúc không còn cộng dồn. API mới 6 route; outbox `comment.*`, `reaction.changed`.
- Giả thuyết / đo lường: Chưa có dữ liệu đo. Gợi ý: % ký ức có ≥ 1 cảm xúc/bình luận của bạn đời trong 24 giờ (tín hiệu gắn kết).
- Kết quả / trạng thái: Đã triển khai + test tự động; chưa đo. Kết thúc 2026-10-18T08:21:50+07:00.
- Theo dõi: công tắc tắt bình luận trên app; thông báo gộp khi có consumer outbox.
- Session: [BF-20261018-003](SESSIONS.md#bf-20261018-003).

<a id="bf-20261018-004"></a>
## BF-20261018-004 — Giao thêm task song song cho Codex

- Ngày làm: 2026-10-18 (Asia/Ho_Chi_Minh), gửi giữa lúc làm BF-20261018-003; ghi lúc 2026-10-18T08:21:50+07:00.
- Yêu cầu: "Hiện tại t đang thấy bạn đang làm từng task một, tôi cần bạn giao thêm task cho với codex nữa cho nhanh đi, đừng ôm một mình như thế."
- Liên quan: BF-20261018-003.
- Role: ORCHESTRATOR, BACKEND (Codex CLI), SECURITY_PRIVACY, QUALITY, TESTER.
- Vấn đề / mục tiêu: Tăng tốc lấp checklist bằng cách chạy song song agent ngoài (Codex) cho các module độc lập.
- Quan sát: Hai module Papa & Mama (check-in, lời nhờ) có đặc tả chi tiết và bảng riêng, không chạm module ký ức Claude đang làm.
- Phân tích / quyết định: Riêng tư là ràng buộc chính của Papa & Mama (§6.4 bất biến 6, 7, 9): bạn đời chỉ thấy trường được chia sẻ, “Khó chịu với bạn đời” không bao giờ gửi đi, ghi chú/lời nhắn mã hoá, Hearts chỉ chủ sở hữu thấy, Circle không bao giờ thấy.
- Tác động: Backend có API US-02 và US-03/04; app chưa dùng nên chưa đổi hành vi người dùng.
- Giả thuyết / đo lường: Chưa có dữ liệu đo. Khi có app: tỉ lệ check-in được chia sẻ, thời gian phản hồi lời nhờ, tỉ lệ DONE/DECLINED (không dùng để so sánh bố–mẹ, §1.3).
- Kết quả / trạng thái: Backend xong + test; app chưa nối. Kết thúc 2026-10-18T08:28:15+07:00.
- Theo dõi: App US-01…07; job hết hạn; DEK cho dữ liệu riêng tư.
- Session: [BF-20261018-004](SESSIONS.md#bf-20261018-004).

<a id="bf-20261018-005"></a>
## BF-20261018-005 — Song song: Codex làm timeline + lưới ảnh (MEM-01/02), Claude nối app Papa & Mama (US-01…04)

- Ngày làm: 2026-10-18T08:29:18+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Đợt tiếp: Codex làm backend timeline + lưới ảnh (MEM-01/02), còn bạn nối app Papa & Mama (US-01/02/03/04) với API vừa có. Xong thì tick checklist."
- Liên quan: BF-20261018-004.
- Role: ORCHESTRATOR, MOBILE, BACKEND (Codex CLI), SECURITY_PRIVACY, QUALITY, TESTER.
- Vấn đề / mục tiêu: Papa & Mama trên app chế độ server vẫn chỉ lưu trên máy (bạn đời không nhận được check-in/lời nhờ); timeline/lưới ảnh chưa có API.
- Quan sát: Đặc tả §7.16.1–7.16.2, §7.10; API US-02/03/04 đã có từ BF-20261018-003/004.
- Phân tích / quyết định: Ghi chú check-in không chia sẻ mặc định; lời nhờ giữ Idempotency-Key khi gửi lại; lỗi giới hạn hiển thị bằng câu trung tính (không “phạt”). Timeline sắp theo ngày xảy ra, lưới ảnh vẫn mở khi hết gói để tải dữ liệu.
- Tác động: Chế độ server: hai Parent thấy check-in đã chia sẻ và lời nhờ của nhau, Hearts lời nhờ do server ghi. Backend có API timeline/lưới ảnh (app chưa dùng). Bản mock không đổi.
- Giả thuyết / đo lường: Chưa có dữ liệu đo. Gợi ý: tỉ lệ check-in được chia sẻ, thời gian từ gửi đến nhận lời nhờ, tỉ lệ lời nhờ DONE (không so sánh bố–mẹ).
- Kết quả / trạng thái: Đã triển khai + test tự động; chưa chạy simulator, chưa đo. Kết thúc 2026-10-18T08:41:12+07:00.
- Theo dõi: app MEM-01/02; câu hỏi hôm nay, cảm ơn; phản hồi nhanh check-in.
- Session: [BF-20261018-005](SESSIONS.md#bf-20261018-005).

<a id="bf-20261018-006"></a>
## BF-20261018-006 — Song song: Codex làm backend Nhiệm vụ hằng ngày, Claude nối app MEM-01/02

- Ngày làm: 2026-10-18T08:42:08+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Đợt tiếp: Codex làm backend Nhiệm vụ hằng ngày (catalog + bày bảng + CARE-01…06 API), còn bạn nối app MEM-01/02 với API timeline/lưới ảnh. Xong thì tick checklist."
- Liên quan: BF-20261018-005.
- Role: ORCHESTRATOR, MOBILE, BACKEND (Codex CLI), SECURITY_PRIVACY, QUALITY, TESTER.
- Vấn đề / mục tiêu: Timeline/lưới ảnh trên app chế độ server cần nguồn theo ngày xảy ra từ server; Nhiệm vụ hằng ngày (trụ cột thứ hai của vòng lặp MVP) chưa có backend.
- Quan sát: Đặc tả §7.10, §7.13, §7.14.1; kỹ thuật §15.1–15.5; schema có sẵn bảng nhiệm vụ/Hearts với CHECK giới hạn định mức 2–4, đổi tối đa 3, việc tự thêm 2 Hearts.
- Phân tích / quyết định: Bảng chia đều hai Parent, Hearts riêng tư (bạn đời không thấy), không có “làm hộ” (BR-024), trần Hearts/ngày là một cấu hình chung. Timeline theo ngày xảy ra, lưới ảnh dùng ảnh thu nhỏ để nhẹ.
- Tác động: App chế độ server: MEM-01/02 lấy từ API. Backend có API Nhiệm vụ (app chưa dùng). Bản mock không đổi.
- Giả thuyết / đo lường: Chưa có dữ liệu đo. Gợi ý khi có app Nhiệm vụ: % ngày cả hai cùng có ít nhất 1 việc xong, tỉ lệ đổi nhiệm vụ, tỉ lệ hoàn tác (không xếp hạng bố–mẹ, §1.3).
- Kết quả / trạng thái: Đã triển khai + test tự động; chưa chạy simulator, chưa đo. Kết thúc 2026-10-18T08:56:29+07:00.
- Theo dõi: app CARE-01…06; job bày bảng; mở rộng catalog ≥ 90 ngày.
- Session: [BF-20261018-006](SESSIONS.md#bf-20261018-006).

<a id="bf-20261018-007"></a>
## BF-20261018-007 — Song song: Codex làm backend Cảm ơn US-05/06 + Nhật ký riêng US-07, Claude nối app Nhiệm vụ CARE-01…06

- Ngày làm: 2026-10-18T08:57:24+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Đợt tiếp: Codex làm backend Cảm ơn US-05/06 + Nhật ký riêng US-07, còn bạn nối app Nhiệm vụ CARE-01…06 với API vừa có. Xong thì tick checklist."
- Liên quan: BF-20261018-006.
- Role: ORCHESTRATOR, MOBILE, BACKEND (Antigravity CLI), SECURITY_PRIVACY, QUALITY, TESTER.
- Vấn đề / mục tiêu: Nhiệm vụ trên app chế độ server cần chạy thật giữa hai Parent; Lời cảm ơn và Nhật ký riêng chưa có backend.
- Quan sát: API Nhiệm vụ có từ BF-20261018-006; đặc tả §7.13, §7.16.3–7.16.4.
- Phân tích / quyết định: Nhiệm vụ của bạn đời không lộ Hearts, không giao việc cho bạn đời (BR-020/024); nhật ký riêng chỉ người viết đọc, chia sẻ đúng đoạn đã xem trước; khoảnh khắc gia đình từ lời cảm ơn cần bạn đời đồng ý.
- Tác động: App chế độ server: bảng nhiệm vụ do server bày và chia đều, hoàn thành/đổi/bỏ đồng bộ hai máy. Backend có API cảm ơn + nhật ký riêng (app chưa dùng). Bản mock không đổi.
- Giả thuyết / đo lường: Chưa có dữ liệu đo. Gợi ý: % ngày cả hai cùng có việc xong; số lời cảm ơn/tuần (không biến thành chỉ tiêu, §7.16.3 gợi ý tối đa 2–3 lần/tuần).
- Kết quả / trạng thái: Đã triển khai + test tự động; chưa chạy simulator, chưa đo. Kết thúc 2026-10-18T09:22:08+07:00.
- Theo dõi: app US-05/06/07; Hearts/cây gia đình; lưu khoảnh khắc từ nhiệm vụ.
- Session: [BF-20261018-007](SESSIONS.md#bf-20261018-007).

<a id="bf-20261018-008"></a>
## BF-20261018-008 — Dùng thêm Antigravity; Codex hết quota

- Ngày làm: 2026-10-18 (Asia/Ho_Chi_Minh), hai tin nhắn gửi giữa lúc làm BF-20261018-007; ghi lúc 2026-10-18T09:22:08+07:00.
- Yêu cầu: "Dùng thêm antigravity nữa" và "codex hết quota rùi".
- Liên quan: BF-20261018-007.
- Role: ORCHESTRATOR.
- Vấn đề / mục tiêu: Giữ tốc độ làm song song khi Codex hết quota.
- Quan sát / quyết định: Dùng Antigravity với allowlist lệnh hẹp do người dùng chọn.
- Tác động: Không đổi hành vi sản phẩm.
- Giả thuyết / đo lường: Chưa có dữ liệu đo.
- Kết quả / trạng thái: Hoàn thành.
- Theo dõi: Không.
- Session: [BF-20261018-008](SESSIONS.md#bf-20261018-008).

<a id="bf-20261018-009"></a>
## BF-20261018-009 — Song song: Antigravity làm backend Hearts/Cây gia đình/Huy hiệu/CARE-08, Claude nối app Cảm ơn US-05/06 + Nhật ký riêng US-07

- Ngày làm: 2026-10-18T14:53:54+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Đợt tiếp: Antigravity làm backend Hearts/Cây gia đình/Huy hiệu (đọc Hearts của tôi, cây, badge, lịch sử nhiệm vụ CARE-08), còn bạn nối app Cảm ơn US-05/06 + Nhật ký riêng US-07. Xong thì tick checklist."
- Liên quan: BF-20261018-008.
- Role: ORCHESTRATOR, MOBILE, BACKEND (Antigravity CLI), SECURITY_PRIVACY, QUALITY, TESTER.
- Vấn đề / mục tiêu: Cảm ơn và nhật ký riêng trên app chế độ server chỉ lưu trên máy; Hearts/cây/huy hiệu/lịch sử chưa có API đọc.
- Quan sát: Đặc tả §7.14, §7.16.3–7.16.4; bất biến §6.4 (Hearts riêng tư, nhật ký chỉ người viết).
- Phân tích / quyết định: Hearts chỉ người gọi xem; cây gia đình chỉ cấp + %; nhật ký riêng không ai khác đọc; chia sẻ đúng đoạn đã xem trước.
- Tác động: App chế độ server: lời cảm ơn hai chiều và nhật ký riêng lưu server; 💛 trên việc bạn đời gửi lời cảm ơn thật. Backend có API Hearts/cây/huy hiệu/lịch sử (app chưa dùng). Bản mock không đổi.
- Giả thuyết / đo lường: Chưa có dữ liệu đo. Gợi ý: số lời cảm ơn/tuần/cặp, % nhật ký có chia sẻ đoạn (không đọc nội dung).
- Kết quả / trạng thái: Đã triển khai + test tự động; chưa chạy simulator, chưa đo. Kết thúc 2026-10-18T15:31:14+07:00.
- Theo dõi: app CARE-08/09/10 + Hearts; ảnh nhật ký.
- Session: [BF-20261018-009](SESSIONS.md#bf-20261018-009).

<a id="bf-20261018-010"></a>
## BF-20261018-010 — Giao thêm task cho Codex (đã có quota): backend Thông báo NOTI-01

- Ngày làm: 2026-10-18 (Asia/Ho_Chi_Minh). Giờ bắt đầu ghi lúc mở entry đã mất: entry mở đầu bị xoá nhầm khi script của Claude cập nhật BF-20261018-009 (cắt phần sau entry); ghi lại đầy đủ lúc 2026-10-18T15:32:12+07:00, không đoán giờ gốc.
- Yêu cầu: "Giao thêm task cho codex nữa đi codex đang rảnh kìa"
- Liên quan: BF-20261018-009.
- Role: ORCHESTRATOR, BACKEND (Codex CLI), SECURITY_PRIVACY, QUALITY.
- Vấn đề / mục tiêu: Hai Parent không biết khi người kia bình luận, thả cảm xúc, gửi lời nhờ, chia sẻ trạng thái hay cảm ơn.
- Quan sát: Đặc tả §7.21; kỹ thuật §13.
- Phân tích / quyết định: Hộp thư trong app trước, push sau; nhóm nhạy cảm không lưu nội dung; gộp tương tác 30 phút; giờ yên tĩnh/trần 3/ngày chỉ ảnh hưởng push.
- Tác động: Backend tạo thông báo trong app từ sự kiện thật; API hộp thư. Không đổi bản mock.
- Giả thuyết / đo lường: Chưa có dữ liệu đo. Gợi ý: tỉ lệ mở thông báo, thời gian từ lời nhờ đến lúc nhận.
- Kết quả / trạng thái: Đã triển khai + test tự động. Kết thúc 2026-10-18T15:32:12+07:00.
- Theo dõi: push; purge 90 ngày.
- Session: [BF-20261018-010](SESSIONS.md#bf-20261018-010).

<a id="bf-20261018-011"></a>
## BF-20261018-011 — Làm tiếp: nối app hộp thông báo NOTI-01, hoàn tất đợt Antigravity/Codex

- Ngày làm: 2026-10-18 (Asia/Ho_Chi_Minh). Giờ bắt đầu ghi lúc mở entry đã mất: entry mở đầu bị xoá nhầm khi script của Claude cập nhật BF-20261018-009 (cắt phần sau entry); ghi lại đầy đủ lúc 2026-10-18T15:32:12+07:00, không đoán giờ gốc.
- Yêu cầu: "Làm tiếp đi"
- Liên quan: BF-20261018-009, BF-20261018-010.
- Role: ORCHESTRATOR, MOBILE, QUALITY, TESTER.
- Vấn đề / mục tiêu: App hiển thị hộp thông báo thật thay cho dữ liệu mẫu ở chế độ server.
- Quan sát: API NOTI-01 từ BF-20261018-010.
- Phân tích / quyết định: Câu thông báo dựng ở app theo ngôn ngữ người dùng; nội dung nhạy cảm không có trên server nên câu chỉ nêu tên người gửi.
- Tác động: Chế độ server: chuông/hộp thông báo dùng dữ liệu thật, đánh dấu đã đọc đồng bộ. Bản mock không đổi.
- Giả thuyết / đo lường: Chưa có dữ liệu đo.
- Kết quả / trạng thái: Đã triển khai + test tự động; chưa chạy simulator. Kết thúc 2026-10-18T15:32:12+07:00.
- Theo dõi: push.
- Session: [BF-20261018-011](SESSIONS.md#bf-20261018-011).

<a id="bf-20261018-012"></a>
## BF-20261018-012 — Song song: Codex làm Xoá tài khoản + Xuất dữ liệu, Antigravity làm Lịch & sự kiện, Claude nối app CARE-08/09/10 + Hearts

- Ngày làm: 2026-10-18T16:02:47+07:00 → 2026-10-18T20:32+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Đợt tiếp: Codex làm backend Xoá tài khoản + Xuất dữ liệu (§7.25), Antigravity làm backend Lịch & sự kiện CARE-07/CAL-02, còn bạn nối app Hearts/Cây/Huy hiệu/Lịch sử CARE-08/09/10. Xong thì tick checklist."
- Liên quan: BF-20261018-009 (backend Hearts/Cây/Huy hiệu), BF-20261018-011.
- Vấn đề/mục tiêu: hoàn thiện các tính năng bắt buộc của Store (xoá tài khoản, xuất dữ liệu), nền lịch gia đình, và hiển thị tiến độ chăm sóc (Hearts riêng, cây, huy hiệu, lịch sử) từ dữ liệu server.
- Tác động sản phẩm/dữ liệu: người dùng xem Hearts của chính mình, cây và huy hiệu của gia đình từ server; backend có luồng xoá có thời gian chờ và xuất dữ liệu; lịch có âm lịch. Chưa đổi hành vi app cho lịch/xoá/xuất.
- Quyết định và cơ sở: giữ bất biến riêng tư — Hearts chỉ cho người gọi; việc của bạn đời không có Hearts; export FAMILY không có nhật ký riêng/Hearts; Circle không thấy sự kiện `COUPLE` và nhiệm vụ. Không tick xoá tài khoản/CAL-02/CARE-10 vì backend chưa đủ (thiếu reauth token, job nhắc, worker huy hiệu).
- Cách kiểm chứng/đo lường: test tự động (app 719, backend unit 218, e2e 35, integration 208) có ca riêng tư. Chưa có dữ liệu đo sử dụng.
- Kết quả: checklist 47/165.
- Việc cần theo dõi: API reauth token để mở luồng xoá tài khoản; job gửi nhắc sự kiện; worker trao huy hiệu; nối app lịch/xoá/xuất.
- Trạng thái: Hoàn thành (phần còn lại ghi ở trên).

<a id="bf-20261018-013"></a>
## BF-20261018-013 — Song song: Codex làm API reauth token + job gửi nhắc sự kiện, Claude nối app Xoá tài khoản + Xuất dữ liệu và Lịch CARE-07/CAL-02

- Ngày làm: 2026-10-18T20:47:41+07:00 → 2026-10-18T21:12+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Đợt tiếp: Codex làm API phát hành reauth token (sau OTP) + job gửi nhắc sự kiện, còn bạn nối app Xoá tài khoản + Xuất dữ liệu và Lịch CARE-07/CAL-02. Xong thì tick checklist."
- Liên quan: BF-20261018-012.
- Vấn đề/mục tiêu: hoàn tất yêu cầu bắt buộc của Store (xoá tài khoản ngay trong app) và xuất dữ liệu cho người dùng thật; lịch gia đình dùng dữ liệu server và có nhắc.
- Tác động sản phẩm/dữ liệu: người dùng xoá được tài khoản sau khi xác thực lại bằng OTP (chờ 30 ngày, huỷ được), xuất dữ liệu cá nhân/gia đình và tải về; lịch hiển thị sự kiện, nhiệm vụ, sinh nhật/tròn tháng từ server; nhắc sự kiện xuất hiện trong hộp thư.
- Quyết định và cơ sở: thao tác xoá chỉ chấp nhận mã xác thực lại ngắn hạn gắn phiên, không chấp nhận access token; client không chọn số nhận OTP; nhắc của sự kiện riêng tư không chứa tiêu đề và không bao giờ tới Circle; app nhắc cho chính người tạo vì chưa ánh xạ id server của bạn đời.
- Cách kiểm chứng/đo lường: test tự động (app 722, backend unit 224, e2e 35, integration 227) có ca bảo mật/riêng tư. Chưa có dữ liệu đo sử dụng.
- Kết quả: checklist 51/165.
- Việc cần theo dõi: push; xác thực lại qua Apple/Google; nhắc cho bạn đời; theo dõi tỉ lệ huỷ xoá và tỉ lệ xuất dữ liệu thành công khi có dữ liệu thật.
- Trạng thái: Hoàn thành (phần còn lại ghi ở trên).

<a id="bf-20261018-014"></a>
## BF-20261018-014 — Song song: Codex làm gửi push + worker trao huy hiệu CARE-10, Claude nối app quyền thông báo/push ONB-10 và nhắc cho bạn đời trên lịch

- Ngày làm: 2026-10-18T21:18:02+07:00 → 2026-10-18T21:38+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Đợt tiếp: Codex làm gửi push (NotificationDelivery, giờ yên tĩnh, trần 3/ngày) + worker trao huy hiệu CARE-10, còn bạn nối app quyền thông báo/push ONB-10 và nhắc cho bạn đời trên lịch. Xong thì tick checklist."
- Liên quan: BF-20261018-013.
- Vấn đề/mục tiêu: người dùng nhận thông báo đẩy đúng lúc, không bị làm phiền (giờ yên tĩnh, tối đa 3/ngày) và không lộ nội dung riêng tư; gia đình được ghi nhận huy hiệu; lịch nhắc được cả hai bố mẹ.
- Tác động sản phẩm/dữ liệu: thông báo trong app giờ có thể được đẩy tới thiết bị; huy hiệu được trao tự động và báo cho Parent; sự kiện lịch có người tham gia và nhắc cho bạn đời.
- Quyết định và cơ sở: trần 3/ngày tính theo thông báo (nhiều máy không bị trừ nhiều lần); nhóm nhạy cảm chỉ gửi chữ chung chung; huy hiệu theo Hearts riêng chỉ báo cho người đó (BR-018); không tick Push vì chưa kiểm chứng trên thiết bị thật.
- Cách kiểm chứng/đo lường: test tự động (app 726, backend unit 247, e2e 35, integration 242). Cần đo khi có dữ liệu thật: tỉ lệ cho phép thông báo ở ONB-10, tỉ lệ push bị dời/bị chặn bởi trần, tỉ lệ token hỏng.
- Kết quả: checklist 53/165.
- Việc cần theo dõi: thử FCM/APNs thật; theo dõi các chỉ số trên.
- Trạng thái: Hoàn thành (phần còn lại ghi ở trên).

<a id="bf-20261018-015"></a>
## BF-20261018-015 — Các mục MVP kế tiếp: Codex làm phiên/thiết bị, đổi số điện thoại, ONB-08; Claude nối app avatar, INV-02/03, ONB-09, FAM-02 và app cho phần của Codex

- Ngày làm: 2026-10-18T22:01:44+07:00 → 2026-10-18T22:18+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp các mục MVP còn trống kế tiếp trong checklist, chia việc cho Codex và bạn. Xong thì tick checklist."
- Liên quan: BF-20261018-014.
- Vấn đề/mục tiêu: người dùng tự quản lý thiết bị đăng nhập, gia đình đặt quyền riêng tư mặc định trên server, các luồng mời bạn đời/lời mời lỗi hoạt động đúng với dữ liệu thật.
- Tác động sản phẩm/dữ liệu: danh sách thiết bị và đăng xuất từ xa là thật; cài đặt quyền riêng tư của gia đình đồng bộ giữa hai bố mẹ; gia đình có bạn đời đã rời vẫn dùng được và mời lại được.
- Quyết định và cơ sở: Circle chỉ đọc `showLunar` (cài đặt là thông tin riêng của bố mẹ); đổi số bắt buộc xác thực lại và thu hồi phiên khác; thu hồi lời mời bằng cách cấp mã mới vì server tự vô hiệu mã cũ; không tick avatar/đổi số vì thiếu backend/thiết kế.
- Cách kiểm chứng/đo lường: test tự động (app 733, backend unit 247, e2e 35, integration 257). Khi có dữ liệu thật: số lần đăng xuất thiết bị khác, tỉ lệ đổi `defaultVisibility`.
- Kết quả: checklist 58/165.
- Việc cần theo dõi: avatar, màn đổi số, áp quyền riêng tư mặc định khi tạo ký ức.
- Trạng thái: Hoàn thành (phần còn lại ghi ở trên).

<a id="bf-20261019-001"></a>
## BF-20261019-001 — Thai kỳ PREG-01…06 + hồ sơ bé: 2 Codex làm backend song song, Claude nối app

- Ngày làm: 2026-10-19T07:32:17+07:00 → 2026-10-19T07:53+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp các mục MVP còn trống kế tiếp trong checklist (thai kỳ PREG-01…07, hồ sơ bé), chia việc cho Codex và bạn. Xong thì tick checklist."
- Liên quan: BF-20261018-015.
- Vấn đề/mục tiêu: hành trình thai kỳ và hồ sơ bé dùng dữ liệu thật trên server, đồng bộ giữa hai bố mẹ.
- Tác động sản phẩm/dữ liệu: tuần thai, kích thước thai, danh sách chuẩn bị, chuyển thai kỳ thành bé, lưu trữ thai kỳ, số đếm hồ sơ, sắp xếp/lưu trữ/xoá bé và ảnh bé đều qua server.
- Quyết định và cơ sở: thai kỳ kết thúc buồn (`ENDED_PRIVATE`) ẩn ngay khỏi người thân và không gửi thông báo; xoá bé cần lưu trữ đủ 7 ngày và nhập lại tên để tránh xoá nhầm; nội dung theo tuần chỉ là thông tin tham khảo nhẹ nhàng, không phải lời khuyên y tế; "chỉ Papa & Mama" khi lưu trữ trên app ánh xạ `ENDED_PRIVATE`.
- Cách kiểm chứng/đo lường: test tự động (app 739, backend unit 257, e2e 35, integration 274) có ca riêng tư cho Circle. Khi có dữ liệu thật: tỉ lệ hoàn thành danh sách chuẩn bị, thời gian từ ngày sinh tới khi chuyển thai kỳ thành bé.
- Kết quả: checklist 67/165.
- Việc cần theo dõi: URL ảnh bé cho máy khác; seed nội dung tuần trên môi trường dev/staging; rà nội dung tuần với chuyên môn trước khi phát hành.
- Trạng thái: Hoàn thành (phần còn lại ghi ở trên).

<a id="bf-20261019-002"></a>
## BF-20261019-002 — Ký ức & album §6, nhật ký/thư/cột mốc §7: 2 Codex làm backend song song, Claude nối app

- Ngày làm: 2026-10-19T08:22:55+07:00 → 2026-10-19T08:48+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp các mục MVP còn trống kế tiếp trong checklist (ký ức & album §6, nhật ký/thư/cột mốc §7), chia việc cho Codex và bạn. Xong thì tick checklist." Giữa chừng người dùng hỏi "Đã xong chưa nhỉ? Nếu xong rùi làm task tiếp theo cho tôi đi" — trả lời đang chạy, làm tiếp đến hết đợt.
- Liên quan: BF-20261019-001.
- Vấn đề/mục tiêu: các tính năng lưu giữ kỷ niệm (album, yêu thích, tải bản gốc, góc nhìn của bố/mẹ còn lại, gợi ý, cột mốc, thư gửi con) dùng dữ liệu thật và đồng bộ giữa các thiết bị.
- Tác động sản phẩm/dữ liệu: album/yêu thích/cột mốc/thư lưu trên server; tải bản gốc thật; thư niêm phong chỉ tác giả đọc được tới ngày mở.
- Quyết định và cơ sở: yêu thích là riêng từng người; album nhạy cảm và ký ức PARENTS/PRIVATE không bao giờ tới Circle; góc nhìn chỉ của Parent còn lại; link tải bản gốc ngắn hạn và có giới hạn tần suất; nhóm/tên cột mốc giữ theo catalog app để không đổi giao diện.
- Cách kiểm chứng/đo lường: test tự động (app 743, backend unit 257, e2e 35, integration 310). Khi có dữ liệu thật: số album/người dùng, tỉ lệ ghi cột mốc theo gợi ý, số thư niêm phong.
- Kết quả: checklist 75/165.
- Việc cần theo dõi: nháp server, sửa ảnh trên app, thông báo khi thư mở, deadlock worker push.
- Trạng thái: Hoàn thành (phần còn lại ghi ở trên).

<a id="bf-20261019-003"></a>
## BF-20261019-003 — Đợt kế tiếp §8 bảng tin + §9 nhiệm vụ: Codex làm backend nhiệm vụ, Claude nối app

- Ngày làm: 2026-10-19T08:48:32+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: tiếp theo câu "Nếu xong rùi làm task tiếp theo cho tôi đi" (cùng lượt với BF-20261019-002): làm nhóm MVP kế tiếp trong checklist, chia việc cho Codex và Claude, xong thì tick checklist.
- Liên quan: BF-20261019-002.
- Tiến độ (2026-10-19 ~09:10): xong phía app §8 — bật/tắt bình luận theo ký ức (màn sửa, ẩn ô bình luận; `commentsEnabled` gửi khi đổi) và lọc bảng tin theo bé/thai kỳ đọc bảng tin server của riêng bé; app `make check` EXIT=0 (745 test); checklist 77/165. Backend §9: Codex hết hạn mức sử dụng ngay đầu phiên (chưa sửa file nào, mở lại 12:34) → giao Antigravity cùng brief, đang chạy.
- Tiến độ (~09:10): Antigravity dừng sau ~18 phút vì cần lệnh ngoài allowlist (headless tự từ chối); đã kịp mở rộng catalog nhiệm vụ 30 → 110 mẫu (vi/en, thai kỳ + bé) và thêm `repeatWindowDays`/`boardHour` vào policy — Claude kiểm tra `mission-board-api` + `care-progress-api` 28/28 qua. Phần còn lại §9 (bộ sinh tránh lặp, job sáng, CARE-06, lặp lại, CARE-12) hẹn Codex tự chạy lúc 12:36 khi hạn mức mở lại.
- Tiến độ (2026-10-19, sau khi người dùng nói "Ok bạn làm đi" — chọn để Claude tự làm backend §9 thay vì chờ Codex): huỷ lịch hẹn Codex; Claude viết job `mission.prepare-boards` (queue `missions`, mỗi giờ, ≥ 5:00 giờ địa phương, `prepareBoard` khoá gia đình, không trùng), CARE-06 `POST /missions/:id/moment` (ký ức MOMENT qua `IMemoryContentService`, gắn `mission_completions.memory_id`), nhiệm vụ lặp lại `/mission-series` (rrule hằng ngày/theo thứ, tạm dừng, kết thúc; tạo mỗi ngày một nhiệm vụ SERIES khi bày/mở bảng), CARE-12 `/mission-settings` + `/mission-preferences`; nối `recentExclusionDays` với `repeatWindowDays`. Sự cố trong lúc làm: test job đầu tiên quét mọi gia đình ACTIVE của DB test và bày bảng cho 20 gia đình còn sót của spec khác (khoá ngoại lỗi khi dọn) → đã dọn 140 nhiệm vụ/20 bảng/20 mẫu tạm trong `baby_family_test` (DB dev không bị ảnh hưởng), test viết lại chỉ chạm gia đình của spec + unit test cho vòng lặp theo giờ. Sau khi macOS cập nhật, `python3` và git chỉ in "chưa đồng ý giấy phép Xcode" rồi thoát → các script Python không chạy mà không báo lỗi; đã phát hiện và làm lại bằng công cụ sửa file/node. Bằng chứng: backend `npm run check` EXIT=0 (unit 262, e2e 35); `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` EXIT=0 (37 suite, 314 test). Checklist 78/165 (tick job bày bảng sáng). Chưa làm: app CARE-06/CARE-12/lặp lại — Flutter/fvm không chạy được (cần git) tới khi người dùng chạy `sudo xcodebuild -license`.
- Kết quả cuối (2026-10-19T13:17+07:00, sau khi người dùng chạy `sudo xcodebuild -license accept` và nhắn "bạn làm tiếp phần app CARE-06/CARE-12/nhiệm vụ lặp lại đi"): git/Python/Flutter chạy lại bình thường. App: CARE-06 lưu khoảnh khắc qua server (tải ảnh + Idempotency-Key), CARE-12 đọc/lưu cài đặt server (mức bảng cả nhà, tuỳ chọn của tôi, chỉ gửi phần đổi), việc tự gõ có "Lặp lại" tạo chuỗi trên server (hằng ngày/ngày thường/cuối tuần/chọn thứ). Checklist 80/165: tick CARE-06, CARE-12 (cùng job bày bảng sáng và §8 trước đó); nhiệm vụ lặp lại giữ 🟡 vì chưa có màn tạm dừng/dừng chuỗi.
- Bằng chứng kiểm tra: app `make check` EXIT=0 (analyze sạch, 748 test); backend `npm run check` EXIT=0 (unit 262, e2e 35); `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` EXIT=0 (37 suite, 314 test).
- Việc còn lại: màn quản lý chuỗi lặp (tạm dừng/dừng); chứng minh catalog đủ 90 ngày không trùng cho mọi độ tuổi; bộ đếm `active_series`; push "bảng hôm nay" theo `boardPushTime`; chưa chạy simulator.
- Trạng thái: Hoàn thành (phần còn lại ghi ở trên).

<a id="bf-20261019-004"></a>
## BF-20261019-004 — Papa & Mama §11 + Family Circle §12: 2 Codex làm backend song song, Claude nối app

- Ngày làm: 2026-10-19T13:22:50+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp các mục MVP còn trống kế tiếp trong checklist (Papa & Mama §11, Family Circle §12), chia việc cho Codex và bạn. Xong thì tick checklist."
- Liên quan: BF-20261019-003.
- Vấn đề/mục tiêu: Papa/Mama mời và quản lý người thân theo từng bé thật trên server; duyệt ảnh người thân đăng; cài đặt và ảnh nhật ký riêng của Papa & Mama đồng bộ qua thiết bị.
- Tác động sản phẩm/dữ liệu: lời mời CIRCLE có payload version 1, hạn 14 ngày, quyền VIEW/COMMENT/CONTRIBUTE + tải xuống theo từng bé; ký ức người thân có thể ở `PENDING_REVIEW`; gói hết hạn → Circle nhận 403 `CIRCLE_PAUSED`, Parent vẫn xem/tải; ảnh nhật ký là asset riêng của người tải.
- Quyết định & cơ sở: quyền Circle đọc từ capability/feature `circle.enabled` của gói, không theo tên gói; lọc ACL trước phân trang để tránh lộ số lượng; giờ yên tĩnh/khoá nhật ký vẫn ở máy vì server chỉ có 4 trường US-15.
- Cách kiểm chứng/đo lường: spec integration family-circle (12), memory-review, circle-content-acl, us-settings, media JOURNAL; test remote app. Chưa có dữ liệu đo thực tế; nên theo dõi tỉ lệ lời mời được chấp nhận, thời gian duyệt ảnh, số Circle bị tạm dừng.
- Kết quả: 87/165 dòng checklist xong; toàn bộ check app/backend/integration đạt.
- Theo dõi: app người thân (CIR-*), màn duyệt lời cảm ơn, Circle tải ảnh lên, ACL bé gắn lẫn, thông báo duyệt ảnh.
- Trạng thái: Hoàn thành (còn các phần nêu ở “Theo dõi”).

## BF-20261019-005 — Circle tải ảnh, ACL bé gắn lẫn, thông báo duyệt ảnh (Codex) + app người thân CIR-*, màn duyệt lời cảm ơn (Claude)

- Ngày làm: 2026-10-19T14:06:38+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Đợt tiếp: Codex cho Circle tải ảnh lên + ACL bé gắn lẫn + thông báo duyệt ảnh, còn bạn nối app người thân CIR-WAIT/CIR-01…06, CIR-05, rời gia đình và màn duyệt lời cảm ơn. Xong thì tick checklist."
- Liên quan: BF-20261019-004.
- Vấn đề/mục tiêu: người thân (ông bà…) dùng app thật: nhận lời mời, chờ duyệt, xem ảnh các cháu được cấp quyền, gửi lời chúc/ảnh; Papa/Mama nhận thông báo duyệt ảnh; bạn đời quyết định đăng lời cảm ơn cho cả nhà.
- Tác động sản phẩm/dữ liệu: người thân CONTRIBUTE tải được ảnh MEMORY (tính quota gia đình), ảnh vào hàng chờ duyệt; ACL áp cả media, cột mốc, thống kê hồ sơ; thông báo không lộ chú thích/tên bé/lý do từ chối; duyệt lời cảm ơn tạo ký ức PARENTS.
- Quyết định & cơ sở: quyền của app người thân đọc từ server (`permission` theo từng bé) thay vì suy ra từ tên gói; trạng thái tạm dừng do server quyết (gói/capability), app không nêu lý do gói (CIR-05); tuỳ chọn thông báo người thân giữ trên máy vì chưa có API.
- Cách kiểm chứng/đo lường: test integration media/ACL/memory-review/notification/family-circle; test app phiên người thân, Circle remote, duyệt lời cảm ơn. Chưa có dữ liệu thực tế; nên theo dõi tỉ lệ người thân chấp nhận lời mời, số ảnh người thân gửi/được duyệt, thời gian chờ duyệt, tỉ lệ lời cảm ơn được đăng.
- Kết quả: 92/165 dòng checklist; mọi check app/backend/integration đạt.
- Theo dõi: chạy seed thông báo v4; API tuỳ chọn thông báo người thân và gỡ nội dung khi rời; tên tác giả trên app người thân.
- Trạng thái: Hoàn thành (còn các phần nêu ở “Theo dõi”).

## BF-20261019-006 — Cài đặt thông báo/AI, tìm kiếm, báo cáo/chặn (2 Codex) + app gói dịch vụ, hồ sơ, nháp và nối API mới (Claude)

- Ngày làm: 2026-10-19T17:08:14+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp các mục MVP còn trống kế tiếp trong checklist, chia việc cho Codex và bạn. Xong thì tick checklist."
- Liên quan: BF-20261019-005.
- Vấn đề/mục tiêu: các mục MVP còn trống về cài đặt cá nhân (thông báo, AI, hồ sơ), tìm kiếm/ngày này năm xưa, an toàn (báo cáo, chặn) và gói dịch vụ hiển thị theo server.
- Tác động sản phẩm/dữ liệu: tắt nhóm thông báo/giờ yên tĩnh đồng bộ qua thiết bị và được pipeline gửi thông báo tôn trọng; tìm kiếm không phân biệt dấu, chỉ trả nội dung người xem được; báo cáo tạo bản ghi có mức ưu tiên/SLA (an toàn trẻ em 24 giờ), có thể ẩn ngay với người báo cáo; chặn ẩn ký ức/bình luận của người bị chặn với người chặn; banner gói/hạn/dung lượng theo quyền lợi server.
- Quyết định & cơ sở: nhóm thông báo, tính năng AI, lý do báo cáo là catalog có version ở config (không rải hardcode); Bố/Mẹ không chặn nhau (rời gia đình là đường đúng); giá gói vẫn từ Store trên máy cho tới khi có IAP; nhóm thông báo app chưa có trên server giữ trên máy.
- Cách kiểm chứng/đo lường: spec integration preference-settings-api, search-safety-api (ACL Parent/Circle, bỏ dấu, idempotent báo cáo, chặn ẩn bình luận); test remote app. Chưa có dữ liệu thực tế; nên theo dõi tỉ lệ tìm kiếm có kết quả, số báo cáo theo lý do và thời gian xử lý so với SLA, số lượt chặn, tỉ lệ tắt từng nhóm thông báo.
- Kết quả: 101/165 dòng checklist; mọi check app/backend/integration đạt.
- Theo dõi: job bản tin người thân, quy trình moderation/Admin, IAP, nháp tiếp tục soạn.
- Trạng thái: Hoàn thành (còn các phần nêu ở “Theo dõi”).

## BF-20261019-007 — Recap tuần + số liệu HOME-01, avatar hồ sơ + ảnh bé qua bootstrap (2 Codex) + app video/multipart, sửa ảnh ký ức, chi tiết từ server (Claude)

- Ngày làm: 2026-10-19T18:39:45+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp các mục MVP còn trống kế tiếp trong checklist, chia việc cho Codex và bạn. Xong thì tick checklist."
- Liên quan: BF-20261019-006.
- Vấn đề/mục tiêu: bố mẹ thấy tổng kết tuần và số liệu “Tuần này” thật; ảnh đại diện/ảnh bé đồng bộ giữa hai máy; đăng được video; sửa ký ức đổi được ảnh; chi tiết ký ức luôn mới.
- Tác động sản phẩm/dữ liệu: recap tuần tạo tự động (mặc định chỉ Papa & Mama xem), số lời cảm ơn chỉ ở phần riêng của bố mẹ; Circle chỉ thấy nội dung đúng quyền; video bị chặn trước khi tải nếu dài hơn giới hạn gói (đọc từ catalog server); ảnh đại diện tài khoản qua kho ảnh riêng (≤ 5 MiB, xử lý lại, bỏ metadata).
- Quyết định & cơ sở: avatar tài khoản tách khỏi media gia đình vì cần trước khi có gia đình và FK `user_assets`; recap chưa chia sẻ tự động (bố mẹ xem trước theo đặc tả); null object cho test cũ thay vì sửa hàng loạt spec không liên quan.
- Cách kiểm chứng/đo lường: spec weekly-recap-api, profile-avatar-api, profile-image-bootstrap, profile-image-cleanup; test remote app (video/multipart, đổi ảnh, recap, tuần này, avatar, mirror ảnh). Chưa có dữ liệu thực tế; nên theo dõi tỉ lệ mở recap tuần, tỉ lệ người đặt ảnh đại diện, số video bị chặn vì giới hạn gói, lỗi tải multipart.
- Kết quả: 108/165 dòng checklist; mọi check đạt ở lần chạy cuối.
- Theo dõi: MEM-06, chia sẻ recap, recap tháng, test push-delivery chập chờn.
- Trạng thái: Hoàn thành (còn các phần nêu ở “Theo dõi”).

## BF-20261019-008 — Xoá gia đình + quyền riêng tư, ảnh tháng + chương tháng + Accept-Language (2 Codex) + app MEM-06, SW-01, hiển thị, FAM-07 (Claude)

- Ngày làm: 2026-10-19T22:23:53+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp các mục MVP còn trống kế tiếp trong checklist, chia việc cho Codex và bạn. Xong thì tick checklist."
- Liên quan: BF-20261019-007.
- Vấn đề/mục tiêu: gia đình tự xoá được dữ liệu có đồng thuận; bố mẹ xem tổng quan quyền riêng tư thật; ảnh tháng đồng bộ; lỗi hiển thị đúng ngôn ngữ; đăng ảnh/video không phải chờ; danh sách bé và cài đặt hiển thị đồng bộ giữa các máy.
- Tác động sản phẩm/dữ liệu: xoá gia đình cần cả hai Parent + xác thực lại, 30 ngày chờ có thể huỷ, người thân mất quyền ngay khi hẹn xoá; ảnh tháng đặt lại đổi ảnh cũ thành ký ức thường (BR-072); thông điệp lỗi theo vi/en, mã lỗi giữ nguyên.
- Quyết định & cơ sở: chỉ màn soạn ký ức dùng tải nền (các luồng cần id server ngay giữ đồng bộ); ký ức tạm mất việc tải chuyển thành nháp để không mất nội dung; FAM-07 để lại vì thiếu backend (ảnh bìa, ngôn ngữ nội dung).
- Cách kiểm chứng/đo lường: spec family-erasure-api, family-privacy-api, monthly photo/timeline/locale (Codex), test remote app. Chưa có dữ liệu thực tế; nên theo dõi số yêu cầu xoá gia đình bị huỷ trong thời gian chờ, tỉ lệ tải nền thất bại/thử lại, tỉ lệ đặt ảnh tháng.
- Kết quả: 115/165 dòng checklist; app/backend check đạt; integration toàn bộ còn chập chờn ở push-delivery.
- Theo dõi: deadlock push-delivery, thẻ timeline server trên app, FAM-07.
- Trạng thái: Hoàn thành phần tính năng; còn lỗi kiểm thử chập chờn.

<a id="bf-20261019-009"></a>
## BF-20261019-009 — Deadlock chập chờn khi nhiều worker push nhận việc đồng thời

- Ngày làm: 2026-10-19T23:06:04+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: tìm và sửa nguyên nhân gốc deadlock trong `PushDeliveryRepository.claim` lộ ra khi chạy toàn bộ integration.
- Role: BACKEND, DBA, TESTER, QUALITY.
- Vấn đề / mục tiêu: worker push chạy song song không được deadlock (mất/trễ thông báo, job RUNNING bị kẹt); bộ integration toàn bộ phải ổn định.
- Quan sát: deadlock xảy ra khi một transaction nhận việc khoá nhiều user theo thứ tự tuỳ ý; lộ ra trong test vì spec push xử lý cả 313 delivery còn sót của spec khác (đã đối chiếu trực tiếp trong DB test).
- Phân tích / quyết định: mỗi transaction chỉ xét một delivery → mỗi worker giữ tối đa một khoá user, không thể tạo chu trình; giữ khoá user để trần 3 push/ngày vẫn đúng giữa các worker. Spec dùng mốc thời gian quá khứ để chỉ đụng dữ liệu của mình thay vì xoá dữ liệu spec khác.
- Tác động: Không đổi hành vi sản phẩm hay API; vận hành: worker push song song không còn deadlock (tránh trễ thông báo, job RUNNING kẹt). Quyết định huỷ/dời từng delivery nay được ghi ngay thay vì cùng lúc với lần nhận việc cuối.
- Giả thuyết / đo lường: Chưa có dữ liệu đo.
- Kết quả / trạng thái: Hoàn thành; integration toàn bộ 2 lần liên tiếp xanh, `npm run check` xanh. Chưa có dữ liệu production.
- Theo dõi: theo dõi log lỗi `40P01`/`Push lease lost` và số job push TIMED_OUT khi chạy nhiều worker.
- Session: [BF-20261019-009](SESSIONS.md#bf-20261019-009).

## BF-20261019-009 — FAM-07/FAM-08, MEM-25 + PARTNER_LEFT (2 Codex) + app MEM-08 video, thẻ timeline server, giữ phiên khi mất mạng (Claude)

- Ngày làm: 2026-10-19T23:06:23+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp các mục MVP còn trống kế tiếp trong checklist, chia việc cho Codex và bạn. Xong thì tick checklist."
- Liên quan: BF-20261019-008.
- Vấn đề/mục tiêu: xem video toàn màn hình, trình chiếu “Hôm nay của bé” bằng dữ liệu thật, mở app lúc mất mạng không bị đăng xuất, gia đình đổi ảnh bìa/ngôn ngữ nội dung, bạn đời mới thấy các bé khi được mời lại.
- Tác động sản phẩm/dữ liệu: bản chụp trên máy (mã hoá, xoá khi đăng xuất) giữ tối đa 300 ký ức gần nhất; story “đã xem” chỉ lưu trên máy; ảnh bìa gia đình là asset COVER của gia đình (ký URL ngắn hạn).
- Quyết định & cơ sở: không thêm migration (dùng cột có sẵn); FAM-08 hoãn vì cần thiết kế lại đồng bộ phiên nhiều gia đình; múi giờ chưa làm vì cần danh mục IANA có nhãn.
- Cách kiểm chứng/đo lường: unit/integration backend + test remote app nêu ở SESSIONS. Chưa có dữ liệu thực tế; nên theo dõi tỉ lệ mở app khi mất mạng còn giữ phiên, lượt xem story hôm nay, tỉ lệ phát video thành công.
- Kết quả: 119/165 dòng checklist; mọi check app/backend/integration toàn bộ đạt.
- Theo dõi: FAM-08, múi giờ, thẻ recap trên dòng thời gian.
- Trạng thái: Hoàn thành (còn các phần nêu ở “Theo dõi”).

## BF-20261019-010 — Support ticket + kiểm duyệt, allowlist khi hết hạn + SUB-06/07 (2 Codex) + app đổi số, ghi âm, chuỗi nhiệm vụ, nháp tài khoản (Claude)

- Ngày làm: 2026-10-20T07:40:42+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp các mục MVP còn trống kế tiếp trong checklist, chia việc cho Codex và bạn. Xong thì tick checklist."
- Liên quan: BF-20261019-009.
- Vấn đề/mục tiêu: người dùng liên hệ hỗ trợ ngay trong app (kể cả khi gói hết hạn); báo cáo vi phạm được gom thành ca có SLA; khi gói hết hạn chỉ còn đọc/tải/xuất dữ liệu đúng §6.5; nhắc trước khi hết thử/hết gói; Bố/Mẹ tự tạm dừng/dừng nhiệm vụ lặp lại; đổi số điện thoại đăng nhập.
- Tác động sản phẩm/dữ liệu: nội dung ticket mã hoá, không kèm dữ liệu của bé; allowlist chặt hơn trước (một số màn trước đây đọc được khi hết hạn nay trả 402 — cố ý theo §6.5); thông báo BILLING không chứa tên bé/nội dung ký ức; tạm dừng chuỗi mặc định 7 ngày.
- Quyết định & cơ sở: danh mục hỗ trợ, mốc nhắc, chính sách SLA là catalog/config có version (không fix cứng ở client); app đọc danh mục từ server; job kiểm duyệt chỉ chạy ở worker; chưa mở route kiểm duyệt vì chưa có admin auth.
- Cách kiểm chứng/đo lường: test app/backend/integration nêu ở SESSIONS. Chưa có dữ liệu thật; nên theo dõi số ticket theo danh mục và thời gian phản hồi, tỉ lệ ca kiểm duyệt quá SLA, tỉ lệ gia hạn sau mỗi mốc nhắc, tỉ lệ chuỗi bị tạm dừng/dừng.
- Kết quả: 124/165 dòng checklist; mọi check app/backend/integration toàn bộ đạt.
- Theo dõi: seed template v5, khoá mã hoá support khi triển khai, admin trả lời ticket/xử lý ca, app đọc `statusBanner`, liên kết Apple/Google, ghi âm, MEM-18.
- Trạng thái: Hoàn thành (còn các phần nêu ở “Theo dõi”).
