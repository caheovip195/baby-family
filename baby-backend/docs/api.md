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

`/notes` là ví dụ CRUD có trước, vẫn giữ contract cũ và chưa xác thực; `/health/live`, `/health/ready` phục vụ hạ tầng. Không dùng Note làm endpoint dữ liệu sản phẩm.

DTO HTTP có allowlist riêng, không dùng nguyên persistence Create/Update input. Body lạ hoặc null sai kiểu bị từ chối. Response được chọn từng field; không trả token hash, refresh token, storage key, khóa mã hóa, receipt hoặc model nội bộ nguyên dạng. Bytes/BigInt nội bộ không đi thẳng vào JSON; storage bytes, duration/version BigInt trong billing trả string thập phân. Ngày trả `YYYY-MM-DD`, giờ sinh `HH:mm`; timestamp trả ISO UTC.

List hiện dùng `page`/`limit` (1..100) và `{ data, meta }` theo base đã có. Các endpoint đơn lẻ trả DTO trực tiếp. Đây là contract hiện triển khai, chưa phải cursor/envelope, Idempotency-Key hay If-Match cho toàn bộ API trong đặc tả §11. Những hợp đồng đó và sync/outbox cần triển khai cùng workflow/transaction tương ứng, không giả lập bằng offset cursor hoặc read-then-write version check.

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
