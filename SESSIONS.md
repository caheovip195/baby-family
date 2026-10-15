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
- Trạng thái: Hoàn thành (đóng 2026-10-15T19:25:00+07:00, phần cuối làm ở BF-20261015-002).
- Phân tích: Quy trình như đợt 2: vẽ frame Pencil trước (nguồn sự thật UI) → thêm route/skeleton/mock typed → sub-agent khu vực code theo frame → agent chính chạy make check, build simulator. Mock-only, luồng mặc định cho đi qua, dữ liệu theo câu chuyện v2.
- Kết quả:
  - Pencil: 41 frame mới ở mục 19–24 (US-00, US-08…14, REC-01/03, CARE-11, MEM-17/18/19, RPT-01/02, CHD-05/05b, CIR-02…06, SET-10, SUB-02…06, INV-02/03/04, FAM-02/05/08, SET-05/13).
  - Nền móng app: 26 route mới + shell người thân `/circle` (4 tab, `CircleTabBar`), khoảng 30 model freezed mới, 4 seed (`partnerLeft`, `circlePaused`, `paymentIssue`, `house`); `MockStore` tự đọc fixture lớn (tránh treo widget test).
  - Papa & Mama + tổng kết: Cầu nối 5 bước (US-08…12b), hỗ trợ an toàn US-13 (chỉ số 111/113/115, không gửi gì cho bạn đời), Tuần của hai ta, REC-01/03, CARE-11; bỏ thông báo “Sắp ra mắt”.
  - Gói/lời mời/cài đặt: SUB-02…06 (sheet dùng chung xác nhận mua, giới hạn gói, banner thanh toán), các trạng thái INV-02/03/04, FAM-02/05/08, SET-05/13.
  - Ký ức/người thân/kiểm duyệt: Thùng rác, Nháp, Ảnh chờ duyệt, sheet Báo cáo và dialog Chặn dùng chung, Lưu trữ hồ sơ bé (xoá vĩnh viễn chỉ sau 7 ngày + gõ đúng tên), tab người thân CIR-02…06, Rời gia đình SET-10.
  - Thêm token màu `error-50` vào đặc tả mục 10.2; đổi tên 3 widget private trùng tên giữa các màn (Skill 11).
- Kiểm chứng: `make check` (l10n, format, analyze, toàn bộ test) đạt 679/679 (chạy ngày 2026-10-15); `flutter analyze` sau khi đổi tên widget: không lỗi; rà Skill 11 (import chéo, widget trùng, màu/hằng/extension ngoài constants): rỗng; build iOS simulator staging (`BABY_FAMILY_DEMO=active`) thành công; mở app trên simulator: Trang chủ, tab Papa & Mama, Cầu nối bước 3/5 hiển thị đúng. Ảnh đối chiếu thiết kế ở `baby-family-app/build/design_qa/`.
- Còn lại (cần người dùng chốt): quyền đóng góp ảnh của Bà ngoại cho Hana (frame CIR-04 vẽ chip Hana, quyền chỉ có Haru; fixture `pp-meo` mâu thuẫn); có báo cáo được nội dung AI không (`ReportTarget`); câu “Đến hết ngày” ở ONB-ACT so với giờ hết hạn thực tế; cỡ chữ mặc định seed người thân; lối vào MEM-19 trên FAM-01/NOTI-01 chưa vẽ; vài chi tiết dữ liệu mẫu tự đặt (tên, dung lượng, sự kiện lịch); ảnh Haru trông lớn hơn 18 tháng. Chưa commit.
- Product history: [BF-20261012-001](PRODUCT_ANALYTICS_HISTORY.md#bf-20261012-001).

<a id="bf-20261012-002"></a>

## BF-20261012-002 — Làm các việc còn tồn của đợt 2

- Ngày làm: 2026-10-12 (Asia/Ho_Chi_Minh); entry tạo lúc 2026-10-12T19:20:00+07:00.
- Yêu cầu: “Với các việc còn lại bên trên nữa” — xử lý danh sách tồn đã báo: font viết tay, ghi chú sự kiện, lối vào Lịch sử/Huy hiệu/Cài đặt nhiệm vụ, lệch kit SET-09, lệch số liệu giữa thiết kế và dữ liệu, ảnh Haru.
- Liên quan: BF-20261012-001.
- Role: Chủ trì MOBILE (sub-agent cleanup); DESIGN (sửa frame Pencil); ORCHESTRATOR tổng hợp; TESTER (make check của sub-agent); DATA_ANALYST impact note.
- Trạng thái: Hoàn thành (xem dòng “Trạng thái cập nhật”).
- Phân tích: Người dùng chấp thuận tải font Dancing Script (OFL, kho google/fonts) và thêm vào pubspec. Lệch số liệu giải quyết theo dữ liệu thật, sửa chữ Pencil cho khớp.
- Kết quả:
  - Font Dancing Script + token `AppTypography.handwriting` cho thư gửi con (MEM-14).
  - `CalendarEvent.note` lưu ghi chú sự kiện (CAL-02; CARE-07 không hiển thị vì frame không vẽ).
  - Nút ⋯ ở CARE-01 mở sheet dùng chung Lịch sử / Huy hiệu / Cài đặt nhiệm vụ (thêm cả vào Pencil).
  - Kit: `AppTopBar(currentStepOnly:)`, tham số tuỳ chọn cho `AppChoiceCard` (SET-09).
  - Đồng bộ dữ liệu ↔ Pencil: HOME-03 “4 tên dự định”, MEM-25 “4/4”, Haru 6 lần đầu / 186 ký ức (CHD-01 lấy từ stats), lời mời Bà nội gồm Hana + Haru, ONB-07 mã K7Q2 · 9MXA, ảnh Haru mới (42 node Pencil + asset app).
  - Ngày hết dùng thử khi đó đặt 05/01/2027 (90 ngày); **đã được thay** bằng 7 ngày theo BF-20261013-005, làm ở BF-20261015-002.
- Kiểm chứng: sub-agent chạy `make runner`, `make check` (509 test lúc đó) và build simulator; được kiểm lại trong lần `make check` cuối 679/679 ở BF-20261015-002.
- Trạng thái cập nhật: Hoàn thành (đóng 2026-10-15T19:25:00+07:00).
- Còn lại: ảnh stock Haru trông khoảng 2–3 tuổi; golden CHD-01 chưa hiện ảnh avatar/cover (hạn chế của golden test).
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

<a id="bf-20261014-004"></a>

## BF-20261014-004 — Nâng TypeScript 7.0.2 và đánh giá tương thích

- Ngày làm: 2026-10-14T21:26:07+07:00; hoàn tất 2026-10-15T19:10:55+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: Muốn dùng TypeScript7 thay6; hỏi bản7.0.2 có gì mới và áp dụng vào project có ổn không.
- Liên quan: BF-20261014-003; BF-20261014-004 là yêu cầu gốc, BF-20261015-001 là lượt tiếp tục.
- Role: BACKEND/ARCHITECT đánh giá và triển khai; TESTER/QUALITY/DEVOPS kiểm pipeline/build/runtime; ORCHESTRATOR/DATA_ANALYST tổng hợp.
- Trạng thái: Hoàn thành.
- Phân tích: Xác minh nguồn Microsoft/npm/ts-jest: 7.0.2 là stable đầu tiên của 7.0, native compiler Go; JS Compiler API cũ vẫn cần compatibility package. Main build/typecheck/watch phải gọi CLI7 thật; giữ strict/decorator metadata, NodeNext và OOP/DI. Không diễn giải .2 thành changelog patch riêng.
- Kết quả: Đã pin @typescript/native → typescript@7.0.2 và typescript → @typescript/typescript6@6.0.2 (API thực 6.0.3 trong lockfile), thay Nest CLI build/watch bằng native runners có noEmitOnError và cleanup process tree; cấu hình Jest/tools tách biệt. Fresh Prisma NodeNext phát hiện .js → .ts resolver lỗi ở seed; đã sửa tsconfig.tools.json/seed command và Jest mapper, thêm regression. CI kiểm actual dist AppModule/DI/JWT/DTO/Swagger/scope. [Hướng dẫn và nguồn](baby-backend/docs/typescript-7.md), README/architecture/AGENTS đồng bộ. Không sửa schema/migration/business source hoặc deploy DB ứng dụng. Lượt14 gián đoạn usage trước mutation, toàn bộ nâng và kiểm chứng hoàn tất lượt15.
- Kiểm chứng: npm run check PASS với Prisma Client sinh mới: schema/DDL/drift 369+236 files/format/lint/native typecheck/build; 115 unit, 34 HTTP, 10 resource generator, 6 migration policy, 5 compiler compatibility, 7 runner và 1 compiled application test. PG18.6 integration 17/17 PASS trên tmpfs *_test; replay 2 migrations, seed explicit. Docker api/migrate build PASS, migrate/seed/runtime readiness + Note create/read/soft delete PASS; production không chứa compiler. Native watch thực tế macOS: restart A→B→C, TS2322 giữ output/app, initial error không chạy stale build, SIGTERM không còn child processes. Review độc lập runner/config/runtime/resolver đạt. npm ls valid; tsc7.0.2/tsc6/API6.0.3. Local M1 Max/macOSarm64/Node26.11.1 warmup1 +3 lượt xen kẽ cùng tsconfig noEmit: median TS6 5.2054s, TS7 1.0873s (~4.79×); chỉ là typecheck local, không suy full CI/Jest/API. 38 local docs links đạt; container/network kiểm thử đã dọn, app PostgreSQL healthy.
- Còn lại: Không còn việc trong scope nâng compiler. Jest/ESLint/generator/seed còn dùng API TS6 theo compatibility; Windows watch chưa kiểm runtime. ts-node có warning DEP0180 trên Node26 nhưng seed thành công. Theo dõi tooling khi API TS7 ổn định; không tự upgrade major khác hoặc sửa dev-only audit ngoài scope.
- Product history: [BF-20261014-004](PRODUCT_ANALYTICS_HISTORY.md#bf-20261014-004).

<a id="bf-20261015-001"></a>

## BF-20261015-001 — Tiếp tục nâng TypeScript 7.0.2

- Ngày làm: 2026-10-15T18:39:45+07:00; hoàn tất 2026-10-15T19:10:55+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: Tiếp tục yêu cầu nâng/đánh giá TypeScript7.0.2 sau lượt bị gián đoạn.
- Liên quan: BF-20261014-003; BF-20261014-004 là yêu cầu gốc, BF-20261015-001 là lượt tiếp tục.
- Role: BACKEND/ARCHITECT đánh giá và triển khai; TESTER/QUALITY/DEVOPS kiểm pipeline/build/runtime; ORCHESTRATOR/DATA_ANALYST tổng hợp.
- Trạng thái: Hoàn thành.
- Phân tích: Xác minh nguồn Microsoft/npm/ts-jest: 7.0.2 là stable đầu tiên của 7.0, native compiler Go; JS Compiler API cũ vẫn cần compatibility package. Main build/typecheck/watch phải gọi CLI7 thật; giữ strict/decorator metadata, NodeNext và OOP/DI. Không diễn giải .2 thành changelog patch riêng.
- Kết quả: Đã pin @typescript/native → typescript@7.0.2 và typescript → @typescript/typescript6@6.0.2 (API thực 6.0.3 trong lockfile), thay Nest CLI build/watch bằng native runners có noEmitOnError và cleanup process tree; cấu hình Jest/tools tách biệt. Fresh Prisma NodeNext phát hiện .js → .ts resolver lỗi ở seed; đã sửa tsconfig.tools.json/seed command và Jest mapper, thêm regression. CI kiểm actual dist AppModule/DI/JWT/DTO/Swagger/scope. [Hướng dẫn và nguồn](baby-backend/docs/typescript-7.md), README/architecture/AGENTS đồng bộ. Không sửa schema/migration/business source hoặc deploy DB ứng dụng. Lượt14 gián đoạn usage trước mutation, toàn bộ nâng và kiểm chứng hoàn tất lượt15.
- Kiểm chứng: npm run check PASS với Prisma Client sinh mới: schema/DDL/drift 369+236 files/format/lint/native typecheck/build; 115 unit, 34 HTTP, 10 resource generator, 6 migration policy, 5 compiler compatibility, 7 runner và 1 compiled application test. PG18.6 integration 17/17 PASS trên tmpfs *_test; replay 2 migrations, seed explicit. Docker api/migrate build PASS, migrate/seed/runtime readiness + Note create/read/soft delete PASS; production không chứa compiler. Native watch thực tế macOS: restart A→B→C, TS2322 giữ output/app, initial error không chạy stale build, SIGTERM không còn child processes. Review độc lập runner/config/runtime/resolver đạt. npm ls valid; tsc7.0.2/tsc6/API6.0.3. Local M1 Max/macOSarm64/Node26.11.1 warmup1 +3 lượt xen kẽ cùng tsconfig noEmit: median TS6 5.2054s, TS7 1.0873s (~4.79×); chỉ là typecheck local, không suy full CI/Jest/API. 38 local docs links đạt; container/network kiểm thử đã dọn, app PostgreSQL healthy.
- Còn lại: Không còn việc trong scope nâng compiler. Jest/ESLint/generator/seed còn dùng API TS6 theo compatibility; Windows watch chưa kiểm runtime. ts-node có warning DEP0180 trên Node26 nhưng seed thành công. Theo dõi tooling khi API TS7 ổn định; không tự upgrade major khác hoặc sửa dev-only audit ngoài scope.
- Product history: [BF-20261015-001](PRODUCT_ANALYTICS_HISTORY.md#bf-20261015-001).

<a id="bf-20261015-002"></a>
## BF-20261015-002 — Tiếp tục đợt 3 UI Flutter sau gián đoạn

- Ngày làm: 2026-10-15 (Asia/Ho_Chi_Minh); entry tạo lúc 2026-10-15T19:05:41+07:00.
- Yêu cầu: “Try again” / “Tiếp tục đi” — tiếp tục BF-20261012-001/002 sau khi sub-agent khu vực Ký ức/Người thân/Báo cáo bị dừng do giới hạn sử dụng.
- Liên quan: BF-20261012-001, BF-20261012-002; quyết định trial 7 ngày ở BF-20261013-005.
- Role: Chủ trì ORCHESTRATOR; MOBILE (sub-agent khu vực), DESIGN (đối chiếu/sửa Pencil), SECURITY_PRIVACY (quyền người thân, báo cáo), TESTER/QUALITY (make check, build, kiểm tra simulator của agent chính), DATA_ANALYST (impact note).
- Trạng thái: Hoàn thành (2026-10-15T19:25:00+07:00).
- Phân tích: Còn khu vực Ký ức/Người thân/Báo cáo đang dở; sau đó hợp nhất, đồng bộ copy trial 90 ngày → 7 ngày theo BF-20261013-005 (app mock + Pencil), chạy make check và build.
- Kết quả:
  - Sub-agent Ký ức/Người thân/Báo cáo hoàn tất (chi tiết ở BF-20261012-001), thêm khoảng 166 key l10n đủ 4 ngôn ngữ và 56 test.
  - Trial lấy từ cấu hình: `catalog.json` có `trialPolicy` (604800 giây), `IFamilyRepository.trialPolicy()`, `IFamilyService.trialDuration()`; `kValueDefaultTrialDuration` chỉ là giá trị dự phòng. Màn AUTH-01, ONB-07, ONB-WAIT, ONB-ACT, INV-04 đọc số ngày từ service; ONB-ACT dùng thời lượng của grant đã cấp.
  - Mock: dùng thử hết hạn 14/10/2026, “Còn 7 ngày”. Pencil: sửa 10 chỗ “3 tháng / 90 ngày” trên các frame Đăng nhập, Mời bạn đời, Chờ bạn đời, Kích hoạt, Gói, Xác nhận mua, Hết hạn, Gia đình (dùng thử), Lời mời chờ xác nhận.
  - Agent chính: đổi tên widget private trùng tên (`_CircleChildHeader`, `_CircleFirstCard`, `_HomeChapterCard`), thêm token `error-50` vào đặc tả mục 10.2.
- Kiểm chứng: `make check` 679/679 test, analyze không lỗi; rà Skill 11 rỗng; build iOS simulator thành công; mở app trên simulator (Trang chủ, Papa & Mama, Cầu nối) hiển thị đúng.
- Còn lại: các điểm cần chốt ghi ở BF-20261012-001; chưa commit.
- Product history: [BF-20261015-002](PRODUCT_ANALYTICS_HISTORY.md#bf-20261015-002).

<a id="bf-20261015-003"></a>
## BF-20261015-003 — Rà cấu trúc backend/DB, xác định service/cache/storage còn thiếu

- Ngày làm: 2026-10-15 (Asia/Ho_Chi_Minh); entry tạo lúc 2026-10-15T19:30:00+07:00, cập nhật kết quả lúc 2026-10-15T19:50:00+07:00.
- Yêu cầu: Kiểm tra cấu trúc backend và database đã ổn chưa, có đáp ứng được các tính năng trong app chưa; xem còn thiếu gì cần bổ sung (service, cache, storage…). Hiện mọi thứ chạy Docker local.
- Liên quan: BF-20261013-004, BF-20261014-002, BF-20261014-003.
- Role: Chủ trì ARCHITECT; hỗ trợ DBA, DEVOPS, INTEGRATION, SECURITY_PRIVACY; QUALITY tự review (agent chính áp dụng góc nhìn, không có sub-agent độc lập); DATA_ANALYST impact note.
- Trạng thái: Hoàn thành (đánh giá/tư vấn, không sửa code).
- Phân tích: Đối chiếu đặc tả kỹ thuật §2/§3/§8/§9/§10 với code: layering và schema (123 models, 5 schema app/billing/ops/us, pg_trgm/unaccent, tsvector, 43 trigger updated_at) đủ nền; khoảng trống chính là workflow API, hạ tầng phụ trợ và tiến trình worker. App có khoảng 95 màn chạy mock; AppClient gọi /auth/refresh, /auth/logout, /me/devices mà backend chưa có.
- Kết quả: Kết luận cấu trúc backend/DB ổn để phát triển tiếp nhưng chưa đáp ứng tính năng app. Thiếu theo ưu tiên: (1) áp migration domain + seed vào DB local; (2) auth issuance (OTP/Apple/Google, refresh rotation, devices); (3) object storage S3 (thư mục `baby-storage/` đang rỗng) + media worker; (4) Redis/Valkey cho cache AccessContext, rate limit nhiều instance, OTP, BullMQ; (5) tiến trình worker/scheduler + outbox publisher; (6) adapter provider giả cho local (OTP, FCM, email qua Mailpit); (7) API workflow theo tính năng. Không cần MongoDB/Elasticsearch ở giai đoạn local; realtime, observability, reverse proxy để sau.
- Kiểm chứng: `npx prisma validate` hợp lệ; `npx prisma migrate status` báo `20261013150000_family_domain` chưa áp dụng vào DB local `baby_family`; `docker ps` chỉ có `baby-database-postgres-1` (healthy). Đọc `docs/api.md`, `docs/jobs.md`, `src/config/environment.ts`, `app.module.ts`, `app_client.dart`. Không chạy test (task đánh giá).
- Còn lại: Chờ người dùng chọn hạng mục triển khai; thêm thư mục `workers/`/entrypoint worker cần người dùng đồng ý vì đổi cấu trúc backend; áp migration vào DB local cần người dùng xác nhận.
- Product history: [BF-20261015-003](PRODUCT_ANALYTICS_HISTORY.md#bf-20261015-003).

<a id="bf-20261015-004"></a>
## BF-20261015-004 — Ghi nhận có agent ngoài (Gemini qua Antigravity, ChatGPT Plus) để gọi qua CLI

- Ngày làm: 2026-10-15T19:52:00+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: Người dùng có thêm agent Gemini 3.8 (Antigravity gói Pro) và ChatGPT gói Plus; được gọi qua cmd khi cần để tiết kiệm token.
- Liên quan: BF-20261015-003 (gửi trong lúc đang làm).
- Role: ORCHESTRATOR.
- Trạng thái: Hoàn thành (ghi nhận).
- Phân tích: Kiểm tra PATH: có `agy` (~/.local/bin/agy); không thấy `gemini`, `codex`, `chatgpt`. Task BF-20261015-003 là đánh giá đã gần xong nên không cần giao thêm.
- Kết quả: Ghi nhận ưu tiên dùng agent ngoài cho phần đọc/phân tích độc lập ở task sau; agent chính vẫn giữ quyền ghi nhật ký và tự kiểm lại kết quả.
- Kiểm chứng: `command -v` cho các CLI trên.
- Còn lại: Cần người dùng xác nhận lệnh gọi ChatGPT (ví dụ `codex`) nếu đã cài ở nơi khác.
- Product history: [BF-20261015-004](PRODUCT_ANALYTICS_HISTORY.md#bf-20261015-004).

<a id="bf-20261015-005"></a>
## BF-20261015-005 — Áp migration + seed DB local, dựng Valkey/MinIO/Mailpit ở baby-storage

- Ngày làm: 2026-10-15 (Asia/Ho_Chi_Minh); entry tạo lúc 2026-10-15T20:00:00+07:00, hoàn thành khoảng 2026-10-15T20:15:00+07:00.
- Yêu cầu: “Làm bước 1 và 2: áp migration + seed vào DB local, dựng thêm Valkey, MinIO, Mailpit ở baby-storage và compose.”
- Liên quan: BF-20261015-003.
- Role: Chủ trì DEVOPS; hỗ trợ DBA, BACKEND, SECURITY_PRIVACY; TESTER/QUALITY tự review (agent chính, không có sub-agent độc lập).
- Trạng thái: Hoàn thành.
- Phân tích: Backup trước khi áp migration theo README database; dùng `migrate deploy` (không dùng `migrate dev`, vì lệnh đó có thể reset DB). Image MinIO chính thức không còn trên Docker Hub/Quay nên dùng bản build Chainguard pin digest, ghi rủi ro theo §10.8. mc của Chainguard không có shell nên đóng gói init trên alpine. Backend dùng key MinIO riêng (least privilege), không dùng root. Cổng host chỉ bind 127.0.0.1. Valkey dùng `noeviction` + AOF cho BullMQ.
- Kết quả: Backup `baby-database/backups/baby-family-20261015T123444Z-DGiWPm.dump`; đã áp `20261013150000_family_domain` và seed catalog. Tạo [baby-storage](baby-storage/README.md): `compose.yaml` (valkey 9.0.6, MinIO RELEASE.2026-09-22, mailpit v1.31.6, minio-init), `scripts/init-env.sh` (sinh secret ngẫu nhiên, tạo data/), `minio-init/` (4 bucket bf-media/bf-user-media/bf-exports/bf-public, versioning, lifecycle 30/7 ngày, user `baby-backend-rw`). Backend compose tham gia network `baby-family-storage` và nhận biến REDIS/S3/SMTP; `.env.example` và `.env` local có khóa mới; `.gitignore` bỏ qua `baby-storage/data/`; CI validate thêm compose storage; README database/backend được cập nhật. Backend API đang chạy ở container `baby-backend-api-1`.
- Kiểm chứng: `prisma migrate status` → up to date; DB có app 78/billing 13/ops 17/us 15 bảng, 271 trigger, catalog 3 plans/3 plan_versions/1 trial_policy. `docker compose up --wait`: valkey/mailpit healthy, minio up; minio-init chạy 2 lần đều thành công (idempotent). Key backend put/get được, tạo bucket/admin bị Access Denied; anonymous GET bf-media 403. Valkey không auth → NOAUTH, policy noeviction, appendonly yes. Gửi SMTP thử tới Mailpit nhận 1 thư rồi xóa. Backend compose: migrate exit 0, api healthy, `/health/ready` 200 database up, từ container api kết nối được valkey và minio (200). Prettier và `docker compose config` cho cả 3 stack đạt. Không chạy `npm run check` vì không đổi source TypeScript.
- Còn lại: Backend chưa có code dùng Redis/S3/SMTP (adapter, upload intent, BullMQ là bước sau). MinIO không có healthcheck vì image không có shell/curl. Chưa commit.
- Product history: [BF-20261015-005](PRODUCT_ANALYTICS_HISTORY.md#bf-20261015-005).

<a id="bf-20261015-006"></a>
## BF-20261015-006 — Adapter backend cho Valkey, MinIO (S3) và Mailpit (SMTP)

- Ngày làm: 2026-10-15 (Asia/Ho_Chi_Minh); entry tạo lúc 2026-10-15T19:50:00+07:00, hoàn thành lúc 2026-10-15T20:02:42+07:00.
- Yêu cầu: Session phụ (giao từ session chính của BF-20261015-005): thêm hạ tầng adapter trong baby-backend dùng Valkey/MinIO/Mailpit theo OOP/DI — validate REDIS_URL/S3_*/SMTP_*, interface + implementation cho cache/kv, object storage S3 path-style (presigned PUT/GET, không root key), mail sender SMTP; readiness Valkey/MinIO trong health; ThrottlerModule lưu ở Valkey khi có REDIS_URL. Chưa làm BullMQ/worker. Done khi `npm run check` đạt và có integration test với stack local.
- Liên quan: BF-20261015-005.
- Role: Chủ trì BACKEND; hỗ trợ SECURITY_PRIVACY, DEVOPS; TESTER do agent chính; QUALITY/SECURITY review độc lập bằng Codex CLI (`codex exec --sandbox read-only`), agent chính đánh giá và xử lý phát hiện. Codex cũng tra API ioredis 6, AWS SDK presign và nodemailer 10.
- Trạng thái: Hoàn thành.
- Phân tích: Lint dự án cấm service import `database/`, nên Valkey (kho key-value) đi qua repository: `ICacheRepository`/`CACHE_REPOSITORY` → `CacheRepository`, kết nối dùng chung `database/valkey.connection.ts`. S3 và SMTP là adapter ngoài, đặt ở services theo quy ước `ObjectStorageService`/`MailService` + interface/Symbol. Mọi biến là tùy chọn (chuỗi rỗng = tắt); S3 phải đủ bộ; SMTP production bắt buộc TLS. Adapter chưa cấu hình hoặc không kết nối được ném `ServiceUnavailableError` 503, thông điệp không lộ URL/secret. AWS SDK mặc định thêm checksum CRC32 vào presigned PUT và không ký `content-type`, nên tắt checksum tự động (`WHEN_REQUIRED`) và ép ký `content-type`. Throttler: Codex chỉ ra bản fixed-window đầu tiên yếu hơn storage in-memory ở ranh giới cửa sổ và lỗi khi `blockDuration=0`; đã viết lại thành sliding log bằng sorted set (khớp đặc tả §9). Valkey mất kết nối thì tạm dùng in-memory theo instance. Giữ HealthController probe hạ tầng trực tiếp theo ngoại lệ có sẵn trong AGENTS/lint (không thêm IHealthService như Codex đề xuất). Dependency chọn bản đã phát hành ít nhất 2 tuần: ioredis 6.0.0, @aws-sdk/client-s3 và s3-request-presigner 3.1142.0, nodemailer 10.0.13 (có sẵn types).
- Kết quả: Trong `baby-backend`: `src/config/environment.ts` (REDIS_URL, S3_*, S3_BUCKET_*, SMTP_*); `src/database/valkey.connection.ts` + DatabaseModule export; `src/interfaces/repositories/cache-repository.interface.ts`, `src/repositories/cache.repository.ts` (get/set TTL/SET NX/increment có TTL/delete); `src/interfaces/services/object-storage-service.interface.ts`, `src/services/object-storage.service.ts` (presigned PUT/GET path-style, ký bằng `S3_PUBLIC_ENDPOINT`, headObject/deleteObject, kiểm key/TTL/content-type, Content-Disposition); `src/interfaces/services/mail-service.interface.ts`, `src/services/mail.service.ts`; `src/common/throttling/valkey-throttler.storage.ts`; `src/common/health/dependency-status.ts`; `ServiceUnavailableError`. `/health/ready` trả `database/cache/objectStorage` = up/down/disabled, 503 khi dịch vụ đã cấu hình bị down. AppModule bind 3 token; ThrottlerModule dùng Valkey khi có REDIS_URL. Test: `test/unit/supporting-services.spec.ts`, `test/integration/supporting-services.spec.ts` (Valkey logical DB 15, bucket exports, Mailpit API; bỏ qua nếu không có cấu hình), e2e readiness 503; `test/setup-env.ts` và test compiled tắt dịch vụ phụ trợ. Tài liệu: `docs/architecture.md` (mục Dịch vụ phụ trợ), README, `.env.example`, comment compose.
- Kiểm chứng: `npm run check` EXIT=0 (check migrations, prisma validate, persistence/services --check, prettier, eslint, typecheck TS7, build, test:compiled, unit 128/128 + node tests, e2e 35/35). `npm run test:integration` 23/23 với stack local (Postgres `baby_family_test`, Valkey, MinIO user `baby-backend`, Mailpit): presigned PUT đúng content-type 200, sai content-type 403, sửa `X-Amz-Expires` 403, GET có `attachment`; throttler sliding/block/blockDuration 0; 429 qua ThrottlerGuard; Mailpit nhận thư rồi xóa. Với `TEST_*` rỗng, 5 test được bỏ qua. `npm audit --omit=dev`: 0 vulnerabilities. Để chạy integration, đã áp `prisma migrate deploy` vào DB test riêng `baby_family_test` (thiếu `20261013150000_family_domain` từ trước); DB dev không bị đụng. Review Codex: 4 phát hiện, sửa 3, giữ 1 có lý do.
- Còn lại: Container `baby-backend-api-1` đang chạy image cũ; cần `docker compose up -d --build` để dùng adapter. Chưa làm BullMQ/worker (cần duyệt thư mục `workers/`), API upload-intent/complete, cache OTP/AccessContext. CI chưa có Valkey/MinIO/Mailpit nên integration storage bị bỏ qua ở CI. Chưa commit.
- Product history: [BF-20261015-006](PRODUCT_ANALYTICS_HISTORY.md#bf-20261015-006).

<a id="bf-20261015-007"></a>
## BF-20261015-007 — Dùng thêm Codex CLI/Antigravity CLI để tra cứu

- Ngày làm: 2026-10-15T19:52:17+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: Người dùng đã cài thêm `codex`; dùng thêm codex hoặc antigravity CLI (`agy`) để tra cứu cho đỡ tốn token (gửi giữa lúc làm BF-20261015-006).
- Liên quan: BF-20261015-004, BF-20261015-006.
- Role: ORCHESTRATOR.
- Trạng thái: Hoàn thành (ghi nhận và áp dụng trong BF-20261015-006).
- Phân tích: `command -v` thấy `/opt/homebrew/bin/codex` (codex-cli 0.162.1) và `agy`. Dùng `codex exec --sandbox read-only` cho tra cứu API thư viện và review diff; agent chính vẫn kiểm lại kết quả và giữ quyền ghi nhật ký. Tiếp tục BF-20261015-006, không đổi phạm vi.
- Kết quả: Đã giao codex tra API ioredis 6/AWS SDK presign/nodemailer 10 trong BF-20261015-006.
- Kiểm chứng: `codex --version` → codex-cli 0.162.1.
- Còn lại: Không.
- Product history: [BF-20261015-007](PRODUCT_ANALYTICS_HISTORY.md#bf-20261015-007).

<a id="bf-20261015-008"></a>
## BF-20261015-008 — Tiếp tục: rebuild API container và kiểm tra adapter trong Docker

- Ngày làm: 2026-10-15 (Asia/Ho_Chi_Minh); entry tạo lúc 2026-10-15T20:11:18+07:00, hoàn thành lúc 2026-10-15T20:17:14+07:00.
- Yêu cầu: "Tiếp tục đi" sau khi bàn giao BF-20261015-006.
- Liên quan: BF-20261015-006.
- Role: Chủ trì DEVOPS; hỗ trợ BACKEND; TESTER/QUALITY tự review (agent chính).
- Trạng thái: Hoàn thành.
- Phân tích: Việc còn lại rõ ràng nhất của BF-20261015-006 là container API chạy image cũ. Hạng mục lớn hơn (BullMQ/worker cần duyệt thư mục `workers/`, API upload) để người dùng chọn.
- Kết quả: Lần rebuild đầu, API khởi động lỗi liên tục vì compose chạy `NODE_ENV=production` mà Mailpit không có TLS, nên vướng quy tắc production SMTP phải TLS từ BF-20261015-006. Thêm opt-out tường minh `SMTP_ALLOW_INSECURE` (mặc định false trong schema và compose; chỉ `.env` local và `.env.example` đặt true cho Mailpit), thêm unit test, cập nhật `docs/architecture.md`. Rebuild lại thì API healthy và dùng được cả ba dịch vụ.
- Kiểm chứng: `docker compose up -d --build --wait` EXIT=0 (migrate exit 0, không có migration mới). `/health/ready` → 200 `{database: up, cache: up, objectStorage: up}`. 105 request `/api/v1/notes` → 100 lần 200 + 5 lần 429, có khóa `rl:default:*:block` trong Valkey. Trong container: ký presigned PUT bằng `http://localhost:9000`, PUT từ host 200, `headObject` size 7/text/plain, xóa xong head trả null, gửi mail tới Mailpit thành công. `npm run check` EXIT=0 (unit 128, e2e 35), `npm run test:integration` 23/23, `docker compose config` hợp lệ. Sự cố: lệnh dọn thư test gửi JSON sai tới Mailpit API, sau đó hộp thư Mailpit local có total 0. Có thể đã xóa toàn bộ thư trong hộp thư giả local; chưa đếm số thư trước khi xóa nên không xác định được có thư nào khác ngoài thư test hay không. Không ảnh hưởng dữ liệu thật.
- Còn lại: Chờ người dùng chọn hạng mục tiếp theo: BullMQ/worker (cần duyệt thư mục `workers/`), API upload-intent/complete, cache OTP/AccessContext, hoặc đưa Valkey/MinIO/Mailpit vào CI. Container `postgres` cũ (Exited, từ trước khi tách DB) vẫn còn trong project compose backend, chưa đụng. Chưa commit.
- Product history: [BF-20261015-008](PRODUCT_ANALYTICS_HISTORY.md#bf-20261015-008).

<a id="bf-20261015-009"></a>
## BF-20261015-009 — API upload media (upload-intent/parts/complete) và ký URL xem theo quyền

- Ngày làm: 2026-10-15 (Asia/Ho_Chi_Minh); entry tạo lúc 2026-10-15T20:23:45+07:00, hoàn thành lúc 2026-10-15T20:42:03+07:00.
- Yêu cầu: "Làm API upload-intent/complete và ký URL xem media theo quyền (đặc tả §10.2, §10.5)."
- Liên quan: BF-20261015-006, BF-20261015-008.
- Role: Chủ trì BACKEND; hỗ trợ BA (quy tắc §10.2/§10.5/§6.3), SECURITY_PRIVACY (quyền xem, ký URL), DBA (asset/reservation/usage/outbox); TESTER do agent chính; QUALITY review độc lập qua Codex CLI.
- Trạng thái: Hoàn thành.
- Phân tích: Theo §10.2/§10.5/§6.3 và schema hiện có (assets, storage_reservations, billing.family_usage, asset_variants, ops.idempotency_records, ops.outbox_events), không thêm migration. Quyền ghi dùng `requireParent(...,'write')` sẵn có; quota đọc từ plan version hiệu lực (`storageBytes`, `videoMaxSec`, `audioMaxSec`), giới hạn kỹ thuật đặt ở `config/media-policy.ts`, không theo tên gói. Repository giữ transaction khóa `family_usage` cho reserve/confirm/fail (cùng thứ tự khóa). Upload đơn ký cả Content-Type và checksum SHA-256 (phải đặt `unhoistableHeaders` để header được ký thay vì bị đưa vào query). Quyền xem cho Parent mô phỏng SQL §6.3; chưa có ACL Circle/JOURNAL nên không cấp. Review độc lập bằng Codex: 8 phát hiện (replay ký lại PUT cho asset đã xong/FAILED, không phục hồi multipart khi NoSuchUpload, dung sai 5 % vượt quota, dedup tin hash multipart chưa xác minh, snapshot quota sau khi trả reservation, uploader thấy media đã gắn ký ức riêng tư, dedup không ghi Idempotency-Key, session multipart bị bỏ lại khi lưu ID lỗi). Đã sửa cả 8 và thêm test tương ứng.
- Kết quả: API mới trong `baby-backend`: `POST /media/upload-intents` (Idempotency-Key bắt buộc), `POST /media/:id/parts`, `POST /media/:id/complete` (202), `GET /media/:id`, `POST /media/urls`. File: `controllers/media.controller.ts`, `services/media.service.ts`, `interfaces/services/media-service.interface.ts`, `repositories/media.repository.ts`, `interfaces/repositories/media-repository.interface.ts`, `models/media-upload.model.ts`, `config/media-policy.ts`, `dto/media/*`, `common/http/idempotency-key.decorator.ts`; adapter S3 thêm multipart, ký part, checksum SHA-256, `bucketName/bucketOf`; DI trong `application.providers.ts`. Complete thành công ghi outbox `media.asset_uploaded`. Tài liệu: mục Media trong `docs/api.md`. Container API đã build lại.
- Kiểm chứng: `npm run check` EXIT=0 (unit 135/135, e2e 35/35, lint, typecheck TS7, build, test:compiled, generator/migration checks). `npm run test:integration` 28/28, gồm `test/integration/media-api.spec.ts` 5/5 trên Postgres `baby_family_test` + MinIO thật + JWT ES256: PUT đúng body 200, body khác checksum bị từ chối, replay/IDEMPOTENCY_KEY_REUSED, replay sau complete không cấp URL, dedup và UPLOAD_PENDING_VERIFICATION, 402 quota/duration, 422 loại/purpose, 400 thiếu Idempotency-Key, 403 parent khác complete, 404 người ngoài, multipart 3 part + re-sign + thiếu part 400, file quá cỡ 422 + object bị xóa + reservation trả lại, URL biến thể tải được nội dung, PRIVATE/thư niêm phong/TRASHED ẩn media, batch trả unavailableIds. Unit `media.service.spec.ts` 7/7 (fail-closed quota/storage, thứ tự kiểm quyền, hết hạn, sai MIME, phục hồi NoSuchUpload, race multipart, batch bỏ family không đọc được). Docker: `docker compose up -d --build --wait` EXIT=0, `/health/ready` 200, `POST /api/v1/media/upload-intents` không token → 401.
- Còn lại: Worker media (xác minh SHA-256 multipart, sinh biến thể, READY), job `purge-orphans`/`reconcile-uploads` (dọn object/multipart của upload hết hạn, trả reservation hết hạn), webhook storage-events, tải bản gốc `/memories/:id/download-urls` (`canDownload`), asset JOURNAL (ACL Papa & Mama), quyền Circle. API trả DTO trực tiếp như các endpoint hiện có, chưa theo envelope `{data}` §11.1. Chưa commit.
- Product history: [BF-20261015-009](PRODUCT_ANALYTICS_HISTORY.md#bf-20261015-009).

<a id="bf-20261015-010"></a>
## BF-20261015-010 — BullMQ + worker media, purge-orphans, reconcile-uploads

- Ngày làm: 2026-10-15 (Asia/Ho_Chi_Minh); entry tạo lúc 2026-10-15T20:51:13+07:00, hoàn thành lúc 2026-10-15T21:42:45+07:00.
- Yêu cầu: "Duyệt thêm thư mục workers/ trong baby-backend. Làm BullMQ + worker media: xác minh SHA-256, sinh biến thể, chuyển READY, kèm job purge-orphans/reconcile-uploads."
- Liên quan: BF-20261015-009.
- Role: Chủ trì BACKEND; hỗ trợ DEVOPS (process worker, Compose/Docker), DBA (job history, outbox lease, quota), SECURITY_PRIVACY (strip metadata, xác minh hash); TESTER do agent chính; QUALITY review độc lập qua Codex CLI.
- Trạng thái: Hoàn thành.
- Phân tích: Theo `docs/jobs.md` (history PostgreSQL, lease/fencing, retry có giới hạn, outbox retry không giới hạn) và đặc tả §3.3/§9/§10.2–10.4, dùng bảng có sẵn `ops.job_runs`/`job_attempts`/`outbox_events`, không thêm migration. Thư viện chọn bản phát hành ≥ 2 tuần: bullmq 6.3.11 (dùng chung ioredis 6.0.0), sharp 0.35.5, blurhash 2.0.5, exifr 7.1.3; ffmpeg là công cụ hệ thống (image worker cài từ Debian). Review độc lập bằng Codex: 9 phát hiện. Đã sửa 7: (1) không sửa bản thô trước commit, output theo prefix của attempt, dọn sau commit; (2) xóa mọi version của bản thô (bucket versioning) – cần thêm quyền `s3:DeleteObjectVersion`/`s3:ListBucketVersions` vào policy MinIO ở baby-storage; (3) kiểm fencing trong transaction ghi asset; (4) run bận → BullMQ delayed không tốn attempt, `maxStalledCount`, reconcile enqueue lại asset kẹt dựa trên PostgreSQL; (5) purge retire trong DB trước với điều kiện kiểm lại trên hàng đã khóa, đánh dấu `purge_after` rồi mới xóa object theo prefix; (6) thứ tự shutdown drain worker trước, đóng DB/Valkey/queue sau; (9) gói giữ bản gốc: bỏ metadata JPEG/PNG không mất dữ liệu (giữ Orientation). Giữ 2 điểm có lý do: (7) dung lượng biến thể có thể vượt quota một chút (nghiệp vụ: vượt gói chỉ chặn upload mới); (8) dọn asset chưa gắn ký ức để opt-in vì chưa có API tạo ký ức. Trong lúc test còn phát hiện và sửa: tham số `retryAt` trong CASE bị suy kiểu text (run kẹt RUNNING), exifr để rò FileHandle khi đọc theo đường dẫn, kết nối Redis của BullMQ Worker không được đóng khiến tiến trình không thoát.
- Kết quả: Thư mục mới `baby-backend/src/workers/` (entrypoint `worker.ts`, `WorkerModule`, `media.worker.ts`, `maintenance.worker.ts`, `outbox-relay.loop.ts`, `worker-heartbeat.ts`, `queue-connection.ts`). Service/repository mới: `JobRunnerService`/`JobExecutionRepository`, `JobQueueService`, `OutboxRelayService`/`OutboxRelayRepository`, `MediaProcessingService`, `ImageProcessorService`, `MediaTranscoderService`, `MediaMaintenanceService`; `config/jobs.ts`, `common/errors/job.error.ts`, `common/media/image-metadata.ts`, model `JobLease`/`OutboxDelivery`; mở rộng `MediaRepository` và adapter S3 (stream tải lên/xuống, list keys, xóa mọi version). Env mới: `WORKER_ID`, `MEDIA_WORKER_CONCURRENCY`, `FFMPEG_PATH`, `FFPROBE_PATH`, `MEDIA_PURGE_UNATTACHED_AFTER_HOURS`. Prisma/Valkey đóng ở `onApplicationShutdown`. Docker: stage `worker` (ffmpeg, giữ optional deps cho sharp, healthcheck heartbeat); Compose: service `worker` (read-only, tmpfs /tmp 2 GB). `npm run start:worker`. baby-storage: policy `baby-backend-rw` thêm quyền version, đã chạy lại `minio-init`. Tài liệu: `docs/jobs.md` (mục Triển khai hiện có), `docs/api.md` (Worker/purge/reconcile), `docs/architecture.md`, `AGENTS.md` (thư mục `workers/` được duyệt), README backend, README baby-storage.
- Kiểm chứng: `npm run check` EXIT=0 (unit 142/142, e2e 35/35, lint, typecheck TS7, build, test:compiled). `npm run test:integration` 33/33, gồm `media-worker.spec.ts` 5/5 chạy WorkerModule thật (Postgres `baby_family_test`, MinIO, Valkey DB 15, ffmpeg): ảnh READY với t320/m1080/l2048/orig không EXIF, `captured_at`, blurhash, bản thô còn 0 version, chỉ còn object của biến thể, `size_bytes` = tổng biến thể = `storage_bytes`, run SUCCEEDED 1 attempt, outbox published; gói giữ bản gốc giữ nguyên pixel và Orientation 6, không GPS/Make; checksum sai → FAILED không retry, purge sau retention trả đúng số byte và xóa hết object; video 1920×1080 có tag location → v1080/poster/t320 không còn location, bản thô 0 version; upload hết hạn bị purge (reservation EXPIRED, reserved hoàn đúng, object xóa), upload chưa complete được reconcile rồi READY, asset UPLOADED mất job được enqueue lại rồi READY. Unit `job-runner.spec.ts` 7/7 (thành công, finished/busy/exhausted, retry backoff có tóm tắt đã làm sạch, mã lỗi permanent/domain, mất lease; relay enqueue theo event id, backoff giới hạn). Docker: `docker compose up -d --build --wait` EXIT=0, api và worker healthy; trong worker có ffmpeg 5.1.9 và sharp/libvips 8.18.7; DB dev có run `media.purge-orphans` và `media.reconcile-uploads` SUCCEEDED. Review Codex: 9 phát hiện, sửa 7, giữ 2 có lý do.
- Còn lại: Chưa có màn quản trị manual retry và cảnh báo monitoring ngoài log; reconcile multipart (cần ETag); HLS; webhook storage-events; sự kiện `media.asset_ready` cho luồng xuất bản ký ức; tải bản gốc theo `canDownload`; asset JOURNAL/Circle. tmpfs 2 GB giới hạn kích thước file worker xử lý được trên Compose local. CI chưa có Valkey/MinIO/ffmpeg nên test worker/media bị bỏ qua ở CI. Chưa commit.
- Product history: [BF-20261015-010](PRODUCT_ANALYTICS_HISTORY.md#bf-20261015-010).

<a id="bf-20261015-011"></a>
## BF-20261015-011 — Commit thay đổi BF-20261015-006 → 010 trên branch mới

- Ngày làm: 2026-10-15 (Asia/Ho_Chi_Minh); entry tạo lúc 2026-10-15T21:45:26+07:00, dừng lúc 2026-10-15T21:46:26+07:00.
- Yêu cầu: "Commit các thay đổi của BF-20261015-006 đến 010 (backend, baby-storage policy, nhật ký) trên branch mới."
- Liên quan: BF-20261015-006, 007, 008, 009, 010.
- Role: Chủ trì DEVOPS; QUALITY kiểm phạm vi diff (agent chính).
- Trạng thái: Đã hủy theo yêu cầu người dùng (không commit).
- Phân tích: Working tree lẫn thay đổi chưa commit của nhiều task (nâng TS7 BF-20261014-004/BF-20261015-001, hạ tầng BF-20261015-005 gồm `baby-storage/` chưa track, app mobile, file thiết kế `.pen`, đặc tả, `.DS_Store`). Nhiều file trộn hunk (`package.json`, `package-lock.json`, `compose.yaml`, `.env.example`, `AGENTS.md`, `test/compiled-application.test.mjs`, hai nhật ký) và code 006–010 phụ thuộc toolchain TS7 + network BF-005 chưa commit, nên đã hỏi người dùng cách gom commit.
- Kết quả: Người dùng trả lời sẽ tự commit và yêu cầu hủy task commit. Không tạo branch, không stage, không commit.
- Kiểm chứng: `git status --porcelain` (đọc phạm vi); không có thao tác git ghi.
- Còn lại: Người dùng tự commit; lưu ý phụ thuộc giữa 006–010 với TS7/BF-005 khi tách commit.
- Product history: [BF-20261015-011](PRODUCT_ANALYTICS_HISTORY.md#bf-20261015-011).

<a id="bf-20261015-012"></a>
## BF-20261015-012 — Tiếp tục tính năng backend và nối API với mobile

- Ngày làm: 2026-10-15 (Asia/Ho_Chi_Minh); entry tạo lúc 2026-10-15T21:30:00+07:00.
- Yêu cầu: “Tiếp tục các tính năng tiếp theo ở cả backend và kết nối api với mobile đi.”
- Liên quan: BF-20261015-003, BF-20261015-005 → 011.
- Role: Chủ trì ORCHESTRATOR/ARCHITECT; BACKEND, MOBILE, INTEGRATION, SECURITY_PRIVACY, BA (gate onboarding/trial), TESTER/QUALITY; DATA_ANALYST impact note.
- Trạng thái: Đang thực hiện.
- Phân tích: (cập nhật khi xong)
- Kết quả: (cập nhật khi xong)
- Kiểm chứng: (cập nhật khi xong)
- Còn lại: (cập nhật khi xong)
- Product history: [BF-20261015-012](PRODUCT_ANALYTICS_HISTORY.md#bf-20261015-012).
