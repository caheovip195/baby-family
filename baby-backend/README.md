# Baby Family Backend

Backend **Node.js + TypeScript + NestJS + PostgreSQL + Prisma**, tổ chức thư mục theo vai trò. Ba lớp xử lý request là **controller → service → repository**; Nest tự tạo và inject dependencies qua interface cùng `Symbol` token.

## Phiên bản

Đã xác minh ngày **11/10/2026**: Node **26.11.1** (Current), npm **11.20.0**, PostgreSQL **18.6**, NestJS **12.1.2**, Prisma CLI/Client/adapter-pg **7.10.0**, TypeScript **6.0.3**. Phiên bản và lockfile được pin cho local, CI và Docker. Prisma 8 đang RC nên bộ Prisma dùng cùng bản stable 7.10.0. [Node releases](https://nodejs.org/en/download), [PostgreSQL versioning](https://www.postgresql.org/support/versioning/), [Nest + Prisma](https://docs.nestjs.com/recipes/prisma).

## Chạy local

Cần Docker Desktop đang chạy và Node đúng phiên bản (`nvm install && nvm use` nếu dùng nvm).

```bash
cd /Users/congnt/workspace/baby-family/baby-backend
cp .env.example .env
npm ci
# Thiết lập .env và thư mục data/backups tại ../baby-database trước lần đầu.
npm run db:up
npm run db:migrate:deploy
npm run start:dev
```

Giữ `.env` hiện tại nếu đã có. Tạo `.env` trước `npm ci`: postinstall sinh Prisma Client và config cần `DATABASE_URL`.

PostgreSQL chạy riêng trong [baby-database](../baby-database/README.md). Lần đầu làm theo hướng dẫn tại đó để tạo `.env`, `data/`, `backups/` và khởi động DB. `npm run db:up`/`db:down` chỉ là lệnh tiện trỏ sang Compose database; `docker compose down` trong backend chỉ dừng API/migrations.

- API: `http://localhost:3000/api/v1/notes`; Swagger: `http://localhost:3000/docs`, JSON: `/docs-json`.
- Health: `/health/live` kiểm tra process; `/health/ready` kiểm tra kết nối PostgreSQL.
- Database local: `localhost:5433`, database `baby_family`, user `baby`, password `baby_local_only`.

```bash
curl -X POST http://localhost:3000/api/v1/notes \
  -H 'Content-Type: application/json' \
  -d '{"title":"Hello Baby Family","content":"First note"}'
curl 'http://localhost:3000/api/v1/notes?page=1&limit=20'
```

`note` là resource CRUD mẫu, chưa có authentication/authorization. Domain thực tế tham khảo `docs/02_TAI_LIEU_KY_THUAT_BABY_FAMILY_v3.md` tại repository gốc.

[Thiết kế database theo đặc tả và canvas](../docs/database/README.md) đã có [Prisma schema](prisma/schema.prisma) và [forward migration](prisma/migrations/20261013150000_family_domain/migration.sql) **tại backend**; server/data/backups vẫn thuộc `baby-database`. Migration domain chưa áp dụng vào DB ứng dụng đang chạy. API thực tế hiện mới có Note; các bảng domain chưa có service/quyền/worker tương ứng.

## Cấu trúc và OOP

```text
src/
  controllers/                    # HTTP, gọi service interface
  services/                       # Nghiệp vụ, gọi repository interface
  repositories/                   # Prisma CRUD, transaction, mapping
  models/                         # Class dữ liệu và hành vi của từng model
  interfaces/
    services/                     # INoteService + NOTE_SERVICE token
    repositories/                 # INoteRepository + NOTE_REPOSITORY token
  dto/note/                       # Create/update/response DTO
  database/                       # DatabaseModule + PrismaService dùng chung
  common/                         # Errors, pagination
  config/                         # Validate environment
  generated/prisma/               # Prisma tự sinh, không commit
  app.module.ts                   # Đăng ký controller và toàn bộ DI bindings
  bootstrap.ts, main.ts
prisma/schema.prisma
prisma/migrations/
prisma/seed.ts                     # Catalog data, chạy chủ động riêng
test/unit/, test/e2e/, test/integration/, test/database-design/
tools/generators/, tools/database/
```

Luồng: `NoteController → INoteService (NOTE_SERVICE) → NoteService → INoteRepository (NOTE_REPOSITORY) → NoteRepository → PrismaService`.

`NoteService implements INoteService`, `NoteRepository implements INoteRepository`; AppModule bind token với class. Interface bị xóa khi compile, token là định danh để Nest inject ở runtime. Test có thể thay implementation bằng `overrideProvider(TOKEN).useValue(mock)`.

`Note` là class có constructor nhận attributes, các property `readonly` và method `hasContent()`. Repository chuyển Prisma row thành `new Note(row)`. Model giữ dữ liệu và hành vi của chính nó; service xử lý nghiệp vụ, repository xử lý database. Service dùng DTO input bằng `import type` để giữ cấu trúc gọn. [Chi tiết kiến trúc](docs/architecture.md).

Schema hiện có **123 bảng**: Note và **122 model class, I-repository/token, concrete repository** tương ứng domain. Ví dụ [FamilyLicense](src/models/family-license.model.ts), [IFamilyLicenseRepository](src/interfaces/repositories/family-license-repository.interface.ts), [FamilyLicenseRepository](src/repositories/family-license.repository.ts). [Danh sách persistence](src/database/persistence.manifest.ts) ghi table, khóa chính, scope và chính sách mutation; [providers](src/database/repository.providers.ts) được đăng ký tại AppModule. Model/interface không import Prisma.

Repository yêu cầu scope family/user/couple khi bảng có tenant; 24 bảng toàn cục yêu cầu `{ privileged: true }` rõ ràng. Đây là điều kiện truy vấn; service vẫn phải xác thực quyền của caller. 18 repository lịch sử/tài chính chỉ mở create/read, không generic update/delete. Những bảng mutable dùng soft delete và lọc active rows; Memory yêu cầu service truyền `purgeAfter` khi xóa. Search tsvector tính bởi DB chưa được đưa vào model/mutation.

Đồng bộ persistence sau khi đổi Prisma schema:

```bash
npm run generate:persistence
npm run generate:persistence -- --check
npm run prisma:generate
```

Generator bảo vệ file bằng hash trong `tools/database/persistence.generated.json`, từ chối ghi đè file đã chỉnh tay. Khi cần tùy biến repository, cập nhật template/chính sách generator rồi review diff; `--force` là lựa chọn ghi đè chủ động, chỉ dùng sau khi đã giữ lại thay đổi cần thiết. Generator không sinh service/controller nghiệp vụ hoặc áp migration.

## Tự sinh resource

```bash
npm run generate -- resource task
npm run prisma:generate
npm run db:migrate -- --name add_task
npm run check
```

Plop sinh **9 file**: model class, hai interface/token, service, repository, controller và ba DTO. Generator thêm Prisma model và đăng ký controller/provider trong AppModule. Dùng tên số ít `kebab-case` (`task`, `family-member`); route tự chuyển số nhiều, ví dụ `/api/v1/tasks`.

Các field `title/content` là mẫu: sửa model, DTO, repository và schema theo resource trước migration. Generator kiểm tra trùng tên, giữ các marker trong AppModule, rollback khi ghi lỗi và dùng lock để tránh chạy đồng thời. Generator không tự chạy SQL.

## Database và kiểm tra

```bash
npm run db:migrate -- --name change    # Tạo và áp dụng migration development
npm run prisma:generate               # Sinh client sau khi schema đổi
npm run db:status
npm run db:studio
npm run db:migrate:deploy              # Áp dụng SQL đã commit
npm run db:seed                        # Chạy catalog seed riêng, sau migration
npm run db:down                       # Dừng stack DB riêng, giữ data host
npm run check                         # Schema, format, lint, types, build, tests
npm run test:cov
```

Prisma 7 đọc URL từ `prisma.config.ts`, dùng `@prisma/adapter-pg`, sinh client CommonJS. DatabaseModule cung cấp một PrismaService/pool và đóng kết nối khi shutdown. Domain dùng schema `app`, `us`, `billing`, `ops`; Note ở `public`. Migration **chỉ DDL**, không CRUD/DML/backfill/seed. Kiểm tra đích `DATABASE_URL` trước khi chạy; `db:seed` là command chủ động riêng, không tự chạy khi migrate, Compose hoặc khởi động API.

[Seed](prisma/seed.ts) đọc [catalog JSON](prisma/seeds/catalog.json), khởi tạo House/Family và policy trial 7 ngày. Chạy lại giữ nguyên bản ghi đã có; version bất biến không khớp thì rollback. Seed bootstrap không phải công cụ cập nhật catalog đang vận hành, không cấp license hoặc tạo giao dịch Store. Thay đổi cấu hình/gói sau này đi qua service/admin command phù hợp và publish version mới khi cần.

[Chuẩn database bắt buộc](../.agents/skills/baby-family-team/references/database-standards.md): mọi bảng dự án có `created_at`, `updated_at`, `deleted_at`; soft delete mặc định và trigger `updated_at` cho mọi writer. Domain migration có ràng buộc DB; repository/generator/API cần kiểm tra riêng, không suy ra tuân thủ runtime chỉ từ schema. Xem [verification](../docs/database/verification.md) về phạm vi đã kiểm chứng.

[Cron/job history và xử lý lỗi](docs/jobs.md) mô tả chuẩn lưu run/attempt vào PostgreSQL, retry, idempotency và recovery. Domain schema có bảng job; base chưa có scheduler/queue, worker hoặc service ghi lịch sử job đang chạy.

Integration cần database riêng có tên kết thúc bằng `_test`. Với credential local mặc định:

```bash
docker compose --project-directory ../baby-database --file ../baby-database/compose.yaml exec -T postgres createdb -U baby baby_family_test
DATABASE_URL='postgresql://baby:baby_local_only@localhost:5433/baby_family_test?schema=public' npm run db:migrate:deploy
TEST_DATABASE_URL='postgresql://baby:baby_local_only@localhost:5433/baby_family_test?schema=public' npm run test:integration
```

Bỏ lệnh `createdb` nếu database đã tồn tại. Test chỉ xóa record do lần chạy tạo. CI tại `.github/workflows/backend-ci.yml` ở repository gốc chạy checks, migration, PostgreSQL integration và Docker build.

## Chạy bằng Docker

```bash
# Khởi động stack DB riêng trước; chờ healthcheck đạt.
npm run db:up
docker compose up --build -d --wait
docker compose logs -f api
```

Compose backend chỉ chạy migrate → API, kết nối alias `baby-postgres` qua external network `baby-family-data` do stack DB tạo. Mỗi stack có vòng đời riêng nên backend không `depends_on` service PostgreSQL của stack khác; chạy DB healthy trước backend. Migration thất bại thì API không khởi động. Runtime dùng user `node`, filesystem read-only, bỏ dev tooling/Prisma CLI; Swagger mặc định tắt ở production.

`DATABASE_URL` dành cho chạy Node/Prisma trên host (`localhost:5433`); `DATABASE_DOCKER_URL` dành cho Compose (`baby-postgres:5432`). Khi đổi database/credential, đồng bộ hai URL với `POSTGRES_*` trong `baby-database/.env`; URL-encode password có ký tự đặc biệt. Compose backend yêu cầu khai báo Docker URL rõ ràng. Credential mẫu chỉ dành cho local; các biến khởi tạo PostgreSQL chỉ áp dụng khi tạo cluster mới.

PostgreSQL 18 bind mount `baby-database/data` trên host vào `/var/lib/postgresql`, không lưu data bằng named volume của backend. Xóa/recreate container hoặc `compose down -v` không xóa thư mục host; vẫn cần giữ thư mục đó và [backup/restore](../baby-database/README.md). Không copy PGDATA đang chạy để làm backup nhất quán.

Base có validation, CORS allowlist, Helmet, rate limit in-memory, pagination, Pino/request ID, error response thống nhất và health checks. `npm audit --omit=dev` không có finding; audit đầy đủ còn 5 high trong chuỗi Plop/braces development chưa có bản vá. [Dependency và vận hành](docs/architecture.md#dependency-và-vận-hành).

Tham khảo [Brocoders](https://github.com/brocoders/nestjs-boilerplate) (4,414 stars), [Notiz Prisma starter](https://github.com/notiz-dev/nestjs-prisma-starter) (2,540), [Express TypeScript boilerplate](https://github.com/w3tecch/express-typescript-boilerplate) (3,411) và [Prisma examples](https://github.com/prisma/prisma-examples) (6,648); stars quan sát ngày 11/10/2026. Áp dụng phân lớp, repository contracts, DI và generator trên bộ dependency hiện tại.
