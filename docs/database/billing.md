# License thuộc family

## Quyết định đã chốt

Người dùng xác nhận ngày 2026-10-13: **user mua Pro nhưng license/quyền lợi thuộc family, không đi theo user**. Đặc tả nghiệp vụ §5.1/BR-055 cũng mô tả gói áp dụng cả gia đình.

Người dùng đã trả lời cả ba điểm thương mại trong BF-20261013-005:

| Mã      | Quyết định                                                                            | Cách thiết kế                                                                                                                     |
| ------- | ------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| BILL-Q1 | Giữ House + Family, trial mặc định **7 ngày**, cho thêm gói mới.                      | Plan/catalog có version; không enum danh sách gói hoặc `users.is_pro`. Trial duration là policy data.                             |
| BILL-Q2 | **Không chuyển** license, kể cả CSKH; luôn thuộc family gốc.                          | Immutable owner family; restore/renewal không update owner, không có API transfer.                                                |
| BILL-Q3 | Store renew đã thanh toán sau khi payer xóa account vẫn cấp quyền cho **family gốc**. | Payer nullable/anonymized; xác minh transaction rồi ghi grant vào license đã bind, không phụ thuộc membership hiện tại của payer. |

Các đoạn kỹ thuật cũ §18.4/§18.5 “gán family theo payer hiện tại” không còn là chuẩn. Không dùng restore để tái sử dụng một giao dịch cho hai family.

Các bảng bên dưới nằm trong [Prisma schema backend](../../baby-backend/prisma/schema.prisma) và [forward migration DDL](../../baby-backend/prisma/migrations/20261013150000_family_domain/migration.sql). Migration domain chưa áp dụng vào DB ứng dụng; API mua, webhook và entitlement service chưa triển khai.

## Các bảng và trách nhiệm

| Bảng                        | Mục đích                                                                                                                                                                                                            |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `plans` / `plan_versions`   | Danh tính gói và phiên bản quota/features. Version đã dùng là bất biến; không sửa quota trong một JSON rồi làm thay đổi mọi hợp đồng cũ.                                                                            |
| `trial_policies`            | Version của thời lượng và plan version dùng thử; mặc định seed 7 ngày. Grant giữ policy ID và thời hạn đã tính, không đổi theo config hiện tại.                                                                     |
| `products`                  | Mapping Store/app/environment/product/base plan → plan version. Cùng product ID có thể tồn tại trên Apple và Google; Google monthly/yearly base plans cùng product vẫn có mapping riêng. Giá hiển thị lấy từ Store. |
| `purchase_intents`          | Server tạo trước purchase: family đích, purchaser đã xác thực, product, correlation/account token, hạn dùng và trạng thái. Không lấy family hiện tại của payer tại thời điểm webhook làm owner.                     |
| `family_licenses`           | Một license owner ổn định theo family, có thể được cấp từ trial, Store hoặc nguồn có audit được cho phép. Không nằm dưới user.                                                                                      |
| `subscriptions`             | Hợp đồng Store, immutable family/license binding, purchaser là người thanh toán, current/next period và trạng thái Store. Payer không quyết định family được hưởng khi webhook tới.                                 |
| `subscription_transactions` | Lịch sử xác minh giao dịch/gia hạn/refund/revoke; unique theo Store/environment/app/transaction. Không xóa rồi tái nhận cùng giao dịch.                                                                             |
| `license_grants`            | Khoảng quyền lợi, plan version và nguồn cấp; revoke/supersede có dấu vết. Một family có thể có hai subscriptions mà vẫn chỉ có một license hiệu lực được tổng hợp.                                                  |
| `store_notifications`       | Durable inbox/dedup webhook + processing/retry state. Payload lưu tối thiểu/mã hóa khi cần, không log receipt/purchase token thô.                                                                                   |
| `family_entitlements`       | Projection trạng thái/quota hiệu lực để đọc nhanh; có thể tính lại từ license/grants/subscriptions, không là nguồn duy nhất chứng minh đã thanh toán.                                                               |
| `trial_consumptions`        | Trial một lần theo family và identity fingerprint của cả hai Parent; chống đổi account/family để nhận lại trial, có retention/privacy riêng.                                                                        |
| `family_usage`              | Counter đã dùng/reserved; cập nhật nguyên tử cùng nguồn nghiệp vụ, có đối soát.                                                                                                                                     |

Mọi bảng có ba cột audit. Purchaser có thể được anonymize/null khi xóa account theo chính sách retention; không cascade xóa giao dịch/license của family. Payment token cần dùng để gọi Store được mã hóa, kèm hash/HMAC để dedup; không coi hash là bản thay thế token khi API cần token gốc.

## Luồng mua

1. Parent đã xác thực chọn family; server kiểm tra active membership, đủ hai Parent, trạng thái family và eligibility/gói hiện có.
2. Server tạo purchase intent và correlation ID. Apple `appAccountToken` là UUID liên kết giao dịch với account của dịch vụ, **không phải giấy phép Pro hoặc bằng chứng owner family**; server mapping intent mới quyết định family. Google dùng account/profile identifiers đã obfuscate khi phù hợp. [Apple appAccountToken](https://developer.apple.com/documentation/appstoreserverapi/appaccounttoken), [Google subscription resource](https://developers.google.com/android-publisher/api-ref/rest/v3/purchases.subscriptionsv2).
3. Client mua bằng SDK; server xác minh chữ ký/API Store, bundle/package, environment, product, account correlation và transaction chain. Không cấp quyền dựa trên screenshot/giá/payload client.
4. Trong transaction ngắn: dedup external transaction, giữ family binding, ghi subscription/transaction/grant, tính entitlement và ghi outbox. Concurrency hai Parent mua không tạo hai license; vẫn giữ hai subscriptions để người dùng biết cần hủy gói trùng.
5. Finish/acknowledge theo lifecycle Store và retry riêng; không báo thành công giả khi chưa ghi bền vững. Client đọc entitlement của family; Parent còn lại và thiết bị khác hưởng cùng quyền.

Store verification và financial state cần cập nhật theo tài liệu provider ở thời điểm triển khai. Đây là thiết kế dữ liệu, chưa gọi Store hoặc thực hiện giao dịch thật.

## Gia hạn, hủy, refund và restore

- Webhook nhận trước, verify và xử lý idempotent; sự kiện trùng không thêm quyền lợi lần hai. Sự kiện đến muộn/khác thứ tự cần reconciliation với trạng thái Store và mốc hiệu lực, không đơn giản ghi đè theo thời điểm nhận HTTP.
- Cancel auto-renew không đồng nghĩa mất thời gian đã trả; valid-until/grace/revocation là các trường riêng. Refund/revoke áp dụng theo giao dịch và hiệu lực provider, không xóa lịch sử.
- Upgrade cùng subscription giữ family; Google linked purchase token nối chain nhưng không phải lệnh đổi tenant. Google state/grace/hold/ack lấy từ API có thẩm quyền. [Google subscription lifecycle](https://developer.android.com/google/play/billing/lifecycle/subscriptions).
- Restore tìm purchase binding đã có. Nếu caller có quyền family gốc thì khôi phục trạng thái đó; nếu đang ở family khác thì trả ownership conflict, không update owner hoặc cho CSKH chuyển. Restore không tạo thêm trial/grant trùng.
- Payer xóa account không chuyển license, không tự hủy Store bằng thao tác DB. Renewal đã xác minh và thanh toán tiếp tục cấp family gốc. Không yêu cầu account đã xóa sống lại để webhook tìm được family owner; quyền quản lý hủy Store vẫn ở Store account của người thanh toán.
- Hai subscriptions cùng hiệu lực: chọn quyền lợi hợp lệ có `entitlement_rank` cao nhất từ **plan version bất biến**, không cộng đôi storage/AI hoặc thời hạn. `plans.display_order` chỉ sắp xếp UI, không quyết định quyền. Khi nguồn cao hơn hết hạn, tính lại từ các nguồn còn hiệu lực.

## Quota và expiry

Trial bắt đầu khi family đủ hai Parent. [Seed catalog riêng](../../baby-backend/prisma/seed.ts) cung cấp policy mặc định **604800 giây = 7 × 24 giờ**, expiry UTC tính một lần; không kéo dài do đổi timezone/đồng hồ. Quy ước này thay ví dụ cũ 90 ngày/kết thúc cuối ngày; thay đổi thời lượng tương lai phải dùng policy version mới. Trial/House/Family là dữ liệu catalog, không danh sách gói bất biến. Trial là plan nội bộ không bán; hai gói trả phí ban đầu là House/Family.

Seed chạy chủ động từ `baby-backend` bằng `npm run db:seed` sau khi schema tương ứng đã được áp dụng và đích kết nối đã được kiểm tra. [catalog.json](../../baby-backend/prisma/seeds/catalog.json) hiện chứa plans, versions, trial policy và default-trial config; Store product mappings cần xác minh/cấu hình riêng. Migration chỉ DDL, không chứa catalog `INSERT`/CRUD. `db:migrate:deploy`, Compose và khởi động API không tự chạy seed; tài liệu này không xác nhận seed đã chạy vào DB ứng dụng.

Quota seed giữ các giới hạn đã chốt tại §5.3: 10/50/200 GB theo bytes trong catalog, Circle 0/0/12 và AI 30/100/300 ở phase tương ứng. Các key quota có đơn vị rõ: `storageBytes`, `photosPerMemory`, `videoMaxSec`, `videoMaxHeight`, `audioMaxSec`, `circleMax`, `aiPerMonth`; capabilities trong `features`. Khi publish Admin, service phải validate schema/types/nonnegative/missing/unlimited, intersect rollout/permission và fail closed với capability chưa biết. DDL chỉ kiểm JSON object, chưa có service publish/entitlement runtime.

Thêm gói dùng capability đã hỗ trợ: thêm `plans` + `plan_versions` + Store product/base-plan mapping, không đổi enum/schema/nhánh tên gói ở client. Thêm tính năng nghiệp vụ hoàn toàn mới vẫn có thể cần code/migration. Theo [quy tắc mở rộng bắt buộc](../../.agents/skills/baby-family-team/references/extensibility-standards.md).

Upload reserve trước khi cấp URL; số bytes reservation + vật lý còn giữ không vượt quota dưới race nhiều thiết bị. Soft delete file không giảm usage cho tới purge thật; restore không làm đếm đôi. Hạ gói không xóa dữ liệu, chỉ chặn hành động bị vượt quota; Circle suspend giữ grant. AI [1.2] dùng family/month counter + idempotency, không đếm số request UI gửi rồi retry thành nhiều lượt.

Expiry đóng các nghiệp vụ theo BR-036, giữ export/account deletion/safety/support theo đặc tả. Family state và paid entitlement cùng được kiểm tra; gói còn tiền không tự cho family thiếu Parent sử dụng đầy đủ. Retention/purge sau expiry là state riêng, có cảnh báo trước và các quyết định dữ liệu còn mở trong requirements.

## Những điều schema không tự giải quyết

DDL có thể chặn FK sai family, owner bị đổi, transaction trùng và khoảng thời gian vô lý. DDL không tự verify Apple/Google, hủy Store, gửi cảnh báo, quyết định CSKH hoặc kiểm tra toàn bộ quyền endpoint. Các việc đó cần service/repository/worker có DI, transaction và test phù hợp khi triển khai.
