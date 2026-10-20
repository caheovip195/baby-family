# BF-20261019-007 — Phạm vi A: recap tuần và HOME-01

Đã viết backend theo controller → service interface → service → repository interface → repository → model, Symbol DI. Không đổi schema/migration/seed. Không đăng ký production DI/controller/worker theo phạm vi được giao; route/job chỉ hoạt động khi người tích hợp thêm các dòng bên dưới. Không ghi nhật ký, checklist, `docs/api.md`, không sửa mobile, không commit.

## File

Mới (đường dẫn tính từ `baby-backend/`):

- `src/config/weekly-recap-policy.ts`
- `src/controllers/weekly-recap.controller.ts`
- `src/dto/recap/weekly-recap.dto.ts`
- `src/interfaces/services/weekly-recap-service.interface.ts`
- `src/interfaces/repositories/weekly-recap-repository.interface.ts`
- `src/services/weekly-recap.service.ts`
- `src/repositories/weekly-recap.repository.ts`
- `src/models/weekly-recap-data.model.ts`
- `src/workers/weekly-recap.worker.ts`
- `test/integration/weekly-recap-api.spec.ts`
- Báo cáo này.

File dùng chung `src/config/jobs.ts`: chỉ cộng một dòng `recaps: 'recaps',` vào `QUEUES`; các diff khác của file này đã có trước phiên này. Queue riêng tránh worker ký ức cũ nhận nhầm job recap.

## Hợp đồng HTTP

Tiền tố `/api/v1`; mọi GET yêu cầu `Authorization: Bearer <access-token>`, không có JSON request body. ID là UUID. Response bên dưới gồm envelope hiện có của ứng dụng; số liệu là ví dụ minh họa cấu trúc, không phải dữ liệu vận hành.

### GET /families/:fid/recaps/weekly?cursor=2026-10-12&limit=20

`limit` mặc định 20, từ 1 đến 50; `cursor` là `periodStart` YYYY-MM-DD của phần tử cuối trang trước. Sắp xếp kỳ mới nhất trước, lọc visibility trước phân trang. Không có dữ liệu: `items: []`, `nextCursor: null`.

```json
{
  "data": {
    "items": [
      {
        "id": "00000000-0000-4000-8000-000000000001",
        "periodStart": "2026-10-05",
        "periodEnd": "2026-10-11",
        "visibility": "PARENTS",
        "content": {
          "version": 1,
          "stats": {
            "weekStart": "2026-10-05",
            "memoryCount": 1,
            "photoCount": 1,
            "videoCount": 0,
            "milestoneCount": 0,
            "byChild": [
              {
                "childId": "00000000-0000-4000-8000-000000000002",
                "memoryCount": 1
              }
            ],
            "missionsDone": 0
          },
          "topMemories": [{ "id": "00000000-0000-4000-8000-000000000003" }],
          "milestones": []
        },
        "coverAssetId": "00000000-0000-4000-8000-000000000004",
        "contentParentsOnly": { "version": 1, "appreciationCount": 0 }
      }
    ],
    "nextCursor": null
  }
}
```

### GET /families/:fid/recaps/weekly/latest

Response 200: `{"data": <một phần tử items như trên>}`. Không có recap xem được: 404 `NOT_FOUND`.

Circle chỉ nhận recap `scope=FAMILY`, `period=WEEK`, `visibility=FAMILY`, trạng thái READY/SAVED/SHARED. Circle không nhận khóa `contentParentsOnly` và `content.stats.missionsDone`. Top ký ức, ảnh bìa, cột mốc, số liệu đều được tính lại theo grants hiện tại: ký ức gắn lẫn bé được/không được cấp quyền bị loại toàn bộ. Không còn ảnh hợp lệ: `coverAssetId: null`. Parent cũng tính lại nội dung để tránh trả nội dung đã xoá/thu hồi. Không đưa ký ức PRIVATE hoặc thư còn niêm phong vào recap, kể cả người gọi là tác giả.

### GET /families/:fid/home/week-stats

```json
{
  "data": {
    "weekStart": "2026-10-19",
    "memoryCount": 1,
    "photoCount": 1,
    "videoCount": 0,
    "milestoneCount": 0,
    "byChild": [
      { "childId": "00000000-0000-4000-8000-000000000002", "memoryCount": 1 }
    ],
    "missionsDone": 0
  }
}
```

`missionsDone` chỉ Parent; không có Hearts hay số theo từng Parent. Trang chủ tính trực tiếp, chỉ ký ức PUBLISHED người xem có quyền (bao gồm PRIVATE của chính Parent, không của người khác), áp block/report-hide. Tuần và các khoảng thời gian tính theo timezone gia đình, từ thứ Hai đến Chủ nhật. Ký ức mới lấy theo `published_at` trong tuần địa phương; ảnh/video đếm asset READY, shared, chưa xoá, không trùng asset. Cột mốc đếm các hàng milestone còn hiệu lực liên kết ký ức được chọn; `milestones[]` chứa tối đa 10 memory ID riêng biệt. `byChild` chỉ chứa bé có ký ức được đếm; ký ức nhiều bé chỉ tính một lần ở tổng.

### Lỗi

- 400 `VALIDATION_ERROR`: limit ngoài 1..50, cursor sai định dạng/ngày hoặc query không hỗ trợ.
- 400 `BAD_REQUEST`: fid không phải UUID (ParseUUIDPipe).
- 401 `UNAUTHORIZED`: thiếu/sai Bearer; các lỗi xác thực token/phiên giữ theo AuthenticationService hiện có.
- 404 `NOT_FOUND`: không có recap xem được, gia đình không tồn tại/người ngoài.
- 403 `CIRCLE_PAUSED`: gói/capability/lifecycle không cho Circle xem; `CIRCLE_ACCESS_REVOKED` khi thành viên bị thu hồi.
- Parent đọc qua access mode `download`: gói hết hạn vẫn đọc; các kiểm tra membership/lifecycle/license hiện có tiếp tục áp dụng (`FAMILY_NOT_ACTIVE`, `LICENSE_BLOCKED`, `SUBSCRIPTION_REQUIRED` khi không có entitlement hợp lệ cho đọc).

## Job, idempotency và recovery

`WEEKLY_RECAP_JOB`: queue `recaps`, tên `recap.weekly-build`, 3 attempts, exponential backoff bắt đầu 10 giây, lease 300 giây. Worker mới dùng `IJobRunnerService` để lưu `ops.job_runs`/`job_attempts`, heartbeat, fencing và phục hồi lease; shutdown dùng drain hiện có.

Tick mỗi giờ; kỳ tuần theo timezone từng gia đình đã kết thúc. Mỗi lần chạy quét toàn bộ ACTIVE families theo keyset, tối đa 25 gia đình mỗi truy vấn; mỗi gia đình xét tối đa 4 tuần đã kết thúc. Đây là giới hạn mỗi batch, không phải 25 gia đình mỗi run. Tick bị lỡ được gộp; downtime trên 4 tuần cần backfill được vận hành chủ động, không tự replay mọi tuần lịch sử.

Tuần không có ký ức công khai cho Parent, nhiệm vụ DONE hoặc lời cảm ơn còn hiệu lực sẽ bỏ qua. Top tối đa 10, điểm `reaction_count * 2 + comment_count`. Job tạo mặc định visibility PARENTS để Parent xem trước khi chia sẻ. API chia sẻ/đổi visibility nằm ngoài phạm vi A.

Khóa dòng family + lookup/update-or-create theo family/FAMILY/null/WEEK/periodStart; unique NULLS NOT DISTINCT đã có trong migration nền. Cập nhật không đổi visibility/status người dùng đã chọn, không hồi sinh recap/snapshot soft-deleted. Recap và snapshot ghi cùng transaction, fence kiểm tra đầu/cuối. Snapshot merge `metrics.recapWeekly` version 1, giữ các khóa metric khác. Chỉ `content_parents_only` chứa số lời cảm ơn; không đọc/giải mã nội dung lời cảm ơn, không trả dữ liệu Papa & Mama cho Circle.

## Các dòng tích hợp phải thêm (chưa sửa trong phiên này)

### HTTP composition: src/common/application/application.providers.ts

Thêm import (đường dẫn tương đối của chính file):

```ts
import { WeeklyRecapController } from '../../controllers/weekly-recap.controller';
import { WeeklyRecapRepository } from '../../repositories/weekly-recap.repository';
import { WeeklyRecapService } from '../../services/weekly-recap.service';
import { WEEKLY_RECAP_REPOSITORY } from '../../interfaces/repositories/weekly-recap-repository.interface';
import { WEEKLY_RECAP_SERVICE } from '../../interfaces/services/weekly-recap-service.interface';
```

Thêm vào `APPLICATION_CONTROLLERS`:

```ts
WeeklyRecapController,
```

Thêm vào `APPLICATION_PROVIDERS` (ApplicationAccessService, MemoryLibraryRepository, auth guard đã có):

```ts
{ provide: WEEKLY_RECAP_REPOSITORY, useClass: WeeklyRecapRepository },
{ provide: WEEKLY_RECAP_SERVICE, useClass: WeeklyRecapService },
```

### Worker composition: src/workers/worker.module.ts

```ts
import { WeeklyRecapQueueWorker } from './weekly-recap.worker';
import { WeeklyRecapRepository } from '../repositories/weekly-recap.repository';
import { WeeklyRecapService } from '../services/weekly-recap.service';
import { WEEKLY_RECAP_REPOSITORY } from '../interfaces/repositories/weekly-recap-repository.interface';
import { WEEKLY_RECAP_SERVICE } from '../interfaces/services/weekly-recap-service.interface';
```

Thêm vào `providers` (JobRunner/JobQueue/ApplicationAccess/Prisma hiện đã có):

```ts
{ provide: WEEKLY_RECAP_REPOSITORY, useClass: WeeklyRecapRepository },
{ provide: WEEKLY_RECAP_SERVICE, useClass: WeeklyRecapService },
WeeklyRecapQueueWorker,
```

Worker tự gọi dòng đăng ký lịch dưới đây trong `onApplicationBootstrap`, đã có trong file mới, không cần thêm vào maintenance SCHEDULES hay worker ký ức cũ:

```ts
await this.queue.schedule(WEEKLY_RECAP_JOB, WEEKLY_RECAP_POLICY.everyMs);
```

## Kiểm chứng và giới hạn

Integration dùng Nest module riêng, ES256 ký/verify token trong fixture, application access/repository/job runner/PostgreSQL thật. AuthenticationService được thay bằng verifier JWT của spec; kiểm tra đầy đủ thu hồi phiên không thuộc spec này. DB bị chặn nếu tên khác `baby_family_test`. Chỉ mock danh sách gia đình để job quét đúng gia đình spec; không chạy full suite. Gia đình và user/session fixture được soft-delete khi dọn.

6 test: job hai run không trùng và replay cùng key; lịch sử run; counts media/milestone/mission/thanks; snapshot merge; fence cũ bị từ chối; PRIVATE/sealed; visibility Circle và mixed-child ACL/cover; route/home/paging/error; expired Parent vs Circle; local Monday/DST.

Chưa thử BullMQ/Redis lifecycle thật hoặc production routes chưa được đăng ký. Không chạy migration/seed/deploy. Không có dữ liệu đo sản phẩm thực tế.

## Lệnh thực chạy — kết quả cuối

Tất cả chạy trong `baby-backend/`:

| Lệnh                                                                            | EXIT | Kết quả                                          |
| ------------------------------------------------------------------------------- | ---- | ------------------------------------------------ |
| `npx tsc --noEmit -p tsconfig.json`                                             | 0    | Không lỗi TypeScript                             |
| `npm run generate:services -- --check`                                          | 0    | 117 services/interfaces, 236 files               |
| `npm run generate:persistence -- --check`                                       | 0    | 122 models/interfaces/repositories, 369 files    |
| `TEST_SMTP_HOST=127.0.0.1 npm run test:integration -- weekly-recap-api.spec.ts` | 0    | 1 suite, 6 test pass, chạy tuần tự `--runInBand` |
| `git diff --check -- src/config/jobs.ts`                                        | 0    | Không lỗi whitespace                             |

Lệnh kiểm tra format thực chạy, EXIT 0 (tất cả file phù hợp Prettier):

```sh
npx prettier --check src/config/jobs.ts src/config/weekly-recap-policy.ts src/dto/recap/weekly-recap.dto.ts src/models/weekly-recap-data.model.ts src/interfaces/repositories/weekly-recap-repository.interface.ts src/interfaces/services/weekly-recap-service.interface.ts src/services/weekly-recap.service.ts src/controllers/weekly-recap.controller.ts src/repositories/weekly-recap.repository.ts src/workers/weekly-recap.worker.ts test/integration/weekly-recap-api.spec.ts docs/handoffs/BF-20261019-007-A-weekly-recap.md
```

Lệnh lint thực chạy, EXIT 0 (không warning):

```sh
npx eslint --max-warnings=0 src/config/jobs.ts src/config/weekly-recap-policy.ts src/dto/recap/weekly-recap.dto.ts src/models/weekly-recap-data.model.ts src/interfaces/repositories/weekly-recap-repository.interface.ts src/interfaces/services/weekly-recap-service.interface.ts src/services/weekly-recap.service.ts src/controllers/weekly-recap.controller.ts src/repositories/weekly-recap.repository.ts src/workers/weekly-recap.worker.ts test/integration/weekly-recap-api.spec.ts
```

Đã chạy `npx prettier --write` trên các file tạo/sửa, EXIT 0. Các lần kiểm tra đầu từng có EXIT 1: TypeScript thiếu interface/constructor của phần phiên song song đang cập nhật (đã hết ở lần cuối); lint model import DTO và vòng lặp hằng (đã sửa); integration setup lấy PinoLogger transient bằng get và fixture nhiệm vụ CUSTOM thiếu createdBy (đã sửa). Không coi những lần thất bại đó là pass.

Review độc lập SECURITY_PRIVACY/QUALITY đã đọc code và không còn blocker; reviewer không chạy test. Các kiểm tra/runtime phía trên do agent triển khai chạy. Chưa có kiểm thử crash/heartbeat với Redis thật hoặc HTTP pagination qua nhiều trang dữ liệu.
