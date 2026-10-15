# Service và controller backend

Triển khai ngày **2026-10-14**, BF-20261014-003. Luồng giữ nguyên `controller → IService → service → IRepository → repository → model`. Tất cả database I/O/transaction ở repository; controller xử lý HTTP/DTO, service xử lý quyền, validation nghiệp vụ, actor và projection trả về.

## API hiện có

Prefix local là `/api/v1`; Swagger ở `/docs`. Những route dưới đây yêu cầu Bearer access token đã xác thực và session PostgreSQL còn hiệu lực.

| Route                                       | Chức năng                                                                                                                  |
| ------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `GET /me`                                   | Hồ sơ của chính actor từ token                                                                                             |
| `PATCH /me`                                 | Sửa displayName, locale, timezone; không nhận userId/status/tokenVersion                                                   |
| `GET /me/settings`                          | Đọc settings riêng; chưa có bản ghi trả 404, GET không tạo dữ liệu                                                         |
| `PATCH /me/settings`                        | Sửa những preference đã có DTO: theme, textScale, preview/lunar và các cờ hiển thị; không bật AI/consent qua generic patch |
| `GET /families/:familyId`                   | Metadata family cho Parent còn hiệu lực; dùng để hiển thị trạng thái/onboarding                                            |
| `PATCH /families/:familyId`                 | Sửa tên/timezone; không đổi membership, lifecycle, license, accessVersion hoặc arbitrary settings                          |
| `GET /families/:familyId/children`          | Danh sách bé trong family đã kiểm quyền                                                                                    |
| `GET /families/:familyId/children/:id`      | Hồ sơ bé cùng family                                                                                                       |
| `POST /families/:familyId/children`         | Tạo hồ sơ bé; createdBy từ actor, name/nickname và ngày/giờ được chuẩn hóa                                                 |
| `PATCH /families/:familyId/children/:id`    | Sửa hồ sơ bé ACTIVE; không đổi status/version/purge fields                                                                 |
| `GET /families/:familyId/pregnancies`       | Danh sách thai kỳ trong family                                                                                             |
| `GET /families/:familyId/pregnancies/:id`   | Metadata thai kỳ cùng family                                                                                               |
| `POST /families/:familyId/pregnancies`      | Tạo thai kỳ; service xác định actor, repository cấp seqNo trong transaction khóa family                                    |
| `PATCH /families/:familyId/pregnancies/:id` | Sửa nickname/dueDate/expectedCount của thai kỳ ACTIVE                                                                      |
| `GET /billing/plans`                        | Catalog gói/version/policy đang hiệu lực; không fix số gói hoặc trial duration trong controller                            |
| `GET /families/:familyId/billing`           | Projection quyền lợi/usage của family; Parent vẫn đọc được khi gói hết hạn                                                 |
| `POST /media/upload-intents`                | Xin URL tải lên (header `Idempotency-Key` UUID bắt buộc); kiểm quyền ghi, loại file, quota gói, dedup theo SHA-256         |
| `POST /media/:id/parts`                     | Ký lại URL part của upload multipart (chỉ người tải lên, upload còn hạn)                                                   |
| `POST /media/:id/complete`                  | Hoàn tất: ghép multipart, HEAD xác minh kích thước/loại, chuyển `UPLOADED`, ghi outbox `media.asset_uploaded` (202)        |
| `GET /media/:id`                            | Trạng thái + URL ký của các biến thể đã xử lý; 404 nếu actor không được xem                                                |
| `POST /media/urls`                          | Ký lại tối đa 100 asset; trả `items` và `unavailableIds`                                                                   |

`/notes` là ví dụ CRUD có trước, vẫn giữ contract cũ và chưa xác thực; `/health/live`, `/health/ready` phục vụ hạ tầng. Không dùng Note làm endpoint dữ liệu sản phẩm.

DTO HTTP có allowlist riêng, không dùng nguyên persistence Create/Update input. Body lạ hoặc null sai kiểu bị từ chối. Response được chọn từng field; không trả token hash, refresh token, storage key, khóa mã hóa, receipt hoặc model nội bộ nguyên dạng. Bytes/BigInt nội bộ không đi thẳng vào JSON; storage bytes, duration/version BigInt trong billing trả string thập phân. Ngày trả `YYYY-MM-DD`, giờ sinh `HH:mm`; timestamp trả ISO UTC.

List hiện dùng `page`/`limit` (1..100) và `{ data, meta }` theo base đã có. Các endpoint đơn lẻ trả DTO trực tiếp. Đây là contract hiện triển khai, chưa phải cursor/envelope, Idempotency-Key hay If-Match cho toàn bộ API trong đặc tả §11. Những hợp đồng đó và sync/outbox cần triển khai cùng workflow/transaction tương ứng, không giả lập bằng offset cursor hoặc read-then-write version check.

## Media (đặc tả §10.2, §10.5)

Triển khai 2026-10-15, BF-20261015-009. `MediaController → IMediaService → MediaService → IMediaRepository/IObjectStorageService`. Giới hạn kỹ thuật (MIME, kích thước tối đa mỗi file, ngưỡng multipart 20 MiB, part 8 MiB, TTL URL) ở [media-policy.ts](../src/config/media-policy.ts); giới hạn theo gói (`storageBytes`, `videoMaxSec`, `audioMaxSec`) đọc từ quota của plan version hiệu lực, không theo tên gói.

- **Upload intent**: chỉ Parent có quyền ghi (`requireParent(..., 'write')`: membership, family ACTIVE, entitlement còn hạn). Purpose client được tải: `MEMORY` (ảnh/video/âm thanh), `AVATAR`, `COVER` (ảnh). `JOURNAL` chờ ACL Papa & Mama; `RECAP`/`EXPORT` do server tạo. Không nhận HEIC (client chuyển JPEG, §10.3). VIDEO/AUDIO bắt buộc `durationMs` và không vượt quota gói (402 `MEDIA_DURATION_EXCEEDED`).
- **Transaction quota** (repository): replay theo `(actor, Idempotency-Key)` trong `ops.idempotency_records` có hash request (khác nội dung → 409 `IDEMPOTENCY_KEY_REUSED`; mọi kết quả thành công, kể cả dedup, đều được ghi) → khóa `billing.family_usage` → dedup `(family, purpose, sha256)` chỉ với nội dung đã xác minh (upload đơn có checksum, hoặc `READY`; multipart chưa xác minh → 409 `UPLOAD_PENDING_VERIFICATION`; đang tải bởi parent kia → 409 `UPLOAD_IN_PROGRESS`; bản FAILED/hết hạn được thu hồi và trả quota) → kiểm `storage + reserved + giữ chỗ ≤ storageBytes` (402 `QUOTA_STORAGE_EXCEEDED`), với giữ chỗ = kích thước khai báo + 5 % (mức tối đa `complete` chấp nhận) → tạo asset `PENDING_UPLOAD` + `storage_reservations` (hết hạn 24 giờ). Replay của upload đã xong/FAILED/hết hạn chỉ trả trạng thái, không ký URL mới.
- **Single (≤ 20 MiB)**: presigned PUT 15 phút, ký cả `Content-Type` và `x-amz-checksum-sha256`; storage từ chối body khác SHA-256 đã khai báo. Client gửi đúng `upload.headers`.
- **Multipart (> 20 MiB)**: server tạo multipart upload khi cần (race → hủy bản thừa), ký tối đa 1.000 part/lần, TTL 1 giờ; `POST /media/:id/parts` ký lại. `complete` yêu cầu đủ part 1..N kèm ETag. SHA-256 của multipart do worker xác minh sau.
- **Complete**: chỉ người tải lên; idempotent khi đã `UPLOADED/PROCESSING/READY`. Nếu session multipart đã mất (lần complete trước đã ghép object nhưng chưa commit DB) thì phục hồi qua HEAD. Lỗi lưu upload ID sau khi tạo session sẽ hủy session đó. HEAD object: kích thước 0 hoặc > khai báo + 5 %, hoặc Content-Type khác → xóa object, asset `FAILED`, trả reservation, 422 `UPLOAD_SIZE_MISMATCH`/`UPLOAD_MIME_MISMATCH`. Thành công: asset `UPLOADED`, reservation `CONFIRMED`, `reserved → storage_bytes` theo kích thước thật, outbox `media.asset_uploaded` trong cùng transaction. Worker xử lý tiếp (xem dưới).
- **Xem**: chỉ ký URL cho biến thể đã xử lý (`asset_variants`) khi asset `READY`, TTL 1 giờ; không bao giờ trả `storageKey` hay URL bản gốc. Parent xem được: file mình tải khi chưa gắn vào ký ức/góc nhìn nào (đã gắn thì theo quyền ký ức), `AVATAR/COVER` của family, media của ký ức/góc nhìn mà Parent đó được xem theo §6.3 (PUBLISHED PARENTS/FAMILY, PENDING_REVIEW, của chính mình kể cả PRIVATE); thư niêm phong của người khác bị ẩn. Không được xem → 404 (không lộ ký ức riêng tư). Circle chưa có ACL nên chưa được cấp URL.
- **Worker** (BF-20261015-010, [jobs](jobs.md#triển-khai-hiện-có-2026-10-15)): outbox `media.asset_uploaded` → queue `media` → tải bản upload thô vào thư mục tạm, **xác minh SHA-256** (sai → `FAILED` `CHECKSUM_MISMATCH`, không retry). Bản thô không bị sửa trong lúc xử lý; mọi output ghi vào prefix riêng của attempt (`…/a/{assetId}/r{fencing}/`). Ảnh (sharp, giới hạn 100 MP, định dạng đọc từ nội dung): xoay theo EXIF, `t320.webp`/`m1080.webp`/`l2048.jpg` không metadata, blurhash 4×3, `captured_at` từ `DateTimeOriginal`, và biến thể `orig` = bản gốc không metadata: gói có `media.keepOriginal` giữ nguyên pixel JPEG/PNG (bỏ EXIF/XMP/IPTC không mất dữ liệu, chỉ giữ Orientation; WebP/GIF mã hóa lại chất lượng cao), gói khác mã hóa lại cạnh dài 3072. Video/âm thanh (ffprobe/ffmpeg, không qua shell, có timeout/hủy): kiểm thời lượng theo quota gói, `v1080.mp4` + `poster.jpg` + `t320.webp` hoặc `a.m4a`, `-map_metadata -1`; `orig` chỉ có khi `media.keepOriginal` (remux bỏ metadata). Commit `READY` + biến thể + chênh lệch `storage_bytes` chỉ khi attempt còn giữ lease (kiểm fencing trong cùng transaction). Sau commit mới xóa **mọi version** của bản thô (có thể chứa GPS, bucket bật versioning) và output thừa của attempt cũ; crash sau commit thì lần giao lại chỉ chạy bước dọn này. `size_bytes` = tổng các biến thể.
- **purge-orphans** (15 phút): trong DB trước, kiểm lại điều kiện trên hàng đã khóa rồi mới retire: `PENDING_UPLOAD` hết hạn reservation (reservation `EXPIRED`, trả `reserved_storage_bytes`), `FAILED` quá 1 giờ (trả `storage_bytes`), `PROCESSING` không đổi 6 giờ → `FAILED` `PROCESSING_STALLED`. Asset retire nhận `DELETED` + `purge_after`; sau đó xóa toàn bộ object dưới prefix của asset (hủy multipart nếu có) rồi xóa `purge_after`, nên lỗi storage được chạy lại ở kỳ sau. Object xóa theo cách này vẫn có thể còn ở version cũ tối đa 30 ngày theo lifecycle bucket (§10.7). Asset `UPLOADED/READY` chưa gắn ký ức chỉ bị dọn khi đặt `MEDIA_PURGE_UNATTACHED_AFTER_HOURS` (mặc định tắt vì API tạo ký ức chưa có).
- **reconcile-uploads** (15 phút): upload đơn còn hạn, tạo hơn 10 phút, chưa gọi complete nhưng object đã có → kiểm như `complete` rồi confirm (cùng transaction + outbox); multipart chưa hỗ trợ vì cần ETag. Asset `UPLOADED/PROCESSING` không đổi 15 phút mà run chưa có, đang chờ hoặc lease hết hạn → enqueue lại (job queue có thể mất khi hết lượt trong lúc DB/Valkey lỗi).
- **Chưa làm**: tải bản gốc (`/memories/:id/download-urls`, `canDownload`), asset JOURNAL, Circle, webhook storage-events, HLS, kiểm duyệt hash CSAM, sự kiện `media.asset_ready` cho luồng xuất bản ký ức. Dung lượng sau xử lý có thể vượt quota gói một chút (biến thể được cộng sau khi đã nhận upload); theo quy tắc nghiệp vụ, vượt gói chỉ chặn upload mới.

## Xác thực và quyền

[AuthenticationService](../src/services/authentication.service.ts) dùng `jose` kiểm chữ ký **ES256**, `iss`, `aud`, header `typ=at+jwt`, `sub`, `sid`, `ver`, `iat`, `exp`; thời hạn access tối đa 900 giây. `sub`/`sid` là UUID. Token re-auth/admin không dùng làm access token ứng dụng. Chỉ dùng public key được cấu hình, không tin key/URL/role/family do token hoặc HTTP tự chỉ định. [jose JWT verification options](https://github.com/panva/jose/blob/main/docs/jwt/verify/interfaces/JWTVerifyOptions.md).

Sau khi xác minh chữ ký, [AuthAccessRepository](../src/repositories/auth-access.repository.ts) đọc session và user cùng snapshot: user ACTIVE, chưa xóa; session chưa thu hồi/thay thế/xóa và chưa vượt cả hai hạn dùng. `ver` phải khớp tokenVersion hiện tại. Không cache role/membership từ token. Không log Bearer token hoặc dùng refresh token làm access token.

Đặt public key SPKI PEM từ issuer tin cậy trong `.env` (literal `\n` được chuyển thành newline):

```dotenv
AUTH_JWT_PUBLIC_KEY="-----BEGIN PUBLIC KEY-----\n<SPKI public key của issuer>\n-----END PUBLIC KEY-----"
AUTH_JWT_ISSUER=baby-family
AUTH_JWT_AUDIENCE=baby-family-app
```

Compose truyền cùng cấu hình vào API. Thiếu public key thì domain endpoints từ chối 503; key đã cấu hình sai làm startup fail. Không ship private key hoặc dev-login bypass. Task này triển khai verifier/session boundary; chưa có endpoint phát token Apple/Google/OTP/refresh/admin.

[ApplicationAccessService](../src/services/application-access.service.ts) kiểm membership PostgreSQL hiện tại:

- Actor không có active Parent membership trả 404, không tiết lộ family tồn tại. Các API hiện tại dành cho Parent; Circle chưa được cấp quyền bằng familyId hoặc header.
- Metadata family/billing vẫn đọc được để onboarding/mua gói; family WAITING_PARTNER có thể sửa metadata đã cho phép.
- Content read/write của family ACTIVE cần đủ hai Parent ACTIVE, license chưa khóa và TRIAL/PAID chưa hết hạn thực tế. Kiểm expiry ở request, không đợi cron. Hết hạn trả 402; family/lifecycle không cho phép trả 403.
- PARTNER_LEFT cho Parent còn lại đọc dữ liệu theo policy, chặn ghi. Entitlement/license BLOCKED vẫn chặn content; metadata/billing là boundary riêng.
- Không suy quyền từ tên House/Family hoặc actor thanh toán. Catalog và quyền lợi luôn theo family gốc.

## Service nội bộ và bảo trì

Có **122 service/interface domain**: 5 service nghiệp vụ trên và 117 service nội bộ, cộng Note mẫu. BillingCatalog/FamilyBilling và Authentication/ApplicationAccess là các service điều phối riêng. [DI composition](../src/common/application/application.providers.ts) được đăng ký trong AppModule; [manifest nội bộ](../src/common/application/service.manifest.ts) ghi phạm vi generated.

117 service nội bộ cung cấp typed persistence orchestration theo repository interface, xử lý not-found/update rỗng; 18 service append-only không có update/delete. Chúng không đăng ký generic HTTP controller. Billing ledger, joins, session secrets, jobs và schema `us` phải đi qua workflow thích hợp; có service nền không có nghĩa đã triển khai Store verification, encryption, Circle ACL, worker hay mọi transition nghiệp vụ.

```bash
npm run generate:services
npm run generate:services -- --check
npm run check
```

Generator bảo vệ file bằng hash, bỏ qua 5 service nghiệp vụ viết riêng và Note. File chỉnh tay không bị tự ghi đè; cập nhật generator/template hoặc giữ thay đổi trước khi dùng `--force`. Local check/CI kiểm cả persistence và internal service drift. Không sinh controller rỗng cho từng bảng nối/lịch sử.

Các luồng cần tiếp tục theo tính năng: family creation/partner approval + trial, pregnancy birth/end, Memory/Us/Circle ACL, mission/Hearts transactions, Store verifier/restore, upload pipeline, sync/version/idempotency và jobs. Chưa mở API destructive account/family/child purge khi retention/lifecycle còn điểm cần chốt. Migration/seed và DB ứng dụng không được áp dụng trong task tầng API này.
