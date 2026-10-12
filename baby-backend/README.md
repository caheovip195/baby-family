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
npm run db:up
npm run db:migrate:deploy
npm run start:dev
```

Giữ `.env` hiện tại nếu đã có. Tạo `.env` trước `npm ci`: postinstall sinh Prisma Client và config cần `DATABASE_URL`.

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
test/unit/, test/e2e/, test/integration/
tools/generators/
```

Luồng: `NoteController → INoteService (NOTE_SERVICE) → NoteService → INoteRepository (NOTE_REPOSITORY) → NoteRepository → PrismaService`.

`NoteService implements INoteService`, `NoteRepository implements INoteRepository`; AppModule bind token với class. Interface bị xóa khi compile, token là định danh để Nest inject ở runtime. Test có thể thay implementation bằng `overrideProvider(TOKEN).useValue(mock)`.

`Note` là class có constructor nhận attributes, các property `readonly` và method `hasContent()`. Repository chuyển Prisma row thành `new Note(row)`. Model giữ dữ liệu và hành vi của chính nó; service xử lý nghiệp vụ, repository xử lý database. Service dùng DTO input bằng `import type` để giữ cấu trúc gọn. [Chi tiết kiến trúc](docs/architecture.md).

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
npm run db:down                       # Dừng database, giữ volume
npm run check                         # Schema, format, lint, types, build, tests
npm run test:cov
```

Prisma 7 đọc URL từ `prisma.config.ts`, dùng `@prisma/adapter-pg`, sinh client CommonJS. DatabaseModule cung cấp một PrismaService/pool và đóng kết nối khi shutdown.

Integration cần database riêng có tên kết thúc bằng `_test`. Với credential local mặc định:

```bash
docker compose exec -T postgres createdb -U baby baby_family_test
DATABASE_URL='postgresql://baby:baby_local_only@localhost:5433/baby_family_test?schema=public' npm run db:migrate:deploy
TEST_DATABASE_URL='postgresql://baby:baby_local_only@localhost:5433/baby_family_test?schema=public' npm run test:integration
```

Bỏ lệnh `createdb` nếu database đã tồn tại. Test chỉ xóa record do lần chạy tạo. CI tại `.github/workflows/backend-ci.yml` ở repository gốc chạy checks, migration, PostgreSQL integration và Docker build.

## Chạy bằng Docker

```bash
docker compose up --build -d --wait
docker compose logs -f api
```

Compose chạy PostgreSQL healthy → migrate hoàn tất → API. Runtime dùng user `node`, filesystem read-only, bỏ dev tooling/Prisma CLI; Swagger mặc định tắt ở production. PostgreSQL 18 mount volume tại `/var/lib/postgresql`.

Credential trong `.env.example` chỉ dành cho local. Khi đổi database/credential, đồng bộ `DATABASE_URL` và `POSTGRES_*`; URL-encode password có ký tự đặc biệt. Các biến khởi tạo PostgreSQL chỉ áp dụng với volume mới.

Base có validation, CORS allowlist, Helmet, rate limit in-memory, pagination, Pino/request ID, error response thống nhất và health checks. `npm audit --omit=dev` không có finding; audit đầy đủ còn 5 high trong chuỗi Plop/braces development chưa có bản vá. [Dependency và vận hành](docs/architecture.md#dependency-và-vận-hành).

Tham khảo [Brocoders](https://github.com/brocoders/nestjs-boilerplate) (4,414 stars), [Notiz Prisma starter](https://github.com/notiz-dev/nestjs-prisma-starter) (2,540), [Express TypeScript boilerplate](https://github.com/w3tecch/express-typescript-boilerplate) (3,411) và [Prisma examples](https://github.com/prisma/prisma-examples) (6,648); stars quan sát ngày 11/10/2026. Áp dụng phân lớp, repository contracts, DI và generator trên bộ dependency hiện tại.
