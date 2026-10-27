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

- Ngày làm: 2026-10-15 → 2026-10-16 (Asia/Ho_Chi_Minh); entry tạo lúc 2026-10-15T21:30:00+07:00, hoàn thành khoảng 2026-10-16T05:00:00+07:00.
- Yêu cầu: “Tiếp tục các tính năng tiếp theo ở cả backend và kết nối api với mobile đi.”
- Liên quan: BF-20261015-003, BF-20261015-005 → 011; tiếp nối bởi BF-20261016-001.
- Role: Chủ trì ORCHESTRATOR/ARCHITECT; BACKEND, MOBILE, INTEGRATION, SECURITY_PRIVACY, BA (BR-041/050…056, §6.5/§7.3), TESTER; QUALITY gồm tự review và review độc lập bằng Codex CLI (read-only); DATA_ANALYST impact note.
- Trạng thái: Hoàn thành phạm vi đã chốt (đăng nhập + onboarding + kích hoạt/dùng thử, nối app).
- Phân tích: Điểm chặn app là backend chưa phát token và chưa có luồng onboarding. Chọn OTP số điện thoại (Apple/Google cần credential Store), đúng §5/§6.5/§7.3/§11.3 và rate limit §21.3. App toàn mock nên dùng service server phản chiếu trạng thái vào kho cục bộ, bật bằng `BABY_FAMILY_API_URL`, để các màn khác không vỡ.
- Kết quả:
  - Backend: `AuthController` (`/auth/phone/otp|verify`, `/auth/refresh`, `/auth/logout`), `AuthTokenService` (ký ES256, HMAC pepper), `OtpSenderService` (Mailpit cho local), `AuthSessionService`/`AuthSessionRepository` (xoay vòng refresh, phát hiện dùng lại → thu hồi chuỗi có khoá từng dòng). `/me` mở rộng (vai trò onboarding, profileCompleted, families, awaitingApproval) + `PUT /me/onboarding-role`, `POST /me/devices`, `POST /me/consents` (`AccountRepository`). `FamilyOnboardingController` + `InviteController` + `OnboardingService`/`OnboardingRepository`: tạo/huỷ gia đình, lời mời bạn đời (7 ngày, 1 lần, 5/24h, mã/token chỉ lưu hash), resolve/accept/decline/approve/reject, kích hoạt trong một transaction (slot B, ACTIVE, couple space, trial 7 ngày từ `trial_policies` một lần mỗi người/identity, outbox), bootstrap. Envelope `{data}` toàn cục (§11.1). Env mới, compose, `.env.example`, `docs/api.md`.
  - Mobile: `SessionRemoteServiceImp`, `IOnboardingRepository`, `IAuthRepository` mở rộng, 12 model `data/model/session/*`, endpoint `Api`, Retrofit, `BaseRespond`; ONB-WAIT poll 30 giây + hộp thoại xác nhận lần cuối; ONB-07 truyền lựa chọn xác nhận; INV-04 tại chỗ; báo lỗi theo `error.code` (`runWithErrorSnackBar`); 11 key l10n × 4 ngôn ngữ; `make local-run`.
  - Sửa sau review Codex (6 điểm): khoá dòng khi thu hồi chuỗi phiên; chặn vượt 5 lần thử OTP song song; app lấy entitlement thật từ bootstrap (không tự cấp trial); áp dụng lời mời chờ ngay sau OTP với tài khoản đã có hồ sơ; giữ trial còn hạn khi mời bạn đời mới (PARTNER_LEFT); thống nhất thứ tự khoá family → invite.
- Kiểm chứng: Backend `npm run check` EXIT=0 (unit 154/154, e2e 35/35, compiled, generator, migration guard); `npm run test:integration` 36/36 trên DB `baby_family_test` + Valkey + Mailpit (gồm `auth-onboarding.spec.ts` 3 kịch bản). App `make check` 687/687 (gồm `session_remote_test.dart` 8 test), `flutter analyze` sạch, build iOS simulator. End-to-end thật trên iPhone Air simulator + backend Docker: OTP qua Mailpit → AUTH-04 → ONB-03 → ONB-06 → ONB-07 (mã server) → ONB-WAIT → Parent B nhận qua API → hộp thoại xác nhận → ONB-ACT “đến hết 23/10/2026”; DB xác nhận ACTIVE, 2 Parent, couple space, TRIAL, 2 trial_consumptions, outbox FamilyCreated/PartnerLinked/TrialStarted; mở lại app khôi phục đúng trạng thái. Container api/worker build lại, `/health/ready` up.
- Còn lại: Apple/Google sign-in; re-auth, `/me/sessions`; lời mời người thân (Circle); ONB-04/05 tạo bé/thai kỳ vẫn ghi mock (API children/pregnancies có sẵn); message lỗi backend chưa i18n; mất mạng khi mở app → về Welcome; kịch bản đồng thời (refresh song song, deadlock) mới sửa theo phân tích, chưa có test tải; chưa commit.
- Product history: [BF-20261015-012](PRODUCT_ANALYTICS_HISTORY.md#bf-20261015-012).

<a id="bf-20261016-001"></a>
## BF-20261016-001 — Tự lập task tiếp, làm cả backend và app (không hỏi lại)

- Ngày làm: 2026-10-16 (Asia/Ho_Chi_Minh); gửi lúc đang làm BF-20261015-012, hoàn thành khoảng 2026-10-16T05:00:00+07:00.
- Yêu cầu: “Desgin đã có sẵn rùi tiếp tục với tự vạch ra task làm tiếp đi bao gồm cả backend và fontend, đừng hỏi lại.”
- Liên quan: BF-20261015-012.
- Role: Chủ trì ORCHESTRATOR/PM (tự lập kế hoạch); BACKEND, MOBILE, INTEGRATION, TESTER/QUALITY.
- Trạng thái: Hoàn thành (thực hiện chung phạm vi BF-20261015-012, không dừng hỏi).
- Phân tích: “Frontend” hiểu là app Flutter theo design `desgin/`; `baby-admin/` rỗng nên ngoài phạm vi. Kế hoạch tự lập: hoàn tất check backend → cấu hình khoá local → nối app (flavor/URL, repository, service, UI ONB-WAIT/INV-04, lỗi) → test → chạy thật simulator → review độc lập Codex → sửa → kiểm lại.
- Kết quả: Xem BF-20261015-012. Đã dùng Codex CLI read-only cho review độc lập theo BF-20261015-007.
- Kiểm chứng: Như BF-20261015-012.
- Còn lại: Đợt sau đề xuất: nối ONB-04/05 + Bé/thai kỳ với API, Ký ức + upload media trên app, Apple/Google sign-in, lời mời người thân.
- Product history: [BF-20261016-001](PRODUCT_ANALYTICS_HISTORY.md#bf-20261016-001).

<a id="bf-20261016-002"></a>
## BF-20261016-002 — Tích hợp đợt 2: Bé/Thai kỳ và Ký ức có ảnh qua API

- Ngày làm: 2026-10-16T06:09:59+07:00 → 2026-10-16T06:56:02+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: (Giao từ session điều phối) Nối ONB-04/05 và màn Bé/Thai kỳ với `POST/PATCH /api/v1/families/:fid/children|pregnancies`, bootstrap.subjects là nguồn sự thật; backend thêm API tạo/xem ký ức theo §11.5/§6.3 (memory + subjects + assets một transaction, outbox) dùng upload media có sẵn; app nối MEM-04 và feed. Xong khi check/test đạt và chạy thật trên iOS simulator: tạo bé, đăng ký ức có ảnh, thấy ảnh trong feed.
- Liên quan: BF-20261015-012, BF-20261016-001.
- Role: Chủ trì ORCHESTRATOR/ARCHITECT; BACKEND, MOBILE, INTEGRATION, DBA (không đổi schema), SECURITY_PRIVACY, TESTER, QUALITY (tự review + review độc lập bằng Codex CLI read-only). Không dùng sub-agent.
- Trạng thái: Hoàn thành phạm vi đã giao; còn việc tiếp theo ghi bên dưới.
- Phân tích: Schema đã đủ bảng `memories/memory_children/memory_assets` và outbox nên không cần migration. Service `IMemoryService` sinh tự động là scaffolding (cấm sửa tay) → thêm bộ viết tay `MemoryContent*`. Ký ức có ảnh chưa xử lý xong phải ở `PROCESSING` và được worker xuất bản khi mọi asset `READY`; khoá hàng asset khi tạo để tuần tự với commit của worker. App vẫn là kho mock trên máy nên dùng cùng mô hình phản chiếu như SessionRemoteServiceImp; ảnh trong app trước đây chỉ là `Image.asset` nên cần một helper chung hiển thị URL ký/file/asset.
- Kết quả:
  - Backend: `POST /memories` (Idempotency-Key, kind MOMENT/DIARY/KEEPSAKE/QUOTE, kiểm bé/thai kỳ cùng family, ảnh của chính actor, `photosPerMemory`, FAMILY→PARENTS khi không có `circle.enabled`, `age_month` theo timezone family, outbox `memory.created`/`memory.published`), `GET /memories/:id`, `GET /families/:fid/feed` (cursor, bộ lọc Parent §6.3, URL ký qua `IMediaService.signViewUrls`); worker xuất bản ký ức trong transaction commit `READY`; `bootstrap.subjects` thêm name/nickname/gender/expectedCount/seqNo. File: `src/controllers/memory.controller.ts`, `src/services/memory-content.service.ts`, `src/repositories/memory-content.repository.ts`, `src/models/memory-view.model.ts`, `src/dto/memory/*`, `src/config/memory-policy.ts`, `media.repository.ts` (publishReadyMemories), `docs/api.md`.
  - App: `ChildRemoteServiceImp`, `MemoryRemoteServiceImp`, `SessionRemoteServiceImp._mirrorSubjects`, repository `ISubjectRepository`/`IMediaRepository`/`IMemoryFeedRepository`, `StorageDio`, helper `mediaImageProvider`, MEM-04 dùng photo picker hệ thống, lỗi lưu hiện snackbar, tắt nháp mẫu ở chế độ server. Chi tiết ở `baby-family-app/SESSION.md`.
  - Sửa sau review Codex: thư niêm phong chỉ trả id/kind/unlockAt/tác giả; replay key của ký ức đã vào thùng rác → 404, không tạo lại; app giữ Idempotency-Key khi bấm Lưu lại sau lỗi; bỏ kết quả feed nếu phiên/gia đình đổi trong lúc chờ.
- Kiểm chứng: Backend `npm run check` EXIT=0 (unit 154/154, e2e 35/35, compiled, generator, migration guard); `npm run test:integration` 41/41 (gồm `memory-api.spec.ts` 5 kịch bản: xuất bản ngay + replay + 409 key, validation/quota, PROCESSING→worker→PUBLISHED + ẩn với bạn đời, cursor/lọc bé, replay ký ức đã xoá). App `make check` 694 pass (gồm `subject_memory_remote_test.dart` 6, `session_remote_test.dart` 9). Chạy thật iPhone Air simulator + backend Docker (api/worker build lại): tạo bé “May” ở CHD → DB `children` có bản ghi FEMALE/color 1; khởi động lại app vẫn thấy May (từ bootstrap); MEM-05 chọn ảnh qua photo picker → DB ký ức `PUBLISHED`/`PARENTS`, asset `READY` với `t320,m1080,l2048,orig`, outbox `media.asset_uploaded → memory.created → memory.published`; feed “Mới trong nhà” hiện ảnh; khởi động lại app → log API `/me`, `bootstrap`, một lần `feed`, ảnh vẫn hiện từ URL ký. Lần chạy simulator là bản trước 4 sửa sau review (đã có test), container đã build lại sau đó.
- Còn lại: Review Codex chưa xử lý: (2) ký ức bị xoá/ẩn phía server không tự gỡ khỏi kho trên máy; (3) dedup SHA-256 trả asset của bạn đời → `MEMORY_ASSET_INVALID`; (6) GET ký ức/ký URL bị chặn khi `EXPIRED` (đặc tả cho đọc để tải về); (7) quota `memoryCount` chưa kiểm; (8) app chỉ đồng bộ trang feed đầu (50); (10) chưa poll ký ức `PROCESSING`/URL sắp hết hạn khi đứng yên màn hình. Ngoài ra: lưu trữ/xoá/sắp xếp bé chưa có API; ghi âm/thư/cột mốc/ảnh tháng/video chưa lên server; số liệu “Tuần này” và câu “Hồ sơ của  giữ nguyên” ở màn Thêm bé vẫn lấy từ dữ liệu mẫu; chưa commit.
- Product history: [BF-20261016-002](PRODUCT_ANALYTICS_HISTORY.md#bf-20261016-002).

<a id="bf-20261017-001"></a>
## BF-20261017-001 — Xử lý 6 điểm review còn mở của BF-20261016-002

- Ngày làm: 2026-10-17T00:49:54+07:00 (lần sửa file đầu tiên; trước đó đọc quy tắc/đặc tả/code) → 2026-10-17T01:02:49+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: (Giao từ session điều phối) Xử lý 6 điểm review Codex còn mở của BF-20261016-002: backend (1) dedup SHA-256 trả asset của bạn đời → `MEMORY_ASSET_INVALID`, (2) đọc ký ức/ký URL khi `EXPIRED` theo §6.5, (3) quota `memoryCount` nguyên tử; app (4) đồng bộ đủ trang feed, (5) gỡ ký ức đã xoá/ẩn phía server, (6) polling ký ức PROCESSING/URL sắp hết hạn có lifecycle. Xong khi `npm run check` + `npm run test:integration` + `make check` đạt, có test cho từng điểm, cập nhật `docs/api.md` và nhật ký. Không commit.
- Liên quan: BF-20261016-002.
- Role: Chủ trì ORCHESTRATOR; BACKEND, DBA (migration index), SECURITY_PRIVACY (ACL dedup, đọc khi hết hạn), MOBILE, TESTER, QUALITY (tự review — không có reviewer độc lập). Không dùng sub-agent.
- Trạng thái: Hoàn thành.
- Phân tích:
  - (1) Index `uq_asset_dedup (family, purpose, private_owner, sha256)` buộc cả gia đình dùng chung một asset, nên chỉ đổi ACL ở `POST /memories` không đủ (ảnh trong ký ức riêng tư của bạn đời vẫn bị chặn) và dedup cũ còn cho phép "biết hash = lấy được asset" của người kia. Chọn: dedup theo người tải (migration DDL đổi index thêm `uploader_user_id`), chỉ dùng lại bản `READY` của Parent kia khi người tải đã xem được nó theo ACL §6.3; `POST /memories` nhận asset của mình hoặc asset `READY` của bạn đời mà actor đã thấy. Điều kiện ACL asset tách thành một fragment SQL dùng chung cho media và memory repository.
  - (2) Thêm mode `download` trong `ApplicationAccessService`: giữ kiểm membership/family/license/BLOCKED, cho entitlement `TRIAL|PAID|EXPIRED` dù hết hạn. Chỉ `GET /memories/:id` + URL ký của nó dùng mode này (allowlist §6.5); feed/tạo/`POST /media/urls` vẫn 402.
  - (3) `family_usage.memory_count` luôn được cộng trong transaction tạo ký ức (khoá hàng usage trước asset, cùng thứ tự với luồng media); chỉ chặn khi plan có `quotas.memoryCount`. Thiếu key = không giới hạn (catalog seed hiện không đặt key), sai kiểu = fail-closed.
  - (4–6) App: trang đầu mỗi 10 giây; đủ mọi trang theo `nextCursor` (tối đa 200 trang, dừng nếu cursor lặp) mỗi 2 phút hoặc khi URL ký sắp hết hạn; chỉ đối soát (gỡ bản có `remoteStatus` không còn trên server) khi tải đủ trang, giữ ký ức chỉ có trên máy và ký ức vừa tạo trong lúc đồng bộ. `IMemoryService.refreshDelay()` + `memoriesProvider` hẹn `Timer` đọc lại (huỷ khi dispose); dừng khi không còn PROCESSING (tối đa 10 phút/ký ức) và chờ tới lúc URL sớm hết hạn nhất cần ký lại. Mốc thời gian đồng bộ chuyển sang `AppClock` để test được.
- Kết quả:
  - Backend: `src/repositories/parent-asset-visibility.sql.ts` (mới), `media.repository.ts` (dedup theo người tải + `findSharedCopy`, bỏ nhánh 409 `UPLOAD_IN_PROGRESS`), `memory-content.repository.ts` (`consumeMemoryQuota`, khoá asset cho phép bản dùng chung, context `sharedWithActor`), `memory-content.service.ts`, `application-access.service.ts` + interface (mode `download`), `media.service.ts`/interface (`signViewUrls(..., access)`), `models/memory-view.model.ts`, `config/memory-policy.ts`, `prisma/schema.prisma` + migration `20261017090000_asset_dedup_per_uploader` (chỉ DROP/CREATE INDEX), `docs/api.md`.
  - App: `data/service_imp/memory_remote.dart`, `data/service/memory.dart` + `service_imp/memory.dart` (`refreshDelay`), `data/repository(_imp)/memory.dart` (`removeMemory`), `data/provider/memory.dart` (hẹn giờ có lifecycle), `utils/constants/values.dart` (`kValueRemoteFeedFullSyncInterval`, `kValueRemoteFeedMaxPages`, `kValueRemoteProcessingPollWindow`).
  - Test: integration `memory-api.spec.ts` +3 (dùng lại bản của bạn đời đã thấy / không lộ bản riêng tư; đọc + URL ký khi EXPIRED, feed/tạo/`media/urls` vẫn chặn; quota với 2 request đồng thời chỉ 1 thắng, thiếu quota = không giới hạn), `media-api.spec.ts` sửa kịch bản dedup cũ (khẳng định hành vi lỗi) và multipart; unit `application-access.spec.ts` +1; app `subject_memory_remote_test.dart` +5 (phân trang, đối soát/gián đoạn, tạo trong lúc đồng bộ, `refreshDelay`, provider tự đọc lại rồi dừng).
- Kiểm chứng: Backend `npm run check` EXIT=0 (migration guard 3 migration, unit 155/155, e2e 35/35, compiled/generator); `prisma migrate deploy` lên DB `baby_family_test`; `npm run test:integration` 44/44 (chạy lại sau format). App `make check` EXIT=0 (l10n, format, analyze sạch, 699 test pass). Chưa chạy lại trên simulator; DB dev `baby_family` và container api/worker chưa áp migration/build lại.
- Còn lại: Áp migration `20261017090000_asset_dedup_per_uploader` cho DB dev rồi build lại api/worker trước khi chạy app thật; `memory_count` chưa trừ khi xoá (chưa có API xoá); `download-urls`/`media-grid` cho gói hết hạn chưa có; dedup cho `purpose=JOURNAL` (private owner) chưa được xử lý riêng (ngoài phạm vi). Cuối `SESSIONS.md` trước entry này có vài dòng lặp lại từ entry BF-20261016-002 (đã có sẵn, không sửa). Chưa commit.
- Product history: [BF-20261017-001](PRODUCT_ANALYTICS_HISTORY.md#bf-20261017-001).

<a id="bf-20261018-001"></a>
## BF-20261018-001 — Checklist toàn bộ tính năng và tự bắt đầu làm task

- Ngày làm: 2026-10-18T07:25:28+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Hãy liệt kê tất cả các tính năng cần làm vào 1 file document sau đó nếu làm được xong tính năng nào thì tick vào đã xong tính năng đó cho t. Tự start với các task cho tôi nha."
- Liên quan: BF-20261017-001.
- Role: Chủ trì ORCHESTRATOR/PM (lập checklist); BA (đối chiếu đặc tả §7, §9, §16), BACKEND, MOBILE, SECURITY_PRIVACY, TESTER, QUALITY (tự review, không reviewer độc lập). Không dùng sub-agent: mọi thay đổi chưa commit nên không chia worktree song song được.
- Trạng thái: Hoàn thành (checklist + task đầu tiên: thùng rác ký ức). Kết thúc 2026-10-18T07:41:40+07:00.
- Phân tích: Gần như mọi màn MVP đã có UI mock; phần “xong thật” = có API backend + app nối API + kiểm chứng. Checklist [docs/03_CHECKLIST_TINH_NANG.md](docs/03_CHECKLIST_TINH_NANG.md) liệt kê 159 dòng theo module đặc tả, mỗi dòng có trạng thái UI/BE/App và mã yêu cầu khi xong. Task đầu tiên chọn theo vòng lặp Ký ức: MEM-09 (sửa) chưa có màn trong app nên làm trước xoá → thùng rác → khôi phục/xoá vĩnh viễn. Bảng `memories` có CHECK `TRASHED/PURGED ⇔ deleted_at` (soft delete bắt đầu từ thùng rác) nên thùng rác đặt `deleted_at`; danh sách/khôi phục đọc riêng theo `status = TRASHED` và `purge_after`.
- Kết quả:
  - Checklist mới: `docs/03_CHECKLIST_TINH_NANG.md` (28/159 đã tick sau task này).
  - Backend: `DELETE /memories/:id`, `GET /families/:fid/trash`, `POST /memories/:id/restore`, `DELETE /memories/:id/purge` (`memory.controller.ts`, `memory-content.service.ts`, `memory-content.repository.ts` + interface, DTO `memory-trash-query.dto.ts`, response thêm `trashedAt/trashedBy/purgeAfter`); job `memory.purge-trash` mỗi giờ (`MemoryMaintenanceService` mới + interface, `config/jobs.ts`, `maintenance.worker.ts`, `worker.module.ts`); luật `DETACHED` trong `media.repository.ts`/`media-maintenance.service.ts`; ACL ảnh thùng rác trong `parent-asset-visibility.sql.ts`; `memory_count` trừ khi xoá, kiểm/cộng lại khi khôi phục; `docs/api.md`.
  - App: `MemoryRemoteServiceImp` (`moveToTrash`, `trash`, `restoreMemory`, `deleteForever` qua server; ký ức chỉ có trên máy giữ luồng cũ), `IMemoryFeedRepository` + imp, Retrofit `AppClient`, endpoint `Api`, `MemoryRecord` thêm `trashedAt/trashedBy/purgeAfter` (đã `make runner`).
  - Test: integration `memory-api.spec.ts` +3 (xoá/idempotent/danh sách/khôi phục/outbox; không lộ hay xoá được ký ức riêng tư của bạn đời; xoá vĩnh viễn, hết hạn 30 ngày + job, retire asset); `media-api.spec.ts` đổi kỳ vọng: ảnh ký ức trong thùng rác vẫn ký được tới `purge_after` (trước đây test khẳng định 404); app `subject_memory_remote_test.dart` +1.
- Kiểm chứng: Backend `npm run check` EXIT=0 (unit 155/155, e2e 35/35); `npm run test:integration` 47/47 hai lần liên tiếp. Một lần chạy trước đó có 2–3 fail ở `supporting-services` (Mailpit) và `auth-onboarding` khi tôi chạy chồng hai tiến trình test cùng lúc; chạy riêng và chạy lại đều đạt, không sửa gì ở hai bộ đó. App `make check` EXIT=0 (700 test). Chưa chạy trên simulator; container api/worker chưa build lại.
- Còn lại: MEM-09 sửa ký ức (màn + `PATCH` If-Match) là task kế tiếp theo checklist; DB dev vẫn cần migration `20261017090000_asset_dedup_per_uploader` + build lại api/worker trước khi chạy app thật. Chưa commit.
- Product history: [BF-20261018-001](PRODUCT_ANALYTICS_HISTORY.md#bf-20261018-001).

<a id="bf-20261018-002"></a>
## BF-20261018-002 — MEM-09 sửa ký ức (màn sửa + PATCH /memories/:id If-Match)

- Ngày làm: 2026-10-18T07:49:33+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp task kế tiếp trong checklist: MEM-09 sửa ký ức (màn sửa + PATCH /memories/:id If-Match), xong thì tick checklist."
- Liên quan: BF-20261018-001.
- Role: Chủ trì ORCHESTRATOR; BACKEND, MOBILE, SECURITY_PRIVACY (quyền sửa §6.2), DESIGN (dùng lại form MEM-05), TESTER, QUALITY (tự review, không reviewer độc lập). Không dùng sub-agent.
- Trạng thái: Hoàn thành. Kết thúc 2026-10-18T08:02:17+07:00.
- Phân tích: App chưa có màn MEM-09; đặc tả “giống MEM-05, điền sẵn; trường không có quyền bị khoá” nên dùng lại composer MEM-05 với query `memoryId` thay vì màn mới. Quyền theo §6.2 `canEditMemory`: tác giả sửa mọi trường, Parent còn lại chỉ bé/người xem (không đặt “Chỉ mình tôi”). Khoá lạc quan bằng `If-Match: version` (tài liệu kỹ thuật); §13.3 “người lưu sau thắng ở từng trường” → app chỉ gửi trường đã đổi. `memory_children` có PK `(memory_id, child_id)` nên gắn lại bé = khôi phục hàng đã soft delete. Đổi ảnh khi sửa để task sau (backend chưa có, UI ẩn ô “+”).
- Kết quả:
  - Backend: `PATCH /memories/:id` (`memory.controller.ts`, decorator mới `common/http/if-match.decorator.ts`, `dto/memory/update-memory.dto.ts`, `MemoryContentService.update`, `MemoryContentRepository.update` + interface `UpdateMemoryCommand`); 428/400/412 `VERSION_CONFLICT`, 403 `MEMORY_FIELD_NOT_EDITABLE`, 422 `MEMORY_VISIBILITY_INVALID`; outbox `memory.updated`; `docs/api.md`.
  - App: `IMemoryService.updateMemory` (mock + `MemoryRemoteServiceImp`: lưu `remoteVersion`, chỉ gửi trường đổi, 412 → tải bản mới vào kho rồi báo lỗi); Retrofit `updateMemory` (`If-Match`), `IMemoryFeedRepository.updateMemory`; composer chế độ sửa (`memoryId`, tiêu đề “Sửa ký ức”, khoá chú thích/ngày với người không phải tác giả + ghi chú, ẩn ô thêm ảnh/cột mốc/album/ghi âm khi sửa, không tạo nháp khi đóng); `showMemoryVisibilitySheet(options:)`; MEM-07 ⋯ “Sửa ký ức” (`canEdit`) rồi đọc lại chi tiết; `actionErrorMessage` cho `VERSION_CONFLICT`/`MEMORY_FIELD_NOT_EDITABLE`; 6 key l10n vi/en/ja/zh.
  - Test: integration `memory-api.spec.ts` +2 (tác giả sửa + 428/400/412 + age_month + gắn lại bé + MEMORY_EMPTY/CHILD_NOT_IN_FAMILY + outbox; Parent còn lại chỉ đổi bé/người xem, không đặt PRIVATE, không thấy ký ức riêng tư); app `subject_memory_remote_test.dart` +1 (version, chỉ trường đổi, 412), `memories_circle_batch3_test.dart` +2 (tác giả sửa chú thích qua MEM-07 ⋯; người kia chỉ đổi bé, ô chú thích readOnly).
- Kiểm chứng: Backend `npm run check` EXIT=0 (unit 155/155, e2e 35/35); `npm run test:integration` 49/49 (chạy tuần tự sau check). App `make runner` OK, `make check` EXIT=0 (703 test). Chưa chạy trên simulator; chưa build lại api/worker.
- Còn lại: đổi ảnh khi sửa (dòng checklist mới), cảnh báo `dryRun` người thân mất quyền xem (khi có Circle); task kế tiếp theo checklist: bình luận + cảm xúc (MEM-10). Chưa commit.
- Product history: [BF-20261018-002](PRODUCT_ANALYTICS_HISTORY.md#bf-20261018-002).

<a id="bf-20261018-003"></a>
## BF-20261018-003 — Bình luận + cảm xúc trên ký ức (MEM-10, §7.12)

- Ngày làm: 2026-10-18T08:03:32+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp task kế tiếp trong checklist: bình luận + cảm xúc trên ký ức (MEM-10, §7.12), xong thì tick checklist."
- Liên quan: BF-20261018-002.
- Role: Chủ trì ORCHESTRATOR; BACKEND, MOBILE, SECURITY_PRIVACY (quyền xem §6.3, không lộ bình luận ký ức riêng tư), TESTER, QUALITY (tự review). Không dùng sub-agent cho phần này (US-02 giao Codex — xem BF-20261018-004).
- Trạng thái: Hoàn thành. Kết thúc 2026-10-18T08:21:50+07:00.
- Phân tích: Bảng `comments`/`reactions` đã có (không migration) nhưng không có trigger đếm → repository khoá hàng ký ức rồi cập nhật `comment_count`/`reaction_count` cùng transaction. Đặc tả 7.12: 5 cảm xúc, mỗi người 1 (đổi được); bình luận ≤ 1.000 ký tự, trả lời 1 cấp, sửa ≤ 15 phút, xoá của mình, Parent xoá mọi bình luận; tắt bình luận theo ký ức. App mock trước đây cộng dồn cảm xúc (sai đặc tả) → đổi sang 1 cảm xúc/người, chạm lại để bỏ.
- Kết quả:
  - Backend: `MemoryInteractionController` (`GET|POST /memories/:id/comments`, `PATCH|DELETE /comments/:id`, `PUT|DELETE /memories/:id/reaction`), `IMemoryInteractionService`/`MemoryInteractionService`, `IMemoryInteractionRepository`/`MemoryInteractionRepository`, DTO `create-comment`, `update-comment`, `set-reaction`, `comment-response`; response ký ức thêm `reactions` theo loại + `myReaction` (`MemoryView.reactionCounts/reactionOf`); `memory-policy.ts` thêm giới hạn bình luận; `docs/api.md`.
  - App: model `CommentRecord`, `ReactionState`; `MemoryRecord` thêm `reactions/myReaction/commentsEnabled`; `Memory.myReaction`; Retrofit + `IMemoryFeedRepository` 6 hàm; `kValueReactionTypes` (emoji ↔ loại server); `MemoryRemoteServiceImp` react/comments/addComment/editComment/deleteComment qua server cho ký ức server; mock `react` 1 cảm xúc/người; số bình luận của ký ức server lấy từ server; MEM-07 tô cảm xúc theo `myReaction`.
  - Test: integration `memory-api.spec.ts` +3 (luồng bình luận + 15 phút + Parent xoá kèm trả lời; ký ức tắt bình luận/riêng tư; cảm xúc 1/người với số đếm đúng); app `subject_memory_remote_test.dart` +2.
- Kiểm chứng: Backend `npm run check` EXIT=0 (unit 155/155, e2e 35/35); `memory-api.spec.ts` 16/16. Full `test:integration` có 3 fail ở `auth-onboarding` do môi trường: `localhost` hiện phân giải `::1` còn Mailpit chỉ nghe `127.0.0.1` (nodemailer ECONNREFUSED ::1:1025); với `TEST_SMTP_HOST=127.0.0.1` hai bộ auth-onboarding + supporting-services 9/9. App `make check` EXIT=0 (705 test). Chưa chạy simulator.
- Còn lại: công tắc tắt bình luận trên app; Idempotency-Key cho POST bình luận; báo cáo bình luận; thông báo gộp. Môi trường: nên đặt `SMTP_HOST=127.0.0.1` trong `.env` dev (chưa sửa vì là file của người dùng). Chưa commit.
- Product history: [BF-20261018-003](PRODUCT_ANALYTICS_HISTORY.md#bf-20261018-003).

<a id="bf-20261018-004"></a>
## BF-20261018-004 — Giao thêm task song song cho Codex

- Ngày làm: 2026-10-18 (Asia/Ho_Chi_Minh), gửi giữa lúc làm BF-20261018-003; ghi lúc 2026-10-18T08:21:50+07:00.
- Yêu cầu: "Hiện tại t đang thấy bạn đang làm từng task một, tôi cần bạn giao thêm task cho với codex nữa cho nhanh đi, đừng ôm một mình như thế."
- Liên quan: BF-20261018-003.
- Role: Chủ trì ORCHESTRATOR (chia việc, brief, review); BACKEND do **Codex CLI** (`codex exec`, sandbox workspace-write) triển khai hai task; QUALITY + SECURITY_PRIVACY + TESTER do Claude review và chạy lại kiểm tra. Đây là agent độc lập thật (Codex), không phải sub-agent Claude.
- Trạng thái: Hoàn thành (backend 2 task; phần app chưa làm). Kết thúc 2026-10-18T08:28:15+07:00.
- Phân tích: Mọi thay đổi chưa commit nên không dùng được worktree; Codex chạy chung working tree với danh sách file được phép không trùng file Claude đang sửa, không ghi nhật ký/docs, chỉ chạy spec riêng của mình (chạy song song cả bộ integration từng gây fail giả). Chọn task backend độc lập, file mới: US-02 check-in cảm xúc, US-03/04 Lời nhờ. Lần chạy Codex thứ hai treo chờ stdin → chạy lại với `< /dev/null`.
- Kết quả:
  - US-02 (Codex): `couple-checkin.controller/service/repository` + interface, `dto/us/checkin.dto.ts`, `config/couple-policy.ts`, `models/couple-checkin-view.model.ts`, `test/integration/couple-checkin-api.spec.ts`, đăng ký trong `application.providers.ts`. Claude review rồi sửa: mood `UPSET_WITH_PARTNER` luôn không chia sẻ (§7.16.1, server ép) + test; khai báo `COUPLE_CHECKIN_ENCRYPTION_KEY` trong `config/environment.ts` (kiểm 32 byte), `.env.example`, `test/setup-env.ts`.
  - US-03/04 (Codex): `couple-request.controller/service/repository` + interface, `dto/us/request.dto.ts`, `config/couple-request-policy.ts`, `models/couple-request-view.model.ts`, `models/couple-request-resend-blocked.model.ts`, `test/integration/couple-request-api.spec.ts`. Review: không Prisma trong service, Hearts chỉ trả cho người làm, outbox chỉ id/trạng thái, lời nhắn mã hoá.
  - `docs/api.md` hai mục mới; checklist cập nhật BE ✅ cho US-02, US-03/04 (chưa tick vì app chưa nối).
- Kiểm chứng: Codex tự chạy tsc/prettier/eslint + spec riêng (check-in 10/10, lời nhờ 36/36 — theo báo cáo Codex). Claude chạy lại: check-in spec 11/11 sau khi sửa; `npm run check` EXIT=0 (unit 155/155, e2e 35/35); `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` 99/99.
- Còn lại: app nối US-02/03/04; “Tự mình làm”, khung yên tĩnh, job hết hạn lời nhờ, “Để mình lo”; khoá mã hoá chưa dùng DEK/`data_keys`, chưa xoay khoá; trần Hearts 75/ngày lặp trong policy lời nhờ. Chưa commit.
- Product history: [BF-20261018-004](PRODUCT_ANALYTICS_HISTORY.md#bf-20261018-004).

<a id="bf-20261018-005"></a>
## BF-20261018-005 — Song song: Codex làm timeline + lưới ảnh (MEM-01/02), Claude nối app Papa & Mama (US-01…04)

- Ngày làm: 2026-10-18T08:29:18+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Đợt tiếp: Codex làm backend timeline + lưới ảnh (MEM-01/02), còn bạn nối app Papa & Mama (US-01/02/03/04) với API vừa có. Xong thì tick checklist."
- Liên quan: BF-20261018-004.
- Role: Chủ trì ORCHESTRATOR; MOBILE (Claude, nối app Papa & Mama); BACKEND do **Codex CLI** (timeline + lưới ảnh, chạy nền song song, danh sách file riêng); QUALITY/SECURITY_PRIVACY/TESTER do Claude review và chạy lại toàn bộ kiểm tra.
- Trạng thái: Hoàn thành phạm vi giao (app US-02/03/04; backend MEM-01/02). Kết thúc 2026-10-18T08:41:12+07:00.
- Phân tích: App giữ kiến trúc phản chiếu như các remote service khác: `UsRemoteServiceImp` gọi server rồi ghi kết quả vào kho trên máy (id server, cờ `remote`), nên màn hiện có không phải sửa nhiều. Mã mood/nhu cầu app ↔ server ánh xạ theo `couple-policy.ts`; chia sẻ mặc định chỉ mood/năng lượng/nhu cầu (ghi chú không chia sẻ, §7.16.1). Lời nhờ của bản mẫu trên máy vẫn chạy luồng cũ; lời nhờ server chuyển trạng thái qua API, Hearts do server cộng. Check-in của bạn đời không chia sẻ mood thì không hiện (thẻ US-01 cần cảm xúc).
- Kết quả:
  - App: model `us/checkin_record`, `checkin_today`, `request_record`, `request_list`, `request_created`; envelope + Retrofit 5 hàm; `ICoupleRemoteRepository` + imp; `IUsRepository.removeCheckin`; `UsRemoteServiceImp` (coupleToday/requests đồng bộ ≤ 10 giây/lần, checkIn, sendRequest giữ Idempotency-Key khi gửi lại, seen/accept/decline/acknowledge/done/remind-me/cancel); provider chọn bản server khi có `BABY_FAMILY_API_URL`; US-03 hiện lỗi server theo mã (`REQUEST_OPEN_LIMIT`, `REQUEST_RESEND_BLOCKED`), US-04 bọc thao tác bằng `runWithErrorSnackBar`; 3 key l10n vi/en/ja/zh; test `test/data/couple_remote_test.dart` (4).
  - Backend (Codex): `GET /families/:fid/timeline`, `GET /families/:fid/media-grid` trong `memory.controller.ts`, `memory-content.service/repository` + interface, `memory-view.model.ts`, `memory-policy.ts`, 4 DTO mới, `test/integration/memory-timeline-api.spec.ts`, `test/unit/memory-timeline.spec.ts`. Review: dùng chung bộ lọc §6.3, lưới ảnh loại nháp/thùng rác, mode `download` chỉ cho lưới ảnh. `docs/api.md` cập nhật.
- Kiểm chứng: Backend `npm run check` EXIT=0 (unit 161/161, e2e 35/35; 3 test watcher Codex báo lỗi EMFILE trong sandbox của nó đều đạt ở máy thật); `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` 115/115. App `make check` EXIT=0 (709 test). Chưa chạy simulator.
- Còn lại: app MEM-01/02 dùng API timeline/lưới ảnh; thẻ chương tháng/ảnh tháng/recap; US-01 câu hỏi hôm nay + cảm ơn (US-05/06) chưa có API; phản hồi nhanh check-in (👀/💬/🙋/🤗) chưa nối app. Chưa commit.
- Product history: [BF-20261018-005](PRODUCT_ANALYTICS_HISTORY.md#bf-20261018-005).

<a id="bf-20261018-006"></a>
## BF-20261018-006 — Song song: Codex làm backend Nhiệm vụ hằng ngày, Claude nối app MEM-01/02

- Ngày làm: 2026-10-18T08:42:08+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Đợt tiếp: Codex làm backend Nhiệm vụ hằng ngày (catalog + bày bảng + CARE-01…06 API), còn bạn nối app MEM-01/02 với API timeline/lưới ảnh. Xong thì tick checklist."
- Liên quan: BF-20261018-005.
- Role: Chủ trì ORCHESTRATOR; MOBILE (Claude, MEM-01/02); BACKEND do **Codex CLI** (Nhiệm vụ CARE-01…06, chạy nền song song, danh sách file riêng); QUALITY/SECURITY_PRIVACY/TESTER do Claude review và chạy lại toàn bộ kiểm tra.
- Trạng thái: Hoàn thành phạm vi giao. Kết thúc 2026-10-18T08:56:29+07:00.
- Phân tích: App vốn dựng timeline/lưới ảnh từ kho trên máy; giữ cách đó nhưng nguồn dữ liệu chế độ server là API: `timeline()` đồng bộ đủ trang theo ngày xảy ra vào kho rồi đọc kho (gồm ký ức chỉ có trên máy), `photos()` dùng ô ảnh `t320` đã ký của media-grid. Thẻ hệ thống của server bỏ qua vì app tự dựng chương tháng. Backend Nhiệm vụ do Codex: bày bảng khi mở bảng (chưa job sáng), Hearts dùng ledger chung với lời nhờ và trần chung `hearts-policy.ts` (sửa lặp từ BF-20261018-004).
- Kết quả:
  - App: `IMemoryService.timeline/photos` (mock + server), `MemoryGridPhoto` DTO, model `TimelineItemRecord`, `MediaGridItemRecord`, envelope + Retrofit `getTimeline/getMediaGrid`, `IMemoryFeedRepository.timeline/mediaGrid`, `memories_tab_controller.dart` dùng hai hàm mới; test `subject_memory_remote_test.dart` +1.
  - Backend (Codex): `mission.controller.ts`, `mission-board.service/repository` + interface, `mission-board-catalog-seed.repository.ts`, `dto/mission/*`, `config/mission-policy.ts`, `config/hearts-policy.ts` (+ `couple-request-policy.ts` dùng chung), model `mission-board-balance/state/view`, `prisma/seeds/missions.json` + `prisma/seed.ts`, test `mission-board-api.spec.ts`, `mission-board-balance.spec.ts`; đăng ký DI. Review: không Prisma trong service, bạn đời không thấy Hearts, `myHeartsToday` chỉ tab của mình. `docs/api.md` thêm mục Nhiệm vụ.
- Kiểm chứng: Codex báo unit cân bằng 15/15, integration mission + lời nhờ 53/53. Claude chạy lại: `npm run check` EXIT=0 (unit 176/176, e2e 35/35); `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` 132/132; app `make check` EXIT=0 (710 test). Chưa chạy simulator.
- Còn lại: app CARE-01…06 nối API; job bày bảng sáng sớm; ảnh hoàn thành → ký ức; series, carry-over, CARE-08/12; catalog mới 30 mẫu (đặc tả cần ≥ 90 ngày nội dung); bộ lọc chip timeline dùng `filter` của server; thẻ chương/ảnh tháng từ server. Chưa commit.
- Product history: [BF-20261018-006](PRODUCT_ANALYTICS_HISTORY.md#bf-20261018-006).

<a id="bf-20261018-007"></a>
## BF-20261018-007 — Song song: Codex làm backend Cảm ơn US-05/06 + Nhật ký riêng US-07, Claude nối app Nhiệm vụ CARE-01…06

- Ngày làm: 2026-10-18T08:57:24+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Đợt tiếp: Codex làm backend Cảm ơn US-05/06 + Nhật ký riêng US-07, còn bạn nối app Nhiệm vụ CARE-01…06 với API vừa có. Xong thì tick checklist."
- Liên quan: BF-20261018-006.
- Role: Chủ trì ORCHESTRATOR; MOBILE (Claude, CARE-01…06); BACKEND do **Antigravity CLI** (`agy`, US-05/06/07 — Codex hết quota, xem BF-20261018-008); QUALITY/SECURITY_PRIVACY/TESTER do Claude review và chạy lại kiểm tra.
- Trạng thái: Hoàn thành phạm vi giao. Kết thúc 2026-10-18T09:22:08+07:00.
- Phân tích: App Nhiệm vụ chế độ server đọc thẳng server (không phản chiếu vào kho mock vì bảng mock sẽ lẫn dữ liệu mẫu): 3 tab board, nhớ các nhiệm vụ server đã đọc để thao tác sau đi đúng đường; sau thao tác gọi `ICareRepository.touch()` để màn đọc lại. Loại nhiệm vụ server nhiều hơn app → gộp về loại gần nhất. Hearts, cây, huy hiệu, lịch sử, lịch, cài đặt chưa có API đọc nên giữ trên máy.
- Kết quả:
  - App: `CareRemoteServiceImp`, `ICareRemoteRepository` + imp, 6 model `care/mission_*`, envelope + Retrofit 7 hàm, endpoint `Api.mission*`, `ICareRepository.touch()`, provider chọn bản server; test `test/data/care_remote_test.dart` (3).
  - Backend (Antigravity): `couple-appreciation.controller/service/repository` + interface, `couple-journal.controller/service/repository` + interface, policy, model view, 2 spec integration, đăng ký DI. Review: không Prisma trong service; nhật ký 404 với bạn đời ở mọi route; nội dung mã hoá (scope người viết / couple). `docs/api.md` thêm mục.
- Kiểm chứng: Antigravity báo tsc/prettier/eslint đạt, 2 spec 15/15. Claude chạy lại: `npm run check` EXIT=0 (unit 176/176, e2e 35/35); `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` 147/147; app `make check` EXIT=0 (713 test). Chưa chạy simulator.
- Còn lại: app US-05/06/07; ký ức từ lời cảm ơn được duyệt; route đọc đoạn trích nhận được; app Hearts/cây/huy hiệu/lịch sử nhiệm vụ; “lưu khoảnh khắc” từ nhiệm vụ server. Chưa commit.
- Product history: [BF-20261018-007](PRODUCT_ANALYTICS_HISTORY.md#bf-20261018-007).

<a id="bf-20261018-008"></a>
## BF-20261018-008 — Dùng thêm Antigravity; Codex hết quota

- Ngày làm: 2026-10-18 (Asia/Ho_Chi_Minh), hai tin nhắn gửi giữa lúc làm BF-20261018-007; ghi lúc 2026-10-18T09:22:08+07:00.
- Yêu cầu: "Dùng thêm antigravity nữa" và "codex hết quota rùi".
- Liên quan: BF-20261018-007.
- Role: ORCHESTRATOR, SECURITY_PRIVACY (quyền chạy lệnh của agent ngoài).
- Trạng thái: Hoàn thành.
- Phân tích: Giao cả US-05/06 và US-07 cho một lượt `agy` (tránh hai agent cùng sửa `application.providers.ts`). `--dangerously-skip-permissions` bị bộ phân loại an toàn chặn; chế độ `--mode accept-edits` headless tự từ chối lệnh shell. Đã hỏi người dùng, người dùng chọn **allowlist hẹp**.
- Kết quả: Thêm vào `~/.gemini/antigravity-cli/settings.json` `permissions.allow`: `command(npx tsc)`, `command(npx prettier)`, `command(npx eslint)`, `command(npm run test:integration)`, `command(git status)`, `command(git diff)`, `command(ls)`, `command(rg)` (không có git ghi/xoá). Chạy `agy -p … --mode accept-edits --effort high` → hoàn thành backend US-05/06/07 (xem BF-20261018-007). Ghi memory cách gọi agy.
- Kiểm chứng: như BF-20261018-007.
- Còn lại: Codex dùng lại khi có quota; allowlist agy có thể thu hẹp/xoá theo ý người dùng.
- Product history: [BF-20261018-008](PRODUCT_ANALYTICS_HISTORY.md#bf-20261018-008).

<a id="bf-20261018-009"></a>
## BF-20261018-009 — Song song: Antigravity làm backend Hearts/Cây gia đình/Huy hiệu/CARE-08, Claude nối app Cảm ơn US-05/06 + Nhật ký riêng US-07

- Ngày làm: 2026-10-18T14:53:54+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Đợt tiếp: Antigravity làm backend Hearts/Cây gia đình/Huy hiệu (đọc Hearts của tôi, cây, badge, lịch sử nhiệm vụ CARE-08), còn bạn nối app Cảm ơn US-05/06 + Nhật ký riêng US-07. Xong thì tick checklist."
- Liên quan: BF-20261018-008.
- Role: Chủ trì ORCHESTRATOR; MOBILE (Claude, US-05/06/07); BACKEND do **Antigravity CLI** (Hearts/Cây/Huy hiệu/CARE-08, allowlist lệnh hẹp); QUALITY/SECURITY_PRIVACY/TESTER do Claude review.
- Trạng thái: Hoàn thành. Kết thúc 2026-10-18T15:31:14+07:00.
- Phân tích: Cảm ơn/nhật ký phản chiếu vào kho trên máy như check-in/lời nhờ. Server lưu một cảm xúc của người nhận nên app chỉ cho người nhận thả ❤️, chưa bỏ tim. App chưa có ô chọn đoạn trích → chia sẻ đúng nội dung trang (đã xem trước ở US-07, là chuỗi con hợp lệ). Ảnh nhật ký cần upload `JOURNAL` riêng tư → để task sau, ảnh chỉ giữ trên máy. 💛 trên việc bạn đời (CARE-01) dùng lời cảm ơn “nhanh” của server; board server chưa trả cờ đã cảm ơn nên app giữ cờ trong phiên.
- Kết quả:
  - App: `UsRemoteServiceImp` (sendThanks, thanks/thanksWall đồng bộ, toggleThanksHeart, journal, addJournalEntry, shareJournalExcerpt), `CareRemoteServiceImp.thankPartner`; model `us/appreciation_record`, `appreciation_wall`, `journal_entry_record`, `journal_list`; Retrofit 6 hàm; test `couple_remote_test.dart` +2, `care_remote_test.dart` +1.
  - Backend (Antigravity): `care-progress.controller/service/repository` + interface, `config/care-progress-policy.ts`, `models/care-progress.model.ts`, `prisma/seeds/badges.json` + `care-badge-seed.repository.ts` + `prisma/seed.ts`, test `care-progress-api.spec.ts`, `care-progress.spec.ts`; đăng ký DI. Review: Hearts chỉ của người gọi (không route theo userId, `?userId=` 400), cây không có Hearts.
- Kiểm chứng: Antigravity báo 2 spec 28/28. Claude: `npm run check` EXIT=0 (unit 203/203, e2e 35/35); `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` 175/175; app `make check` EXIT=0 (718 test). Chưa chạy simulator.
- Còn lại: app CARE-08/09/10 + Hearts; ảnh nhật ký lên server; đăng lời cảm ơn thành khoảnh khắc gia đình; worker trao huy hiệu; cờ “đã cảm ơn” trên board server. Chưa commit.
- Product history: [BF-20261018-009](PRODUCT_ANALYTICS_HISTORY.md#bf-20261018-009).

<a id="bf-20261018-010"></a>
## BF-20261018-010 — Giao thêm task cho Codex (đã có quota): backend Thông báo NOTI-01

- Ngày làm: 2026-10-18 (Asia/Ho_Chi_Minh). Giờ bắt đầu ghi lúc mở entry đã mất: entry mở đầu bị xoá nhầm khi script của Claude cập nhật BF-20261018-009 (cắt phần sau entry); ghi lại đầy đủ lúc 2026-10-18T15:32:12+07:00, không đoán giờ gốc.
- Yêu cầu: "Giao thêm task cho codex nữa đi codex đang rảnh kìa"
- Liên quan: BF-20261018-009.
- Role: Chủ trì ORCHESTRATOR; BACKEND do **Codex CLI** (NOTI-01, không sửa `application.providers.ts` để tránh đè Antigravity); QUALITY/SECURITY_PRIVACY/TESTER do Claude review, đăng ký DI và sửa test cũ.
- Trạng thái: Hoàn thành. Kết thúc 2026-10-18T15:32:12+07:00.
- Phân tích: Thông báo là consumer outbox đầu tiên ngoài media: job `dispatchNotification` qua queue riêng, chống trùng theo id sự kiện. Tên sự kiện đối chiếu với repository thật (`us.request.sent|accept|decline|done|acknowledge`, `us.checkin.shared`, `us.appreciation.created`). Nhóm nhạy cảm chỉ lưu id; Circle không nhận Papa & Mama.
- Kết quả: Codex tạo `notification-inbox.controller`, `notification-inbox.service`, `notification-dispatch.service`, `notification-inbox.repository` + interface, `dto/notification/*`, `config/notification-policy.ts`, model, `workers/notification.worker.ts`, seed `notification-templates.json` + loader, test integration/unit; sửa `config/jobs.ts`, `workers/worker.module.ts`, `prisma/seed.ts`. Claude: đăng ký controller/provider trong `application.providers.ts`; sửa kỳ vọng `test/unit/job-runner.spec.ts` (claim mọi loại sự kiện trong `OUTBOX_ROUTES`); `docs/api.md`.
- Kiểm chứng: Codex báo integration 17/17, unit thông báo 18/18. Claude: `npm run check` EXIT=0; integration 175/175 (gồm `notification-inbox-api.spec.ts`).
- Còn lại: gửi push (APNs/FCM) + delivery attempts; purge sau 90 ngày; deepLink lời nhờ trỏ chi tiết (hiện `babyfamily://us`, app dùng `entityId`); worker chưa thử với Redis thật. Chưa commit.
- Product history: [BF-20261018-010](PRODUCT_ANALYTICS_HISTORY.md#bf-20261018-010).

<a id="bf-20261018-011"></a>
## BF-20261018-011 — Làm tiếp: nối app hộp thông báo NOTI-01, hoàn tất đợt Antigravity/Codex

- Ngày làm: 2026-10-18 (Asia/Ho_Chi_Minh). Giờ bắt đầu ghi lúc mở entry đã mất: entry mở đầu bị xoá nhầm khi script của Claude cập nhật BF-20261018-009 (cắt phần sau entry); ghi lại đầy đủ lúc 2026-10-18T15:32:12+07:00, không đoán giờ gốc.
- Yêu cầu: "Làm tiếp đi"
- Liên quan: BF-20261018-009, BF-20261018-010.
- Role: Chủ trì ORCHESTRATOR; MOBILE (NOTI-01 app); QUALITY/TESTER.
- Trạng thái: Hoàn thành. Kết thúc 2026-10-18T15:32:12+07:00.
- Phân tích: Trong lúc chờ Antigravity, làm phần độc lập kế tiếp là app NOTI-01. Server trả `templateCode` + `params` → app dựng câu bằng l10n (Skill 10), mẫu lạ (server mới hơn app) → câu chung; route từ `deepLink`/`entityId`; tên người thao tác lấy từ thành viên trên máy.
- Kết quả: `NotificationRemoteServiceImp`, `INotificationRemoteRepository` + imp, model `notification/notification_record`, `notification_page`, `notification_count`, Retrofit 3 hàm, `INotificationRepository.touch()`, provider chọn bản server, 12 key l10n vi/en/ja/zh; test `test/data/notification_remote_test.dart` (2). Sau khi Antigravity xong: đăng ký DI NOTI-01, chạy đủ kiểm tra, tick checklist (44/165).
- Kiểm chứng: app `make check` EXIT=0 (718 test); backend như BF-20261018-009/010.
- Còn lại: push + quyền thông báo (ONB-10); app CARE-08/09/10 + Hearts. Chưa commit.
- Product history: [BF-20261018-011](PRODUCT_ANALYTICS_HISTORY.md#bf-20261018-011).

<a id="bf-20261018-012"></a>
## BF-20261018-012 — Song song: Codex làm Xoá tài khoản + Xuất dữ liệu, Antigravity làm Lịch & sự kiện, Claude nối app CARE-08/09/10 + Hearts

- Ngày làm: 2026-10-18T16:02:47+07:00 → 2026-10-18T20:32+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Đợt tiếp: Codex làm backend Xoá tài khoản + Xuất dữ liệu (§7.25), Antigravity làm backend Lịch & sự kiện CARE-07/CAL-02, còn bạn nối app Hearts/Cây/Huy hiệu/Lịch sử CARE-08/09/10. Xong thì tick checklist."
- Liên quan: BF-20261018-009 (backend Hearts/Cây/Huy hiệu), BF-20261018-011.
- Role: ORCHESTRATOR; BACKEND (Codex CLI: xoá/xuất; Antigravity CLI: lịch); MOBILE (Claude); SECURITY/PRIVACY + QUALITY (Claude review); TESTER.
- Phân tích tóm tắt: ba phần độc lập, mỗi agent một allowlist file riêng; agent không sửa `application.providers.ts`, Claude đăng ký DI. App đọc Hearts/Cây/Huy hiệu/Lịch sử từ API của BF-009 qua `CareRemoteServiceImp`.
- Kết quả:
  - App: `CareRemoteServiceImp` override `myHearts`/`tree`/`badges`/`missionHistory` (Hearts chỉ của tôi; lịch sử 30 ngày ME/PARTNER/TOGETHER, việc của bạn đời không có Hearts; huy hiệu theo locale); model + Retrofit + l10n 4 ngôn ngữ; số liệu cây theo tuần chưa có API → 0.
  - Backend xoá tài khoản (Codex): `GET /me/deletion-preview`, `POST /me/deletion`, `POST /me/deletion/cancel`; chờ 30 ngày, thu hồi phiên, executor có checkpoint/fencing. Thiếu API phát hành reauth token.
  - Backend xuất dữ liệu (Codex): `POST /exports`, `GET /exports/:id`; JSON + manifest media; PERSONAL chỉ dữ liệu riêng của người gọi, FAMILY chỉ Parent và không có dữ liệu riêng (Claude review).
  - Backend lịch (Antigravity): `GET /families/:fid/calendar`, `POST/GET/PATCH/DELETE /events`; âm lịch, sinh nhật/tròn tháng; Circle không thấy `COUPLE`/nhiệm vụ. Claude sửa 2 lỗi thuật toán âm lịch (năm lệch 1, `b11` khi tháng ≥ 11) và fixture test (trigger phạm vi nhiệm vụ là deferred → transaction). Antigravity chạy ~4 giờ, Claude dừng sau khi đủ file và test xanh. Chưa gửi nhắc sự kiện.
  - `docs/api.md` thêm 2 mục; checklist 47/165 (tick CARE-08, CARE-09, Hearts; CARE-10 giữ vì BE 🟡; lịch, xoá, xuất cập nhật trạng thái BE).
- Bằng chứng kiểm tra: app `make check` EXIT=0 (719 test); backend `npm run check` EXIT=0 (unit 218, e2e 35); `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` EXIT=0 (19 suite, 208 test).
- Việc còn lại: API reauth token; job gửi nhắc sự kiện; worker trao huy hiệu; app cho lịch/xoá tài khoản/xuất dữ liệu; số liệu cây theo tuần.
- Trạng thái: Hoàn thành (phần còn lại ghi ở trên).

<a id="bf-20261018-013"></a>
## BF-20261018-013 — Song song: Codex làm API reauth token + job gửi nhắc sự kiện, Claude nối app Xoá tài khoản + Xuất dữ liệu và Lịch CARE-07/CAL-02

- Ngày làm: 2026-10-18T20:47:41+07:00 → 2026-10-18T21:12+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Đợt tiếp: Codex làm API phát hành reauth token (sau OTP) + job gửi nhắc sự kiện, còn bạn nối app Xoá tài khoản + Xuất dữ liệu và Lịch CARE-07/CAL-02. Xong thì tick checklist."
- Liên quan: BF-20261018-012.
- Role: ORCHESTRATOR; BACKEND (Codex CLI); MOBILE (Claude); SECURITY/PRIVACY + QUALITY (Claude review); TESTER.
- Phân tích tóm tắt: Codex làm backend theo allowlist, Claude làm app song song và đăng ký DI. Luồng xoá cần mã xác thực lại ngắn hạn gắn với phiên; nhắc sự kiện dùng hộp thư sẵn có.
- Kết quả:
  - Backend (Codex): `POST /auth/reauth/otp` + `/verify` (OTP chỉ tới số của chính người gọi, tách khỏi OTP đăng nhập, JWT `reauth+jwt` 300 giây gắn phiên); đăng nhập được trong thời gian chờ để huỷ xoá; queue `event-reminders` với job lập lịch (15 phút + outbox `event.changed`, 14 ngày tới) và job gửi (mỗi phút, kiểm lại quyền, không gửi trùng) vào hộp thư `NOTI_EVENT_REMINDER`.
  - Claude sửa phía backend: đăng ký `ReauthController`; Codex đã ghi đè file sinh tự động `event-reminder.*` làm hỏng kiểm tra của bộ sinh code → chuyển code sang `event-reminder-schedule.*` (token/lớp riêng), khôi phục bản sinh tự động từ git; hộp thư trả đủ params an toàn + deep link `babyfamily://calendar/events/{id}` cho nhắc sự kiện; `docs/api.md` cập nhật.
  - App (Claude): xuất dữ liệu và xoá tài khoản qua server (OTP xác thực lại → xoá → đăng xuất; nút xoá chỉ bật khi đã xác thực + tích xác nhận); lịch đọc/tạo qua server (âm lịch, mã nhắc ↔ phút, sự kiện riêng tư không mời Circle, nhiệm vụ bạn đời không Hearts, sinh nhật/tròn tháng); hiển thị thông báo nhắc sự kiện.
  - Checklist 51/165: tick CARE-07, CAL-02, Xoá tài khoản, Xuất dữ liệu.
- Bằng chứng kiểm tra: app `make check` EXIT=0 (analyze sạch, 722 test); backend `npm run check` EXIT=0 (gồm 2 bộ sinh `--check`, unit 224, e2e 35); `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` EXIT=0 (21 suite, 227 test).
- Việc còn lại: gửi push; xác thực lại qua Apple/Google khi server có đăng nhập đó; người tham gia/nhắc cho bạn đời trên lịch (app chưa ánh xạ id người dùng server của bạn đời); lặp tuần/tháng; worker trao huy hiệu (CARE-10); chưa chạy worker BullMQ thật và simulator.
- Trạng thái: Hoàn thành (phần còn lại ghi ở trên).

<a id="bf-20261018-014"></a>
## BF-20261018-014 — Song song: Codex làm gửi push + worker trao huy hiệu CARE-10, Claude nối app quyền thông báo/push ONB-10 và nhắc cho bạn đời trên lịch

- Ngày làm: 2026-10-18T21:18:02+07:00 → 2026-10-18T21:38+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Đợt tiếp: Codex làm gửi push (NotificationDelivery, giờ yên tĩnh, trần 3/ngày) + worker trao huy hiệu CARE-10, còn bạn nối app quyền thông báo/push ONB-10 và nhắc cho bạn đời trên lịch. Xong thì tick checklist."
- Liên quan: BF-20261018-013.
- Role: ORCHESTRATOR; BACKEND (Codex CLI); MOBILE (Claude); SECURITY/PRIVACY + QUALITY (Claude review); TESTER.
- Phân tích tóm tắt: app đã có `POST /me/devices` và Firebase nên ONB-10 chỉ cần lấy token phía app; id server của bạn đời có sẵn trong `bootstrap.parents`, không cần API mới. Brief cho Codex cấm sửa file sinh tự động (bài học BF-013).
- Kết quả:
  - Backend (Codex): queue `push` job `notification.deliver-push` (một dòng gửi mỗi thiết bị, kiểm lại quyền, giờ yên tĩnh, trần 3/ngày, nội dung nhạy cảm chung chung, xoá token hỏng, thử lại có backoff; FCM HTTP v1 hoặc bản log); queue `care` job `care.award-badges` (theo `mission.changed` + hằng ngày, ghi `family_badges` một lần, outbox `badge.earned`, thông báo Parent, huy hiệu theo Hearts chỉ báo cho chính người đó, Circle không nhận).
  - Claude sửa backend: trần ngày khi xếp hàng trong hộp thư đếm theo thông báo thay vì theo dòng/thiết bị; hộp thư trả `badgeCode` + deep link `babyfamily://care/badges`; `docs/api.md` thêm mục.
  - App (Claude): ONB-10 xin quyền FCM + đăng ký/gửi lại token, từ chối thì xoá token; lịch mời và nhắc bạn đời bằng id server; hiển thị thông báo huy hiệu.
  - Checklist 53/165: tick ONB-10, CARE-10; dòng Push giữ chưa tick vì chưa thử FCM/APNs thật trên thiết bị.
- Bằng chứng kiểm tra: app `make check` EXIT=0 (analyze sạch, 726 test); backend `npm run check` EXIT=0 (unit 247, e2e 35, 2 bộ sinh `--check`); `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` EXIT=0 (23 suite, 242 test). Codex báo 3 test watcher lỗi trong sandbox của nó; chạy lại ở máy thì qua.
- Việc còn lại: thử push thật (cần cấu hình FCM + APNs); phát lại an toàn khi kết quả gửi không rõ; seed mẫu thông báo; số liệu cây theo tuần.
- Trạng thái: Hoàn thành (phần còn lại ghi ở trên).

<a id="bf-20261018-015"></a>
## BF-20261018-015 — Các mục MVP kế tiếp: Codex làm phiên/thiết bị, đổi số điện thoại, ONB-08; Claude nối app avatar, INV-02/03, ONB-09, FAM-02 và app cho phần của Codex

- Ngày làm: 2026-10-18T22:01:44+07:00 → 2026-10-18T22:18+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp các mục MVP còn trống kế tiếp trong checklist, chia việc cho Codex và bạn. Xong thì tick checklist."
- Liên quan: BF-20261018-014.
- Role: ORCHESTRATOR; BACKEND (Codex CLI); MOBILE (Claude); SECURITY/PRIVACY + QUALITY (Claude review); TESTER.
- Phân tích tóm tắt: lấy các mục MVP chưa xong theo thứ tự checklist, bỏ qua CI/staging/monitoring (hạ tầng) và đăng nhập Apple/Google (cần cấu hình nhà cung cấp). Backend thiếu: phiên đăng nhập, đổi số, API cho `Family.settings`. Phía app: INV-02/03, ONB-09, FAM-02 đã có API.
- Kết quả:
  - Backend (Codex): `GET/DELETE /me/sessions`, `POST /me/sessions/revoke-others`; `POST /me/phone/otp` + `/verify` (cần xác thực lại, OTP tới số mới, thu hồi phiên khác); `GET/PATCH /families/:fid/settings` (whitelist có version, Circle chỉ đọc `showLunar`, outbox). Claude đăng ký DI, viết `docs/api.md`.
  - App (Claude): thiết bị SET-07 từ server; cài đặt quyền riêng tư + tên gia đình qua server; phản chiếu `PARTNER_LEFT`; FAM-02 thu hồi lời mời bằng cách cấp mã mới; lỗi khi nhận lời mời chuyển đúng màn INV-02/03; ONB-09 xác nhận đã đi qua server.
  - Không làm được trong đợt: avatar AUTH-04 (`PATCH /me` chưa nhận avatar, `users.avatar_asset_id` trỏ `user_assets`), màn đổi số điện thoại (thiết kế chưa có màn nhập số mới + OTP).
  - Checklist 58/165: tick phiên/thiết bị, INV-02/03, ONB-08, ONB-09, FAM-02.
- Bằng chứng kiểm tra: app `make check` EXIT=0 (analyze sạch, 733 test); backend `npm run check` EXIT=0 (unit 247, e2e 35, 2 bộ sinh `--check`); `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` EXIT=0 (25 suite, 257 test). Codex báo 2 test watcher lỗi trong sandbox của nó; ở máy thì qua.
- Việc còn lại: backend avatar hồ sơ; màn đổi số (cần thiết kế); áp `defaultVisibility` khi tạo ký ức (sửa `memory-*`); chặn chỉ-đọc cho `PARTNER_LEFT` phía server; FAM-07 ảnh bìa/múi giờ.
- Trạng thái: Hoàn thành (phần còn lại ghi ở trên).

<a id="bf-20261019-001"></a>
## BF-20261019-001 — Thai kỳ PREG-01…06 + hồ sơ bé: 2 Codex làm backend song song, Claude nối app

- Ngày làm: 2026-10-19T07:32:17+07:00 → 2026-10-19T07:53+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp các mục MVP còn trống kế tiếp trong checklist (thai kỳ PREG-01…07, hồ sơ bé), chia việc cho Codex và bạn. Xong thì tick checklist."
- Liên quan: BF-20261018-015.
- Role: ORCHESTRATOR; BACKEND (2 phiên Codex CLI song song, file tách biệt); MOBILE (Claude); SECURITY/PRIVACY + QUALITY (Claude review); TESTER.
- Phân tích tóm tắt: schema đã đủ (Pregnancy, PrepItem, BirthConversion*, Child, ký ức BUMP/ULTRASOUND, ops.content_items) nên không cần migration. Chia Codex A (hành trình tuần, ký ức thai kỳ theo loại, danh sách chuẩn bị + seed) và Codex B (chào đời, lưu trữ thai kỳ, hồ sơ bé). PREG-07 (1.1) và CHD-06 (1.2) để ngoài.
- Kết quả:
  - Codex A bị dừng giữa chừng vì máy chủ model quá tải; Claude nối lại đúng phiên (`codex exec resume`), Codex hoàn tất: `/journey`, `/memories?kind`, `/prep-items`, seed 78 mục tuần + 14 mục chuẩn bị vi/en.
  - Codex B: `/birth` idempotent (sinh đôi, chuyển ký ức, kế thừa quyền), `/archive|restore` (`ENDED_PRIVATE` ẩn khỏi Circle), sắp xếp/lưu trữ/xoá bé (lưu trữ 7 ngày trước khi xoá), ảnh đại diện/ảnh bìa, `/profile-stats` theo quyền người gọi.
  - Claude: đăng ký DI (controller mới đặt trước controller cũ để route không bị nuốt); nới điều kiện ảnh sang `UPLOADED|PROCESSING|READY` vì app gắn ảnh ngay sau khi tải; sửa test `care-progress` phụ thuộc ngày (hôm qua thuộc tuần trước khi hôm nay là thứ Hai, lỗi có từ BF-20261018-009); `docs/api.md`.
  - App: thai kỳ (chuẩn bị, chào đời, lưu trữ, kích thước theo tuần, tuần thai của ảnh bụng/siêu âm) và hồ sơ bé (số đếm, sắp xếp, lưu trữ/xoá, tải ảnh đại diện/ảnh bìa) qua server.
  - Checklist 67/165: tick PREG-01…06, CHD-01/03/05; ảnh bé giữ 🟡 vì máy khác chưa nhận URL ảnh.
- Bằng chứng kiểm tra: app `make check` EXIT=0 (analyze sạch, 739 test); backend `npm run check` EXIT=0 (unit 257, e2e 35, 2 bộ sinh `--check`); `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` EXIT=0 (29 suite, 274 test).
- Việc còn lại: URL ảnh bé/thai kỳ qua bootstrap; `?status=archived` trên route danh sách cũ; huỷ nhắc/việc của thai kỳ khi chào đời/lưu trữ; form chào đời nhiều bé trên app; chưa chạy seed trên DB dev và chưa chạy simulator.
- Trạng thái: Hoàn thành (phần còn lại ghi ở trên).

<a id="bf-20261019-002"></a>
## BF-20261019-002 — Ký ức & album §6, nhật ký/thư/cột mốc §7: 2 Codex làm backend song song, Claude nối app

- Ngày làm: 2026-10-19T08:22:55+07:00 → 2026-10-19T08:48+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp các mục MVP còn trống kế tiếp trong checklist (ký ức & album §6, nhật ký/thư/cột mốc §7), chia việc cho Codex và bạn. Xong thì tick checklist." Giữa chừng người dùng hỏi "Đã xong chưa nhỉ? Nếu xong rùi làm task tiếp theo cho tôi đi" — trả lời đang chạy, làm tiếp đến hết đợt.
- Liên quan: BF-20261019-001.
- Role: ORCHESTRATOR; BACKEND (2 phiên Codex CLI song song); MOBILE (Claude); SECURITY/PRIVACY + QUALITY (Claude review); TESTER.
- Phân tích tóm tắt: schema có sẵn Album/AlbumMemory/Favorite/MemoryLetter/MilestoneTemplate/Milestone/MemoryPerspective/MemoryPromptTemplate. Codex A (không được sửa file `memory-*`): album, yêu thích, tải bản gốc, góc nhìn, gợi ý. Codex B (sở hữu `memory-*`): cột mốc, những lần đầu, thư + job mở thư, nháp, sửa ảnh.
- Kết quả:
  - Backend: Codex A 4 suite/21 test; Codex B 6 suite/47 test (gồm suite ký ức cũ). Claude đăng ký DI cho 6 controller mới, bổ sung 4 mẫu cột mốc mà app dùng vào seed (lần đầu thiếu `dateRule: null` làm `milestone-api` đỏ, đã sửa), viết `docs/api.md`.
  - App: `MemoryLibraryRemoteServiceImp` (album, yêu thích, tải bản gốc, góc nhìn, gợi ý, cột mốc, đếm thư niêm phong); tạo ký ức cột mốc/thư lên server; nút "Tải về" ở màn xem ảnh mở bản gốc.
  - Chưa nối app: nháp trên server (MEM-18) và sửa ảnh của ký ức (màn sửa chưa có chọn ảnh).
  - Checklist 75/165: tick MEM-03, MEM-22, tải bản gốc, MEM-24, gợi ý ghi lại, MEM-14, MEM-11, MEM-12.
- Bằng chứng kiểm tra: app `make check` EXIT=0 (analyze sạch, 743 test); backend `npm run check` EXIT=0 (unit 257, e2e 35); `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` lần cuối EXIT=0 (37 suite, 310 test). Lần chạy trước có 1 deadlock trong `push-delivery.spec.ts` (ca nhiều job nhận việc cùng lúc) khi cả bộ chạy nặng; chạy lại thì qua — cần theo dõi thứ tự khoá `users` trong worker push.
- Việc còn lại: app nháp server + sửa ảnh; thông báo khi thư mở; deadlock tiềm ẩn của worker push; ghi âm cho góc nhìn; chưa chạy seed trên DB dev, chưa chạy simulator.
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
- Role: ORCHESTRATOR (chia việc, review, tích hợp), BACKEND (2 phiên Codex CLI song song: A — Circle mời/quản lý người thân; B — duyệt ảnh, ACL/CIR-05, US-15, lời cảm ơn → ký ức), MOBILE (Claude nối app), TESTER, QUALITY.
- Phân tích: backend chia hai phạm vi file không chồng nhau; Claude đăng ký DI, bật tải ảnh JOURNAL riêng tư (`private_owner_user_id`, không dùng lại bản sao của người khác), sửa fixture album theo luật CIR-05 mới. App: `FamilyRemoteServiceImp` phản chiếu người thân/lời mời/quyền từ `/circle`, `/invites/circle`, `/circle-members/*`; `MemoryLibraryRemoteServiceImp` duyệt ảnh người thân qua `pending-review`/approve/reject; `UsRemoteServiceImp` tải ảnh nhật ký (JOURNAL), gửi đề nghị đăng lời cảm ơn, đọc/lưu `/me/us-settings`.
- Kết quả: checklist tick FAM-01/03/04-06/05, MEM-19, US-15, ảnh nhật ký riêng (87/165); ACL, CIR-05, rời gia đình, CIR-* và lời cảm ơn → khoảnh khắc để 🟡/❌ đúng hiện trạng. `docs/api.md` có mục mới.
- Bằng chứng: app `make check` EXIT 0 (analyze sạch, 753 test); backend `npm run check` EXIT 0 (unit 262, e2e 35); `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` EXIT 0 (41 suite, 353 pass, 1 todo). Chưa chạy simulator.
- Còn lại: app của người thân (CIR-WAIT, CIR-01…06, CIR-05, rời gia đình); màn bạn đời duyệt đăng lời cảm ơn; Circle tải ảnh lên (media service còn chỉ cho Parent); ACL bé gắn lẫn ở milestone/profile-stats; định tuyến thông báo sự kiện duyệt ảnh; ảnh nhật ký riêng chưa có URL xem trong media view.
- Trạng thái: Hoàn thành (còn các phần nêu ở “Còn lại”).

## BF-20261019-005 — Circle tải ảnh, ACL bé gắn lẫn, thông báo duyệt ảnh (Codex) + app người thân CIR-*, màn duyệt lời cảm ơn (Claude)

- Ngày làm: 2026-10-19T14:06:38+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Đợt tiếp: Codex cho Circle tải ảnh lên + ACL bé gắn lẫn + thông báo duyệt ảnh, còn bạn nối app người thân CIR-WAIT/CIR-01…06, CIR-05, rời gia đình và màn duyệt lời cảm ơn. Xong thì tick checklist."
- Liên quan: BF-20261019-004.
- Role: ORCHESTRATOR (chia việc, review, tích hợp), BACKEND (Codex CLI: Circle tải ảnh, ACL bé gắn lẫn, thông báo duyệt ảnh; Claude thêm quyền theo bé vào `/me/circles`), MOBILE (Claude), TESTER, QUALITY (tự review diff Codex — không có reviewer độc lập).
- Phân tích: app người thân đã có UI mock; bản server phản chiếu tư cách người thân từ `/me/circles` vào phiên trên máy (chờ duyệt → CIR-WAIT, ACTIVE → CIR-01, PAUSED → CIR-05) rồi dùng lại logic hiển thị mock. `CircleRemoteServiceImp` đọc bảng tin qua memory service bản server (ẩn bài đang chờ duyệt), lời chúc/thả tim/đăng ảnh qua API ký ức, rời gia đình qua `/circle/leave`. `SessionRemoteServiceImp` xem trước/nhận lời mời CIRCLE. Bức tường cảm ơn có nút “Đăng cho cả nhà / Để riêng hai mình” cho người nhận (`share-respond`). Family service không gọi `/circle` khi là người thân.
- Kết quả: checklist tick thêm 5 dòng (lời cảm ơn → khoảnh khắc, CIR-WAIT/CIR-01…06, ACL §6.3, CIR-05, rời gia đình) → 92/165. `docs/api.md` có mục BF-005.
- Bằng chứng: app `make check` EXIT 0 (analyze sạch, 756 test; mới: 2 test người thân trong session_remote_test, 1 test duyệt lời cảm ơn); backend `npm run check` EXIT 0 (unit 267, e2e 35); `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` EXIT 0 (41 suite, 362 test). Codex báo thêm 72/72 test ở 7 spec liên quan. Chưa chạy simulator; chưa chạy seed catalog thông báo v4.
- Còn lại: chạy seed `notification-templates.json` v4 khi triển khai; tuỳ chọn thông báo/bản tin người thân (CIR-06) và “gỡ nội dung khi rời” chưa có API; tên tác giả ký ức trên app người thân chưa có (không có danh sách Bố/Mẹ); CIR-05 giữa phiên chỉ chuyển màn khi trang chủ tải lại; dọn nhỏ backend: `requireContentAccess` optional, kind IMAGE/VIDEO viết cứng trong media service.
- Trạng thái: Hoàn thành (còn các phần nêu ở “Còn lại”).

## BF-20261019-006 — Cài đặt thông báo/AI, tìm kiếm, báo cáo/chặn (2 Codex) + app gói dịch vụ, hồ sơ, nháp và nối API mới (Claude)

- Ngày làm: 2026-10-19T17:08:14+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp các mục MVP còn trống kế tiếp trong checklist, chia việc cho Codex và bạn. Xong thì tick checklist."
- Liên quan: BF-20261019-005.
- Role: ORCHESTRATOR, BACKEND, MOBILE, TESTER, QUALITY — tất cả do Claude làm (tự review, không có reviewer độc lập). Ban đầu giao 2 phiên Codex (A: cài đặt thông báo/AI; B: tìm kiếm/báo cáo/chặn) nhưng Codex hết quota ngay (không sửa file nào); Antigravity cho phần A dừng ngay vì allowlist lệnh headless (không tự sửa cấu hình agy). Người dùng yêu cầu bỏ chờ Codex B, Claude tự làm.
- Phân tích: backend dùng schema có sẵn, không migration — `user_settings` (notification_prefs/quiet/hide preview/circle digest/ai), `memories.search_tsv` (unaccent + GIN, trigger có sẵn), `reports`/`report_hides`/`blocks`. Thêm `PreferenceSettingsController/Service/Repository` (+ policy v1), `SafetyController/Service/Repository` (+ policy v1), `viewerExclusions` áp cho feed/timeline/tìm kiếm/bình luận, route `/search`, `/on-this-day` trong memory controller. App: `FamilyRemoteServiceImp` đọc `/billing/plans` + `/families/:fid/billing` và phản chiếu gói/hạn/dung lượng/ân hạn vào gói trên máy; `SettingsRemoteServiceImp` PATCH /me (tên), cài đặt thông báo/AI (ánh xạ nhóm/mã), chặn theo userId; `MemoryRemoteServiceImp` nháp trên tài khoản (danh sách, xoá), tìm kiếm, ngày này năm xưa, báo cáo (thêm tham số `ReportTarget`). Màn người thân: chặn rồi gỡ qua Family service.
- Kết quả: checklist tick thêm 9 dòng (cài đặt thông báo, MEM-15, MEM-16, RPT-01, RPT-02, catalog gói, SUB-03, PATCH /me, cài đặt AI) → 101/165; MEM-18 và SUB-06/07 cập nhật 🟡/App ✅. `docs/api.md` có mục BF-006.
- Bằng chứng: app `make check` EXIT 0 (analyze sạch, 765 test; mới ở family_remote +2, settings_remote +4, subject_memory_remote +3); backend `npm run check` EXIT 0 (unit 267, e2e 35); `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` EXIT 0 (43 suite, 372 test; mới preference-settings-api 5, search-safety-api 5). Chưa chạy simulator.
- Còn lại: job gom bản tin người thân (DIGEST) và thông báo ký ức cho Circle; moderation case/Admin xử lý báo cáo; ẩn cảm xúc người bị chặn, lưới ảnh/album chưa áp chặn; tiếp tục soạn nháp từ tài khoản; IAP/giá từ Store; `analysis_options` loại trừ thư mục test nên `flutter analyze` không bắt lỗi test (tests vẫn biên dịch khi chạy).
- Trạng thái: Hoàn thành (còn các phần nêu ở “Còn lại”).
- Ghi bù 2026-10-26T15:06+07:00 (BF-20261026-007): chạy lại đủ bộ kiểm tra **trên mã hiện tại** (đã gồm mọi thay đổi sau BF-20261019-006, nên không tái hiện riêng trạng thái lúc đó):
  - Backend `npm run check` EXIT 0 (unit 331, e2e 35); `npx eslint --max-warnings=0 src test` EXIT 0; `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` EXIT 0 (73 suite, 609 test).
  - App `make check` EXIT 0 (analyze sạch, 878 test).
  - Entry này vốn đã có kết quả kiểm tra của lần làm ban đầu, nên không đổi trạng thái.

## BF-20261019-007 — Recap tuần + số liệu HOME-01, avatar hồ sơ + ảnh bé qua bootstrap (2 Codex) + app video/multipart, sửa ảnh ký ức, chi tiết từ server (Claude)

- Ngày làm: 2026-10-19T18:39:45+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp các mục MVP còn trống kế tiếp trong checklist, chia việc cho Codex và bạn. Xong thì tick checklist."
- Liên quan: BF-20261019-006.
- Role: ORCHESTRATOR (chia việc, review, tích hợp DI/worker), BACKEND (2 phiên Codex CLI song song: A — recap tuần + số liệu HOME-01; B — avatar tài khoản AUTH-04 + URL ảnh hồ sơ/ảnh bé), MOBILE (Claude), TESTER, QUALITY (Claude tự review diff Codex; Codex báo có reviewer phụ đọc code).
- Phân tích: Codex A thêm `WeeklyRecapController/Service/Repository`, job `recap.weekly-build` (queue `recaps`, worker riêng), `/home/week-stats`; Codex B thêm pipeline ảnh tài khoản (`ProfileImageController/Service/Repository`, dọn trong `media.purge-orphans`), `avatarUrl` ở /me, bootstrap, circle, overview. Claude đăng ký DI API + worker; sửa lỗi tích hợp: 4 service bắt buộc `PROFILE_IMAGE_SERVICE` làm vỡ các module test cũ → `@Optional()` + null object `NO_PROFILE_IMAGES` (ứng dụng/worker thật luôn bind service thật), cập nhật kỳ vọng test cho trường avatar mới, stub trong test bản build. App: video (`pickMultipleMedia`, đọc thời lượng bằng video_player, kiểm giới hạn gói, `durationMs`), multipart (PUT từng part + ETag), sửa ký ức đổi ảnh (`mediaAssetIds` song song khi mirror → add/remove/cover), `refreshMemory` cho chi tiết/xem ảnh/bình luận, recap tuần + “Tuần này” từ server, avatar hồ sơ (chọn ảnh, tải lên, `PATCH /me`), ảnh bé + avatar của tôi mirror qua bootstrap//me.
- Kết quả: checklist tick 7 dòng (avatar AUTH-04, ảnh bé, MEM-07, đổi ảnh khi sửa, upload video, REC-02, HOME-01) → 108/165; multipart/MEM-06 để 🟡. `docs/api.md` mục BF-007 + 2 handoff của Codex trong `baby-backend/docs/handoffs/`.
- Bằng chứng: app `make check` EXIT 0 (analyze sạch, 770 test; cập nhật 2 widget test theo hành vi mới); backend `npm run check` EXIT 0 (unit 267, e2e 35, test bản build); integration lần cuối EXIT 0 (47 suite, 392 test). Lần chạy toàn bộ trước đó `push-delivery.spec` lỗi 18 test nhưng chạy riêng đạt 18/18 và lần toàn bộ kế tiếp đạt — ghi nhận là chập chờn khi chạy chung, chưa tìm nguyên nhân. Codex A: 6 test spec recap; Codex B: 14 integration + 41 unit. Chưa chạy simulator; chưa thử BullMQ/Redis thật cho job recap.
- Còn lại: hàng đợi tải nền MEM-06; chia sẻ/lưu recap lên server; recap tháng; tìm nguyên nhân `push-delivery` chập chờn khi chạy toàn bộ; ảnh đại diện Bố/Mẹ còn lại và người thân hiển thị từ `avatarUrl` (đã có trong API, app chưa dùng).
- Trạng thái: Hoàn thành (còn các phần nêu ở “Còn lại”).

## BF-20261019-008 — Xoá gia đình + quyền riêng tư, ảnh tháng + chương tháng + Accept-Language (2 Codex) + app MEM-06, SW-01, hiển thị, FAM-07 (Claude)

- Ngày làm: 2026-10-19T22:23:53+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp các mục MVP còn trống kế tiếp trong checklist, chia việc cho Codex và bạn. Xong thì tick checklist."
- Liên quan: BF-20261019-007.
- Role: ORCHESTRATOR (chia việc, review, tích hợp DI/worker/interceptor), BACKEND (2 phiên Codex CLI: A — xoá gia đình + privacy overview; B — ảnh tháng, thẻ chương/recap trên timeline, Accept-Language), MOBILE (Claude), TESTER, QUALITY (Claude tự review; Codex báo có reviewer phụ).
- Phân tích: đăng ký `FamilyErasure/FamilyPrivacy/MonthlyPhotoSelection` controller, provider timeline/locale/notification text, worker `family.deletion-executor`, `RequestLocaleInterceptor`. Sửa tích hợp: lỗi 5xx của Nest giữ thông điệp vận hành gốc trong `error.details` (readiness e2e); `push-delivery.repository` đóng lần gửi bỏ dở bằng chọn hàng theo id `FOR UPDATE SKIP LOCKED` thay cho UPDATE nhiều hàng không thứ tự (nguy cơ deadlock giữa worker). App: MEM-06 tải nền (`create(deferUpload:)`, ký ức tạm có tiến độ, thử lại/huỷ, ký ức tạm sót sau khi mở lại → nháp); SW-01 bé không còn trong bootstrap → lưu trữ; SET-06 hiển thị lưu trên máy + `/me/settings` + áp khi mở app; SET-04 `/privacy-overview`; màn “Xoá gia đình” (OTP, chờ đồng ý, hẹn xoá, huỷ); ảnh tháng đọc/ghi server. FAM-07 (ảnh bìa, múi giờ IANA, ngôn ngữ nội dung) chưa làm vì cần backend.
- Kết quả: checklist tick 7 dòng (SW-01, multipart/MEM-06, MEM-20/21, bảng quyền riêng tư, đồng bộ hiển thị, xoá gia đình, Accept-Language) → 115/165; thẻ timeline từ server App 🟡. `docs/api.md` mục BF-008 + 2 handoff Codex.
- Bằng chứng: app `make check` EXIT 0 (analyze sạch, 774 test); backend `npm run check` EXIT 0 (unit 267, e2e 35, sau khi sửa filter). Integration: Codex A 15/15, Codex B 33/33 chạy riêng; toàn bộ 3 lần: lần 1 lỗi `media-api` (MinIO tạm không phản hồi) + `push-delivery` (deadlock), lần 2 chỉ `push-delivery`, lần 3 (sau sửa thứ tự khoá) `push-delivery` deadlock ở bước khoá `users` + `circle-content-acl` 500 một test. Chạy riêng: `push-delivery` 18/18, `media-api` + `push-delivery` 25/25, `circle-content-acl` 13/13. **Integration toàn bộ chưa xanh** — chập chờn khi chạy chung, chưa tìm ra nguyên nhân gốc.
- Còn lại: điều tra deadlock/độc lập dữ liệu của `push-delivery.spec` khi chạy toàn bộ (đề xuất phiên riêng); app đọc thẻ chương/recap từ `/timeline`; FAM-07 ảnh bìa/múi giờ/ngôn ngữ nội dung; thông báo cho sự kiện xoá gia đình.
- Trạng thái: Hoàn thành phần tính năng; kiểm thử integration toàn bộ còn lỗi chập chờn (xem “Bằng chứng”).

<a id="bf-20261019-009"></a>
## BF-20261019-009 — Điều tra và sửa deadlock chập chờn của push-delivery.spec khi chạy toàn bộ integration

- Ngày làm: 2026-10-19T23:06:04+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: (phiên phụ do phiên BF-20261019-008 giao) tìm nguyên nhân gốc lỗi `40P01 deadlock detected` tại bước khoá `app.users` trong `PushDeliveryRepository.claim` khi chạy toàn bộ `npm run test:integration`, sửa ở repository/service (hoặc fixture/cleanup nếu do độc lập dữ liệu giữa spec), không commit; xong khi integration toàn bộ 2 lần liên tiếp EXIT 0 và `npm run check` EXIT 0.
- Liên quan: BF-20261019-008.
- Role: Chủ trì BACKEND; hỗ trợ DBA (thứ tự khoá PostgreSQL); review TESTER, QUALITY (góc nhìn do agent chính tự áp dụng, không có reviewer độc lập).
- Trạng thái: Hoàn thành.
- Phân tích: Test DB còn 313 delivery PUSH của 129 user do spec khác để lại; `push-delivery.spec` dùng `now=2030` nên `claim` (quét toàn cục `next_attempt_at<=now`) xử lý cả dữ liệu đó. Mỗi lần `claim` cũ quét tới 100 delivery trong **một** transaction và khoá user người nhận của từng delivery (thứ tự tuỳ ý, giữ tới cuối transaction) → hai claim song song của test “concurrent claims” khoá user chéo nhau → `40P01`; job bị ngắt để lại `job_runs` RUNNING → bước dọn lỗi `PENDING_WORK_RETENTION_FORBIDDEN`. Chạy riêng spec không có dữ liệu lạ nên luôn đạt. Lỗi thật cả ở production khi nhiều worker push cùng chạy và có nhiều người nhận.
- Kết quả: `src/repositories/push-delivery.repository.ts`: `claim` tách thành transaction đóng lần gửi bỏ dở + vòng `claimNext` — mỗi transaction chỉ xét một delivery (fence lease, khoá delivery `SKIP LOCKED`, khoá một user), quyết định huỷ/dời/hết lượt commit ngay; interface/service không đổi. `test/integration/push-delivery.spec.ts`: đổi mốc thời gian sang 2020 (trước mọi dữ liệu thời gian thật của spec khác) để claim toàn cục chỉ thấy delivery của spec; `joinedAt` cố định 2019 cho Parent/Circle fixture, `birthDate` bé 2018. `docs/api.md` mục Push thêm ghi chú hành vi đồng thời.
- Kiểm chứng: `npm run test:integration -- test/integration/push-delivery.spec.ts` 18/18; `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` toàn bộ 2 lần liên tiếp đều EXIT 0 (51 suite, 424 test mỗi lần); `npm run check` EXIT 0 (unit 267, e2e 35). Không có reviewer độc lập (agent chính tự review). Không commit.
- Còn lại: Test DB vẫn giữ dữ liệu cũ của các spec khác (không xoá vì ngoài phạm vi); `claim` vẫn trả `null` khi hết ngân sách quét 100 delivery trong một lần (lần chạy sau tiếp tục) — giữ nguyên hành vi cũ.
- Product history: [BF-20261019-009](PRODUCT_ANALYTICS_HISTORY.md#bf-20261019-009).

## BF-20261019-009 — FAM-07/FAM-08, MEM-25 + PARTNER_LEFT (2 Codex) + app MEM-08 video, thẻ timeline server, giữ phiên khi mất mạng (Claude)

- Ngày làm: 2026-10-19T23:06:23+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp các mục MVP còn trống kế tiếp trong checklist, chia việc cho Codex và bạn. Xong thì tick checklist."
- Liên quan: BF-20261019-008.
- Role: ORCHESTRATOR, BACKEND, MOBILE, TESTER, QUALITY — Claude làm toàn bộ (tự review). Đã giao 2 phiên Codex (A: FAM-07/FAM-08; B: MEM-25 + PARTNER_LEFT) nhưng Codex hết quota ngay (không sửa file nào, mở lại 23:40); theo cách người dùng chọn ở BF-006, Claude tự làm thay vì chờ và huỷ lịch hẹn chạy lại Codex. Song song có phiên [Sửa deadlock push-delivery] do người dùng khởi chạy, sửa `push-delivery.*` (đợt này không đụng các file đó).
- Phân tích: backend — `GET /children/:id/today-story` (dùng ACL/loại trừ + `project` của feed, theo `occurred_local_date`), `activeChildren` cho xem trước lời mời bạn đời khi `PARTNER_LEFT` (rà US-00: các phần khác đã có), FAM-07 `contentLocale` + `coverAssetId`/`coverUrl` (cột có sẵn, ký URL qua `ProfileImageService.familyCover`). App — MEM-08 phát video (`_displayUrl` poster, `mediaVideos` v1080, `_ViewerVideo`), thẻ chương tháng dùng thẻ `CHAPTER` của `/timeline` (lưu `serverChapters` trên hàng bé), giữ phiên khi mất mạng (bản chụp `exportSnapshot/importSnapshot` + `IOfflineSnapshotRepository` mã hoá LocalStore, nạp khi mở app nguội mà server không phản hồi), MEM-25 `stories()` từ server, FAM-07 chọn ảnh bìa + đổi ngôn ngữ nội dung, xem trước lời mời bạn đời có tên bé. FAM-08 để lại (cần đồng bộ lại phiên theo gia đình được chọn).
- Kết quả: checklist tick 4 dòng (PARTNER_LEFT, giữ phiên khi mất mạng, MEM-08, MEM-25) → 119/165; FAM-07 và thẻ timeline cập nhật 🟡. `docs/api.md` mục BF-009.
- Bằng chứng: app `make check` EXIT 0 (analyze sạch, 778 test; mới: subject_memory_remote +3, session_remote (mất mạng nguội), family_remote +1); backend `npm run check` EXIT 0 (unit 270 gồm onboarding-partner-left 2 + FAM-07 1; e2e 35); `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` EXIT 0 (51 suite, 425 test — xanh toàn bộ sau bản sửa deadlock của phiên kia; search-safety-api thêm MEM-25). Chưa chạy simulator.
- Còn lại: FAM-08 chuyển gia đình; múi giờ FAM-07 (danh mục IANA trên app); thẻ recap tuần trên dòng thời gian; ảnh bé trong xem trước lời mời bạn đời.
- Trạng thái: Hoàn thành (còn các phần nêu ở “Còn lại”).

## BF-20261019-010 — Support ticket + kiểm duyệt, allowlist khi hết hạn + SUB-06/07 (2 Codex) + app đổi số, ghi âm, chuỗi nhiệm vụ, nháp tài khoản (Claude)

- Ngày làm: 2026-10-20T07:40:42+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp các mục MVP còn trống kế tiếp trong checklist, chia việc cho Codex và bạn. Xong thì tick checklist."
- Liên quan: BF-20261019-009.
- Role: ORCHESTRATOR (chia việc, tích hợp), BACKEND (Codex A: support ticket + gom ca kiểm duyệt; Codex B: allowlist §6.5 + nhắc gia hạn SUB-06/07; Claude: đăng ký DI/worker), MOBILE (Claude: đổi số, chuỗi nhiệm vụ, gửi yêu cầu hỗ trợ), TESTER, QUALITY (Claude rà handoff, sửa kỳ vọng test cũ). Codex A/B chạy song song đủ quota; báo cáo ở `baby-backend/docs/handoffs/BF-20261019-010-A.md`, `-B.md`.
- Phân tích: Codex để lại composition root cho bên tích hợp → Claude đăng ký `SupportHelpdeskController`, provider support/moderation/subscription-reminder ở API và worker, lịch + nhánh `moderation.reconcile-sla` trong `MaintenanceQueueWorker`, `SubscriptionReminderQueueWorker`; thêm `SUPPORT_ENCRYPTION_KEY` (tuỳ chọn, base64 32 byte) vào `environment.ts`/`.env.example` (không sửa `.env`). API không có `JOB_RUNNER_SERVICE` nên `ModerationWorkflowService` nhận runner `@Optional` (chỉ worker chạy job). Allowlist §6.5 của B đổi có chủ đích hồ sơ gia đình sang mode `read` và cho BLOCKED tải dữ liệu → cập nhật 2 unit + 1 e2e cũ. App: màn đổi số (`/settings/phone`), mục “Chuỗi lặp lại” trong Cài đặt nhiệm vụ (`missionSeries/pauseSeries/endSeries`, ngày MO..SU → 1..7, quản lý chuỗi của tôi/Cùng nhau), màn gửi yêu cầu hỗ trợ (`/settings/help/request`, danh mục từ server, danh sách đã gửi; chỉ gửi nội dung người dùng nhập + id gia đình đang mở). Ghi âm (VOICE) và tiếp tục nháp từ tài khoản (MEM-18) không làm đợt này.
- Kết quả: checklist tick 5 dòng (chuỗi nhiệm vụ, kiểm duyệt, SUB-06/07, allowlist §6.5, support ticket) → 124/165; dòng đổi số cập nhật App 🟡 (còn liên kết Apple/Google). `docs/api.md` mục BF-010.
- Bằng chứng: app `make check` EXIT 0 (analyze sạch, 781 test; mới: care_remote CARE-03 series, settings_remote phone change + support). Backend `npm run check` EXIT 0 (unit 272, e2e 35, compiled); `npx eslint --max-warnings=0 src test` EXIT 0; `generate:services`/`generate:persistence --check` EXIT 0; `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` EXIT 0 (56 suite, 465 test). Chưa chạy Redis/BullMQ/FCM thật, chưa chạy simulator, chưa seed catalog template v5 vào DB.
- Còn lại: seed catalog thông báo v5 (BILLING) theo quy trình riêng; đặt `SUPPORT_ENCRYPTION_KEY` khi triển khai; CSKH trả lời/route kiểm duyệt cần admin auth (Admin CMS); app xem/nhắn tiếp ticket, tải tệp SUPPORT; app đọc `statusBanner`; liên kết Apple/Google; ghi âm VOICE; MEM-18 nháp từ tài khoản; FAM-08, múi giờ FAM-07.
- Trạng thái: Hoàn thành (còn các phần nêu ở “Còn lại”; tiêu đề nêu ghi âm/nháp tài khoản nhưng hai phần này chưa làm).

## BF-20261020-001 — Đăng nhập/liên kết Apple & Google + IAP (SUB-01/02/04, store notifications) (2 Codex) + app tiếp tục nháp, thẻ recap tuần, giới hạn gói, múi giờ (Claude)

- Ngày làm: 2026-10-20T18:56:25+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp task tiếp theo đi"
- Liên quan: BF-20261019-010.
- Role: ORCHESTRATOR (chọn mục MVP, chia việc, tích hợp), BACKEND (Codex A: đăng nhập/liên kết Apple & Google; Codex B: IAP + nâng cấp + webhook Store; Claude: đăng ký DI/worker, biến mẫu `.env.example`), MOBILE (Claude), TESTER, QUALITY (Claude rà handoff, chạy toàn bộ kiểm tra). Báo cáo Codex: `baby-backend/docs/handoffs/BF-20261020-001-A.md`, `-B.md`.
- Phân tích: backend dùng schema có sẵn (`AuthIdentity`, `PurchaseIntent`/`SubscriptionTransaction`/`Subscription`), không migration. Claude đăng ký `SocialAuthController`, `SignInMethodsController`, `IapBillingController`, `IapWebhookController` và provider ở API; worker thêm IAP providers + `CatalogQueryRepository`/`FamilyBillingService` + `IapBillingQueueWorker`. App: MEM-18 mở nháp trên tài khoản ở chế độ sửa của trình soạn (`draftId`) → `PATCH` rồi `POST /memories/:id/publish`; nháp được phản chiếu vào kho nhưng ẩn khỏi danh sách ký ức (`remoteStatus: DRAFT`); thẻ recap tuần mới nhất (`WEEKLY_RECAP` của `/timeline`) chèn vào dòng thời gian cả nhà, mở màn Recap tuần; SUB-05 sheet giới hạn theo mã `QUOTA_*` (lưu nháp / nâng cấp); phương thức đăng nhập đọc từ `/me/sign-in-methods`, chế độ server không giả lập liên kết Apple/Google. Không thêm SDK Apple/Google/`in_app_purchase` (cần cấu hình gốc + client id/sản phẩm Store) và không làm FAM-07 múi giờ (đã đổi kế hoạch so với tiêu đề).
- Kết quả: checklist tick 4 dòng (MEM-18, thẻ recap/chương trên timeline, SUB-05, store notifications) → 128/165; cập nhật Apple, Google, liên kết đăng nhập, SUB-01/02, SUB-04 (BE ✅, App ❌/🟡). `docs/api.md` mục BF-20261020-001.
- Bằng chứng: app `make check` EXIT 0 (analyze sạch, 784 test; mới: subject_memory_remote +2 (đăng nháp, recap tuần), settings_remote +1 (phương thức đăng nhập)). Backend `npm run check` EXIT 0 (unit 314, e2e 35, compiled); `npx eslint --max-warnings=0 src test` EXIT 0; `generate:services`/`generate:persistence --check` EXIT 0; `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` EXIT 0 (58 suite, 496 test). Chưa gọi Apple/Google/Store thật, chưa chạy BullMQ/Redis, chưa chạy simulator; sheet SUB-05 chưa có widget test.
- Còn lại: app SDK Sign in with Apple/Google, liên kết/gỡ trên app; app `in_app_purchase` cho SUB-01/02/04; Play publisher production, Apple OCSP, đổi mã/revoke token Apple; cấu hình env Store/Apple/Google khi triển khai; FAM-07 múi giờ, FAM-08, ghi âm, ticket hỗ trợ chi tiết.
- Trạng thái: Hoàn thành (còn các phần nêu ở “Còn lại”; tiêu đề nêu múi giờ nhưng phần này chưa làm).

## BF-20261021-001 — CI app + giám sát production, ghi âm VOICE + chuyển gia đình FAM-08 + danh mục múi giờ (2 Codex) + app ghi âm, chuyển gia đình, múi giờ (Claude)

- Ngày làm: 2026-10-21T10:24:27+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp task tiếp theo đi"
- Liên quan: BF-20261020-001.
- Role: ORCHESTRATOR (chọn mục, chia việc, tích hợp), BACKEND (Codex A: CI app + log JSON/`/metrics`/hook báo lỗi; Codex B: VOICE, FAM-08, danh mục múi giờ; Claude: đăng ký DI, sửa hồi quy), MOBILE (Claude), TESTER, QUALITY (Claude). Báo cáo Codex: `baby-backend/docs/handoffs/BF-20261021-001-A.md`, `-B.md`.
- Phân tích: Codex A tự nối `ObservabilityModule` vào `AppModule`; Claude đăng ký `MeFamiliesController`, `TimezoneCatalogController` + 3 provider, thêm biến mẫu vào `.env.example`. QUALITY phát hiện và sửa 3 hồi quy: (1) validator múi giờ mới từ chối `Etc/GMT+7` (unit cũ) → nhận mọi zone ICU dạng Area/Location; (2) `X-Request-Id` bị siết thành chỉ UUID, vỡ contract e2e cũ → khôi phục `[a-zA-Z0-9_-]{1,100}`; (3) chạy toàn bộ integration hết heap 4 GB (mỗi spec ~1.3 GB RSS, cộng dồn trong một tiến trình `--runInBand`; spec cũ cũng vậy, 4 suite mới đẩy vượt ngưỡng) → `--maxWorkers=1` + `workerIdleMemoryLimit: 1536MB` (vẫn tuần tự). App: ghi âm thật (`record` 7.1.2, quyền `RECORD_AUDIO`, `IVoiceRecorderRepository` + `IVoiceRecordingService`, bản mẫu giữ đoạn 12 giây), tải `AUDIO` + chờ `GET /media/:id` READY rồi tạo VOICE, phản chiếu `durationSec`/`urls.a`, `PlayableVoiceCard` (video_player) trên dòng thời gian; FAM-08 `memberships()` từ `/me/families`, `switchFamily` → `PUT /me/default-family` + `ISessionService.changeFamily` (reseed bản phản chiếu, đồng bộ lại theo gia đình đã chọn, Parent ↔ người thân), xoá cache của dịch vụ ký ức khi đổi gia đình; FAM-07 chọn múi giờ từ `/catalog/timezones` (tìm kiếm, `PATCH {timezone}`).
- Kết quả: checklist tick 3 dòng (FAM-08, VOICE, FAM-07) → 131/165; cập nhật CI và logging/monitoring 🟡. `docs/api.md` mục BF-20261021-001.
- Bằng chứng: app `make check` EXIT 0 (analyze sạch, 789 test; mới: family_remote +2, session_remote +1 (FAM-08), subject_memory_remote +2 (VOICE)). Backend `npm run check` EXIT 0 (unit 325, e2e 35, compiled); `npx eslint --max-warnings=0 src test` EXIT 0; `generate:services`/`generate:persistence --check` EXIT 0; `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` EXIT 0 (62 suite, 515 test) sau khi đổi cấu hình worker (lần đầu EXIT 134 hết heap — đã ghi ở trên). Chưa chạy GitHub Actions, chưa thử ghi âm/nghe trên máy thật, chưa có widget test cho màn chọn múi giờ/chuyển gia đình.
- Còn lại: chạy CI thật; Sentry/cảnh báo và observability cho worker; thử ghi âm trên thiết bị; app SDK Apple/Google + `in_app_purchase`; ticket hỗ trợ chi tiết; staging.
- Trạng thái: Hoàn thành (còn các phần nêu ở “Còn lại”).

## BF-20261021-002 — Admin backend (xác thực admin, kiểm duyệt, khoá license, CSKH, catalog) + người/địa điểm ký ức, email giao dịch, outbox consumer (2 Codex) + app nhật ký, người/địa điểm, ticket hỗ trợ (Claude)

- Ngày làm: 2026-10-21T10:49:41+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp task tiếp theo đi"
- Liên quan: BF-20261021-001.
- Role: ORCHESTRATOR (chọn mục, chia việc, tích hợp), BACKEND (Codex A: Admin CMS; Codex B: người/địa điểm, email giao dịch, rà outbox — cả hai hết quota lúc ~11:01, mở lại 15:25; theo lựa chọn trước đây của người dùng, Claude tự hoàn thiện thay vì chờ), MOBILE (Claude), TESTER, QUALITY (Claude).
- Phân tích: Codex đã viết gần đủ code + spec nhưng chưa đăng ký DI và không có handoff. Claude chạy từng spec mới, sửa: spec email (fixture `callName` 27 ký tự > cột 20; dọn Mailpit sai route → `DELETE /api/v1/messages {IDs}`), truy vấn thùng rác chọn nhầm `joinedAt` (vỡ `memory-api`), spec admin chạy chung bị 429 do bộ đếm đăng nhập theo IP lưu trong `admin_audit_events` (spec xoá mềm lượt thử cũ trên DB test), unit relay cập nhật danh sách claim gồm `OUTBOX_NO_CONSUMER`. Đăng ký 4 controller + guard + 8 provider admin ở API; worker thêm `MailService`, `TransactionalMailService/Repository`, `TransactionalMailQueueWorker`, `MemoryHeartAwardService/Repository` (bật Hearts ký ức theo `docs/outbox.md`); loại `admin/v1/*` khỏi prefix `api/v1`; thêm `ADMIN_CMS_TOTP_ENCRYPTION_KEY`, `ADMIN_CMS_TOKEN_SECRET` vào `environment.ts`/`.env.example`. App: “Ai ở đó”/cảm xúc/địa điểm trong trình soạn (gửi `people:[{displayName}]`, `feeling`, `locationLabel`; phản chiếu + hiển thị ở chi tiết), nhật ký tự lưu nháp trên máy (debounce 2 giây, cập nhật cùng nháp, mở lại điền đủ; nháp mẫu demo không bị điền), ticket hỗ trợ chi tiết + nhắn thêm.
- Kết quả: checklist tick 4 dòng (outbox consumer, người/địa điểm/cảm xúc, MEM-13, email giao dịch) → 135/165; cập nhật các dòng Admin (BE ✅/🟡, web ❌). `docs/api.md` mục BF-20261021-002.
- Bằng chứng: app `make check` EXIT 0 (analyze sạch, 792 test; mới: mock_services +1 (nháp), settings_remote +1 (ticket), subject_memory_remote +1 (người/cảm xúc/địa điểm)). Backend `npm run check` EXIT 0 (unit 325, e2e 35, compiled); `npx eslint --max-warnings=0 src test` EXIT 0; generators `--check` EXIT 0; `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` EXIT 0 (68 suite, 552 test). Lượt đầu có lỗi (FMT/CHECK/INT) đã sửa như trên. Chưa chạy SMTP production, chưa có web admin, chưa thử trên thiết bị.
- Còn lại: web `baby-admin/`; sửa catalog có version qua admin; app dùng `people-suggestions` và gửi `memberId`; FAQ Trợ giúp; SDK Apple/Google + IAP trên app; CI thật, cảnh báo, staging.
- Trạng thái: Hoàn thành (còn các phần nêu ở “Còn lại”).

## BF-20261021-003 — US-01 bản server không hiện câu hỏi mẫu + Trợ giúp/FAQ và Giới thiệu từ server (Claude; Codex hết quota tới 15:25)

- Ngày làm: 2026-10-21T11:43:03+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp task tiếp theo đi"
- Liên quan: BF-20261021-002.
- Role: ORCHESTRATOR, BACKEND, MOBILE, TESTER, QUALITY — Claude làm toàn bộ (Codex hết quota tới 15:25; không giao Codex đợt này).
- Phân tích: US-01 — lời cảm ơn đã đi qua server; chỉ “câu hỏi hôm nay” còn lấy từ dữ liệu mẫu và hiện cả ở bản server → `UsRemoteServiceImp.coupleToday` bỏ câu hỏi khi có gia đình server (câu hỏi kết nối là 1.1, dòng riêng). SET-11/12 — backend `HelpCenterController` → `IHelpCenterService` (catalog FAQ có version vi/en trong config, liên hệ/đường dẫn pháp lý từ biến môi trường tuỳ chọn, không bịa email/hotline), đăng ký DI, thêm biến vào `environment.ts`/`.env.example`; app `IAccountRemoteRepository.helpCenter`, `SettingsRemoteServiceImp.help()` (không hiện số báo cáo mẫu), Trợ giúp chạm câu hỏi xem câu trả lời, email/hotline mở bằng `mailto:`/`tel:` và ẩn khi chưa cấu hình, Giới thiệu mở điều khoản/quyền riêng tư theo URL server.
- Kết quả: checklist tick 2 dòng (US-01, Trợ giúp/giới thiệu) → 137/165. `docs/api.md` mục SET-11/12.
- Bằng chứng: app `make check` EXIT 0 (analyze sạch, 793 test; mới: couple_remote kiểm không có câu hỏi mẫu, settings_remote +1 help center). Backend `npm run check` EXIT 0 (unit 328 gồm help-center 3, e2e 35, compiled); `npx eslint --max-warnings=0 src test` EXIT 0 (lượt đầu 1 lỗi `no-unnecessary-type-assertion` đã sửa); generators `--check` EXIT 0; `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` EXIT 0 (68 suite, 552 test). Chưa có nội dung điều khoản/quyền riêng tư thật (cần pháp chế cung cấp URL).
- Còn lại: URL điều khoản/quyền riêng tư và email/hotline thật khi triển khai; web admin; SDK Apple/Google + IAP trên app; catalog nhiệm vụ 90 ngày; CI thật, cảnh báo, staging.
- Trạng thái: Hoàn thành (còn các phần nêu ở “Còn lại”).

## BF-20261021-004 — Bộ kiểm thử bất biến bảo mật §6.4 (release blocker) (Claude; Codex hết quota tới 15:25)

- Ngày làm: 2026-10-21T11:57:44+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp task tiếp theo đi"
- Liên quan: BF-20261021-003.
- Role: ORCHESTRATOR, BACKEND, TESTER (chủ trì), QUALITY — Claude làm toàn bộ (Codex hết quota tới 15:25).
- Phân tích: đối chiếu 10 bất biến §6.4 với test hiện có — 5, 6, 8, 9, 10 đã có test chuyên biệt; thiếu phép quét hệ thống cho 1, 2, 3, 4, 7. Viết `test/integration/security-invariants.spec.ts` (AppModule thật, fixture gia đình A: Bố, Mẹ, người thân chỉ được cấp một bé, người ngoài): (1) người ngoài quét 53 route GET với UUID thật → chỉ 404/400; (2) Circle không tới được `/us/*`, nhiệm vụ, Hearts, huy hiệu, `purchase-intents`; (3) Circle không thấy bé chưa cấp quyền ở chi tiết/thống kê/cột mốc/thư/ký ức/today-story/timeline/feed/media-grid/search/on-this-day (kèm kiểm bé được cấp vẫn xem được để phép thử không rỗng); (4) bị gỡ → feed và presign bị từ chối; (7) Bố/Mẹ B quét mọi route không thấy Hearts của A (A vẫn thấy Hearts của mình). Phép quét tìm ra lỗi thật: lịch và chi tiết sự kiện trả 403 `FAMILY_ACCESS_DENIED` cho người ngoài → sửa thành 404; `missions/templates?childId=` bé lạ → 404. Lập `baby-backend/docs/security-invariants.md` (bảng bất biến → test, phần 1.1 chưa có route).
- Kết quả: checklist tick dòng “Kiểm thử bất biến bảo mật §6.4” → 138/165. Không đổi app. `docs/api.md` ghi thay đổi mã lỗi.
- Bằng chứng: `security-invariants.spec.ts` 5/5 (lần đầu 1 fail chính là lỗi lịch 403); `calendar-api` 10/10, `mission-board-api` 21/21, `event-reminder` 11/11 sau sửa; `npm run check` EXIT 0 (unit 328, e2e 35, compiled); `npx eslint --max-warnings=0 src test` EXIT 0 (lượt đầu 1 lỗi `no-unexpected-multiline` trong spec mới, đã sửa); generators `--check` EXIT 0; `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` EXIT 0 (69 suite, 557 test). Chưa có pentest bên ngoài.
- Còn lại: route mới phải thêm vào danh sách quét; bất biến phần 1.1 khi có route; pentest.
- Trạng thái: Hoàn thành (còn các phần nêu ở “Còn lại”).

## BF-20261021-005 — Catalog nhiệm vụ đủ ≥ 90 ngày nội dung mỗi giai đoạn (bổ sung mẫu + test chứng minh) (Claude; Codex hết quota tới 15:25)

- Ngày làm: 2026-10-21T12:20:16+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp task tiếp theo đi"
- Liên quan: BF-20261019-003, BF-20261021-004.
- Role: ORCHESTRATOR, BACKEND, PRODUCT/CONTENT (viết mẫu), TESTER, QUALITY — Claude làm toàn bộ (Codex hết quota tới 15:25).
- Phân tích: mức mặc định MEDIUM = 3 việc/Bố-Mẹ/ngày + 1 việc “Cùng nhau”, cửa sổ không lặp 14 ngày ⇒ mỗi giai đoạn cần ≥ 84 mẫu cho Bố/Mẹ (≥ 42 mỗi người) và ≥ 14 “Cùng nhau”; catalog cũ chỉ có 16–48 mẫu Bố/Mẹ mỗi giai đoạn và 12 “Cùng nhau” khi có con. Viết thêm 158 mẫu song ngữ (4 đợt, chỉ thêm mới, không sửa mẫu đã publish). Phép quét đầy đủ (mọi tuần 1–42, mọi tuổi 0–2190 ngày) lộ khoảng thiếu mà lấy mẫu bỏ sót (tuần 21–23, bé 91–119 ngày); mô phỏng 90 ngày bằng bộ sinh thật lộ thêm hai ràng buộc: người mang thai/vừa sinh ≤ 42 ngày bắt buộc 1 việc SELF/ngày (cần mẫu SELF riêng cho họ) và mẫu thai kỳ phạm vi `CHILD` không dùng được khi chưa có bé — đây là lỗi bộ sinh có sẵn (gia đình chỉ đang mang thai có thể nhận `MISSION_BOARD_POOL_INSUFFICIENT`, và gia đình có con lớn bị gán nhầm việc thai kỳ cho con). Sửa `MissionBoardRepository.generate`: mẫu `PREGNANCY` lưu ở phạm vi gia đình, mẫu `CHILD` khác chỉ vào pool khi có bé phù hợp. Mẫu thai kỳ mới dùng phạm vi `FAMILY`. Xoá 18 bản nháp mẫu thai kỳ cũ chỉ nằm trong DB test (không còn nhiệm vụ tham chiếu). Sửa test chập chờn có sẵn của `notification-inbox-api` (regex `999` khớp nhầm UUID).
- Kết quả: catalog 268 mẫu; checklist tick dòng “Catalog nhiệm vụ (≥ 90 ngày)” → 139/165. Không đổi app. `docs/api.md` mục catalog.
- Bằng chứng: `mission-catalog-coverage` unit 3/3; `mission-catalog-90-days` 9/9 chạy 3 lần liên tiếp đều đạt (lượt đầu thất bại — chính là các lỗi nêu trên); `mission-board-api` 21/21, `care-progress-api` 11/11, `calendar-api` 10/10; `npm run check` EXIT 0 (unit 331, e2e 35, compiled); `npx eslint --max-warnings=0 src test` EXIT 0; generators `--check` EXIT 0; `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` 69/70 suite đạt, 1 lỗi là test chập chờn của `notification-inbox-api` — đã sửa và chạy lại riêng 19/19. Nội dung chưa được người dùng/chuyên gia nội dung duyệt.
- Còn lại: duyệt nội dung (văn phong, y khoa an toàn); mức HEAVY (4 việc/người) và trẻ trên 6 tuổi chưa được chứng minh; DB thật cần chạy `npm run db:seed` để có mẫu mới; mẫu thai kỳ cũ phạm vi `CHILD` nên đổi qua quy trình publish version khi có.
- Trạng thái: Hoàn thành (còn các phần nêu ở “Còn lại”).

## BF-20261021-006 — Web Admin CMS `baby-admin/` (đăng nhập, kiểm duyệt, khoá license, CSKH, catalog) (Claude; Codex hết quota tới 15:25)

- Ngày làm: 2026-10-21T16:02:38+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp task tiếp theo đi" (và "Try again" khi lượt trước bị ngắt).
- Liên quan: BF-20261021-002.
- Role: ORCHESTRATOR, FRONTEND (web admin), BACKEND (đối chiếu contract), TESTER, QUALITY — Claude làm toàn bộ (Codex hết quota tới 15:25).
- Phân tích: `baby-admin/` trống; theo tài liệu kỹ thuật §24 chọn React 18 + Vite 5 + TypeScript + Ant Design 5 (phiên bản pin cố định). Đọc contract thật của 4 controller admin (BF-20261021-002). Cấu trúc: `src/api/client.ts` (envelope `{data}`, lỗi `{error:{code}}`, Bearer admin, 401 → xoá phiên, phiên chỉ ở `sessionStorage`), `src/api/admin.ts` (hàm có kiểu cho từng route), trang `LoginPage` (email + mật khẩu + TOTP), `CasesPage` (lọc trạng thái, chi tiết báo cáo, xem nội dung bắt buộc lý do, đổi trạng thái, ẩn nội dung), `LicensePage` (mã lý do + ghi chú, xác nhận), `TicketsPage` (metadata, mở nội dung với `SUPPORT_REQUEST`, trả lời, đổi trạng thái), `CatalogPage` (5 loại, chỉ đọc). Menu ẩn theo vai trò, quyền thật vẫn ở backend. Dev proxy `/admin/v1` → backend (không mở CORS). Thêm `README.md`, `.github/workflows/admin-ci.yml` (cùng phiên bản action/Node với workflow sẵn có).
- Kết quả: checklist tick 2 dòng (Admin CMS web; xử lý báo cáo/khoá license có audit) → 141/165; dòng catalog/gói cập nhật Admin 🟡 (chỉ xem).
- Bằng chứng: `npm run check` trong `baby-admin` EXIT 0 (typecheck, vitest 6/6: client envelope/401/phiên hết hạn, phân quyền menu, đăng nhập gửi đủ TOTP, danh sách ca; `vite build` đạt, cảnh báo bundle > 500 kB). Chạy thật: backend build từ mã nguồn ở cổng 3100 nối DB `baby_family_test` (không đụng Docker stack đang chạy — container API hiện tại là bản cũ, route admin trả 404), tạo admin QA bằng `npm run admin:create` với khoá sinh tạm (chỉ lưu ở scratchpad, không vào repo), đăng nhập TOTP thành công, xem danh sách/chi tiết ca, đổi một ca sang IN_REVIEW (audit hiển thị), xem catalog nhiệm vụ, mở màn hỗ trợ. Chưa chạy GitHub Actions.
- Còn lại: tạo/publish phiên bản catalog, tra cứu người dùng/gia đình (ADM-03), audit log (ADM-17), cấu hình/flags; tách bundle (code-splitting); build lại container API để có route admin; đổi TOTP/mật khẩu admin.
- Trạng thái: Hoàn thành (còn các phần nêu ở “Còn lại”).

## BF-20261021-007 — Publish phiên bản catalog qua Admin (Codex) + app mua gói IAP và đăng nhập/liên kết Apple & Google (Claude)

- Ngày làm: 2026-10-21T16:11:43+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp task tiếp theo đi"
- Liên quan: BF-20261020-001, BF-20261021-006.
- Role: ORCHESTRATOR, BACKEND + FRONTEND admin (Codex: publish catalog), MOBILE (Claude: IAP, Apple/Google), TESTER, QUALITY. Giữa task người dùng nhắn hướng tiếp theo: sau task này tập trung luồng sử dụng chính; media (ảnh/video) do client nén/xử lý, server chỉ trả phiên upload presigned, client upload thẳng lên S3 — đã ghi nhận (bộ nhớ dự án) để làm ở task sau.
- Phân tích: Codex làm backend + `baby-admin` cho tạo nháp → publish → ngừng dùng (nhiệm vụ, phiên bản gói, chính sách dùng thử). Claude đăng ký DI, và sửa lưu ý vận hành của Codex: seed nhiệm vụ bỏ qua các trường vòng đời (`status`, `rolloutPct`) để mẫu seed đã bị admin ngừng dùng không làm `db:seed` lỗi. App: `IStorePurchaseRepository` (bọc `in_app_purchase` 3.3.1, StoreKit 2 mặc định — `serverVerificationData` là JWS) + `FamilyRemoteServiceImp.purchasePlan` (purchase-intent với mã gói server → mua với appAccountToken/obfuscatedAccountId → verify → hoàn tất giao dịch → đồng bộ gói); `ISocialCredentialRepository` (`sign_in_with_apple` 8.2.0 với nonce gốc/SHA-256, `google_sign_in` 7.2.0 với client id qua `--dart-define`) + `SessionRemoteServiceImp.signIn` dùng chung bước sau đăng nhập với OTP; kiểu `UserCancelled` để huỷ ở Store/Apple/Google không hiện lỗi.
- Kết quả: checklist tick “Quản lý gói/plan version/trial policy” → 142/165; Apple, Google, SUB-01/02, SUB-04 cập nhật App 🟡 (mã đã nối, chưa cấu hình/thử thật); catalog nhiệm vụ BE/Admin 🟡.
- Bằng chứng: app `make check` EXIT 0 (analyze sạch, 797 test; mới: family_remote +2 IAP (mua, huỷ), session_remote +2 Apple/Google (đăng nhập, huỷ)). Backend `npm run check` EXIT 0 (unit 331, e2e 35, compiled); generators `--check` EXIT 0; `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` EXIT 0 (71 suite, 580 test). `baby-admin` `npm run check` EXIT 0 (15 test, build). Chưa thử Store sandbox, chưa bật capability Sign in with Apple, chưa có client id Google thật.
- Còn lại: cấu hình sản phẩm Store + sandbox, capability/entitlement Apple, client id + URL scheme Google; liên kết/gỡ Apple/Google trong Cài đặt (cần màn xác thực lại); version cho cột mốc/mẫu thông báo; luồng media phía client (task tiếp theo theo yêu cầu).
- Trạng thái: Hoàn thành (còn các phần nêu ở “Còn lại”).

## BF-20261021-008 — Luồng media mới: client nén/tạo biến thể ảnh–video, server chỉ cấp phiên upload presigned, client upload thẳng S3 (Codex backend + Claude app)

- Ngày làm: 2026-10-21T16:48:34+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm luồng media theo hướng mới: client nén/xử lý ảnh, video; server chỉ cấp phiên upload presigned, client upload thẳng lên S3."
- Liên quan: BF-20261021-007 (hướng người dùng chốt giữa task đó).
- Câu hỏi bổ sung giữa task:
  1. "ưu tiên hiển thị video ảnh của user tồn tại ở gallary … nếu 2 file đó trùng nhau thì ưu tiên hiển thị ảnh ở local trước … cơ chế check trùng như thế nào (tôi nghĩ dùng hash file name không biết có ổn không)".
  2. "ghi lại … thiết kế hệ thống data ở dưới local và đồng bộ với server … app ưu tiên user sử dụng được khi không có mạng".
- Role:
  - ORCHESTRATOR.
  - BACKEND (Codex: phiên upload presigned + HEAD verify; Claude: trường `source`).
  - MOBILE (Claude: nén/biến thể, local-first).
  - ARCHITECT (thiết kế offline-first).
  - TESTER, QUALITY.
- Phân tích — backend (Codex, handoff `BF-20261021-008-A.md`):
  - Client khai báo `variants` (IMAGE `m1080`/`t320`, VIDEO `poster`/`t320`, AUDIO không có). Server presign file chính + từng biến thể; `complete` HEAD kiểm size/MIME → READY ngay.
  - `MEDIA_SERVER_PROCESSING=disabled` mặc định; avatar tài khoản dùng bảng `user_asset_variants`.
  - Claude thêm `source {sha256, key, capturedAt}` của file gốc: migration DDL `20261021120000_asset_client_source` (`source_sha256`, `source_key`), DTO intent, hash idempotency, projection media/ký ức.
- Phân tích — app:
  - `processImage`/`processVideo` (`flutter_image_compress`, `video_compress`, `exif`); `MediaUploader` upload file chính + biến thể thẳng S3. Avatar đi cùng đường qua `uploadAvatar`.
  - Picker ký ức không resize nữa, để giữ bytes gốc.
- Cơ chế check trùng (trả lời người dùng): **không dùng hash tên file**, vì tên file không ổn định (iOS `IMG_xxxx` lặp lại, picker đổi tên, Android đặt lại tên). Dùng SHA-256 **nội dung file gốc** làm định danh thật, có lọc trước để không phải băm cả thư viện:
  1. Chỉ mục đã lưu (assetId → id thư viện, mã hoá, xoá khi đăng xuất).
  2. Ứng viên cùng khoá metadata (`kind|cạnh ngắn x cạnh dài|giây`) + thời điểm chụp ±2 s.
  3. Băm SHA-256 tối đa 10 ứng viên, có cache.
  4. Picker đổi định dạng (HEIC → JPEG) nên SHA khác: chỉ nhận khi đúng một ứng viên cùng khoá + thời điểm chụp.
  5. Không khớp: thử lại sau 1 ngày.

  Ảnh đã xoá khỏi thư viện thì quay lại ảnh server. Quyền thư viện được xin khi người dùng chọn ảnh để đăng.
- Offline-first: viết `docs/04_THIET_KE_OFFLINE_FIRST.md` gồm:
  - Hiện trạng: MockStore RAM, offline snapshot, hàng đợi MEM-06.
  - Đích: local DB bền vững + outbox (client id, Idempotency-Key) + SyncEngine push/pull.
  - Quy tắc xung đột, phân loại offline/online-only, việc backend cần bổ sung, lộ trình, cách kiểm chứng.

  Đây mới là **thiết kế, chưa triển khai**.
- Kết quả:
  - Checklist: cập nhật ghi chú Upload video, MEM-08 và dòng "Đang làm"; tổng giữ 142/165, không có dòng mới đủ điều kiện tick.
  - Tài liệu: thêm `docs/media-client-processing.md` (mục `source`), api.md, `baby-family-app/SESSION.md`.
- Bằng chứng:
  - App `make check` EXIT 0 (analyze sạch, 806 test). Test mới: `local_media_test` 6; memory_library_remote +1 (ảnh trong máy thay URL server); subject_memory_remote MEM-04/MEM-08 client nén + biến thể; settings_remote avatar có biến thể.
  - Backend `npm run check` EXIT 0 (unit 331, e2e 35, compiled; sau khi sinh lại `generate:services`); `npx eslint --max-warnings=0 src test` EXIT 0; `generate:persistence -- --check` EXIT 0.
  - Backend `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` EXIT 0 (71 suite, 596 test; gồm media-api +1 cho `source`).
  - Migration chỉ áp dụng lên `baby_family_test`.
  - Chưa thử trên máy thật: nén video, `photo_manager`, quyền thư viện iOS/Android.
- Còn lại:
  - Thử trên máy thật: nén video, thời gian băm file lớn, quyền thư viện giới hạn của iOS.
  - Deploy 2 migration mới trước API.
  - Video local: hiện vẫn dùng poster của server cho thẻ, chỉ thay file phát.
  - Triển khai offline-first theo lộ trình trong tài liệu.
  - Commit các vòng BF-20261020-001 … BF-20261021-008 khi người dùng yêu cầu.
- Trạng thái: Hoàn thành (còn các phần nêu ở "Còn lại").

## BF-20261021-009 — Commit các thay đổi BF-20261020-001 → BF-20261021-008 thẳng vào main

- Ngày làm: 2026-10-21T17:19:36+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Commit tất cả thay đổi BF-20261020-001 đến BF-20261021-008 thẳng vào main."
- Role: ORCHESTRATOR, QUALITY (rà working tree trước commit).
- Phân tích: working tree chỉ gồm thay đổi của các vòng BF-20261020-001 … BF-20261021-008 (backend, app, `baby-admin/`, CI workflow, tài liệu, nhật ký). Không có secret, `.env`, node_modules/dist hay log. Các phiên liên kết khác đang idle, không có ghi chú bàn giao mới. Bỏ `.DS_Store` (file hệ thống macOS).
- Kết quả: một commit trên `main`, không push (người dùng không yêu cầu push).
- Bằng chứng: các check ở BF-20261021-008 (app `make check` 806 pass; backend `npm run check`, eslint, generators, integration 71 suite/596 test đều EXIT 0); `git status` sau commit chỉ còn `.DS_Store`.
- Còn lại: push khi người dùng yêu cầu.
- Trạng thái: Hoàn thành.

## BF-20261022-001 — Offline-first giai đoạn 1: outbox bền vững cho tạo ký ức + đồng bộ khi có mạng (Claude app) · idempotency + changes API (Codex backend)

- Ngày làm: 2026-10-22T06:41:25+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp cho tôi những phần tiếp theo đi".
- Liên quan: `docs/04_THIET_KE_OFFLINE_FIRST.md` (BF-20261021-008), lộ trình bước 1–2.
- Role:
  - ORCHESTRATOR: chọn phần tiếp theo. MVP còn lại chủ yếu cần cấu hình Store/Apple/Google/staging hoặc thiết bị thật, nên làm theo hướng người dùng đã chốt: luồng chính và offline-first.
  - MOBILE (Claude): outbox.
  - BACKEND (Codex): idempotency + changes API; Claude tích hợp.
  - TESTER, QUALITY.
- Phân tích — app:
  - `OutboxEntry` + `IMemoryOutboxRepository`: mã hoá trong hộp đăng nhập; sao file media vào `pending_uploads/outbox`.
  - `MemoryRemoteServiceImp` thay hàng đợi MEM-06 trong RAM bằng outbox. Mọi ký ức tạo từ màn soạn đều hiện ngay và gửi nền. Idempotency-Key là UUID v5 theo id thao tác, nên giữ nguyên qua lần tắt app.
  - Lỗi mạng/5xx/408/429 → "Chờ có mạng" + backoff 30 giây → 15 phút; có mạng lại thì `syncPending` qua `isOfflineProvider` ở `RootApp`. 4xx → chờ người dùng Thử lại / Huỷ.
  - Băng ngoại tuyến đếm số ký ức chờ; thêm l10n 4 ngôn ngữ.
- Phân tích — backend (handoff `BF-20261022-001-A.md`):
  - Idempotency-Key tuỳ chọn, có snapshot response mã hoá: bình luận, cảm xúc, góc nhìn, yêu thích, ghi chú, nhật ký riêng, check-in, cảm ơn.
  - `GET /families/:id/changes`: log `offline_memory_changes` (migration DDL `20261022090000`), cursor ổn định, tombstone khi xoá hoặc mất quyền, cursor quá 90 ngày → 409.
  - Claude đăng ký DI. Claude cũng khôi phục key **bắt buộc** cho nhiệm vụ và lời nhờ: Codex đã đổi sang tuỳ chọn, làm hỏng 2 test cũ và có thể khiến cộng Hearts trùng.
- Kết quả: checklist thêm dòng "Offline-first" (BE 🟡, App 🟡) → 142/166. Cập nhật `docs/04_THIET_KE_OFFLINE_FIRST.md` (mục cập nhật giai đoạn 1), api.md, `docs/offline-sync.md`, `baby-family-app/SESSION.md`.
- Bằng chứng — app: `make check` EXIT 0 (analyze sạch, 808 test). Test mới: tạo offline → tắt app → mở lại gửi đúng một lần với cùng key; 4xx chờ người dùng / thử lại / huỷ xoá file; MEM-06 mất mạng → chờ → gửi.
- Bằng chứng — backend:
  - `npm run check` EXIT 0 (unit 331, e2e 35); `npx eslint --max-warnings=0 src test` EXIT 0.
  - `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` EXIT 0 (73 suite, 609 test) ở lần chạy cuối.
  - Lần chạy đầu sau khi tích hợp có 3 suite lỗi: mission-board và couple-request (do key tuỳ chọn, đã sửa); transactional-mail lỗi SMTP tạm thời, chạy lại riêng đạt 8/8 và đạt trong lần chạy toàn bộ cuối.
  - Migration chỉ áp lên `baby_family_test`.
- Còn lại:
  - App chưa dùng changes API.
  - Outbox cho bình luận/cảm xúc/sửa ký ức/chăm sóc/nhiệm vụ.
  - Local DB thay `MockStore`.
  - Claim idempotency treo `PENDING` sau crash chưa có reconciliation.
  - Ledger chưa có retention.
  - Changes API cần benchmark với gia đình lớn.
  - Test `MemoryOutboxRepositoryImp` với file thật.
  - Thử trên máy thật (bật chế độ máy bay).
- Trạng thái: Hoàn thành (còn các phần nêu ở "Còn lại").

## BF-20261022-002 — Offline-first giai đoạn 2: app dùng changes API, outbox cho bình luận, cảm xúc, chăm sóc (Claude app)

- Ngày làm: 2026-10-22T07:08:35+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp giai đoạn 2 offline-first: app dùng changes API và outbox cho bình luận, cảm xúc, chăm sóc."
- Liên quan: BF-20261022-001, `docs/04_THIET_KE_OFFLINE_FIRST.md`, `baby-backend/docs/offline-sync.md`.
- Role: ORCHESTRATOR, MOBILE (Claude, chủ trì), ARCHITECT (tách hàng đợi chung), TESTER, QUALITY. Backend không đổi: dùng route của BF-20261022-001.
- Phân tích:
  - Tách cơ chế outbox của ký ức thành `OutboxRunner` dùng chung (lưu bền, phân loại lỗi, backoff, `syncAll`, key UUID v5), để ký ức và chăm sóc cùng một hành vi.
  - Bình luận và cảm xúc ghi trên máy trước, gửi với Idempotency-Key. Cảm xúc chỉ gửi lần chọn cuối.
  - Hoàn thành nhiệm vụ: có mạng chờ Hearts từ server; mất mạng xong trên máy. Bảng nhiệm vụ lưu bản đọc gần nhất để mở khi offline.
  - Changes API chạy sau mỗi lần đồng bộ feed: gỡ ký ức đã xoá hoặc mất quyền, đọc lại ký ức đổi version / có bình luận / cảm xúc mới (tối đa 30), cập nhật bình luận đã lưu; cursor hết hạn → tải lại.
- Kết quả: cập nhật dòng checklist Offline-first (vẫn 🟡, tổng 142/166); cập nhật `docs/04_THIET_KE_OFFLINE_FIRST.md` và `baby-family-app/SESSION.md`.
- Bằng chứng: app `make check` EXIT 0 (analyze sạch, 811 test). Test mới:
  - Bình luận/cảm xúc offline, gửi một lần khi có mạng.
  - Changes: xoá, version, bình luận, cursor hết hạn.
  - Bảng nhiệm vụ offline sau khi mở lại app; hoàn thành gửi một lần cùng key; hoàn tác khi còn chờ.

  Backend không sửa nên không chạy lại; lần chạy đầy đủ gần nhất ở BF-20261022-001. Chưa thử end-to-end app ↔ backend thật hay trên máy thật.
- Còn lại:
  - Bộ nhớ bình luận chỉ trong RAM.
  - Outbox cho sửa/xoá bình luận, sửa ký ức, tạo/hoàn tác/đổi nhiệm vụ, Papa & Mama.
  - Changes API cho nhiệm vụ.
  - Local DB thay `MockStore`.
  - Thử chế độ máy bay trên máy thật; chạy app với backend thật.
- Trạng thái: Hoàn thành (còn các phần nêu ở "Còn lại").

## BF-20261022-003 — Offline-first: local DB bền vững (Hive, mã hoá theo dòng) cho ký ức và bình luận (Claude app)

- Ngày làm: 2026-10-22T07:27:08+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp offline-first: local DB bền vững thay MockStore cho ký ức và bình luận."
- Liên quan: BF-20261022-001/002, `docs/04_THIET_KE_OFFLINE_FIRST.md` (lộ trình bước 1, 5).
- Câu bổ sung giữa task: "Làm chú ý phần nếu data trên server cập nhật field mới hoặc chỉnh sửa phải đảm bảo dưới local không bị crash đấy" — đã làm trong cùng task (xem phân tích) và ghi vào bộ nhớ dự án.
- Role: ORCHESTRATOR, MOBILE (chủ trì), ARCHITECT (chọn kiểu DB), TESTER, QUALITY. Backend không đổi.
- Phân tích:
  - Chọn Hive box riêng, mã hoá theo dòng, làm local DB bền vững thay vì SQLite/drift. Lý do: repository của app đọc `MockStore` đồng bộ; chuyển sang SQLite bất đồng bộ phải viết lại toàn bộ tầng repository. `MockStore` giữ vai bộ nhớ làm việc; DB là nguồn bền vững, nạp lúc mở app và ghi diff có debounce.
  - Dọn race có sẵn bị lộ ra: ký ức tạo ngay trước lần đồng bộ bị gỡ nhầm.
  - Chống crash khi dữ liệu đổi:
    - Field lạ bị bỏ qua; enum server ở dạng `String`.
    - `lenientList` cho feed, changes, outbox, bình luận lưu trên máy.
    - Kiểm từng dòng trước khi nạp; schema version để xoá DB cũ khi đổi cấu trúc.
    - Lỗi parse trong đồng bộ chỉ ghi log; DB hỏng thì app vẫn chạy bằng dữ liệu server.
- Kết quả: cập nhật dòng checklist Offline-first (vẫn 🟡, 142/166). `docs/04_THIET_KE_OFFLINE_FIRST.md` thêm mục BF-20261022-003 và "Quy tắc tương thích dữ liệu". Cập nhật `baby-family-app/SESSION.md`.
- Bằng chứng: app `make check` EXIT 0 (analyze sạch, 814 test). Test mới:
  - Ký ức/bình luận còn sau khi tắt app và mở khi offline; chỉ ghi dòng đổi; xoá dòng mất.
  - Dòng hỏng / field lạ / schema cũ không crash.
  - Feed/changes có phần tử đổi kiểu vẫn đọc được phần còn lại.

  Không chạy backend (không sửa). Chưa test `LocalMemoryDbImp` với Hive thật, chưa thử trên máy thật.
- Còn lại:
  - Test Hive thật (cần khởi tạo Hive trong test).
  - Local DB cho nhiệm vụ / Papa & Mama.
  - Outbox cho sửa ký ức.
  - Bỏ bảng `memories` khỏi offline snapshot sau khi thử máy thật.
  - Thử chế độ máy bay với backend thật.
- Trạng thái: Hoàn thành (còn các phần nêu ở "Còn lại").

## BF-20261022-004 — Offline-first: local DB cho nhiệm vụ và Papa & Mama (đọc offline + check-in/lời nhờ/cảm ơn/nhật ký qua outbox) (Claude app)

- Ngày làm: 2026-10-22T07:39:09+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Chưa commit, làm tiếp local DB cho nhiệm vụ và Papa & Mama."
- Liên quan: BF-20261022-001…003, `docs/04_THIET_KE_OFFLINE_FIRST.md`.
- Role: ORCHESTRATOR, MOBILE (chủ trì), ARCHITECT (local DB bảng chung + `submit`), TESTER, QUALITY. Backend không đổi: dùng Idempotency-Key tuỳ chọn của BF-20261022-001.
- Phân tích:
  - Tổng quát hoá local DB thành bảng dùng chung (`ILocalDb`, `LocalTables`), áp nguyên các quy tắc chống crash của BF-20261022-003 (schema version, kiểm từng dòng, bỏ dòng hỏng).
  - Thêm `OutboxRunner.submit`: khi có mạng, trải nghiệm giữ như trước (bản server, lỗi server); khi mất mạng thì xếp hàng.
  - Nhiệm vụ: chuyển cache bảng sang local DB, chi tiết offline, hoàn thành qua `submit`.
  - Papa & Mama: lưu bền 4 bảng phản chiếu; 4 thao tác tạo qua outbox, bản tạm do bản trên máy tạo (giữ BR-067).
  - Sửa lỗi có sẵn: đồng bộ song song bị mất mạng ném `ParallelWaitError`, không được bắt.
- Kết quả: cập nhật dòng checklist Offline-first (vẫn 🟡, 142/166); cập nhật `docs/04_THIET_KE_OFFLINE_FIRST.md` và `baby-family-app/SESSION.md`.
- Bằng chứng: app `make check` EXIT 0 (analyze sạch, 816 test). Test mới:
  - Bảng nhiệm vụ và chi tiết khi offline từ local DB.
  - Papa & Mama mở offline sau khi tắt app; dòng hỏng bị bỏ.
  - Tạo check-in / cảm ơn / nhật ký offline rồi gửi đúng một lần với 3 key khác nhau.
  - Check-in bị từ chối báo lỗi và không để lại bản tạm.
  - Lời nhờ mất mạng gửi lại cùng key.

  Backend không sửa nên không chạy lại. Chưa thử end-to-end với backend thật hay trên máy thật.
- Còn lại:
  - Thao tác lời nhờ, duyệt/thả tim cảm ơn, chia sẻ nhật ký khi offline.
  - Tạo/đổi/hoàn tác nhiệm vụ khi offline.
  - Sửa ký ức khi offline.
  - Thử chế độ máy bay trên máy thật với backend thật.
- Trạng thái: Hoàn thành (còn các phần nêu ở "Còn lại").

## BF-20261022-005 — Chạy app với backend thật, thử luồng offline-first (mất mạng → có mạng lại) (Claude)

- Ngày làm: 2026-10-22T22:43:45+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Chạy app với backend thật và thử luồng offline-first (mất mạng rồi có mạng lại)."
- Liên quan: BF-20261022-001…004.
- Role: ORCHESTRATOR, TESTER (chủ trì: chạy thật), MOBILE (sửa lỗi), QUALITY.
- Phân tích / quá trình:
  - Backend build từ mã nguồn ở cổng 3100, DB test (không đụng Docker stack của người dùng).
  - iOS không build được: Flutter 3.44.5 không tương thích Xcode 27.1 ở bước `lipo -verify_arch`. Đây là lỗi môi trường, không phải lỗi app; chuyển sang emulator Android `Pixel_8`, tắt/bật mạng thật bằng `adb svc`.
  - Đăng ký Mama bằng số thử (OTP qua Mailpit cục bộ), Papa tham gia qua API, duyệt, tạo bé.
  - Thử: offline → hoàn thành nhiệm vụ, viết nhật ký, check-in → mở lạnh offline → bật mạng.
- Lỗi tìm ra và đã sửa:
  1. Snapshot offline cũ khiến mở lạnh offline quay về màn chờ Papa.
  2. Nhật ký / Thư / Câu nói không qua outbox.
  3. Hoàn thành offline không làm màn vẽ lại; sheet hiện "+0 💗".
  4. Tám lệnh đọc ném lỗi khi mất mạng làm hỏng cả Home / Ký ức.
  5. Thêm log lỗi tải.

  Một lần thao tác "biến mất" là do tôi chạm nhầm nút Undo khi thử, không phải lỗi app.
- Kết quả:
  - Bật mạng lại → trong cùng giây gửi đủ: refresh 200, complete 201, check-in 201, memory 201, changes 200.
  - DB test: đúng 1 nhật ký, 2 lần hoàn thành, 1 check-in, không trùng.
  - Hearts 5 → 9.
  - Mở lạnh offline: Home, Ký ức (nhật ký "Chờ có mạng"), Chăm sóc (2/7), Papa & Mama (check-in) đều hiển thị.
- Bằng chứng:
  - Ảnh chụp và log trong scratchpad của phiên; log backend `be-3100.log`.
  - Truy vấn DB test chỉ đọc.
  - App `make check` EXIT 0 (analyze sạch, 817 test). Test mới: snapshot sau duyệt / `completeSetup` / `persistOffline`; care `pendingSync` + cây offline; memory_library đọc offline.
  - Không sửa backend.
- Còn lại:
  - Nâng Flutter để build iOS với Xcode 27.1, rồi thử iOS.
  - Rà offline các màn còn lại (thông báo, cài đặt, chi tiết album, chi tiết ký ức…).
  - Ghi nhận ngoài phạm vi: "Papa Minh" (tên mẫu) ở màn chọn giai đoạn; "Your family this week" hiện dữ liệu mẫu; thẻ nhật ký tạm dùng icon ảnh.
  - Backend 3100 và emulator vẫn đang chạy nền trong phiên.
- Trạng thái: Hoàn thành (còn các phần nêu ở "Còn lại").

<a id="bf-20261022-006"></a>
## BF-20261022-006 — App chế độ server còn lộ dữ liệu mẫu: tên "Papa Minh" ở màn chọn giai đoạn, thẻ "Your family this week" (Claude app)

- Ngày làm: 2026-10-22T23:30:37+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: (giao từ phiên BF-20261022-005) Ở chế độ server, sửa hai chỗ hiện dữ liệu mẫu từ `MockStore`/fixtures thay dữ liệu server (tên Papa mẫu ở màn chọn giai đoạn; thẻ "Your family this week" có ảnh stock và "1 new quotes" cho gia đình mới), rà các màn chính khác, thêm test, `make check` đạt.
- Liên quan: BF-20261022-005.
- Role: Chủ trì MOBILE; review TESTER, QUALITY (agent chính tự áp dụng, không sub-agent).
- Trạng thái: Hoàn thành (ngày giờ hoàn thành 2026-10-22T23:38:52+07:00).
- Phân tích:
  - Lỗi 1: khi gia đình kích hoạt, `SessionRemoteServiceImp._mirrorActivated` gọi `simulatePartnerJoined` của bản mock, tạo bạn đời với tên `defaultPartnerName` của fixture `session.json` ("Minh"); tên server trong `bootstrap.parents` không được ghi. Ảnh hưởng cả máy Papa (Mama mang tên "Minh").
  - Lỗi 2: `ChildServiceImp.weekSummary` cộng nền mẫu `children.json → stats.week` (24/2/1 + 4 ảnh stock); bản remote chỉ thay số khoảnh khắc/lần đầu từ server nên câu nói và ảnh vẫn là mẫu.
  - Rà các nguồn `store.meta` khác qua service remote. Lộ dữ liệu mẫu ở gia đình thật:
    - CAL-02 tạo sự kiện (FAB) điền sẵn "Sinh nhật Bà nội".
    - MEM-15 "tìm gần đây" có 3 mục mẫu.
    - CARE-09 thống kê, US tổng kết tuần, gợi ý viết lại Cầu nối hiện số/nội dung mẫu.
  - Đã đúng từ trước: US-01 câu hỏi (BF-20261021-003); `monthRecap`/`dayStory`/`chapters`/`stats(child)` lọc theo id bé (id server không khớp fixture).
- Kết quả:
  - `SessionServiceImp.applyServerPartner`; `_mirrorActivated` ghi `displayName`/`callName` của bạn đời từ bootstrap mỗi lần đồng bộ (sửa cả bản đã lưu tên mẫu).
  - `ChildServiceImp.weekBaseline` (`@protected`); `ChildRemoteServiceImp` trả `null`. Không có nền: ảnh nhỏ lấy từ `mediaAssets` của ký ức trong tuần (mới nhất trước, bỏ thư còn niêm phong). `HomeTabController` ẩn thẻ "Tuần này" khi không có số liệu/ảnh (HOME-01: khối không có dữ liệu thì ẩn).
  - `CareRemoteServiceImp.eventDraft` trả form trống (ngày hôm nay); `careStats` → `null`. `UsRemoteServiceImp.coupleWeek`/`rewriteSuggestion` → `null` (màn đã có EmptyState).
  - `IMemoryRepository.searchRecents/saveSearchRecents({server})` (khoá meta `serverSearchRecents`); `MemoryRemoteServiceImp.searchRecents` override.
  - Bản mock giữ nguyên hành vi.
- Kiểm chứng:
  - Test mới/sửa:
    - session_remote: tên/nhãn Papa từ bootstrap.
    - subject_memory_remote: tuần của gia đình mới không có câu nói/ảnh mẫu, ảnh từ ký ức đồng bộ; tìm gần đây rỗng.
    - care_remote: CAL-02 trống, CARE-09 null.
    - couple_remote: tuần/gợi ý null.
    - home_test: thẻ tuần ẩn khi rỗng.
  - `fvm flutter test` 6 file liên quan: 151 pass. `make check` EXIT 0 (analyze sạch, 821 test).
  - Chưa chạy lại trên emulator với backend thật.
- Còn lại:
  - Kiểm tra lại trên app thật: ONB-04 hiện "QA Papa", Home gia đình mới không có thẻ tuần.
  - `CareRemoteServiceImp.tree()` khi mất mạng mà chưa có bản lưu vẫn rơi về `super.tree()` (số tuần lấy từ `treeStats` mẫu): ca hiếm, chưa sửa.
  - Thẻ nhật ký tạm dùng icon ảnh (ghi nhận ở BF-20261022-005) không thuộc task này.
  - Không commit.
- Product history: [BF-20261022-006](PRODUCT_ANALYTICS_HISTORY.md#bf-20261022-006).

<a id="bf-20261023-001"></a>
## BF-20261023-001 — Làm tiếp BF-20261022-006: xác minh trên app thật + sửa cây gia đình offline còn số liệu mẫu (Claude app)

- Ngày làm: 2026-10-23T06:43:23+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp đi" — tiếp phần còn lại của BF-20261022-006.
- Liên quan: BF-20261022-006.
- Role: Chủ trì MOBILE (Claude); hỗ trợ Codex CLI (`codex exec`, rà và sửa `lib/data/service_imp/**` + `test/data/**` theo brief, không ghi nhật ký); TESTER chạy thật và QUALITY review diff của Codex do Claude làm.
- Giữa chừng người dùng nhắn "Kêu codex làm thêm nữa" (cùng mã, là chỉ đạo cách làm, không phải yêu cầu mới).
- Trạng thái: Hoàn thành (2026-10-23T06:56:15+07:00; xem "Còn lại").
- Phân tích:
  - Claude: `CareRemoteServiceImp.tree()` mất mạng và chưa có bản lưu vẫn lấy số tuần mẫu → sửa về 0.
  - Codex rà mọi phương thức của các remote service so với bản mock (~250 phương thức), tìm chỗ gia đình thật có thể thấy dữ liệu mẫu (meta fixture, id fixture qua liên kết cũ, nhánh lỗi/offline `super.*`).
  - Codex không chạy được Flutter trong sandbox (SDK cần ghi cache ngoài workspace). Claude chạy format/analyze/test và review.
- Kết quả:
  - Codex sửa 10 service: session, child, memory, memory_library, care, us, family, settings, circle, pregnancy. Các thay đổi chính:
    - Ký ức/nhiệm vụ/thành viên/thai kỳ theo id ngoài gia đình hiện tại → null/rỗng.
    - `dayStory`/`monthRecap`/`weeklyRecap` bản nền → null.
    - Bộ sưu tập đếm theo ký ức thật; nháp chỉ giữ nháp người dùng lưu.
    - Tìm kiếm ngắn không quét fixture; báo cáo không trả mã biên nhận giả.
    - CARE-03 nháp trống; hoàn thành nhiệm vụ id lạ → lỗi.
    - Cài đặt (hồ sơ, thông báo, quyền riêng tư, AI, bảo mật, xuất dữ liệu, trợ giúp, xoá tài khoản) không dùng số/nhãn mẫu.
    - `birthDraft` bỏ số đo/ảnh mẫu.
  - Codex thêm 39 test, trong đó có file mới `test/data/circle_remote_test.dart`.
  - QUALITY tìm ra 1 lỗi do Codex: `planOffers` trả `priceText: ''` → ONB-ACT sẽ hiện "House () or Family ()" và mất giá ở các màn gói. Claude khôi phục giá từ catalog giá của app (quota vẫn theo server; API lỗi/rỗng → `[]`) và trả lại kỳ vọng test cũ `priceText isNotEmpty` mà Codex đã đổi.
- Kiểm chứng:
  - Chạy thật trên Android emulator với backend 3100 (DB test).
    - Gia đình cũ: thẻ "Your family this week" = 1 khoảnh khắc / 0 / 0, không ảnh stock.
    - Gia đình mới (Mama đăng ký trong app, OTP qua Mailpit; Papa "QA Papa Sao" nhận lời mời qua API; Mama duyệt):
      - ONB-04 hiện "Mama Mama and Papa QA" (tên server, không còn "Minh"; "Mama Mama" do tên thử đặt bắt đầu bằng "Mama").
      - Home sau tạo bé không có thẻ tuần.
    - Lần chạy này dùng code trước khi có thay đổi của Codex.
  - `fvm flutter analyze` sạch. `make check` EXIT 0 (861 test).
  - Review của Claude: đọc kỹ care/memory/family/settings(security); các phần còn lại review theo bảng audit + test, chưa soi từng dòng.
- Còn lại:
  - Chưa chạy lại app thật sau thay đổi của Codex.
  - Giá gói vẫn từ catalog giá của app cho tới khi có giá Store/server.
  - Không commit.
- Product history: [BF-20261023-001](PRODUCT_ANALYTICS_HISTORY.md#bf-20261023-001).

<a id="bf-20261026-001"></a>
## BF-20261026-001 — Chạy lại app thật, thử các màn Codex sửa ở BF-20261023-001 (Cài đặt, Bộ sưu tập, Tạo nhiệm vụ, Chào đời)

- Ngày làm: 2026-10-26T08:35:45+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Chạy lại app trên emulator với backend thật và thử các màn Codex vừa sửa (Cài đặt, Bộ sưu tập, Tạo nhiệm vụ, Chào đời)." (kèm "Try again").
- Liên quan: BF-20261023-001.
- Role: Chủ trì TESTER (chạy thật); MOBILE (sửa lỗi tìm được); QUALITY (agent chính tự áp dụng, không sub-agent).
- Trạng thái: Hoàn thành (2026-10-26T08:49:15+07:00); còn 1 câu hỏi cho người dùng về lối vào Cài đặt.
- Phân tích / quá trình:
  - Android emulator, backend 3100 (DB test), gia đình thử "The Mama family" từ BF-20261023-001. Thao tác bằng `adb` + `uiautomator`.
  - Cài đặt:
    - Cài đặt gia đình (FAM-07): múi giờ "Asia/Ho_Chi_Minh" từ server, không nhãn mẫu.
    - **Cài đặt cá nhân SET-01 không mở được từ app Bố/Mẹ.** Chỉ màn chờ bạn đời có nút `SettingsRoute`; FAM-01 và Home không có. Đặc tả 8.1 đặt SET-01 dưới "Gia đình & Cài đặt" (avatar góc trái). Thiếu sót có từ commit đầu, không do BF-20261023-001.
    - Chưa thử được SET-02…13 trên máy; các thay đổi của Codex ở đó chỉ được kiểm qua unit test.
  - Bộ sưu tập: mọi số 0, không ảnh bìa mẫu. Lỗi hiển thị "Little words · 0 quotes": tên bé rỗng khi chưa có câu nói gắn với bé. Thêm vào đó, thẻ "Con lớn từng tháng" hiện " · 0/0 ảnh" khi chưa có bé đã sinh (thấy qua widget test).
  - Tạo nhiệm vụ (CARE-03): form trống, không điền mẫu; lưu "QA test task" → lên bảng (Mine 0/4).
  - Chào đời: tạo thai kỳ "Bi" (dự sinh 09/11/2026). Màn hành trình thai kỳ báo "Could not load memories": `ChildRemoteServiceImp.stats` gọi `/v1/children/{id}/profile-stats` với id thai kỳ → 404 (có từ trước, bản HEAD cũng gọi). Sau khi sửa, màn tải được. Màn chào đời (PREG-06) chỉ điền tên thật "Bi"; ngày/giờ, cân nặng, chiều dài, ảnh trống. Không bấm hoàn tất.
  - "Synthetic swap option"/"Synthetic default item" là dữ liệu thử của server trong DB test, không phải fixture app.
- Kết quả (sửa):
  - `ChildRemoteServiceImp.stats`: thai kỳ không gọi `profile-stats`, trả số trên máy.
  - `collections_view.dart`: chưa có tên bé → key mới `memCollQuotesCount` / `memCollMonthlyCount` (vi, en, zh, ja).
- Kiểm chứng:
  - Test mới: subject_memory_remote "pregnancy stats never call the child profile-stats"; memories_test "MEM-22 quotes card without a child has no dangling dot".
  - `make check` EXIT 0 (analyze sạch, 863 test).
  - Trên máy sau build lại: "Little words | 0 quotes"; hành trình thai kỳ tải được.
- Còn lại:
  - Quyết định lối vào SET-01 cho Bố/Mẹ (đã hỏi người dùng).
  - Thử SET-02…13 trên máy sau khi có lối vào.
  - Không commit.
- Product history: [BF-20261026-001](PRODUCT_ANALYTICS_HISTORY.md#bf-20261026-001).

<a id="bf-20261026-002"></a>
## BF-20261026-002 — Thêm lối vào Cài đặt (SET-01) ở cuối FAM-01 và thử SET-02…13 trên emulator

- Ngày làm: 2026-10-26T08:58:52+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Thêm một dòng "Cài đặt" ở cuối màn Gia đình (FAM-01) mở SET-01, rồi thử SET-02…13 trên emulator."
- Liên quan: BF-20261026-001.
- Role: Chủ trì MOBILE; TESTER (chạy thật); QUALITY (agent chính tự áp dụng, không sub-agent).
- Trạng thái: Hoàn thành (2026-10-26T09:08:49+07:00).
- Phân tích:
  - Đặc tả 8.1 đặt SET-01 trong "Gia đình & Cài đặt". Dùng lại `AppGroupedList` + `AppSettingsRow` và key `settingsTitle` có sẵn; không thêm widget/chuỗi mới cho dòng này.
  - Thử trên emulator (backend 3100, gia đình "The Mama family") lần lượt SET-01…13: Hồ sơ, Thông báo, Quyền riêng tư, AI, Hiển thị & Ngôn ngữ, Bảo mật & Thiết bị, Dữ liệu của tôi, Gói & thanh toán, Trợ giúp, Giới thiệu, Xoá tài khoản (chỉ xem bước 1, không xoá).
    - Không còn dữ liệu mẫu: tên "Mama Sao", số ***4661, tên Papa "QA Papa Sao" ở bước xoá tài khoản, giá gói từ catalog app, FAQ từ server.
    - Màn Hiển thị có câu xem trước "Na just reached… sitting up alone" — mẫu minh hoạ cỡ chữ với tên bé thật, giữ nguyên.
  - Lỗi tìm ra:
    1. SET-07 thiết bị hiện "Android |  · In use": server không có vị trí đăng nhập.
    2. SET-04 "Signed-in devices 0" trong khi SET-07 liệt kê 1 thiết bị: BF-20261023-001 (Codex) đặt `deviceCount: 0` thay số mẫu, nhưng server có `sessions()`.
    3. SET-05 hiện "0 / 0 uses": bản server chưa có API quota AI.
- Kết quả:
  - `family_mobile_view.dart`: nhóm "Cài đặt" cuối FAM-01 → `SettingsRoute`.
  - `device_row.dart`: không có vị trí → "Đang dùng" / chỉ thời gian; key mới `setDeviceInUseNoLocation` (vi, en, zh, ja).
  - `SettingsRemoteServiceImp.privacySettings`: `deviceCount` = số phiên từ `sessions()`.
  - `ai_settings_mobile_view.dart`: ẩn thẻ quota khi `total == 0`.
- Kiểm chứng:
  - Test mới/sửa:
    - family_settings_circle_test "“Cài đặt” at the bottom opens SET-01".
    - family_settings_batch2_test: thiết bị không vị trí; AI ẩn thẻ quota.
    - settings_remote_test: `deviceCount` 2 theo phiên.
  - `make check` EXIT 0 (866 test).
  - Trên máy sau build lại: SET-04 "1 device", SET-05 không còn "0 / 0", SET-07 "Android | In use".
- Còn lại:
  - Nhãn gói ở thẻ AI khi dùng thử là "Family" (ánh xạ sẵn của `planTitle`); thẻ đang ẩn ở bản server nên chưa lộ.
  - Không commit.
- Product history: [BF-20261026-002](PRODUCT_ANALYTICS_HISTORY.md#bf-20261026-002).

<a id="bf-20261026-003"></a>
## BF-20261026-003 — Làm tiếp: rà dữ liệu mẫu trên app thật ở các màn chính còn lại (Papa & Mama, Lịch, Thông báo, Ký ức, Chăm sóc)

- Ngày làm: 2026-10-26T09:11:22+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Làm tiếp cho t đi" (sau BF-20261026-002). Câu này không yêu cầu commit rõ ràng, nên tiếp tục rà các màn chính còn lại và không commit.
- Liên quan: BF-20261026-001, BF-20261026-002.
- Role: Chủ trì TESTER (chạy thật); MOBILE (sửa lỗi); QUALITY (agent chính tự áp dụng, không sub-agent).
- Trạng thái: Hoàn thành (2026-10-26T09:26:32+07:00).
- Phân tích / quá trình (emulator + backend 3100, gia đình "The Mama family"):
  - Không còn dữ liệu mẫu ở:
    - Papa & Mama: tuần, nhật ký riêng, Cầu nối, cài đặt.
    - Lịch: nhiệm vụ server, âm lịch; Tạo sự kiện: form trống, bé/thành viên thật; chi tiết nhiệm vụ.
    - Ký ức: tìm kiếm không có "tìm gần đây" mẫu; Nháp, Thùng rác, Ngày này năm xưa rỗng đúng.
    - Trang bé HOME-02: số 0; gợi ý cột mốc từ catalog.
    - Huy hiệu: 0/8, danh mục catalog.
  - "Synthetic …" là dữ liệu thử của server.
  - Lỗi tìm ra (có từ trước, không phải dữ liệu mẫu, nhưng làm gia đình mới thấy màn hỏng):
    1. NOTI-01 rỗng là trang trắng, không empty state (Skill 8).
    2. MEM-03 Album rỗng chỉ còn hai tiêu đề trơ.
    3. CARE-08 việc "Cùng nhau" chưa làm vẫn ghi "· đã xong" (mock chỉ có việc xong nên chưa lộ).
    4. CARE-09 thống kê bản server chỉ hiện chữ "Thống kê" (trùng tiêu đề màn).
- Kết quả:
  - `notifications_mobile_view.dart`: `EmptyState` (`notificationsEmpty`, `notificationsEmptyDescription`).
  - `albums_mobile_view.dart`: ẩn "Album tự động" khi rỗng; `EmptyState` (`memAlbumsEmpty`, `memAlbumsEmptyDescription`).
  - `history_entry_row.dart`: chưa làm → `careHistoryTogetherMissed`.
  - `care_stats_mobile_view.dart`: `careStatsEmpty`.
  - Chuỗi mới đủ vi/en/zh/ja; đặc tả NOTI-01/MEM-03 không có câu rỗng nên viết theo giọng văn mục 11.
- Kiểm chứng:
  - Widget test mới:
    - home_test "empty inbox shows the empty state".
    - memories_batch2_test "MEM-03 without albums shows the empty state".
    - care_us_child_batch2_test "CARE-08 together task not done reads as missed".
  - `make check` EXIT 0 (869 test).
  - Trên máy sau build lại: cả 4 màn hiển thị đúng.
- Còn lại:
  - Việc hôm nay chưa làm cũng ghi "Không kịp làm" ở lịch sử (ngữ nghĩa sẵn có, cả việc của tôi).
  - Chưa rà app người thân (Circle) và luồng thai kỳ sau chào đời.
  - Không commit.
- Product history: [BF-20261026-003](PRODUCT_ANALYTICS_HISTORY.md#bf-20261026-003).

<a id="bf-20261026-004"></a>
## BF-20261026-004 — Rà app người thân (Circle) và luồng sau chào đời trên emulator với backend thật

- Ngày làm: 2026-10-26T09:34:43+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Rà tiếp app người thân (Circle) và luồng sau chào đời trên emulator với backend thật."
- Liên quan: BF-20261026-003.
- Role: Chủ trì TESTER (chạy thật); MOBILE (sửa lỗi); QUALITY (agent chính tự áp dụng, không sub-agent).
- Trạng thái: Hoàn thành (2026-10-26T09:57:25+07:00); còn mục cho backend và dữ liệu test đã đổi (xem "Còn lại").
- Phân tích / quá trình (emulator + backend 3100, DB `baby_family_test`):
  - Chào đời "Bi" (Mama):
    - Gõ "10/26/2026" (tiếng Anh) thì thẻ chào mừng ghi **2/10/2028**. Ô ngày điền sẵn theo `toFormDate` (en `M/d/yyyy`) nhưng `_parseDate` luôn đọc `dd/MM`, cuộn tháng 26 sang năm khác, và nhận cả ngày tương lai.
    - Cùng lỗi ở sheet sửa thai kỳ: chỉ mở rồi lưu (en) là ngày dự sinh 09/11 thành 11/09.
    - Hai bản `_parseDate` trùng (Skill 11).
    - Sau sửa: thẻ ghi "10/26/2026 · 3.2 kg", hoàn tất được, bé "0 days old", có ký ức chào đời.
  - Gói: server chỉ cho mời người thân khi gói có `circle.enabled`. Bản dev không có lối cấp gói (IAP cần store thật, Admin chỉ khoá/mở). Đã sửa **trực tiếp 1 dòng** `billing.family_entitlements` của gia đình thử QA trong DB test: TRIAL → FAMILY v1, PAID, hạn 30 ngày. Giá trị cũ lưu ở scratchpad phiên (`entitlement_before.txt`: TRIAL, plan version TRIAL v1, hạn 2026-10-29T23:49:42Z).
  - Lời mời người thân (FAM-03/05):
    - Bấm "Tạo lời mời" chỉ hiện snackbar, không có bảng chia sẻ như đặc tả.
    - "Gửi lại link" bản server chạy bản mock: báo "Đã gửi lại" mà không chia sẻ gì.
  - INV-01 người thân:
    - " (Mama) mời…": server chỉ trả tên gọi người mời.
    - " · Chỉ xem": server không trả tên gọi đề xuất.
    - Quyền luôn "Chỉ xem": app bỏ `permission`. Kiểm API: `/invites/resolve` (công khai) **không trả** `permission` cho CIRCLE, dù DB lưu COMMENT.
  - Người thân đăng ký (OTP Mailpit, tên "Ba Noi QA") và nhận lời mời → server `AWAITING_APPROVAL`, nhưng CIR-WAIT vẫn ghi "Bà cần được con cháu mời vào gia đình". Mama duyệt qua API → CIR-01 có Na, Bi; tab Ký ức/Đăng ảnh rỗng đúng (không quyền đăng → giải thích).
  - CIR-06 "Tôi": câu xem trước cỡ chữ thiếu tên cháu ("  có ảnh mới…"), vì bản server không gửi ngày sinh cho người thân.
- Kết quả (sửa):
  - `lib/utils/helper/form_date.dart` `parseFormDate(text, locale)`: ngược `toFormDate`, `parseStrict`, nhận `.`/`-`. Thay 2 bản `_parseDate` (`birth_mobile_view.dart`, `edit_pregnancy_sheet.dart`). PREG-06 bỏ ngày sau hôm nay.
  - `external_launcher.dart` `shareText`. FAM-03 tạo lời mời → bảng chia sẻ với `famInviteShareMessage` (tên gọi, tên bé, mã, link). FAM-05 "Gửi lại link" → mở lại bảng chia sẻ khi có mã.
  - INV-01: `invInviterParentShort` / `invInviterRelativeShort` khi không có tên; tên gọi người thân rơi về nhãn quan hệ; `SessionRemoteServiceImp._circlePreview` đọc `permission` (canComment / canPost).
  - CIR-WAIT: `CircleWaitingController.awaitingApproval` → `circleAwaitingTitle` / `circleAwaitingSubtitle`.
  - CIR-06: `previewChild` rơi về bé đầu tiên.
  - Chuỗi mới đủ vi/en/zh/ja.
- Kiểm chứng:
  - Test mới/sửa:
    - `test/utils/form_date_test.dart` (3).
    - session_remote (quyền INV-01).
    - invite_preview_accept_test +2 (INV-01 không tên, CIR-WAIT chờ duyệt).
    - family_settings_circle_test, billing_settings_batch3_test (bắt kênh share qua helper mới `test/helpers/share_capture.dart`).
    - memories_circle_batch3_test +1 (CIR-06).
  - `make check` EXIT 0 (875 test).
  - Trên máy: thẻ chào mừng đúng ngày; bảng chia sẻ hiện tin nhắn có mã; INV-01 "Mama invited Grandma…", "Paternal grandmother · View only"; CIR-06 "Na has new photos…".
- Còn lại:
  - **Backend:** `/invites/resolve` (CIRCLE) chưa trả `permission` từng bé và tên gọi đề xuất (`displayName` có trong payload) → INV-01 vẫn hiện "Chỉ xem" sai cho lời mời có bình luận.
  - "Recent firsts" ở HOME-02 của bé vừa chào đời không hiện thẻ dù chương ghi "1 firsts".
  - FAM-01 ghi "0/12" trong khi FAM-05 ghi "1/12" (lời mời chờ).
  - CIR-WAIT "Quét QR" mở mã mẫu (rỗng ở bản server).
  - "31 days until 1 months" (số nhiều).
  - Lời mời tạo trước khi sửa chưa có mã trên máy nên "Gửi lại" không chia sẻ được (cần "Tạo lời mời mới").
  - Dữ liệu test đang đổi:
    - Gia đình QA đang ở gói FAMILY (PAID 30 ngày), có người thân "Ba Noi QA".
    - Emulator đang đăng nhập bằng tài khoản người thân.
  - Không commit.
- Product history: [BF-20261026-004](PRODUCT_ANALYTICS_HISTORY.md#bf-20261026-004).

<a id="bf-20261026-005"></a>
## BF-20261026-005 — Trả gói của gia đình QA trong DB test về dùng thử như trước BF-20261026-004

- Ngày làm: 2026-10-26T10:01:01+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: "Trả dòng billing.family_entitlements của gia đình QA về giá trị cũ (TRIAL, plan version TRIAL v1, hạn 2026-10-29T23:49:42Z)."
- Liên quan: BF-20261026-004.
- Role: Chủ trì DBA (dữ liệu test); QUALITY (agent chính tự áp dụng).
- Trạng thái: Hoàn thành (2026-10-26T10:02+07:00).
- Kết quả: `billing.family_entitlements` của gia đình QA (`01a16604-…c875`) về `TRIAL`, plan version TRIAL v1 (`01a1401a-0c09-…`), `valid_until` = `trial_ends_at` = 2026-10-29T23:49:42.129Z, `trial_started_at` giữ nguyên. `version` tăng lên 4 (bộ đếm chỉ tăng).
- Kiểm chứng: `select` sau `update` khớp giá trị cũ đã lưu ở BF-20261026-004 (trừ `version`/`computed_at`/`updated_at`).
- Còn lại: người thân "Ba Noi QA" vẫn là thành viên; với gói dùng thử, Circle sẽ ở trạng thái tạm dừng (CIR-05). Emulator vẫn đăng nhập bằng tài khoản người thân. Không sửa code.
- Product history: [BF-20261026-005](PRODUCT_ANALYTICS_HISTORY.md#bf-20261026-005).

<a id="bf-20261026-006"></a>
## BF-20261026-006 — Backend: `/invites/resolve` CIRCLE trả quyền từng bé và tên gọi đề xuất

- Ngày làm: 2026-10-26T13:32+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: (giao từ session BF-20261026-004) bổ sung `children[].permission`/`allowDownload` và `displayName` vào response `POST /v1/invites/resolve` loại CIRCLE; cập nhật `docs/api.md`, test; không commit.
- Liên quan: BF-20261026-004.
- Role: Chủ trì BACKEND; hỗ trợ ARCHITECT (contract API công khai), SECURITY_PRIVACY (không lộ id người dùng); review TESTER, QUALITY — góc nhìn do agent chính áp dụng, không có reviewer độc lập.
- Trạng thái: Hoàn thành (2026-10-26T13:34+07:00).
- Phân tích: `resolveCircle` chỉ trả `children:[{id,name}]` dù `payload.grants` của lời mời lưu `permission`/`allowDownload` và `payload.displayName` có tên gọi đề xuất, nên INV-01 luôn hiện "Chỉ xem". Ghép quyền theo grant của lời mời (giống cách `GET /me/circles` ghép grant của thành viên), sau khi vẫn lọc bé qua `grantedSubjects` (chỉ bé còn hiệu lực, thai kỳ riêng tư bị loại). Không thêm id người dùng; `displayName` là tên gọi Bố/Mẹ đặt cho người được mời.
- Kết quả: `baby-backend/src/repositories/family-circle.repository.ts` (`resolveCircle` gắn `permission` mặc định VIEW và `allowDownload` cho từng bé), `src/models/family-circle-state.model.ts` (`FamilyCirclePreview.displayName`), `src/dto/invite/circle-preview.dto.ts` (response thêm `displayName`, `children[].permission/allowDownload`), `docs/api.md` (dòng `/invites/resolve` + mục Lời mời người thân), test `test/integration/family-circle-api.spec.ts` (kiểm VIEW/false cho bé, COMMENT/true cho thai kỳ, `displayName`, không chứa id Bố/Mẹ). Không sửa file sinh tự động, không sửa app.
- Kiểm chứng: `npm run check` đạt (unit 38 suite/331 test, e2e 2 suite/35 test, lint/typecheck/build/format). `npm run test:integration -- family-circle-api.spec.ts auth-onboarding.spec.ts` với DB `baby_family_test`: 2 suite/15 test đạt. Không chạy toàn bộ integration suite; không thử lại trên app thật.
- Còn lại: App có thể map `displayName` vào `InviteInfo.callName` (`baby-family-app/lib/data/model/session/invite_resolution.dart`) — tuỳ chọn, chưa làm. Không commit.
- Product history: [BF-20261026-006](PRODUCT_ANALYTICS_HISTORY.md#bf-20261026-006).

## BF-20261026-007 — App nối `/invites/resolve` mới (tên gọi đề xuất, quyền xem/tải ảnh từng bé), chạy lại đủ bộ kiểm tra cho BF-20261019-006, làm mục checklist kế tiếp

- Ngày làm: 2026-10-26T14:58:29+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: (giao từ session điều phối, theo yêu cầu "Làm phần tiếp theo di" của người dùng) (1) nối app với `POST /invites/resolve` mới của BF-20261026-006; (2) chạy lại đủ bộ kiểm tra hiện tại và ghi kết quả thật vào entry BF-20261019-006; (3) làm tiếp mục kế trong checklist.
- Liên quan: BF-20261026-006, BF-20261019-006.
- Role: ORCHESTRATOR, MOBILE (chủ trì), TESTER, QUALITY. Backend không sửa.
- Phân tích / kết quả:
  1. **Lời mời người thân (INV-01):**
     - `InviteResolution.displayName`. `_circlePreview` map tên gọi Bố/Mẹ đặt vào `InviteInfo.callName` (trống → nhãn quan hệ như trước).
     - `InvitePreviewData.childAccess` (id bé → `permission` + `allowDownload`). Màn xem trước hiện nhãn quyền **theo từng bé** qua helper chung `permissionSummary` (tách từ `relativePermissionSummary`), thiếu thì dùng quyền chung.
     - Phần `permission`/`allowDownload` trong `CircleSubjectRecord` đã có từ BF-20261026-004.
  2. **BF-20261019-006:** không thấy chỗ nào còn "đang chờ kết quả kiểm tra đầy đủ"; cả hai entry đã "Hoàn thành" có số liệu. Vẫn chạy lại đủ bộ kiểm tra trên mã hiện tại và ghi bù vào entry đó (có đánh dấu).
  3. **Mục kế trong checklist** ("rà offline các màn còn lại"):
     - Quét các phương thức đọc của service remote: 23 lệnh đọc màn phụ chưa có dự phòng khi mất mạng (chăm sóc: thư viện / Hearts / huy hiệu / lịch sử / lịch / cài đặt / chuỗi; ký ức: album / góc nhìn / bài chờ duyệt / recap / ngày này năm xưa; thông báo; cài đặt: thông báo / AI / trợ giúp / thiết bị; Papa & Mama: cài đặt; thai kỳ: chuẩn bị / kích thước thai; gia đình: múi giờ / các gia đình của tôi).
     - Thêm `OfflineReads`: mất mạng → bản đọc thành công gần nhất cùng khoá (trong phiên), chưa có → lỗi như cũ; 4xx không bị che. Khoá theo người dùng server với cài đặt / thông báo, để không lộ bản đệm khi đổi tài khoản.
- Bằng chứng:
  - App `make check` EXIT 0 (analyze sạch, 878 test). Test mới: session (`displayName`, quyền từng bé, tên trống), `relative_text` (`permissionSummary`), `offline_read_test` (`OfflineReads` / `whenOnline`).
  - Backend `npm run check` EXIT 0 (unit 331, e2e 35), eslint EXIT 0, `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` EXIT 0 (73 suite / 609 test).
  - Chưa chạy lại app trên emulator cho phần này.
- Còn lại:
  - Bản đọc gần nhất của màn phụ chỉ trong RAM (mất khi tắt app).
  - Thao tác ghi ở màn phụ (đổi cài đặt, hoàn tác / đổi nhiệm vụ, thao tác lời nhờ) vẫn cần mạng.
  - Nâng Flutter cho iOS: đã có phiên đề xuất riêng.
  - Không commit.
- Trạng thái: Hoàn thành (còn các phần nêu ở "Còn lại").

## BF-20261027-001 — PREG-07 Đặt tên cho con + CARE-11 Thống kê chăm con (Codex backend + Claude app)

- Ngày làm: 2026-10-27T18:36:43+07:00 (Asia/Ho_Chi_Minh).
- Yêu cầu: (chuyển từ session điều phối) "Tiếp tục làm các tính năng tiếp theo cho t đi" — chọn mục kế tiếp trong checklist, làm cả backend và app, chạy đủ kiểm tra, ghi nhật ký.
- Liên quan: checklist dòng PREG-07, CARE-11 (1.1); đặc tả 7.15, 9.5 PREG-07, 9.7 CARE-11.
- Role:
  - ORCHESTRATOR: chọn mục — MVP còn lại đều cần cấu hình Store / Apple / Google / staging hoặc thiết bị thật, nên chọn hai mục 1.1 đã có UI, đặc tả rõ.
  - BACKEND: 2 phiên Codex song song — A: PREG-07, B: CARE-11.
  - MOBILE (Claude), TESTER, QUALITY.
- Phân tích:
  - **Codex A (PREG-07):**
    - Dùng lại hai bảng tên / lượt thích đã có; migration DDL `20261027120000_pregnancy_name_key` (khoá chuẩn hoá + unique).
    - Tên và ý nghĩa mã hoá AES-GCM (khoá `COUPLE_CHECKIN_ENCRYPTION_KEY`); thích theo người xem; chọn tối đa `expectedCount` và cập nhật cột mốc `name_chosen` trong transaction.
    - Chỉ người thêm được xoá; thai kỳ không ACTIVE chỉ đọc.
  - **Codex B (CARE-11):**
    - `GET /families/:id/care-stats` gộp theo category / tuần (múi giờ gia đình) / bé, đủ category kể cả 0, bỏ COUPLE, ngày cây nở hoa.
    - Không trả theo người; feature `care.statistics` theo plan version của entitlement (không theo tên gói).
  - **Claude:**
    - Đăng ký DI cho hai controller / service / repository.
    - App: model / client / repository / service theo hợp đồng.
      - PREG-07: thai kỳ server qua API; bấm Chọn lần nữa = bỏ chọn.
      - CARE-11: tham số tuần / bé, tuần trước / sau ở `AppWeekSelector`, đổi bé tải lại.
      - Cả hai đọc qua `OfflineReads`.
- Kết quả:
  - Checklist tick PREG-07 và CARE-11 → 144/166 (MVP giữ 142/154).
  - `docs/api.md` có mục BF-20261027-001; `baby-family-app/SESSION.md` đã cập nhật; handoff `BF-20261027-001-A/B.md`.
- Bằng chứng:
  - App `make check` EXIT 0 (analyze sạch, 879 test; mới: pregnancy_remote PREG-07, care_remote CARE-11 + bản đọc khi mất mạng).
  - Backend `npm run check` EXIT 0 (unit 337, e2e 35, compiled); `npx eslint --max-warnings=0 src test` EXIT 0.
  - Backend `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` EXIT 0 (75 suite, 655 test; gồm spec mới của Codex).
  - Migration chỉ áp lên `baby_family_test`.
  - Chưa chạy trên emulator với backend thật.
- Còn lại:
  - App chưa có nút xoá tên dự định (API đã có) và chưa hiện thông báo riêng cho các mã `NAME_*` (đang dùng thông điệp server).
  - POST thêm tên chưa có Idempotency-Key.
  - Deploy migration và seed catalog `name_chosen` ở môi trường khác.
  - Thử trên máy thật.
  - Không commit.
- Trạng thái: Hoàn thành (còn các phần nêu ở "Còn lại").
