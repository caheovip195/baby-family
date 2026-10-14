# Quy tắc database bắt buộc

Quyết định của người dùng ngày 2026-10-13. DBA chịu trách nhiệm schema/migration; BACKEND áp dụng trong model/repository/generator; TESTER và QUALITY kiểm tra trước bàn giao.

## Ba cột trên mọi bảng

**Mọi bảng do dự án quản lý bắt buộc có đủ `created_at`, `updated_at`, `deleted_at`.** Áp dụng cả bảng nghiệp vụ, bảng nối, cấu hình, outbox, job và lịch sử chạy. Prisma many-to-many phải dùng model bảng nối tường minh để khai báo đủ cột. Không tự sửa bảng hệ thống PostgreSQL, `_prisma_migrations` hoặc bảng nội bộ do package quản lý.

| Cột PostgreSQL | Kiểu / mặc định                         | Quy tắc                                                        |
| -------------- | --------------------------------------- | -------------------------------------------------------------- |
| `created_at`   | `timestamptz(3) NOT NULL DEFAULT now()` | Thời điểm tạo; bất biến trong thao tác nghiệp vụ thông thường. |
| `updated_at`   | `timestamptz(3) NOT NULL DEFAULT now()` | Làm mới khi thay đổi bản ghi, bao gồm soft delete/restore.     |
| `deleted_at`   | `timestamptz(3) NULL DEFAULT NULL`      | `NULL` khi chưa xóa; có thời điểm khi soft delete.             |

Trao đổi thời điểm qua API bằng ISO 8601 UTC; timezone của lịch/nghiệp vụ lưu riêng khi cần. `timestamptz` không giữ tên timezone ban đầu. Không dùng thời gian do client gửi để ghi đè các cột audit.

Trong TypeScript/Prisma dùng camelCase, map sang tên cột DB bắt buộc:

```prisma
createdAt DateTime  @default(now()) @map("created_at") @db.Timestamptz(3)
updatedAt DateTime  @default(now()) @updatedAt @map("updated_at") @db.Timestamptz(3)
deletedAt DateTime? @map("deleted_at") @db.Timestamptz(3)
```

`@updatedAt` chạy ở Prisma ORM; `DEFAULT now()` chỉ xử lý insert. **Migration phải có trigger PostgreSQL làm mới `updated_at` khi UPDATE**, để raw SQL, cron, worker và các writer khác cũng tuân thủ. Chọn rõ hàm thời gian trong trigger; không hứa timestamp luôn tăng nghiêm ngặt vì có thể cùng transaction/millisecond. [Prisma v7](https://www.prisma.io/docs/orm/v7/reference/prisma-schema-reference#updatedat), [PostgreSQL datetime](https://www.postgresql.org/docs/18/datatype-datetime.html).

## Repository và soft delete

- Xóa nghiệp vụ mặc định là cập nhật `deleted_at`, không gọi physical delete. Model có `deletedAt: Date | null`; helper của model không làm DB I/O.
- Get/list/count/update, aggregate và các quan hệ phải loại bản đã xóa bằng `deleted_at IS NULL`, đồng thời giữ tenant/family/child scope. Không để count và list dùng hai bộ lọc khác nhau. Kiểm tra cả đường truy vấn raw SQL.
- Đọc thùng rác, restore và purge dùng phương thức riêng có kiểm tra quyền ở service. Quy định rõ API trả gì khi xóa lặp hoặc restore bản đã active.
- Khi nghiệp vụ cho tái sử dụng khóa sau soft delete, dùng partial unique index trên dòng active, kèm tenant scope. Không coi composite unique có `deleted_at` nullable là bảo đảm uniqueness của dòng active. Restore phải xử lý xung đột khóa. [PostgreSQL partial indexes](https://www.postgresql.org/docs/18/indexes-partial.html).
- Định nghĩa xử lý quan hệ cha/con khi soft delete/restore; FK cascade vật lý không tự thực hiện soft delete. Purge chỉ theo retention/quy trình xóa dữ liệu đã xác định, không thay bằng hard delete tùy ý.
- Bảng audit/ledger vẫn có đủ ba cột, nhưng phải giữ tính bất biến và retention riêng; có cột `deleted_at` không có nghĩa được tùy ý xóa lịch sử.

## Khi tạo hoặc sửa bảng

**Migration chỉ DDL, nghiêm cấm CRUD dữ liệu:** không INSERT/UPDATE/DELETE/MERGE/TRUNCATE hoặc seed catalog trong migration. Backend quản lý `prisma/schema.prisma` và `prisma/migrations`; seed riêng `prisma/seed.ts`/`prisma/seeds` chạy chủ động bằng `npm run db:seed`. Fixtures/backfill/business task có command và kiểm chứng riêng, không giấu trong migration hoặc startup. Trigger/constraint được định nghĩa bằng DDL, không dùng chúng để thực hiện một đợt CRUD khi migrate.

1. DBA/BACKEND đọc quy tắc này và đối chiếu schema, model, repository, generator cùng migration SQL.
2. Bảng mới hoặc bảng nối mới thiếu một trong ba cột là **chưa đạt yêu cầu**. Generator cũng phải sinh đủ cột trước khi được dùng làm đầu ra hoàn chỉnh.
3. Bảng cũ cần forward migration và kế hoạch backfill phù hợp trước khi thêm `NOT NULL`; không sửa migration đã áp dụng. Không bịa thời điểm lịch sử nếu không có nguồn; ghi rõ ý nghĩa giá trị backfill.
4. Khi triển khai thay đổi persistence: backup theo runbook, review migration, regenerate Prisma Client, đồng bộ model/repository/generator và kiểm thử DB riêng. Không tự chạy migration chỉ vì đang sửa tài liệu.
5. TESTER xác minh insert, update qua Prisma và raw SQL, soft delete, list/count/relations, uniqueness, restore và quyền theo phạm vi thay đổi. QUALITY kiểm tra mọi bảng mới đủ cột và không có đường hard delete ngoài purge đã quy định. Đây là tiêu chí bắt buộc, chưa phải tuyên bố CI hiện đã tự enforce.

## Cron và background job

Khi triển khai cron/job có nghiệp vụ, bắt buộc lưu từng lần chạy và từng lần thử vào PostgreSQL; các bảng đó cũng có đủ ba cột. Scheduler/worker gọi service qua interface/DI; repository giữ persistence/transaction. Retry, idempotency, lease/recovery và cảnh báo theo [quy tắc jobs](../../../../baby-backend/docs/jobs.md).

## Hiện trạng tại ngày ban hành

Ngày ban hành 2026-10-13, `Note` và generator còn thiếu `deleted_at`, repository hard delete; BF-20261013-003 chỉ viết quy tắc. **Cập nhật 2026-10-14:** schema/migration backend, Note/generator và domain persistence đã được đồng bộ audit/soft delete; migration ứng dụng và seed vẫn cần được áp vào từng môi trường theo workflow riêng. Bảng job/history đã có trong schema, nhưng scheduler/queue/business handler chưa được triển khai; không coi bảng là chức năng chạy thật.
