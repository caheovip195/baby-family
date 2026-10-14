# Kiến trúc backend

## Ba lớp và thư mục

1. **Controller** (`controllers/`): nhận HTTP, validate DTO, gọi service interface, trả response.
2. **Service** (`services/`): xử lý nghiệp vụ, kiểm tra quy tắc, gọi repository interface.
3. **Repository** (`repositories/`): Prisma CRUD/transaction, mapping database row sang model và xử lý persistence errors.

`models/` chứa class; `interfaces/services/` và `interfaces/repositories/` chứa contracts/tokens; `dto/<resource>/` chứa create/update/response DTO. `database/`, `common/`, `config/` là phần dùng chung. Một AppModule là composition root, đăng ký controller/provider; DatabaseModule cung cấp kết nối Prisma.

Persistence domain hiện có 122 bộ model/interface/repository, cùng Note mẫu thành 123 bộ tương ứng 123 Prisma models. `database/repository.providers.ts` đăng ký Symbol token → class; `database/persistence.manifest.ts` ghi scope, khóa chính và append-only policy. Tạo lại bằng `npm run generate:persistence`, kiểm tra drift bằng `npm run generate:persistence -- --check`; file đã chỉnh tay được hash guard bảo vệ. Model và contract dùng kiểu domain, giữ Prisma types trong repository/database.

Repository domain nhận scope bắt buộc cho family/user/couple hoặc explicit privileged scope cho bảng toàn cục. Service phải kiểm tra caller có quyền dùng scope đó và thực thi chuyển trạng thái/retention; việc truyền scope không tự cấp quyền. 18 repository lịch sử/tài chính không mở generic update/delete. Business services, domain API và worker sẽ triển khai theo từng luồng đã xác định; lớp persistence không tự thay thế chúng.

Luồng mẫu: `NoteController → INoteService → NoteService → INoteRepository → NoteRepository → PrismaService`.

## Model và OOP

`Note` là class với các property `readonly`: `id`, `title`, `content`, `createdAt`, `updatedAt`. Constructor nhận `NoteAttributes` và gán dữ liệu; `hasContent()` kiểm tra content có ký tự sau khi trim.

Repository trả `new Note(row)` để caller nhận được model instance có method. Model giữ dữ liệu và hành vi của chính nó; service điều phối nghiệp vụ, repository thực hiện database I/O.

Service nhận create/update DTO qua `import type`; decorator validation chạy tại HTTP boundary. Interface repository dùng model/DTO types, giữ Prisma query types bên trong repository.

## Dependency injection

```ts
@Injectable()
export class NoteService implements INoteService {
  constructor(
    @Inject(NOTE_REPOSITORY) private readonly repository: INoteRepository,
  ) {}
}

// Đăng ký trong AppModule.providers.
const providers = [
  { provide: NOTE_SERVICE, useClass: NoteService },
  { provide: NOTE_REPOSITORY, useClass: NoteRepository },
];
```

`NoteRepository implements INoteRepository`; controller inject `NOTE_SERVICE` với type `INoteService`. Interface chỉ có ở compile time, `Symbol` token tồn tại runtime. Import cùng token đã export khi đăng ký và inject. Nest tự tạo dependencies, reuse singleton và quản lý lifecycle. Test thay provider bằng `overrideProvider(TOKEN).useValue(mock)`.

## CRUD và generator

List dùng `findMany/count` trong transaction `RepeatableRead`, sort `createdAt/id`, giới hạn 100 record/page. Repository chuyển `P2025` khi update/delete thành `null/false`; service chuyển thành `NotFoundError`. Controller giữ mỏng; business rules nằm ở service, database operations nằm ở repository.

`npm run generate -- resource task` sinh 9 file theo cùng cấu trúc, thêm Prisma model và đăng ký controller/DI providers trong AppModule. Các field `title/content` cần đổi theo resource. Generator kiểm tra tên/trùng đích, stage/rollback khi ghi lỗi và dùng lock; migration chạy bằng lệnh riêng sau khi review schema.

## Dependency và vận hành

Node 26.11.1 Current, PostgreSQL 18.6, Nest12, Prisma CLI/Client/adapter 7.10.0 stable, TypeScript6; lockfile được cài bằng `npm ci`. Prisma 8 đang RC với workflow khác. Client sinh CommonJS; test scripts bật `--experimental-vm-modules` cho Jest30 load Nest12 ESM.

Scoped overrides: `prisma → mysql2@3.24.5`, `@prisma/config → deepmerge-ts@8.0.2`, `@istanbuljs/load-nyc-config → js-yaml@5.4.3`. Chúng xử lý dependency advisories; Prisma config dùng plain objects, coverage loader dùng API `load`. `npm audit --omit=dev` sạch; còn 5 high qua Plop → liftoff → findup-sync → micromatch → braces ở development chưa có patched release. Không dùng `audit fix --force` để downgrade stack.

API `/api/v1`, health `/health/*`, Swagger `/docs`. DTO chặn field lạ/null không hợp lệ/patch rỗng. Pino ghi request ID, tránh body/query/authorization/cookies. Rate limit in-memory cần shared storage và proxy trust khi chạy nhiều replica. Resource mẫu chưa có auth.

PostgreSQL server chạy riêng tại `../baby-database/compose.yaml`, bind mount data ra host và quản lý backup/restore ở đó. Backend Compose chỉ giữ migration/API, kết nối alias `baby-postgres` qua external network; khởi động DB healthy trước khi chạy backend. `DATABASE_URL` dùng cho host, `DATABASE_DOCKER_URL` dùng trong container. Migration hoàn tất trước API. Runtime image bỏ CLI/dev dependencies, dùng user `node` và filesystem read-only. PrismaService dùng pool có giới hạn/timeout, connect khi startup và disconnect khi shutdown. Prisma schema/migrations tiếp tục nằm trong backend.

Nguồn: [Nest DI](https://docs.nestjs.com/fundamentals/custom-providers), [Nest + Prisma](https://docs.nestjs.com/recipes/prisma), [Jest ESM](https://jestjs.io/docs/ecmascript-modules), [Brocoders architecture](https://github.com/brocoders/nestjs-boilerplate/blob/main/docs/architecture.md), [Braces advisory](https://github.com/advisories/GHSA-vfj7-8cjw-p6xm).
