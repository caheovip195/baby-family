# Kiểm chứng database và persistence backend

Ngày: **2026-10-14**, Asia/Ho_Chi_Minh. Liên quan BF-20261013-004/005/006 và BF-20261014-001/002.

## Môi trường và nguồn cấu trúc

- [Prisma schema](../../baby-backend/prisma/schema.prisma): 123 models, gồm 122 bảng domain và Note mẫu trong `public`.
- [Forward migration](../../baby-backend/prisma/migrations/20261013150000_family_domain/migration.sql) quản lý bởi backend; giữ nguyên migration init đã có. Migration chỉ DDL, không CRUD/seed dữ liệu.
- PostgreSQL 18.6 disposable container, data tmpfs, cổng ngẫu nhiên chỉ bind localhost. Chạy `prisma migrate deploy` thực sự; không copy dữ liệu ứng dụng.
- Database ứng dụng `baby_family` và data bind mount trong baby-database không được áp migration/seed trong task này. Các database kiểm thử nằm trong container riêng.
- Đã dọn các container kiểm thử sau khi hoàn tất; container PostgreSQL ứng dụng vẫn healthy.

## Kết quả đã thực chạy

| Kiểm tra                                                 | Kết quả                                                                                                                                                                    |
| -------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Prisma format/validate/generate                          | Đạt; Prisma Client 7.10.0 sinh từ schema thực trong backend.                                                                                                               |
| `npm run prisma:check-migrations`                        | Đạt; 2 migrations không có catalog/business DML.                                                                                                                           |
| Replay init + family-domain bằng `prisma migrate deploy` | Đạt trên database sạch cách ly.                                                                                                                                            |
| Catalog ngay sau migration                               | Trống; migration không tự seed.                                                                                                                                            |
| `npm run db:seed`, chạy riêng hai lần                    | Đạt; ID/row digest catalog, versions, trial policies/config giữ nguyên.                                                                                                    |
| `npm run db:verify`                                      | Đạt: replay migration, explicit seed, audit/PK/trigger và 47 kịch bản domain.                                                                                              |
| Audit metadata                                           | 122 bảng domain đủ ba cột timestamptz(3), nullable/default đúng, PK và trigger cập nhật. Note nhận deleted_at/default updated_at/trigger bằng forward migration.           |
| Prisma diff DB cách ly → schema                          | Đạt, `No difference detected`, exit 0 đối với các tính năng Prisma biểu đạt được.                                                                                          |
| NoteService unit                                         | 6/6 đạt.                                                                                                                                                                   |
| HTTP e2e Note                                            | 10/10 đạt.                                                                                                                                                                 |
| Resource generator                                       | 10/10 đạt.                                                                                                                                                                 |
| Note PostgreSQL integration                              | 1/1 đạt trên DB ephemeral kết thúc `_test`; xóa đồng thời 204/404, row còn giữ, query/update không thấy row đã xóa.                                                        |
| Model/interface/repository coverage và DI                | 122 bộ domain + Note = 123 bộ; 122 domain providers nối AppModule. Scope tenant hoặc explicit privileged; 18 repository append-only.                                       |
| Persistence generator, hash guard                        | Đạt; `generate:persistence -- --check` kiểm 369 generated files; từ chối ghi đè file đã chỉnh tay.                                                                         |
| Domain unit, generator protection và naming              | 16/16 đạt; toàn bộ 5 unit suites có 24 tests đạt.                                                                                                                          |
| PostgreSQL integration đầy đủ                            | 2/2 đạt: Note và domain persistence trên DB cách ly `_test`.                                                                                                               |
| Migration policy regression                              | 6/6 nhóm đạt, gồm DML/CTE/DO/dynamic execution và hai migration thực. Guard là kiểm tra tĩnh bổ trợ SQL review.                                                            |
| `npm run check`                                          | Đạt: Prisma validate, persistence drift guard, format, lint, TypeScript, build, 24 unit tests, 10 resource generator tests, 6 migration policy tests và 10 HTTP e2e tests. |

47 kịch bản SQL gồm: slot Parent A/B, một user không Parent hai family, composite FK chống cross-family, grant XOR child/pregnancy, soft-delete/restore, mission scope deferred, NULL constraint, Hearts dedup/reversal/immutable, historical couple/private journal, avatar/support trước family, license không chuyển, purchaser detach, paid renewal giữ family gốc, trial7/config version không hồi tố, thêm plan bằng catalog, chống trùng Store transaction, pending job/lease và attempt history.

Các fixtures synthetic chạy trong transaction rồi rollback. Metadata [data dictionary](data-dictionary.md) chỉ đọc cột/keys/indexes/triggers của DB cách ly, không xuất business rows.

## Chạy lại

Trong `baby-backend`, cài dependencies rồi:

```bash
npm run prisma:check-migrations
npm run prisma:validate
npm run prisma:generate
npm run check
npm run db:verify
```

`db:verify` tự tạo container PostgreSQL riêng, đặt DATABASE_URL tạm cho process con, replay migration và chạy seed riêng; trap dọn container khi kết thúc/lỗi. Không dùng DATABASE_URL ứng dụng để chạy kiểm chứng. `npm run db:seed` bình thường dùng DATABASE_URL đã cấu hình nên chỉ chạy khi chủ động muốn khởi tạo catalog của môi trường đó.

## Giới hạn

SQL/Prisma/persistence không thay cho API, authorization, Apple/Google verification, queue worker hoặc đầy đủ luồng UI. Không có giao dịch Store/FCM/AI thật, không đo latency/load trên dữ liệu production, không tuyên bố exactly-once hoặc đã triển khai mọi phase. Check constraints/triggers/partial indexes cần giữ trong migration SQL; Prisma diff không chứng minh các phần ngoài khả năng biểu đạt của Prisma.

Các quyết định destructive còn mở trong [requirements](requirements.md) cần được chốt trước khi triển khai purge/account restore/family deletion executor. UI canvas là snapshot đã phân tích, chưa sửa copy90ngày trên canvas thành7ngày trong task backend này.
