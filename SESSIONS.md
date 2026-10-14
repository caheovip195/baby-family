# Baby Family — lịch sử câu hỏi và công việc

Mỗi yêu cầu có một mã, ngày làm, phân tích và kết quả; đối chiếu với [PRODUCT_ANALYTICS_HISTORY.md](PRODUCT_ANALYTICS_HISTORY.md). Quy tắc và mẫu: [AGENTS.md](AGENTS.md), [history-templates.md](.agents/skills/baby-family-team/references/history-templates.md). Múi giờ: `Asia/Ho_Chi_Minh` (`UTC+07:00`).

Các mục 001–005 được **ghi bù ngày 2026-10-11** từ hội thoại hiện có và kết quả công việc đã lưu trong context. Không có timestamp gốc đầy đủ nên không khẳng định ngày/giờ thực hiện trước đó; role ở các mục này là phân loại hồi cứu, không phải bằng chứng từng role đã chạy độc lập. Lịch sử Flutter trước đây vẫn giữ tại [baby-family-app/SESSION.md](baby-family-app/SESSION.md).

<a id="bf-20261011-001"></a>

## BF-20261011-001 — Tạo base backend Node.js/PostgreSQL/Prisma

- Ngày ghi bù: 2026-10-11; ngày/giờ làm gốc chưa xác định từ bản lịch sử hiện có.
- Yêu cầu: Khởi tạo `baby-backend`, Node.js/PostgreSQL mới nhất, Prisma, three-layer, repository/service interfaces, DI và generator; nghiên cứu tài liệu và base GitHub nhiều sao trước khi làm.
- Liên quan: Không.
- Role: Phân loại hồi cứu BACKEND, ARCHITECT, DBA, DEVOPS, TESTER, QUALITY.
- Trạng thái: Hoàn thành base; cấu trúc cuối được điều chỉnh theo yêu cầu 004.
- Phân tích: Cần runtime/toolchain tương thích, database chạy được và kiến trúc dễ mở rộng; phân biệt stable release với release candidate. Stack đã chọn tại lúc thiết lập: Node 26.11.1, PostgreSQL 18.6, NestJS 12.1.2, Prisma 7.10.0 stable, TypeScript 6.0.3.
- Kết quả: Base API, Prisma schema/migration, PostgreSQL Docker, DI, CRUD Note, validation/errors/logging/health/Swagger, generator, CI và tài liệu. Xem [backend README](baby-backend/README.md), [architecture](baby-backend/docs/architecture.md). Các file này phản ánh cấu trúc cuối, không phải snapshot của lần khởi tạo.
- Kiểm chứng: Context công việc trước ghi nhận format/lint/typecheck/build/schema đạt, 28 tests gồm 8 unit + 9 generator + 10 HTTP + 1 integration PostgreSQL, Docker CRUD smoke. Đây là kết quả lịch sử, **không chạy lại trong task role/docs hiện tại**; không khôi phục danh sách repo nghiên cứu khi chưa có nguồn đầy đủ.
- Còn lại: Base chưa đồng nghĩa đã triển khai toàn bộ nghiệp vụ Baby Family; audit dev dependency còn 5 high trong chuỗi Plop/micromatch/braces, production audit đã ghi nhận 0 tại thời điểm kiểm tra.
- Product history: [BF-20261011-001](PRODUCT_ANALYTICS_HISTORY.md#bf-20261011-001).

<a id="bf-20261011-002"></a>

## BF-20261011-002 — Bổ sung yêu cầu TypeScript

- Ngày ghi bù: 2026-10-11; ngày/giờ làm gốc chưa xác định.
- Yêu cầu: “À quên nhớ sử dụng TypeScript”.
- Liên quan: BF-20261011-001.
- Role: Phân loại hồi cứu BACKEND, ARCHITECT, QUALITY.
- Trạng thái: Hoàn thành.
- Phân tích: Áp dụng TypeScript xuyên suốt source, contracts, DI và generator; interface cần runtime token vì TypeScript interface không tồn tại lúc chạy.
- Kết quả: Backend dùng TypeScript strict, service/repository interfaces cùng Symbol token, DTO có kiểu; generator phát sinh TypeScript. Tham chiếu [tsconfig](baby-backend/tsconfig.json), [AppModule](baby-backend/src/app.module.ts).
- Kiểm chứng: Typecheck/build đã đạt trong đợt kiểm tra backend nêu ở 001; không chạy lại ở task tài liệu này.
- Còn lại: Không trong phạm vi yêu cầu ngôn ngữ.
- Product history: [BF-20261011-002](PRODUCT_ANALYTICS_HISTORY.md#bf-20261011-002).

<a id="bf-20261011-003"></a>

## BF-20261011-003 — Hỏi so sánh kiến trúc với MVC

- Ngày ghi bù: 2026-10-11; ngày/giờ làm gốc chưa xác định.
- Yêu cầu: “Nhìn loạn lắm. So sánh với mvc thì sao.”
- Liên quan: BF-20261011-001.
- Role: Phân loại hồi cứu ARCHITECT, BACKEND.
- Trạng thái: Quyết định kiến trúc được chốt bằng yêu cầu tiếp theo 004.
- Phân tích: Người dùng ưu tiên cấu trúc dễ nhìn và bảo trì; cần phân biệt vai trò xử lý HTTP, nghiệp vụ và truy cập dữ liệu khi so sánh với MVC.
- Kết quả: Hội thoại tiếp theo xác định rõ mô hình Controller → Service → Repository → Model. Không tái dựng nguyên văn câu trả lời so sánh trước đó khi bản ghi đầy đủ không còn trong context.
- Kiểm chứng: Yêu cầu trực tiếp của người dùng ở 004 và [backend conventions](baby-backend/AGENTS.md) thể hiện quyết định cuối.
- Còn lại: Không áp dụng lại cấu trúc phức tạp đã được người dùng yêu cầu thay đổi.
- Product history: [BF-20261011-003](PRODUCT_ANALYTICS_HISTORY.md#bf-20261011-003).

<a id="bf-20261011-004"></a>

## BF-20261011-004 — Chuyển sang OOP Controller → Service → Repository → Model

- Ngày ghi bù: 2026-10-11; ngày/giờ làm gốc chưa xác định.
- Yêu cầu: Chia thư mục rõ theo loại; nghiệp vụ ở service, CRUD ở repository; `INoteRepository`/`NoteRepository`, service tương tự, DI; model chỉ thuộc tính và một vài helper.
- Liên quan: BF-20261011-003.
- Role: Phân loại hồi cứu ARCHITECT, BACKEND, TESTER, QUALITY.
- Trạng thái: Hoàn thành.
- Phân tích: Loại bỏ cây feature/domain/application/infrastructure gây khó bảo trì theo phản hồi user. Giữ interface boundaries, runtime tokens và model class thực sự; generator và lint phải theo cùng kiến trúc.
- Kết quả: Global folders `controllers`, `services`, `repositories`, `models`, `interfaces`, `dto`, `database`, `config`, `common`; AppModule bind DI. NoteRepository map Prisma row thành Note; service xử lý nghiệp vụ. Generator, tests và docs đã đồng bộ. Xem [NoteService](baby-backend/src/services/note.service.ts), [NoteRepository](baby-backend/src/repositories/note.repository.ts), [Note model](baby-backend/src/models/note.model.ts).
- Kiểm chứng: Đợt kiểm tra cuối backend ghi nhận 28 tests và các checks ở 001 đạt; Docker CRUD smoke đã kiểm tra. Không chạy lại trong task hiện tại.
- Còn lại: Giữ mô hình này cho resource mới; không tự đổi sang feature/function architecture.
- Product history: [BF-20261011-004](PRODUCT_ANALYTICS_HISTORY.md#bf-20261011-004).

<a id="bf-20261011-005"></a>

## BF-20261011-005 — Giải thích config/env và cách mở rộng Mongo, Redis, storage

- Ngày ghi bù: 2026-10-11; ngày/giờ làm gốc chưa xác định.
- Yêu cầu: Hiểu config hiện tại, đọc env ra sao và thêm Mongo/Redis/storage thế nào.
- Liên quan: BF-20261011-004.
- Role: Phân loại hồi cứu BACKEND, DEVOPS, INTEGRATION, TECH_WRITER.
- Trạng thái: Hoàn thành phần giải thích.
- Phân tích: `.env` mặc định đọc từ working directory; biến môi trường của tiến trình ưu tiên, `.env.example` là mẫu, `.env.production` không tự được chọn. Schema Zod validate/coerce trước startup; ConfigService truy cập dữ liệu có kiểu. Thêm integration cần cả env/schema lẫn SDK/provider/DI/lifecycle.
- Kết quả: Đã giải thích luồng nạp/validate/đọc config, mẫu Redis và nhóm key Mongo/storage, cùng việc forward env khi chạy Docker. **Chưa cài Mongo/Redis/storage**, vì câu hỏi yêu cầu giải thích cách mở rộng. Xem [environment.ts](baby-backend/src/config/environment.ts), [AppModule](baby-backend/src/app.module.ts), [PrismaService](baby-backend/src/database/prisma.service.ts).
- Kiểm chứng: Đã đối chiếu source và tài liệu Nest configuration trong lần trả lời trước; không có thay đổi code hoặc runtime test cho câu hỏi này.
- Còn lại: Chọn nhu cầu và provider cụ thể khi có task triển khai integration.
- Product history: [BF-20261011-005](PRODUCT_ANALYTICS_HISTORY.md#bf-20261011-005).

<a id="bf-20261011-006"></a>

## BF-20261011-006 — Cài bộ role và bắt buộc lịch sử từng câu hỏi

- Ngày làm: 2026-10-11 (Asia/Ho_Chi_Minh).
- Yêu cầu: Cài role backend, mobile, frontend, database, analytics, PM, BA, design, tester, quality và role liên quan; mỗi task dùng role phù hợp phân tích kỹ; bắt buộc ghi câu hỏi, phân tích, kết quả và ngày làm vào hai file lịch sử.
- Liên quan: BF-20261011-001 đến 005.
- Role: ORCHESTRATOR + TECH_WRITER + DATA_ANALYST do agent chính áp dụng; PM/BA/ARCHITECT qua sub-agent catalog; TESTER/QUALITY qua reviewer độc lập. DEVOPS thực hiện yêu cầu bổ sung 007.
- Trạng thái: Hoàn thành.
- Phân tích: Dùng project skill trong `.agents/skills` và root/local AGENTS để quy tắc tồn tại qua các phiên. Role có trigger, trách nhiệm, đầu ra, routing và handoff; agent chính ghi hai log, từng câu hỏi có mã riêng; giữ lịch sử SESSION cũ và kiến trúc hiện tại. Không biến role thành các chat mới hoặc giả định đã có nhân sự chạy độc lập.
- Kết quả: Đã tạo skill `baby-family-team` cùng UI metadata, catalog 17 role chính + AI_ENGINEER có điều kiện, mẫu lịch sử, root hướng dẫn và bổ sung hướng dẫn backend/mobile. Hai log có 7 yêu cầu, gồm 5 mục ghi bù có giới hạn nguồn; SESSION mobile được append, lịch sử cũ được giữ nguyên.
- Kiểm chứng: Đối chiếu [official skills docs](https://learn.chatgpt.com/docs/build-skills); `quick_validate.py` đạt, YAML metadata/prompt/policy đạt, `git diff --check` đạt. Validator ban đầu thiếu PyYAML, đã cài riêng vào `/tmp/baby-family-skill-validation-deps` để chạy lại, không thêm dependency vào dự án. Root và reviewer độc lập đều kiểm tra 52 local links, 7 mã khớp/14 anchors và trường bắt buộc đạt; SHA256 xác nhận 16.629 bytes lịch sử mobile cũ nguyên vẹn, root SESSION vẫn 0 bytes. Reviewer mô phỏng 6 tuyến task đạt theo tài liệu (không phải runtime tests), không còn must-fix. Không chạy lại backend/Flutter tests vì chỉ đổi Markdown và ignore.
- Còn lại: Không trong phạm vi thiết lập; các phiên sau phải tiếp tục tuân thủ workflow và ghi kết quả thực tế.
- Product history: [BF-20261011-006](PRODUCT_ANALYTICS_HISTORY.md#bf-20261011-006).

<a id="bf-20261011-007"></a>

## BF-20261011-007 — Bổ sung .gitignore

- Ngày làm: 2026-10-11 (Asia/Ho_Chi_Minh).
- Yêu cầu: “Thêm luôn cho t một vài cái vào .gitignore đi.”
- Liên quan: BF-20261011-006.
- Role: DEVOPS qua sub-agent sửa root ignore; ORCHESTRATOR cập nhật exception backend; QUALITY/TESTER kiểm tra rule; DATA_ANALYST do agent chính ghi impact note.
- Trạng thái: Hoàn thành.
- Phân tích: Repo có Flutter và Node, cần ignore env/secrets, dependencies/build/cache/log/IDE/OS; giữ env mẫu, source/generated Flutter đang quản lý, migrations, role và lịch sử. Ignore không tự tác động file đã tracked.
- Kết quả: Đã tạo [root .gitignore](.gitignore), bổ sung `!.env.*.example` trong [backend .gitignore](baby-backend/.gitignore) vì ignore ở thư mục con ưu tiên hơn root.
- Kiểm chứng: DEVOPS chạy 48 assertions `git check-ignore` cho root rules đạt; root chạy thêm 28 assertions cuối đạt, gồm exception env mẫu backend, role/log files, source Flutter và migrations. Reviewer độc lập xác nhận exception và các file cần giữ. Không in nội dung secrets, không stage/untrack/xóa file.
- Còn lại: Không trong phạm vi bổ sung rule. `.DS_Store` đã tracked trước đó vẫn được Git quản lý; thêm ignore không tự gỡ file khỏi index hoặc lịch sử.
- Product history: [BF-20261011-007](PRODUCT_ANALYTICS_HISTORY.md#bf-20261011-007).

<a id="bf-20261012-001"></a>

## BF-20261012-001 — Làm nốt đợt 3 các màn còn thiếu (thiết kế + Flutter)

- Ngày làm: 2026-10-12 (Asia/Ho_Chi_Minh); entry tạo lúc 2026-10-12T19:20:00+07:00, giờ nhận yêu cầu chính xác không có nguồn.
- Yêu cầu: “Làm nốt cho t đợt 3 đi” — vẽ và code các màn còn lại theo đặc tả mục 9 (Cầu nối, Tuần của hai ta, tổng kết, gói dịch vụ, lời mời, người thân, báo cáo/chặn, thùng rác/nháp/chờ duyệt, cài đặt còn lại).
- Liên quan: Các đợt dựng UI trước trong cùng chat (đợt 1, 2; chưa có mã vì diễn ra trước khi áp dụng quy tắc nhật ký).
- Role: Chủ trì ORCHESTRATOR; DESIGN (3 sub-agent vẽ Pencil), MOBILE (sub-agent nền móng + sub-agent theo khu vực), BA (đối chiếu luồng/BR theo đặc tả), SECURITY_PRIVACY (US-13 hỗ trợ an toàn, RPT, quyền người thân), TESTER/QUALITY (test + review của agent chính), DATA_ANALYST (impact note).
- Trạng thái: Đang thực hiện.
- Phân tích: Quy trình như đợt 2: vẽ frame Pencil trước (nguồn sự thật UI) → thêm route/skeleton/mock typed → sub-agent khu vực code theo frame → agent chính chạy make check, build simulator. Mock-only, luồng mặc định cho đi qua, dữ liệu theo câu chuyện v2.
- Kết quả: (đang cập nhật) Đã vẽ 41 frame Pencil ở mục 19–24.
- Kiểm chứng: (đang cập nhật).
- Còn lại: Route/skeleton đợt 3, code màn, khung tab người thân, kiểm thử.
- Product history: [BF-20261012-001](PRODUCT_ANALYTICS_HISTORY.md#bf-20261012-001).

<a id="bf-20261012-002"></a>

## BF-20261012-002 — Làm các việc còn tồn của đợt 2

- Ngày làm: 2026-10-12 (Asia/Ho_Chi_Minh); entry tạo lúc 2026-10-12T19:20:00+07:00.
- Yêu cầu: “Với các việc còn lại bên trên nữa” — xử lý danh sách tồn đã báo: font viết tay, ghi chú sự kiện, lối vào Lịch sử/Huy hiệu/Cài đặt nhiệm vụ, lệch kit SET-09, lệch số liệu giữa thiết kế và dữ liệu, ảnh Haru.
- Liên quan: BF-20261012-001.
- Role: Chủ trì MOBILE (sub-agent cleanup); DESIGN (sửa frame Pencil); ORCHESTRATOR tổng hợp; TESTER (make check của sub-agent); DATA_ANALYST impact note.
- Trạng thái: Đang thực hiện.
- Phân tích: Người dùng chấp thuận tải font Dancing Script (OFL, kho google/fonts) và thêm vào pubspec. Lệch số liệu giải quyết theo dữ liệu thật, sửa chữ Pencil cho khớp.
- Kết quả: (đang cập nhật).
- Kiểm chứng: (đang cập nhật).
- Còn lại: (đang cập nhật).
- Product history: [BF-20261012-002](PRODUCT_ANALYTICS_HISTORY.md#bf-20261012-002).

<a id="bf-20261013-001"></a>

## BF-20261013-001 — Tách PostgreSQL và bind mount dữ liệu ra host

- Ngày làm: 2026-10-13 (Asia/Ho_Chi_Minh); thời gian kiểm tra thực tế 2026-10-13T07:23:58+07:00.
- Yêu cầu: Tách DB server khỏi Compose backend, đặt đúng thư mục database đã chia; mount data ra ngoài Docker để backup và giữ data khi Compose/container/Docker bị xóa.
- Liên quan: BF-20261011-001, BF-20261011-005.
- Role: DEVOPS/DBA qua sub-agent triển khai database; DBA/ARCHITECT qua sub-agent phân tích chuyển dữ liệu read-only; TESTER/QUALITY qua reviewer độc lập; ORCHESTRATOR/BACKEND/DATA_ANALYST do agent chính thực hiện.
- Trạng thái: Hoàn thành.
- Phân tích: Hiện PostgreSQL 18.6 chạy trong project baby-backend trên named volume, có baby_family và baby_family_test. Tách project, dùng shared network cho container backend và URL localhost cho dev; chuyển toàn cluster offline cùng image sau backup, giữ volume/container cũ để rollback. Bind mount không thay thế bản backup và không bảo vệ nếu chính thư mục host bị xóa.
- Kết quả: [DB Compose](baby-database/compose.yaml) chạy PostgreSQL riêng, bind [data](baby-database/data) vào /var/lib/postgresql; [backend Compose](baby-backend/compose.yaml) chỉ còn API/migrations qua external network baby-family-data/alias baby-postgres. Đã chuyển cluster offline bằng cùng image sau backup; giữ baby-backend-postgres-1 ở trạng thái dừng và volume baby-backend_postgres-data. Backup trước chuyển ở baby-database/backups/pre-split-20261013T072752 gồm globals, 3 custom dumps và baseline; thêm [backup](baby-database/scripts/backup.sh)/[restore](baby-database/scripts/restore.sh) cùng [runbook](baby-database/README.md). Đồng bộ env mẫu, npm db commands, CI, AGENTS, docs và ignore data/backups. Prisma/schema/migrations và kiến trúc OOP giữ nguyên.
- Kiểm chứng: 3 DB, roles và 4 table count/digests khớp sau cutover. Thực sự chạy DB compose down --volumes/up: container ID đổi, host PG_VERSION=18 và 4 digests giữ nguyên. Backup/restore DB mới khớp 2 tables; từ chối application DB/target tồn tại; dump/globals mode600; target kiểm thử đã xóa. Thiếu host bind directory làm startup thất bại, không tự tạo folder; isolated project đã dọn. Integration PostgreSQL 1/1 đạt; Docker build api+migrate đạt; API readiness + POST201/GET200/PATCH200/DELETE204 đạt, note kiểm thử đã xóa. Backend compose down chỉ gỡ API/migrations, DB mới vẫn healthy. Compose config, Bash syntax, Prettier và git diff --check đạt; review DBA/QUALITY độc lập không có must-fix, ignore/source paths đúng và 4 block lịch sử 2026-10-12 giữ nguyên SHA256. Không chạy remote GitHub CI hoặc toàn bộ Flutter/backend unit tests vì không đổi source nghiệp vụ.
- Còn lại: Không trong phạm vi yêu cầu. Data/backups hiện nằm trên host trong baby-database; có env đổi sang ổ rời khi có đường dẫn. Backup thường chỉ POSTGRES_DB + globals, không phải full cluster/PITR; bản cũ không tự đồng bộ writes sau cutover.
- Product history: [BF-20261013-001](PRODUCT_ANALYTICS_HISTORY.md#bf-20261013-001).

<a id="bf-20261013-002"></a>

## BF-20261013-002 — Xác nhận vị trí Compose trong baby-database

- Ngày làm: 2026-10-13 (Asia/Ho_Chi_Minh).
- Yêu cầu: Người dùng xác nhận có thư mục database và yêu cầu đặt docker-compose ngay tại đó.
- Liên quan: BF-20261013-001.
- Role: ORCHESTRATOR/DEVOPS/DBA; QUALITY kiểm tra cấu trúc cuối.
- Trạng thái: Hoàn thành.
- Phân tích: Thư mục thực tế là baby-database; không tạo thêm folder theo lỗi gõ “babay-database”. Chưa có ổ cứng ngoài được mount và chưa có đường dẫn ổ riêng do user cung cấp.
- Kết quả: Compose đặt tại [baby-database/compose.yaml](baby-database/compose.yaml); [env mẫu](baby-database/.env.example) dùng ./data và ./backups, đổi vị trí qua POSTGRES_DATA_DIR/POSTGRES_BACKUP_DIR. Scripts neo đường dẫn theo database folder, không phụ thuộc thư mục gọi. Backend đã tách server DB và có hướng dẫn kết nối hai stack.
- Kiểm chứng: Compose config và Docker inspect xác nhận bind source /Users/congnt/workspace/baby-family/baby-database/data đúng target PG18; backup script gọi từ root vẫn ghi đúng baby-database/backups. Data/backups/env được ignore, Compose/scripts/env mẫu vẫn versionable. Các bài kiểm tra runtime và review ở 001 đạt.
- Còn lại: Không trong phạm vi xác nhận vị trí Compose; hiện chưa có ổ rời vật lý được chỉ định.
- Product history: [BF-20261013-002](PRODUCT_ANALYTICS_HISTORY.md#bf-20261013-002).

<a id="bf-20261013-003"></a>

## BF-20261013-003 — Bắt buộc timestamp/soft delete trong role và giải thích cron/job lỗi

- Ngày làm: 2026-10-13 (Asia/Ho_Chi_Minh); bắt đầu kiểm tra lúc 2026-10-13T07:39:52+07:00, kiểm tra tài liệu lúc 2026-10-13T07:56:14+07:00.
- Yêu cầu: Viết vào role quy tắc tất cả table phải có created_at, updated_at, deleted_at; giải thích cron job có ghi thông tin vào DB không và xử lý job failed thế nào.
- Liên quan: BF-20261011-006, BF-20261013-001.
- Role: DBA/ARCHITECT nghiên cứu chuẩn dữ liệu; BACKEND/DEVOPS kiểm tra scheduler/queue hiện trạng; TESTER/QUALITY review độc lập; ORCHESTRATOR/TECH_WRITER/DATA_ANALYST tổng hợp.
- Trạng thái: Hoàn thành.
- Phân tích: Scope là viết quy tắc vào role và trả lời cơ chế cron, không phải yêu cầu triển khai scheduler/queue hoặc chạy migration. Schema/generator hiện đã có created_at/updated_at, chưa deleted_at; NoteRepository đang hard delete. Chưa có scheduler/queue/job-history trong base. Chuẩn mới cần nêu rõ DB column vs TS field, nullable deleted_at, cập nhật timestamp mọi writer và quy trình durable job/error/retry/crash.
- Kết quả: Đã thêm [chuẩn database](.agents/skills/baby-family-team/references/database-standards.md) và [chuẩn cron/job](baby-backend/docs/jobs.md), cập nhật role DBA/BACKEND/TESTER/QUALITY/DEVOPS, skill, root/backend AGENTS, backend README và đặc tả §7.1/7.2. Mọi bảng app-owned gồm join/job/history bắt buộc 3 cột timestamptz(3), created/updated NOT NULL, deleted nullable, cập nhật bằng DB trigger cho mọi writer; soft delete, partial uniqueness/restore, retention và forward migration được quy định. Jobs có run/attempt history, retry phân loại, idempotency, lease/heartbeat/fencing, crash recovery, missed-schedule policy, DB-outage monitoring/reconciliation; outbox retry dài hạn phân biệt business-job attempts. Ghi rõ tất cả là policy, Note/generator/runtime chưa được đổi.
- Kiểm chứng: Đọc schema/model/repository/generator/manifest, đối chiếu nguồn chính thức Prisma v7/PostgreSQL/Nest/BullMQ. Targeted Prettier đạt; 30 đường dẫn link local tồn tại; quick_validate skill đạt với dependency PyYAML có sẵn trong /tmp (lần chạy mặc định thiếu module, đã chạy lại thành công); git diff --check đạt, ID/anchor 003 duy nhất ở cả hai logs. Source/schema/generator/lock không có diff. Review QUALITY/TESTER và BACKEND/DEVOPS độc lập đều đạt, không có must-fix; reviewer xác nhận 34 targets trong 8 docs/entrypoints, coverage policy và 8 block lịch sử cũ giữ nguyên SHA256. Không chạy backend/runtime tests hoặc migration vì thay đổi chỉ là tài liệu/quy tắc.
- Còn lại: Không trong phạm vi viết quy tắc/giải thích. Triển khai timestamps/soft delete vào Note/generator và triển khai scheduler/job runtime cần công việc riêng; chưa có migration hoặc chức năng cron tự lưu/retry trong base.
- Product history: [BF-20261013-003](PRODUCT_ANALYTICS_HISTORY.md#bf-20261013-003).

<a id="bf-20261013-004"></a>

## BF-20261013-004 — Thiết kế database theo đặc tả và thiết kế, license theo family

- Ngày làm: 2026-10-13 (Asia/Ho_Chi_Minh); bắt đầu lúc 2026-10-13T20:55:23+07:00. Hoàn thành/cập nhật kết quả lúc 2026-10-14T07:28:29+07:00.
- Yêu cầu: Đối chiếu luồng/tính năng trong docs và desgin, phân tích và thiết kế cấu trúc database chính xác, hiệu quả, dễ mở rộng; gói Pro/license thuộc family, user là người mua. Yêu cầu được gửi lại sau lượt bị ngắt trước khi có thao tác; xử lý chung một phạm vi.
- Liên quan: BF-20261013-003, BF-20261011-001.
- Role: ORCHESTRATOR/ARCHITECT chủ trì; BA/PRODUCT đối chiếu đặc tả; DESIGN phân tích canvas read-only; DBA thiết kế constraints/index/transactions; BACKEND/INTEGRATION cho Prisma và billing; SECURITY_PRIVACY, TESTER/QUALITY review; DATA_ANALYST impact note.
- Trạng thái: Hoàn thành thiết kế database và persistence trong phạm vi đã giao.
- Phân tích: Tách nguồn nghiệp vụ, UI minh họa và schema kỹ thuật cũ; quyết định mới nhất license thuộc family là bắt buộc. Kiểm tra đầy đủ màn/luồng và ràng buộc tenant/privacy, lifecycle/soft-delete, billing, quota, job history. Thiết kế có artifact kiểm chứng, không tự áp dụng schema chưa chốt vào DB ứng dụng đang chạy; hỏi điểm nghiệp vụ quan trọng còn thiếu và tiếp tục phần độc lập.
- Kết quả: Đã đối chiếu đặc tả và canvas qua Pencil MCP; tài liệu [database](docs/database/README.md), [requirements](docs/database/requirements.md), [design coverage](docs/database/design-coverage.md), [billing](docs/database/billing.md) và [data dictionary](docs/database/data-dictionary.md). Prisma có 123 models (122 domain + Note), 46 enums; audit ba cột, tenant composite FK, privacy, billing/catalog, quota/storage, Hearts và durable job schema. Model/interface/repository/DI tương ứng đã tạo; API nghiệp vụ và workers chưa được triển khai.
- Kiểm chứng: Canvas 188 top-level nodes (150 screen states, 13 components, 25 labels), 138 mã; đọc 4.019 text nodes, không suy ra navigation wire/runtime. npm run db:verify đạt replay hai migration, seed riêng idempotent, metadata audit/PK/trigger và 47 kịch bản SQL. Prisma diff DB cách ly → schema không khác; các checks code/DI/persistence đạt, xem [verification](docs/database/verification.md). Không áp migration/seed vào DB ứng dụng.
- Còn lại: Không còn việc trong phạm vi thiết kế/persistence. Các quyết định destructive/retention còn mở được ghi trong requirements để chốt trước executor; phase chưa đủ chi tiết có migration riêng khi triển khai.
- Product history: [BF-20261013-004](PRODUCT_ANALYTICS_HISTORY.md#bf-20261013-004).

<a id="bf-20261013-005"></a>

## BF-20261013-005 — Trial 7 ngày, catalog gói mở rộng và nguyên tắc thiết kế hệ thống

- Ngày làm: 2026-10-13 (Asia/Ho_Chi_Minh); nhận xác nhận và kiểm tra lúc 2026-10-13T21:27:46+07:00. Hoàn thành/cập nhật kết quả lúc 2026-10-14T07:28:29+07:00.
- Yêu cầu: Giữ House/Family, đổi trial mặc định từ 90 thành 7 ngày; gói phải mở rộng được, hạn chế fix cứng; ghi nguyên tắc mở rộng bắt buộc vào role thiết kế/backend/frontend. License luôn thuộc family gốc, không chuyển; Store renew đã thanh toán sau payer xóa account vẫn cấp family gốc.
- Liên quan: BF-20261013-004; trả lời BILL-Q1/Q2/Q3.
- Role: PRODUCT/BA cập nhật nguồn; ARCHITECT/DBA/BACKEND cho catalog/version/trial policy; FRONTEND/MOBILE cho entitlement-driven clients; TESTER/QUALITY review; ORCHESTRATOR/DATA_ANALYST ghi lịch sử.
- Trạng thái: Hoàn thành.
- Phân tích: Đây là thay đổi nghiệp vụ đã xác nhận, thay thế các đoạn trial90/3tháng và transfer/renew cũ. Plan là dữ liệu catalog, quota/features có version, trial policy có phiên bản và applied validity cố định; client dùng capabilities thay vì enum/tên gói. Extensibility cần contract/validation/backward compatibility, không biến mọi state kỹ thuật thành cấu hình tùy ý.
- Kết quả: Giữ House/Family trong catalog JSON; plan/version/product/trial policy mở rộng bằng dữ liệu, không enum tên gói. Default trial 604800 giây (7 ngày), applied grant không hồi tố. Family/license binding bất biến, không chuyển; purchaser nullable và renewal đã thanh toán tiếp tục thuộc family gốc. Đồng bộ docs và [extensibility standards](.agents/skills/baby-family-team/references/extensibility-standards.md), role/skill/root/backend AGENTS bắt buộc cả backend/frontend/mobile.
- Kiểm chứng: 47 kịch bản domain trên PostgreSQL cách ly có thêm plan, trial version/validity/không cấp lặp, never-transfer và payer detach/paid renewal giữ family gốc. Seed hai lần có digest không đổi. Skill validation và local doc links đạt; canvas giữ nguyên snapshot, copy90ngày được ghi là discrepancy.
- Còn lại: Không còn việc trong scope thiết kế/catalog/rules. Store verification, capability API và frontend runtime thực thi khi làm tính năng tương ứng; chưa có thay đổi quyền lợi thật.
- Product history: [BF-20261013-005](PRODUCT_ANALYTICS_HISTORY.md#bf-20261013-005).

<a id="bf-20261013-006"></a>

## BF-20261013-006 — Đưa schema và migration về backend Prisma

- Ngày làm: 2026-10-13 (Asia/Ho_Chi_Minh); nhận lúc 2026-10-13T21:42:21+07:00. Hoàn thành/cập nhật kết quả lúc 2026-10-14T07:28:29+07:00.
- Yêu cầu: Sửa việc đặt schema/DDL vào database folder; cấu trúc DB phải được backend quản lý bằng Prisma migrations, làm cẩn thận và nhất quán với workflow dự án.
- Liên quan: BF-20261013-004/005.
- Role: ORCHESTRATOR/BACKEND/DBA sửa ownership và migration workflow; TESTER/QUALITY review; DATA_ANALYST ghi impact.
- Trạng thái: Hoàn thành.
- Phân tích: Vị trí candidate trước đó gây lệch kiến trúc: baby-database chỉ server/data/backup, backend sở hữu Prisma schema/migration. Không có SQL nào đã áp vào DB ứng dụng; các lần trước chỉ chạy PostgreSQL ephemeral. Cần chuyển artifacts cấu trúc về backend, tạo schema.prisma thực và forward migration, giữ migration Note đã áp, kiểm chứng bằng migrate deploy/generate/check trên DB cách ly.
- Kết quả: Cấu trúc ứng dụng nằm trong [backend Prisma schema](baby-backend/prisma/schema.prisma) và [forward migration](baby-backend/prisma/migrations/20261013150000_family_domain/migration.sql); giữ nguyên init đã có. baby-database chỉ server/Compose/data/backups. Test/scripts/docs cùng trỏ nguồn backend; schema normalize dùng tên domain camelCase/PascalCase giữ DB maps, seed tách riêng theo yêu cầu001.
- Kiểm chứng: Prisma format/validate/generate, migrate deploy init+domain trên PostgreSQL cách ly và migrate diff không khác đều đạt. npm run check đạt; không áp schema/seed vào DB ứng dụng. Không còn cấu trúc ứng dụng trong database/design.
- Còn lại: Không còn việc trong scope ownership/migration. Deploy schema và seed là thao tác riêng theo môi trường; chưa thực hiện trên DB ứng dụng.
- Product history: [BF-20261013-006](PRODUCT_ANALYTICS_HISTORY.md#bf-20261013-006).

<a id="bf-20261014-001"></a>

## BF-20261014-001 — Cấm CRUD dữ liệu trong migration, tách seed riêng

- Ngày làm: 2026-10-14 (Asia/Ho_Chi_Minh); kiểm tra lúc 2026-10-14T06:49:13+07:00. Hoàn thành/cập nhật kết quả lúc 2026-10-14T07:28:29+07:00.
- Yêu cầu: Tiếp tục công việc; nghiêm cấm CRUD dữ liệu trong migration, không để INSERT catalog trong migration.
- Liên quan: BF-20261013-004/005/006.
- Role: BACKEND/DBA triển khai, TESTER/QUALITY review; ORCHESTRATOR/DATA_ANALYST ghi lịch sử.
- Trạng thái: Hoàn thành.
- Phân tích: Forward migration mới chưa áp ứng dụng nên có thể sửa trước phát hành. Migration chỉ DDL; catalog House/Family/trial là seed riêng, chạy chủ động qua npm run db:seed, không tự seed lúc migrate/start. DDL định nghĩa trigger/constraint không phải chạy CRUD dữ liệu nghiệp vụ.
- Kết quả: Loại INSERT catalog khỏi migration mới; migrations chỉ DDL. Tạo [prisma/seed.ts](baby-backend/prisma/seed.ts) + [catalog.json](baby-backend/prisma/seeds/catalog.json), chạy chủ động npm run db:seed, không tự chạy khi migrate/start/Compose. Seed insert-once qua transaction, không ghi đè catalog đã tồn tại; immutable version mismatch rollback. Thêm guard SQL và regression test, quy tắc bắt buộc trong roles/AGENTS/standards.
- Kiểm chứng: Guard CLI kiểm hai migrations đạt; 6/6 nhóm regression gồm top-level DML/CTE/DO/SQL động và quoted function calls đạt, review độc lập đóng finding. Replay migrate deploy để catalog trống; chạy seed riêng hai lần digest giữ nguyên; 47 domain scenarios đạt. Guard là kiểm tra tĩnh bổ trợ review, không thay SQL parser/sandbox.
- Còn lại: Không còn việc trong scope DDL-only/seed. Backfill và thay catalog đang vận hành dùng script/service/command riêng được review.
- Product history: [BF-20261014-001](PRODUCT_ANALYTICS_HISTORY.md#bf-20261014-001).

<a id="bf-20261014-002"></a>

## BF-20261014-002 — Bổ sung model và repository tương ứng schema

- Ngày làm: 2026-10-14 (Asia/Ho_Chi_Minh). Hoàn thành/cập nhật kết quả lúc 2026-10-14T07:28:29+07:00.
- Yêu cầu: Bổ sung model/repository tương ứng các bảng, không chỉ có thiết kế/DDL.
- Liên quan: BF-20261013-004/006, BF-20261014-001.
- Role: BACKEND tạo persistence OOP, DBA bảo toàn constraints, TESTER/QUALITY review độc lập; ORCHESTRATOR/DATA_ANALYST tổng hợp.
- Trạng thái: Hoàn thành.
- Phân tích: Cần model attributes/helpers, I-prefixed repository contracts + Symbol tokens, concrete repositories trả model, DI; composite PK/JSON/audit/soft delete đúng. Ledger/tài chính/audit bất biến không mở generic update/delete. Không tự tạo API/service nghiệp vụ giả khi mới cần persistence.
- Kết quả: Có đủ 123 model classes, 123 I-repository contracts/Symbol tokens và 123 concrete repositories (122 domain + Note). [Manifest](baby-backend/src/database/persistence.manifest.ts) ghi khóa chính/scope/policy, [122 providers](baby-backend/src/database/repository.providers.ts) nối AppModule. 98 domain repos bắt scope tenant, 24 explicit privileged; 18 append-only không generic update/delete. Audit, composite keys, soft delete, exact Decimal/JSON mapping và model instances đã xử lý; sửa MissionSeries tên sinh số ít sai. Generator hash guard bảo vệ chỉnh tay; local check và CI kiểm drift.
- Kiểm chứng: Coverage schema/model/contracts/repos khớp123/123, DI122/122, model/interface không import Prisma. npm run check đạt: 5 suites/24 unit tests, generator10/10, migration-policy6/6, e2e10/10, format/lint/types/build; deterministic persistence --check369files. PostgreSQL integration 2/2 và Prisma diff không khác sau rename. Review độc lập persistence và guard đạt.
- Còn lại: Không còn việc trong scope model/repository/DI. Service/controller nghiệp vụ, authorization và workers triển khai theo từng luồng; persistence không thay thế các phần này.
- Product history: [BF-20261014-002](PRODUCT_ANALYTICS_HISTORY.md#bf-20261014-002).

<a id="bf-20261014-003"></a>

## BF-20261014-003 — Triển khai tầng service và controller

- Ngày làm: 2026-10-14 (Asia/Ho_Chi_Minh); bắt đầu 2026-10-14T19:11:55+07:00. Cập nhật kết quả lúc 2026-10-14T19:44:32+07:00.
- Yêu cầu: Tiếp tục triển khai tầng service và controller trên model/repository đã tạo.
- Liên quan: BF-20261014-002, BF-20261011-004.
- Role: BACKEND/ARCHITECT chủ trì; BA/SECURITY_PRIVACY chốt boundary và quyền; DBA/INTEGRATION bảo toàn persistence; TESTER/QUALITY review; ORCHESTRATOR/DATA_ANALYST tổng hợp.
- Trạng thái: Hoàn thành tầng service/controller nền trong phạm vi đã triển khai; workflow tích hợp đầy đủ theo từng tính năng được ghi rõ riêng.
- Phân tích: Giữ controller mỏng gọi IService/DI, business policy ở service, mọi Prisma/transaction ở repository. Không dùng persistence inputs rộng làm HTTP DTO, không mở CRUD công khai cho secrets/billing/ledger/jobs hoặc dữ liệu riêng. Tạo lớp tương ứng và các endpoint có scope/validation/response projection rõ; kiểm chứng JWT/session, tenant isolation và các đường đại diện.
- Kết quả: Có đủ 122 service/interface domain (117 nội bộ được sinh, 5 nghiệp vụ viết riêng), Note mẫu và 4 service điều phối auth/access/catalog/billing. [DI composition](baby-backend/src/common/application/application.providers.ts) nối AppModule; [API scope](baby-backend/docs/api.md) ghi 7 nhóm controller, DTO, validation và phần chưa triển khai. Có ES256 verifier/live session/tokenVersion, actor từ server, Parent/lifecycle/license expiry gates và response allowlist. Pregnancy POST cấp seqNo trong transaction khóa family, không tái dùng số đã soft delete. Generator local/CI kiểm drift 117 services/236 files và bảo vệ chỉnh tay. Không sửa schema/migration hoặc deploy DB ứng dụng.
- Kiểm chứng: npm run check cuối PASS: schema/DDL policy, persistence 369 files, service 236 files, format/lint/TypeScript/build, 115 unit tests/11 suites, 10 resource generator tests, 6 migration policy groups và 34 HTTP tests/2 suites. PostgreSQL integration 17 tests/3 suites PASS (15 API/auth/catalog/concurrency mới +2 persistence cũ) trên PG18.6 tmpfs, DB riêng *_test sau replay 2 migrations và seed riêng. Hai Pregnancy POST trả 201/201, seqNo 8/9 sau bản ghi synthetic đã soft delete seqNo7; actor và server fields giả mạo bị chặn. Review độc lập đạt; đã sửa BLOCKED-after-partner-left, trial boundary và timezone offset regressions. Coverage 123 model/service/interface, 7 guards và 57 local docs links đạt; Compose config và production audit 0 vulnerabilities. Xem [verification](baby-backend/docs/api-verification.md). Đã dọn container kiểm thử; DB ứng dụng healthy, không đọc/copy dữ liệu người dùng.
- Còn lại: Không còn việc trong scope layering/API nền đã mô tả. Public key issuer cần được cấu hình khi dùng API; chưa triển khai Apple/Google/OTP/refresh token issuance, full Circle/Memory/Us ACL, Store verifier, upload, sync/If-Match/idempotency/outbox và workers/lifecycle destructive. Không coi internal service scaffolding là full workflow hoặc API đã deploy.
- Product history: [BF-20261014-003](PRODUCT_ANALYTICS_HISTORY.md#bf-20261014-003).
