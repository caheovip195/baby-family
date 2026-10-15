# Cron và background job

Trạng thái ngày 2026-10-13: **quy tắc thiết kế**. Cập nhật 2026-10-15 (BF-20261015-010): đã có worker BullMQ đầu tiên; xem [Triển khai hiện có](#triển-khai-hiện-có-2026-10-15). Các quy tắc dưới đây vẫn bắt buộc cho mọi job mới.

## Cron có tự lưu DB không?

Không. `@Cron()` của Nest gọi hàm theo lịch trong process; exception được catch/log, không tự tạo bảng lịch sử PostgreSQL hoặc retry bền vững. `waitForCompletion` bỏ tick mới khi callback còn chạy trong instance đó; nhiều replica vẫn cần điều phối riêng. [Nest task scheduling](https://docs.nestjs.com/application/task-scheduling).

Với Baby Family, khi triển khai job nghiệp vụ phải có lịch sử PostgreSQL để biết job nào đã chạy, đang chạy, lỗi và thử lại bao nhiêu lần. Log console chỉ hỗ trợ chẩn đoán.

## Trách nhiệm theo kiến trúc hiện tại

```text
Scheduler / Worker
  → IJobService / JobService
  → IJobRepository / JobRepository
  → Prisma / PostgreSQL
```

Scheduler chỉ tạo yêu cầu chạy. Worker gọi service để xử lý nghiệp vụ; service gọi các repository interface qua DI. Repository sở hữu CRUD/claim/transaction, model chứa attributes/helpers. Bind interface bằng Symbol token trong AppModule; không nhét Prisma hoặc nghiệp vụ vào callback cron. Đây là vai trò dự kiến, chưa có các class này trong source.

## Lịch sử lưu trong PostgreSQL

Thiết kế tối thiểu gồm hai bảng do dự án quản lý; cả hai tuân thủ [chuẩn ba cột audit](../../.agents/skills/baby-family-team/references/database-standards.md):

| Bảng dự kiến   | Nội dung                                                                                                                                                                                     |
| -------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `job_runs`     | Một lần chạy logic: job name, scope, kỳ chạy `scheduled_for`, idempotency key, status, thời điểm bắt đầu/kết thúc, max attempts, next retry, worker/lease/heartbeat và lỗi cuối đã làm sạch. |
| `job_attempts` | Mỗi lần thử của run: attempt number, started/finished, status, lease/fencing token và mã/tóm tắt lỗi. Unique `(run_id, attempt_number)`.                                                     |

`created_at` không thay thế `scheduled_for`, `started_at` hoặc `finished_at`. Thời gian chạy tính từ started/finished. Không ghi payload thô, secrets, nội dung ký ức hoặc dữ liệu riêng tư của gia đình vào error/history.

Định nghĩa lịch có thể nằm trong code. Chỉ thêm `job_schedules` khi cần lịch động/quản trị trong DB; nếu thêm cũng bắt buộc đủ ba cột. Mỗi lịch phải khai báo timezone và cách xử lý kỳ bị lỡ: catch-up, gộp kỳ hoặc skip có lý do. Không mặc định chạy lại mọi tick sau downtime.

Run có unique key theo **job + phạm vi nghiệp vụ + thời điểm kỳ chạy**, giữ nguyên qua các retry. Không soft delete/purge run còn pending/running/retry. Retention lịch sử phải giữ khóa chống trùng đủ lâu hoặc có ledger riêng, tránh purge xong chạy lại cùng kỳ.

## Trạng thái và cách xử lý lỗi

Luồng run: `PENDING → RUNNING → SUCCEEDED`. Lỗi tạm thời: `RUNNING → RETRY_WAIT → RUNNING`; lỗi vĩnh viễn hoặc hết lượt: `FAILED`. Kỳ được bỏ theo chính sách có trạng thái `SKIPPED` và lý do.

Mỗi attempt kết thúc là `SUCCEEDED`, `FAILED` hoặc `TIMED_OUT`; không ghi đè/mất attempt cũ khi retry. Ví dụ mặc định đề xuất **3 attempts tổng cộng**: lần đầu, thử lại sau khoảng 10 giây, thử lại sau khoảng 20 giây, thêm jitter; từng job có thể cấu hình khác. Lỗi mạng tạm thời/provider 5xx có thể retry; dữ liệu không hợp lệ hoặc thiếu quyền không retry tự động.

Sau thất bại cuối: giữ lỗi và lịch sử, phát cảnh báo qua hệ thống monitoring, cho phép kiểm tra/chạy lại có kiểm soát. Manual retry bổ sung attempt và dấu vết người/thao tác, giữ business idempotency key và kết quả đã có; không xóa history để giả như chưa từng lỗi.

Outbox delivery trong đặc tả kỹ thuật §9 cho phép retry tiếp đến khi phát thành công: giữ bản ghi pending, backoff có giới hạn delay và cảnh báo khi tồn lâu; không áp dụng giới hạn 3 lần rồi bỏ mất sự kiện. Chính sách retry phải được khai báo riêng theo loại job.

## Worker chết, chạy trùng và DB mất kết nối

1. Claim run bằng thao tác DB nguyên tử trong transaction ngắn; chỉ chạy nghiệp vụ sau claim thành công. Lease có expiry, heartbeat và fencing token; cập nhật trạng thái/checkpoint phải khớp ownership hiện tại. Không giữ transaction mở suốt một tác vụ mạng dài.
2. Scheduler nhiều replica dùng unique run key và cơ chế claim/distributed coordination. `waitForCompletion` không thay thế các bảo đảm này. Khi shutdown, ngừng nhận job mới trước khi đóng kết nối.
3. Job phải idempotent: retry hoặc crash sau side effect không được gửi thông báo, cộng quyền lợi hoặc xóa asset lần hai. Với thay đổi DB, commit nghiệp vụ + completion/outbox cùng transaction khi phù hợp; ack queue sau commit. Với provider ngoài, truyền idempotency key nếu được hỗ trợ và có checkpoint/reconciliation khi kết quả chưa xác định.
4. Reconciler phát hiện lease/heartbeat hết hạn, đánh dấu attempt timeout và đưa run về retry hoặc failed theo policy. Timeout cần hủy công việc thực sự khi có thể; chỉ `Promise.race`/đổi status không dừng callback cũ. Fencing phải bảo vệ từng ghi dữ liệu, và side effect ngoài vẫn cần idempotency.
5. **DB down thì không thể bảo đảm ghi lỗi ngay vào DB.** Trước claim: chưa chạy nghiệp vụ, không ack/report success; giữ yêu cầu trong queue bền vững hoặc để scheduler catch-up sau phục hồi. Trong lúc đang chạy: có thể chưa biết side effect đã xong chưa, phải reconcile bằng checkpoint/idempotency. Cảnh báo dependency/missing heartbeat qua monitoring bên ngoài DB; bổ sung trạng thái khi DB hoạt động lại, không bịa kết quả.
6. Worker readiness phải có truy vấn/claim DB thực sự thành công; không coi chỉ khởi tạo client hoặc `$connect()` là bằng chứng DB reachable. Chưa có worker trong base nên đây là tiêu chí triển khai, không phải hành vi startup đã xác minh.

Không hứa xử lý exactly-once cho cả DB và provider ngoài. Mục tiêu là nhận lại được công việc và an toàn khi chạy lặp.

## Queue khi triển khai

Đặc tả dự án §9/§14 định hướng BullMQ trên Redis và transactional outbox. BullMQ hỗ trợ retry qua attempts/backoff và phục hồi stalled job, nhưng không tự tạo history PostgreSQL hoặc bảo đảm handler idempotent. Với lựa chọn Redis này, phải cấu hình persistence, eviction, retention và monitoring; outbox ghi cùng transaction nghiệp vụ rồi dispatcher enqueue để tránh DB commit nhưng mất yêu cầu chạy. Chưa cài thêm package/hạ tầng trong task này. [BullMQ retry](https://docs.bullmq.io/guide/retrying-failing-jobs), [idempotent jobs](https://docs.bullmq.io/patterns/idempotent-jobs), [production](https://docs.bullmq.io/guide/going-to-production).

## Tiêu chí kiểm tra khi có implementation

- Thành công, lỗi tạm thời, lỗi vĩnh viễn, hết attempts và manual retry đều có đúng run/attempt history.
- Hai scheduler/worker nhận cùng kỳ chỉ tạo một run logic; retry không lặp side effect.
- Crash trước/sau commit hoặc trước ack, lease hết hạn và stale worker được phục hồi đúng ownership.
- DB/queue/provider down không báo success giả; recovery và missed-schedule policy có kiểm thử.
- Cả bảng job/join/history đều có ba cột audit; raw SQL cập nhật timestamp, retention không phá idempotency và logs không lộ dữ liệu riêng tư.

Đây là các kiểm tra bắt buộc khi triển khai, chưa phải kết quả test runtime của task tài liệu này.

## Triển khai hiện có (2026-10-15)

Tiến trình riêng `node dist/workers/worker.js` (`npm run start:worker`, service Compose `worker`, image target `worker` có ffmpeg). `src/workers/` chỉ chứa entrypoint, `WorkerModule` (composition root) và adapter BullMQ/vòng lặp; mọi nghiệp vụ đi qua service interface, không có Prisma trong callback.

| Thành phần                                                                         | Vai trò                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ---------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `JobRunnerService` + `JobExecutionRepository`                                      | Mỗi lần chạy = một attempt của `ops.job_runs` (unique `idempotency_key` + `(job_name, scope_key, scheduled_for)`). Claim trong transaction ngắn: `PENDING/RETRY_WAIT` hoặc `RUNNING` có lease hết hạn (attempt cũ → `TIMED_OUT`); tăng `fencing_token`, ghi `job_attempts`. Heartbeat gia hạn lease theo fencing; mất lease thì hủy handler (AbortSignal). Thành công/thất bại chỉ ghi khi fencing khớp. Handler nhận lease để ghi nghiệp vụ cũng kiểm fencing trong transaction của nó. |
| Lỗi                                                                                | `PermanentJobError` (dữ liệu sai, media hỏng, checksum, vượt thời lượng) → run `FAILED`, BullMQ `UnrecoverableError`, không retry. Lỗi khác → `RETRY_WAIT` với backoff mũ, rethrow để BullMQ retry (`attempts` = `max_attempts`, `maxStalledCount` cùng giá trị). Run đang bị lease khác giữ → BullMQ job chuyển sang delayed 30 giây, không tốn attempt. Hết lượt → `FAILED` + log error. Lỗi lưu vào DB chỉ gồm mã và thông điệp do code đặt; lỗi lạ chỉ lưu tên lỗi.                  |
| `OutboxRelayService` + `OutboxRelayLoop`                                           | Poll `ops.outbox_events` (1 giây) theo loại có route trong [jobs.ts](../src/config/jobs.ts), claim bằng lease + fencing + `SKIP LOCKED`, enqueue với jobId = event id (không enqueue trùng), rồi `published_at`. Lỗi enqueue: giữ pending, backoff mũ tối đa 5 phút, log error khi ≥ 10 lần; không giới hạn số lần. Loại sự kiện chưa có route vẫn pending cho consumer tương lai.                                                                                                       |
| `media.process-asset` (queue `media`, 5 attempts, backoff 10 giây)                 | Xem [Media](api.md#media-đặc-tả-102-105).                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| `media.purge-orphans`, `media.reconcile-uploads` (queue `maintenance`, 3 attempts) | BullMQ job scheduler mỗi 15 phút; run key theo đầu kỳ 15 phút nên nhiều replica chỉ tạo một run/kỳ. Kỳ bị lỡ khi worker tắt bị bỏ qua (skip): mỗi run xử lý toàn bộ backlog nên kỳ kế tiếp bắt kịp.                                                                                                                                                                                                                                                                                      |
| `WorkerHeartbeat`                                                                  | Ghi file heartbeat chỉ sau khi `SELECT 1` và Valkey `PING` thành công; healthcheck Docker kiểm tra file mới hơn 60 giây.                                                                                                                                                                                                                                                                                                                                                                 |

Shutdown: `onModuleDestroy` dừng nhận job và chờ job đang chạy tối đa 45 giây (quá hạn thì nhả job thành stalled, DB lease hết hạn sẽ được nhận lại), dừng relay/heartbeat; Prisma, Valkey và producer queue đóng sau cùng ở `onApplicationShutdown`. Job queue có thể mất (hết lượt khi DB lỗi, mất dữ liệu Valkey): `reconcile-uploads` dựa trên PostgreSQL để enqueue lại. Chưa có màn quản trị manual retry và cảnh báo monitoring ngoài log; job mới phải theo cùng `JobRunnerService`.
