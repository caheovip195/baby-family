# Outbox consumers — BF-20261021-002 B

Đối chiếu code phát event tại `src/repositories/`, `CoupleRequestService` và §3.3/§6.6/§15 tài liệu kỹ thuật, §7.14 nghiệp vụ. Tên event thực tế dùng cả PascalCase đời đầu và dotted names; không tự đổi contract đã ghi trong DB.

## Cách phân loại và recovery

`src/config/jobs.ts` là nguồn sự thật: `OUTBOX_ROUTES` chọn consumer chính, `OUTBOX_ADDITIONAL_ROUTES` chọn consumer bổ sung, `OUTBOX_NO_CONSUMER` ghi lý do cụ thể cho event không cần consumer bất đồng bộ. Relay claim cả hai nhóm đã audit. Event không biết vẫn unpublished để điều tra, không tự bỏ.

Consumer chính giữ queue ID `evt-${eventId}` để tương thích. Consumer bổ sung có ID `evt-${eventId}-${job.name}`. Relay chỉ ghi `published_at` sau khi mọi enqueue thành công. Nếu crash/lỗi sau consumer đầu, lần sau enqueue lại với cùng ID: queue và `job_runs` chống trùng; không bỏ sót consumer sau. Lease/fencing và exponential backoff của outbox giữ nguyên. Event terminal chỉ được acknowledge qua repository có fencing, không xóa row và không enqueue job rỗng.

Job nghiệp vụ dùng `JobRunnerService`/`JobExecutionRepository`: run, attempts, lease, fencing, retry tối đa theo policy. Consumer không ghi Prisma trong service.

## Consumer hiện có và bổ sung

| Event                                                                                                                             | Consumer                                                                                                     |
| --------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| `billing.store-notification`                                                                                                      | `billing.process-store-notification`                                                                         |
| `mission.changed`                                                                                                                 | `care.award-badges`                                                                                          |
| `memory.created`, `memory.restored`, `memory.perspective.changed`                                                                 | `care.award-badges`: xử lý Hearts ký ức/góc nhìn trước rồi đánh giá huy hiệu                                 |
| `memory.published`                                                                                                                | `notify.resolve-and-dispatch` + `care.award-badges` (quan trọng khi media mới chuyển PROCESSING → PUBLISHED) |
| `event.changed`                                                                                                                   | `event.plan-reminders`                                                                                       |
| `media.asset_uploaded`                                                                                                            | `media.process-asset`                                                                                        |
| `memory.review_requested`, `memory.submitted`, `memory.approved`, `memory.rejected`, `comment.created`, `reaction.changed`        | `notify.resolve-and-dispatch`                                                                                |
| `us.request.sent`, `us.request.created`, `us.request.accept`, `us.request.decline`, `us.request.acknowledge`, `us.checkin.shared` | `notify.resolve-and-dispatch`                                                                                |
| `us.request.done`, `us.appreciation.created`                                                                                      | `notify.resolve-and-dispatch` + `care.award-badges`                                                          |
| `mail.transactional`                                                                                                              | `mail.deliver-transactional` qua worker email riêng; policy chính xác ở `transactional-mail-policy.ts`       |

`memory.submitted`/`us.request.created` là alias tương thích đã cấu hình, không khẳng định code hiện tại đang phát chúng.

Hearts nhiệm vụ và Lời nhờ đã ghi trong transaction nghiệp vụ, không chạy consumer cộng lần hai. Memory/perspective trước đây chưa có writer: bổ sung `MemoryHeartAwardService` → `IMemoryHeartAwardRepository` → `MemoryHeartAwardRepository`, gọi từ `BadgeAwardService` qua dependency optional để test module cũ không bị vỡ. Khi triển khai phải bind dependency này trong worker để bật hành vi.

Hearts ký ức/góc nhìn chỉ cho Parent đang active, nội dung gốc phải PUBLISHED/chưa trash/delete, có text/title hoặc media READY; góc nhìn phải ACTIVE và có nội dung. Người thân không được nhận Hearts. Policy version 1 cấp +2, chung `memory_count` tối đa 5 lần/người/ngày; trần tổng lấy `HEARTS_POLICY.dailyHeartCap` (75). Ngày tính theo `created_at` của nguồn và timezone gia đình, không dùng ngày xảy ra do client chọn hoặc ngày retry của worker. Khóa `(user, localDate)`, unique ledger theo nguồn/reason và family/tree serialization ngăn cộng trùng/vượt trần; partial award còn 1 điểm khi tổng đang 74. Xóa/khôi phục không thu hồi hoặc cộng lại ledger cũ. Không đưa điểm cá nhân vào payload outbox, inbox hoặc response mới.

Feed/timeline/search đang đọc PostgreSQL cùng ACL, chưa có Elasticsearch/materialized cache để invalidation. Không thêm consumer no-op giả làm indexer.

## Event đã phát nhưng không cần consumer riêng

Tất cả event dưới đây trước đợt audit chưa có route. Nay có disposition rõ và relay acknowledge, giữ row:

| Events                                                                                                                                                                                                            | Lý do                                                                                                                                                                                                          |
| ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `FamilyCreated`, `PartnerLinked`, `TrialStarted`                                                                                                                                                                  | Family/member/license/trial đã transaction; reminder hiện có scan nguồn                                                                                                                                        |
| `badge.earned`                                                                                                                                                                                                    | Badge và inbox theo đúng recipient đã ghi cùng transaction; không gửi thông báo hai lần hoặc lộ Hearts riêng                                                                                                   |
| `memory.changed`, `memory.updated`, `memory.trashed`, `memory.purged`, `comment.deleted`                                                                                                                          | Truy vấn trực tiếp trạng thái/ACL; trash event còn là nguồn audit cho restore                                                                                                                                  |
| `memory.letter.released`                                                                                                                                                                                          | Unlock/visibility đã ghi; truy vấn trực tiếp đọc thư đã mở. Hiện chưa có template notification riêng, không giả claim đã gửi inbox                                                                             |
| `memory.original.downloaded`                                                                                                                                                                                      | Audit download; link đã ký ở đường request                                                                                                                                                                     |
| `child.order_changed`, `child.status_changed`, `child.profile_changed`, `pregnancy.profile_changed`, `pregnancy.status_changed`, `pregnancy.birth_converted`, `pregnancy.prep.changed`, `family.settings.changed` | Projection, lifecycle/access version và chuyển sinh đã được persist; client đọc nguồn trực tiếp                                                                                                                |
| `family.entitlement.changed`                                                                                                                                                                                      | Billing đã persist projection trong transaction                                                                                                                                                                |
| `family.entitlement.recompute`                                                                                                                                                                                    | Khi xóa một Parent và người kia tiếp tục, license vẫn thuộc family; trạng thái PARTNER_LEFT/access version chặn đường quyền. Không có consumer recompute riêng; event không được hiểu là đã chạy recomputation |
| `family.deletion_scheduled`, `family.deletion_cancelled`, `family.deleted`                                                                                                                                        | Executor/mail reconciliation scan request, kiểm lại trạng thái và quyền hiện tại; cancellation không gửi email cũ                                                                                              |
| `us.request.reminder_set`, `us.request.seen`, `us.request.cancel`, `us.request.expired`                                                                                                                           | Preference/read receipt/state đã persist; chưa có template notification cho những transition này                                                                                                               |
| `us.journal.created`, `us.journal.deleted`, `us.journal.shared`                                                                                                                                                   | Dữ liệu riêng; projection chia sẻ chỉ đọc qua couple ACL, không fan-out ra family                                                                                                                              |
| `us.appreciation.reacted`, `us.appreciation.share_requested`, `us.appreciation.share_approved`, `us.appreciation.share_rejected`                                                                                  | State được đọc qua couple ACL; share approved đã phát memory.created/published riêng                                                                                                                           |
| `auth.email_verified`                                                                                                                                                                                             | Proof email đã được external verifier xác minh. Không queue; giữ row làm bằng chứng kiểm tra hash với identity hiện tại                                                                                        |

`auth.email_verified` phải giữ tới identity revoked/account erasure, không đưa vào cleanup outbox published 7 ngày; chưa có cleanup tự động cho proof. `published_at` chỉ có nghĩa delivery/disposition hoàn tất, không phải quyền purge. Giữ outbox rows mà restore, security proof, notification dispatch còn cần; retention phải kiểm từng loại trước khi bổ sung purge job.

## Đăng ký DI cần tích hợp

Không sửa composition root/worker module theo phạm vi yêu cầu. Trong worker providers, bổ sung đúng hai binding và import tương ứng:

```ts
{ provide: MEMORY_HEART_AWARD_REPOSITORY, useClass: MemoryHeartAwardRepository },
{ provide: MEMORY_HEART_AWARD_SERVICE, useClass: MemoryHeartAwardService },
```

Không thêm worker hoặc schedule cho Hearts/badges: `CareQueueWorker` đang gọi `BadgeAwardService`, lease/retry/history giữ nguyên. Email có bindings/worker/schedule riêng, xem handoff B.

## Kiểm chứng

`test/integration/outbox-consumers.spec.ts` tạo Nest module riêng: queue fake + persistence PostgreSQL thật, relay chỉ nhận row thuộc family fixture (không claim row của spec/phiên khác). Kiểm partial enqueue failure/retry, distinct stable queue IDs, terminal acknowledge/unknown retained, badge và private recipient idempotence, memory/perspective quota/trần/tree. Không kiểm Redis/BullMQ thật trong spec này; durability handler đi qua runner PostgreSQL thật.
