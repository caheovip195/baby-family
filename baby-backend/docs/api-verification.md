# Kiểm chứng service/controller

Ngày **2026-10-14**, Asia/Ho_Chi_Minh · BF-20261014-003. [API scope](api.md) ghi các route và phần workflow chưa triển khai.

## Checks thực tế

- `npm run check`: Prisma validate, DDL policy, persistence drift 369 files, service drift 236 files, format, ESLint, TypeScript, build, unit, resource generator, migration policy và HTTP tests đều đạt.
- Unit toàn bộ: 115 tests / 11 suites. Trong đó 117 internal services/generator có 12 tests; core service/command repo có 41 tests; auth/access/catalog/billing có 38 tests. Các test này kiểm đường đại diện và guard generator, không phải thử mọi method của mọi bảng trên DB thật.
- HTTP: 34 tests / 2 suites; 24 cases core API dùng guard thật và thay auth/repository qua DI, giữ 10 cases Note cũ.
- PostgreSQL integration: **17 tests / 3 suites** đạt trên PostgreSQL 18.6 disposable container, tmpfs, localhost port ngẫu nhiên, database riêng kết thúc `_test`. Replay 2 migration và seed riêng; không copy dữ liệu hoặc dùng DATABASE_URL ứng dụng.
- Trong 15 cases API+DB mới: ES256 signature/session thật, self scope, mass assignment, revoked/replaced/expiry/absolute expiry/user status/tokenVersion, dynamic catalog/version visibility, trial config từ DB, BigInt precision, Parent/foreign-family gate, expired billing metadata và content gate.
- Hai Pregnancy POST đồng thời cùng family trả 201 với seqNo 8/9 sau một bản ghi synthetic đã xóa mềm seqNo7; xác minh không tái dùng sequence, actor tạo do server đặt, body seqNo/createdBy bị từ chối và không tạo thêm row.
- `docker compose --env-file .env.example config --quiet` đạt. `npm audit --omit=dev` có 0 vulnerabilities; không dùng audit fix hoặc thay các override development có trước.
- Review độc lập internal services, JWT/session/activation và 5 API core đạt; đã sửa regression PARTNER_LEFT + BLOCKED và trialEndsAt boundary. Chưa thực hiện load test hoặc kiểm provider/Store/FCM/AI thật.

## Chạy lại

```bash
npm run check
# Chỉ dùng DB kiểm thử riêng đã migrate; fixtures chỉ tác động dữ liệu synthetic của test.
TEST_DATABASE_URL='postgresql://<test-user>:<test-password>@127.0.0.1:<port>/<name>_test' npm run test:integration
```

Tests không tắt trigger hoặc TRUNCATE lịch sử được bảo vệ. Fixture billing/history giữ soft delete khi DB cấm physical delete; hủy container disposable sau kiểm thử dọn toàn bộ dữ liệu kiểm chứng. Không áp migration/seed lên `baby_family` hoặc thay server/data mount ứng dụng trong task này.

Container kiểm thử đã được dọn sau khi hoàn tất; `baby-database-postgres-1` vẫn healthy.

Auth verifier chỉ nhận key issuer được cấu hình; tests tự sinh key dùng một lần. Không có private key, bypass đăng nhập, Store token hoặc dữ liệu người dùng thật được ghi vào source/lịch sử.
