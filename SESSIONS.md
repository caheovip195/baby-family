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
