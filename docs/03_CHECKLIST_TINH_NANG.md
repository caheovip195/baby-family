# Checklist tính năng Baby Family

Tạo 2026-10-18 (BF-20261018-001). Nguồn: [đặc tả nghiệp vụ](01_DAC_TA_NGHIEP_VU_BABY_FAMILY_v3.md) mục 7, 9, 16 và [tài liệu kỹ thuật](02_TAI_LIEU_KY_THUAT_BABY_FAMILY_v3.md); hiện trạng đối chiếu từ code, [API backend](../baby-backend/docs/api.md), [SESSIONS.md](../SESSIONS.md) và [SESSION.md của app](../baby-family-app/SESSION.md).

## Cách đọc

- `[x]` = **đã xong**: có API backend, app đã nối API thật (chế độ `BABY_FAMILY_API_URL`) và đã có test/kiểm chứng ghi trong nhật ký. `[ ]` = chưa xong.
- Sau mỗi dòng là trạng thái từng phần: **UI** = màn có trong app (phần lớn đang chạy bằng dữ liệu mock), **BE** = API backend, **App** = app gọi API thật. ✅ có · 🟡 một phần · ❌ chưa có.
- Gần như mọi màn MVP đã có UI dạng mock (đợt UI 2026-10-08 → 10-15). Việc còn lại chủ yếu là backend + nối API.
- Mỗi lần xong một dòng: tick `[x]`, ghi mã yêu cầu `BF-…` ở cuối dòng.
- Phase theo đặc tả §16.1: **MVP** (1.0), **1.1**, **1.2**, **2.0**.

## Tiến độ

- Tổng: 154 / 167 dòng đã xong (đếm lại BF-20261028-013, +1 dòng nhắn tin BF-20261101-001; 13 dòng còn mở đều là hạ tầng / cấu hình phát hành / offline-first toàn app).
- Đang làm: —. Xong gần nhất: BF-20261101-001 — nhắn tin cả nhà + Papa & Mama qua WebSocket. Còn lại chủ yếu cần cấu hình/quyết định của người dùng: Store / Apple / Google / staging / CI / ký số / pháp lý
- Thứ tự đề xuất tiếp theo (MVP, theo vòng lặp Ký ức → Gia đình → Nhiệm vụ):
  1. Upload video, ghi âm, multipart trên app (MEM-04/06).
  2. Timeline + lưới ảnh + lọc theo bé (MEM-01/02).
  3. Nhiệm vụ hằng ngày (CARE-01…06) + Hearts.
  4. Papa & Mama: check-in, lời nhờ, cảm ơn, nhật ký riêng.
  5. Gói dịch vụ IAP + Paywall.
  6. Thông báo đẩy, Circle, xoá tài khoản/xuất dữ liệu, Admin CMS.

---

## 1. Hạ tầng & nền tảng

- [x] Backend NestJS + Prisma/PostgreSQL, DI controller → service → repository (BF-20261014-003)
- [x] Database riêng `baby-database/` + backup, migration chỉ DDL (BF-20261015-005)
- [x] Object storage MinIO, Redis/Valkey, Mailpit (BF-20261015-006)
- [x] Worker xử lý media + job/outbox có lịch sử chạy (BF-20261015-010)
- [x] Envelope response `{data}`, lỗi `error.code` (BF-20261015-012)
- [x] App Flutter: kiến trúc Page → Controller → Service → Repository, l10n vi/en, Design System (2026-10-07)
- [x] Outbox relay → consumer (thông báo, feed, Hearts) — BE ✅ (rà toàn bộ event: route chính/bổ sung + danh sách “không cần consumer” có lý do, Hearts ký ức/góc nhìn qua `care.award-badges`, email giao dịch; feed đọc trực tiếp PostgreSQL nên không cần consumer, `docs/outbox.md`, BF-20261021-002)
- [ ] CI build/test tự động — 🟡 (`backend-ci.yml` + `app-ci.yml` (Flutter: format, codegen, analyze, test), BF-20261021-001, Codex; chưa chạy trên GitHub Actions)
- [ ] Offline-first: ghi trên máy trước, đồng bộ khi có mạng (`docs/04_THIET_KE_OFFLINE_FIRST.md`) — BE 🟡 (Idempotency-Key cho các lệnh xếp hàng được, `GET /families/:id/changes` cho ký ức/bình luận/cảm xúc, BF-20261022-001, Codex) · App 🟡 (outbox bền vững cho tạo ký ức: hiện ngay khi mất mạng, tự gửi khi có mạng, không trùng sau khi tắt app, BF-20261022-001; `OutboxRunner` chung cho bình luận, cảm xúc, hoàn thành nhiệm vụ + bảng nhiệm vụ mở được khi offline; kéo changes API: gỡ ký ức đã xoá, đọc lại ký ức đổi, cập nhật bình luận, BF-20261022-002; local DB bền vững (Hive mã hoá theo dòng) cho ký ức + bình luận, mở app offline có dữ liệu, chịu được server đổi/thêm field, BF-20261022-003; local DB bảng chung cho bảng nhiệm vụ và Papa & Mama (check-in, lời nhờ, cảm ơn, nhật ký riêng: đọc offline + tạo qua outbox), BF-20261022-004; thử thật Android + backend thật: tạo offline → mở lạnh offline → có mạng tự gửi đúng một lần, sửa 5 lỗi, BF-20261022-005; màn phụ (lịch sử, huy hiệu, thông báo, cài đặt, album…) dùng bản đọc gần nhất khi mất mạng, BF-20261026-007; thao tác lời nhờ (xem/nhận/từ chối/xong/huỷ/hẹn nhắc) qua outbox, bị từ chối thì trả về bản trước, BF-20261028-001; sửa chữ/bé/phạm vi/bình luận của ký ức qua outbox (gộp các lần sửa, giữ version gốc, 412 → đọc lại bản server), BF-20261028-002; tạo nhiệm vụ (không lặp lại) qua outbox, bản tạm hiện trên bảng của ngày đó, cùng Idempotency-Key khi gửi lại, BF-20261028-003; đổi ảnh ký ức qua outbox: ảnh mới sao vào thư mục thao tác, hiện ngay, chỉ tải lên lúc gửi, nhớ asset đã tải để gửi tiếp, gộp với bản sửa chữ, bị từ chối thì trả về ảnh server, BF-20261029-001; đổi nhiệm vụ (lựa chọn + token lưu trên máy) và tạo chuỗi lặp qua outbox + Idempotency-Key, bản tạm hiện trên bảng, BF-20261029-002; chưa thử iOS (Flutter 3.44.5 không build được với Xcode 27.1))
- [ ] Môi trường staging + deploy — ❌
- [ ] Logging/monitoring production, cảnh báo sự cố — BE 🟡 (log JSON có cấu trúc, `/metrics` Prometheus có token, hook báo lỗi, `docs/observability.md`, BF-20261021-001, Codex; worker báo job thất bại vĩnh viễn qua `IErrorReporter.reportJob` (tag allowlist), BF-20261028-001; chưa có DSN Sentry thật/cảnh báo Prometheus triển khai)

## 2. Tài khoản & đăng nhập (§7.1, §9.1)

- [x] SPL-01 Splash, ONB-01 Welcome — UI ✅
- [x] Đăng nhập số điện thoại + OTP (AUTH-02/03) — UI ✅ · BE ✅ · App ✅ (BF-20261015-012)
- [x] Hồ sơ cơ bản + đồng ý điều khoản (AUTH-04) — UI ✅ · BE ✅ · App ✅ (BF-20261015-012)
- [x] Refresh token xoay vòng, đăng xuất — BE ✅ · App ✅ (BF-20261015-012)
- [ ] Đăng nhập Apple — UI ✅ · BE ✅ (`POST /auth/apple`, BF-20261020-001) · App 🟡 (`sign_in_with_apple` + nonce SHA-256, phiên qua server, BF-20261021-007; chưa bật capability Sign in with Apple trong Xcode, chưa thử máy thật)
- [ ] Đăng nhập Google — UI ✅ · BE ✅ (`POST /auth/google`, BF-20261020-001) · App 🟡 (`google_sign_in` 7, client id qua `--dart-define GOOGLE_CLIENT_ID/GOOGLE_SERVER_CLIENT_ID`, BF-20261021-007; chưa cấu hình client id/URL scheme thật, chưa thử máy thật)
- [x] Avatar hồ sơ (upload ảnh AUTH-04) — UI ✅ · BE ✅ (`/me/avatar/*`, `PATCH /me {avatarAssetId}`, `avatarUrl`, BF-20261019-007, Codex) · App ✅ (BF-20261019-007)
- [ ] Liên kết/đổi số điện thoại, quản lý phương thức đăng nhập (SET bảo mật) — UI 🟡 (màn đổi số: xác thực lại → số mới → OTP, BF-20261019-010) · BE ✅ (đổi số `/me/phone/*` BF-20261018-015; `/me/sign-in-methods`, liên kết/gỡ Apple/Google, reauth bằng Apple/Google, BF-20261020-001, Codex) · App 🟡 (đổi số; trạng thái liên kết thật từ server, BF-20261020-001; liên kết/gỡ Apple/Google thật: xác thực lại bằng OTP hoặc Apple/Google đã liên kết → `POST/DELETE /me/identities/*`, BF-20261028-001; chưa thử máy thật — cần cấu hình Apple/Google như dòng đăng nhập)
- [x] Danh sách thiết bị/phiên đăng nhập, đăng xuất thiết bị khác — UI ✅ · BE ✅ (`/me/sessions*`, BF-20261018-015, Codex) · App ✅ (BF-20261018-015)

## 3. Vai trò, tạo gia đình & kích hoạt (§7.2, §7.3, §9.2)

- [x] ONB-03 Chọn vai trò Bố/Mẹ/Người thân — UI ✅ · BE ✅ · App ✅ (BF-20261015-012)
- [x] ONB-06 Tạo gia đình, huỷ gia đình đang chờ — UI ✅ · BE ✅ · App ✅ (BF-20261015-012)
- [x] ONB-07 Mời bạn đời (mã + link, 7 ngày) — UI ✅ · BE ✅ · App ✅ (BF-20261015-012)
- [x] ONB-WAIT chờ bạn đời + xác nhận lần cuối — UI ✅ · BE ✅ · App ✅ (BF-20261015-012)
- [x] INV-01/04/05 Xem, nhận, từ chối, nhập mã lời mời — UI ✅ · BE ✅ · App ✅ (BF-20261015-012)
- [x] ONB-ACT Kích hoạt gia đình + dùng thử 7 ngày — UI ✅ · BE ✅ · App ✅ (BF-20261015-012)
- [x] Bootstrap gia đình khi mở app — BE ✅ · App ✅ (BF-20261015-012)
- [x] INV-02/03 Lời mời không hợp lệ / đang là Bố-Mẹ nhà khác — UI ✅ · BE ✅ · App ✅ (lỗi khi nhận lời mời cũng chuyển đúng màn, BF-20261018-015)
- [x] ONB-08 Quyền riêng tư của nhà mình (cài đặt mặc định) — UI ✅ · BE ✅ (`/families/:fid/settings`, BF-20261018-015, Codex) · App ✅ (đọc/lưu qua FAM-07, BF-20261018-015; áp mặc định khi tạo ký ức còn TODO phía server)
- [x] ONB-09 Ký ức đầu tiên — UI ✅ · BE ✅ · App ✅ (hoàn tất thiết lập trên server + composer ký ức bản server; xác nhận BF-20261018-015)
- [x] ONB-10 Bật thông báo (pre-permission + đăng ký push token) — UI ✅ · BE ✅ (`/me/devices`) · App ✅ (FCM token + gửi lại khi đổi, BF-20261018-014)
- [x] FAM-02 Mời lại bạn đời từ màn Gia đình — UI ✅ · BE ✅ · App ✅ (lời mời server, thu hồi = cấp mã mới, BF-20261018-015)
- [x] FAM-08 Chuyển gia đình — UI ✅ · BE ✅ (`/me/families`, `PUT /me/default-family`, BF-20261021-001, Codex) · App ✅ (danh sách từ server, đồng bộ lại phiên theo gia đình đã chọn, BF-20261021-001)
- [x] Gia đình `PARTNER_LEFT` (US-00, chỉ đọc + mời bạn đời mới) — UI ✅ · BE ✅ (rà lại US-00; lời mời bạn đời mới có tên các bé, BF-20261019-009) · App ✅ (phản chiếu trạng thái BF-20261018-015; xem trước lời mời có tên bé, BF-20261019-009)
- [x] Mất mạng khi mở app vẫn giữ phiên (cache bootstrap) — App ✅ (bản chụp mã hoá phiên/gia đình/bé/300 ký ức, nạp khi mở app nguội mà server không phản hồi, BF-20261019-009)

## 4. Thai kỳ & chào đời (§7.5, §7.6, §9.5)

- [x] ONB-05a Tạo thai kỳ; sửa thai kỳ — UI ✅ · BE ✅ · App ✅ (BF-20261016-002)
- [x] PREG-01 Hành trình thai kỳ (tuần thai, nội dung theo tuần) — UI ✅ · BE ✅ (`/journey`, catalog tuần vi/en, BF-20261019-001, Codex) · App ✅ (kích thước thai từ server, BF-20261019-001)
- [x] PREG-02 Nhật ký bụng bầu — UI ✅ · BE ✅ (ký ức BUMP của thai kỳ, `/memories?kind`, BF-20261019-001) · App ✅ (đồng bộ qua bảng tin + tuần thai, BF-20261019-001)
- [x] PREG-03 Ảnh siêu âm — UI ✅ · BE ✅ (ký ức ULTRASOUND, BF-20261019-001) · App ✅ (BF-20261019-001)
- [x] PREG-04 Chuẩn bị đón bé (danh sách chuẩn bị) — UI ✅ · BE ✅ (`/prep-items`, mặc định từ catalog, BF-20261019-001) · App ✅ (người phụ trách/“Đã nhờ” còn trên máy, BF-20261019-001)
- [x] PREG-05 Bé đã chào đời (birth conversion, sinh đôi) — UI ✅ · BE ✅ (`/birth` idempotent, sinh đôi, BF-20261019-001) · App ✅ (form một bé, BF-20261019-001)
- [x] PREG-06 Lưu trữ thai kỳ (nhạy cảm) — UI ✅ · BE ✅ (`ENDED_PRIVATE` ẩn khỏi Circle, BF-20261019-001) · App ✅ (BF-20261019-001)
- [x] PREG-07 Đặt tên cho con — **1.1** — UI ✅ · BE ✅ (tên dự định mã hoá, thích theo người, chọn tối đa theo số bé dự kiến + cột mốc `name_chosen`, chỉ Papa & Mama, BF-20261027-001, Codex) · App ✅ (danh sách / thêm / thích / chọn – bỏ chọn qua API, BF-20261027-001)

## 5. Hồ sơ bé & nhiều bé (§7.7, §9.6)

- [x] ONB-05b / CHD-04 Thêm bé — UI ✅ · BE ✅ · App ✅ (BF-20261016-002)
- [x] CHD-02 Sửa hồ sơ bé — UI ✅ · BE ✅ · App ✅ (BF-20261016-002)
- [x] CHD-01 Hồ sơ bé (số liệu ký ức/cột mốc từ server) — UI ✅ · BE ✅ (`/profile-stats`, BF-20261019-001) · App ✅ (BF-20261019-001)
- [x] CHD-03 Các con, sắp xếp thứ tự bé — UI ✅ · BE ✅ (`/children/order`, BF-20261019-001) · App ✅ (BF-20261019-001)
- [x] CHD-05 Lưu trữ / xoá bé — UI ✅ · BE ✅ (lưu trữ 7 ngày trước khi xoá, BF-20261019-001) · App ✅ (BF-20261019-001)
- [x] Ảnh đại diện / ảnh bìa bé — UI ✅ · BE ✅ (`PUT /children/:id/avatar|cover`, BF-20261019-001; URL qua bootstrap, BF-20261019-007, Codex) · App ✅ (tải lên + nhận ảnh trên máy khác, BF-20261019-007)
- [x] SW-01 Bộ chuyển bé dùng dữ liệu server — UI ✅ · App ✅ (bé/thai kỳ theo bootstrap; lưu trữ/xoá/sinh trên máy khác → “Đã lưu trữ”, BF-20261019-008)
- [x] CHD-06 Tăng trưởng — **1.2** — UI ✅ · BE ✅ (`GET/PUT/DELETE /children/:id/growth[/:date]`, mỗi ngày một lần đo, chỉ Parent, BF-20261028-004) · App ✅ (màn biểu đồ đường của bé + disclaimer, mở từ hồ sơ bé; offline-first qua outbox + local DB, BF-20261028-004)

## 6. Ký ức & album (§7.8, §9.4)

- [x] Upload ảnh (upload-intent → PUT → complete, dedup, worker tạo biến thể) — BE ✅ · App ✅ (BF-20261016-002, BF-20261017-001)
- [x] MEM-04/05 Tạo ký ức Ảnh / Nhật ký / Kỷ vật / Câu nói — UI ✅ · BE ✅ · App ✅ (BF-20261016-002)
- [x] Feed “Mới trong nhà” đồng bộ server, đủ trang, gỡ ký ức đã xoá, tự làm mới khi đang xử lý — UI ✅ · BE ✅ · App ✅ (BF-20261017-001)
- [x] MEM-07 Chi tiết ký ức đọc từ server — UI ✅ · BE ✅ · App ✅ (mở chi tiết/xem ảnh/bình luận đọc lại `GET /memories/:id`, BF-20261019-007)
- [x] MEM-09 Sửa ký ức (chú thích, tiêu đề, ngày, bé, người xem; If-Match) — UI ✅ · BE ✅ · App ✅ (BF-20261018-002)
- [x] Đổi ảnh khi sửa ký ức (thêm/bớt, đổi ảnh bìa) — UI ✅ (BF-20261019-007) · BE ✅ (`PATCH /memories/:id` add/remove/cover, BF-20261019-002, Codex) · App ✅ (BF-20261019-007)
- [x] Xoá ký ức → thùng rác; MEM-17 Thùng rác (khôi phục, xoá vĩnh viễn, tự xoá hẳn sau 30 ngày) — UI ✅ · BE ✅ · App ✅ (BF-20261018-001)
- [x] MEM-18 Nháp — UI ✅ · BE ✅ (`status: DRAFT`, `/me/drafts`, `/publish`, BF-20261019-002, Codex) · App ✅ (danh sách + xoá nháp trên tài khoản BF-20261019-006; soạn tiếp nháp trên tài khoản rồi đăng, BF-20261020-001)
- [x] Upload video (thời lượng theo gói) — UI ✅ · BE ✅ · App ✅ (chọn ảnh + video, kiểm giới hạn gói, gửi `durationMs`, BF-20261019-007; client nén ≤ 1080p + poster/t320, upload thẳng S3, BF-20261021-008)
- [x] Ghi âm giọng nói (VOICE) — UI ✅ · BE ✅ (VOICE: một asset AUDIO READY, thời lượng server đo, `audioMaxSec`, BF-20261021-001, Codex) · App ✅ (ghi bằng micro qua `record`, tải AUDIO + chờ READY, nghe lại trên dòng thời gian, BF-20261021-001; chưa thử trên máy thật)
- [x] Upload multipart (> 20 MiB) trên app; MEM-06 Đang tải lên — UI ✅ (BF-20261019-008) · BE ✅ · App ✅ (multipart + ETag BF-20261019-007; tải nền, tiến độ, thử lại/huỷ, giữ nháp khi mất việc tải, BF-20261019-008)
- [x] MEM-01 Dòng thời gian (timeline theo ngày xảy ra, chương theo tháng tuổi dựng trên app) — UI ✅ · BE ✅ · App ✅ (BF-20261018-005/006)
- [x] Thẻ chương tháng/ảnh tháng/recap từ server trên timeline — BE ✅ (thẻ `CHAPTER`, `WEEKLY_RECAP` trên `/timeline`, BF-20261019-008, Codex) · App ✅ (thẻ chương từ `/timeline` BF-20261019-009; thẻ recap tuần mới nhất trên dòng thời gian cả nhà, BF-20261020-001)
- [x] MEM-02 Lưới ảnh (media grid) — UI ✅ · BE ✅ · App ✅ (BF-20261018-005/006)
- [x] MEM-03 Album, tạo/sửa album — UI ✅ · BE ✅ (`/albums`, BF-20261019-002, Codex) · App ✅ (album tự động vẫn trên máy, BF-20261019-002)
- [x] MEM-22 Bộ sưu tập — UI ✅ · BE ✅ (yêu thích riêng từng người, BF-20261019-002) · App ✅ (đồng bộ yêu thích, BF-20261019-002)
- [x] MEM-08 Xem ảnh/video toàn màn hình — UI ✅ · App ✅ (phát video `v1080`, poster cho thẻ, video vừa chọn trên máy, BF-20261019-009; ưu tiên bản còn trong thư viện máy khi khớp SHA-256 file gốc, BF-20261021-008)
- [x] Tải về bản gốc (`download-urls`) & chia sẻ ra ngoài — UI ✅ · BE ✅ (BF-20261019-002, Codex) · App ✅ (nút Tải về mở bản gốc, BF-20261019-002)
- [x] MEM-24 Kể cùng nhau — góc nhìn thứ hai — UI ✅ · BE ✅ (BF-20261019-002, Codex) · App ✅ (chữ, BF-20261019-002; ghi âm góc nhìn: thu trên máy → tải audio → `audioAssetId`, nghe lại ở MEM-07 qua URL ký `audioUrl`, BF-20261030-004; ảnh (tối đa 6) qua `assetIds` — ảnh mới tải lên, ảnh cũ giữ asset id, chạm để bỏ, BF-20261030-006; video cùng giới hạn độ dài theo gói như MEM-04 (sàng dùng chung `video_screening.dart`), BF-20261030-007; chạm ảnh/video của góc nhìn ở MEM-07 → MEM-08 `?perspective=` (vuốt, phát video, tải ảnh), BF-20261030-008; “Tải về” lấy bản gốc qua `download-urls?perspectiveId=` (cùng quyền tải, giới hạn tần suất, audit), BF-20261030-009)
- [x] MEM-20/21 Ảnh tháng & “Con lớn từng tháng”, collage — UI ✅ · BE ✅ (`/children/:id/monthly-photos`, BF-20261019-008, Codex) · App ✅ (BF-20261019-008; collage ghép trên app)
- [x] Gợi ý ghi lại (memory prompts) — UI ✅ · BE ✅ (catalog + bỏ qua, BF-20261019-002) · App ✅ (BF-20261019-002)
- [x] MEM-25 Hôm nay của bé (trình chiếu) — UI ✅ · BE ✅ (`/children/:id/today-story`, BF-20261019-009) · App ✅ (BF-20261019-009; “đã xem” lưu trên máy)
- [x] “Ai ở đó” (people), địa điểm, cảm xúc đầy đủ — UI ✅ (mục nâng cao trong trình soạn, BF-20261021-002) · BE ✅ (`people` qua `memory_people`, `feeling`, `locationLabel`, `/people-suggestions`, BF-20261021-002, Codex) · App ✅ (gửi/hiển thị người, cảm xúc, địa điểm, BF-20261021-002; gợi ý người từ `/people-suggestions` trong trình soạn)
- [x] Quota `memoryCount`: đếm, chặn, trừ khi xoá, kiểm lại khi khôi phục — BE ✅ (BF-20261017-001, BF-20261018-001)

## 7. Nhật ký, thư gửi con, cột mốc (§7.9, §7.11)

- [x] MEM-13 Viết nhật ký (chữ dài) — UI ✅ · BE ✅ (kind DIARY) · App ✅ (lưu lên server; tự lưu nháp trên máy sau 2 giây và mở lại soạn tiếp, BF-20261021-002)
- [x] MEM-14 Thư gửi con + time capsule (niêm phong tới ngày mở) — UI ✅ · BE ✅ (thư + job mở thư, BF-20261019-002, Codex) · App ✅ (tạo thư niêm phong qua server, BF-20261019-002)
- [x] MEM-11 Chọn cột mốc (catalog, cả truyền thống VN) — UI ✅ · BE ✅ (`/milestone-templates`, BF-20261019-002) · App ✅ (BF-20261019-002)
- [x] MEM-12 Những lần đầu — UI ✅ · BE ✅ (`/children/:id/milestones`, BF-20261019-002) · App ✅ (trạng thái đã ghi từ server, BF-20261019-002)

## 8. Bảng tin, bình luận, cảm xúc (§7.12)

- [x] MEM-10 Bình luận (trả lời 1 cấp, sửa ≤ 15 phút, xoá; Parent xoá mọi bình luận) — UI ✅ · BE ✅ · App ✅ (BF-20261018-003)
- [x] Tắt bình luận theo từng ký ức trên app (server đã nhận `commentsEnabled`) — UI ✅ (bật/tắt ở màn sửa, ẩn ô bình luận, BF-20261019-003) · BE ✅ · App ✅ (BF-20261019-003)
- [x] Reaction (5 cảm xúc, mỗi người 1, đổi/bỏ được) — UI ✅ · BE ✅ · App ✅ (BF-20261018-003)
- [x] Bộ lọc feed theo bé / thai kỳ trên app — UI ✅ · BE ✅ · App ✅ (đọc bảng tin server theo bé/thai kỳ khi lọc, BF-20261019-003)

## 9. Nhiệm vụ hằng ngày (§7.13, §9.7)

- [x] Catalog nhiệm vụ (≥ 90 ngày nội dung), seed — BE ✅ (268 mẫu vi/en, +158 mẫu mới: chung mọi giai đoạn, thai kỳ, sơ sinh/sau sinh, 2–5 tháng, mẫu giáo 2,5–6 tuổi; unit chứng minh mọi tuần thai 1–42 và mọi tuổi 0–6 năm đủ mẫu cho cửa sổ không lặp 14 ngày + SELF cho người mang thai/vừa sinh; integration mô phỏng 90 ngày bằng bộ sinh thật cho 9 giai đoạn không lặp trong 14 ngày; sửa bộ sinh gán nhầm mẫu thai kỳ cho bé, BF-20261021-005)
- [x] Job bày bảng nhiệm vụ mỗi ngày, chia đều 2 Parent — BE ✅ (job `mission.prepare-boards` mỗi giờ, 5:00 giờ địa phương, không trùng, BF-20261019-003)
- [x] CARE-01 Hôm nay (tab Của tôi / Cùng nhau / Bạn đời) — UI ✅ · BE ✅ · App ✅ (BF-20261018-006/007)
- [x] CARE-02 Chi tiết nhiệm vụ — UI ✅ · BE ✅ · App ✅ (BF-20261018-007)
- [x] CARE-03 Tự thêm nhiệm vụ — UI ✅ · BE ✅ · App ✅ (BF-20261018-007)
- [x] CARE-04 Thư viện nhiệm vụ — UI ✅ · BE ✅ · App ✅ (BF-20261018-007)
- [x] CARE-05 Đổi nhiệm vụ (giới hạn lượt) — UI ✅ · BE ✅ · App ✅ (BF-20261018-007)
- [x] CARE-06 Hoàn thành / hoàn tác (Hearts do server ghi) — UI ✅ · BE ✅ · App ✅ (BF-20261018-007)
- [x] CARE-06 “Lưu lại khoảnh khắc” → ký ức từ nhiệm vụ trên server — BE ✅ (`POST /missions/:id/moment`, BF-20261019-003) · App ✅ (tải ảnh + lưu qua server, BF-20261019-003)
- [x] Nhiệm vụ lặp lại (series) — UI ✅ (form CARE-03 + mục “Chuỗi lặp lại” trong Cài đặt nhiệm vụ: tạm dừng 1 tuần / dừng chuỗi) · BE ✅ (`/mission-series`, hằng ngày/theo thứ, tạm dừng, kết thúc, BF-20261019-003) · App ✅ (tạo chuỗi, danh sách/tạm dừng/dừng qua server, BF-20261019-010)
- [x] CARE-08 Lịch sử nhiệm vụ — UI ✅ · BE ✅ (BF-20261018-009, Antigravity) · App ✅ (BF-20261018-012)
- [x] CARE-12 Cài đặt nhiệm vụ — UI ✅ · BE ✅ (`/mission-settings`, `/mission-preferences`, BF-20261019-003) · App ✅ (mức bảng cả nhà + tuỳ chọn của tôi, BF-20261019-003)
- [x] Bàn giao ca (handoff) — **1.1** — BE ✅ (`POST/GET /families/:id/us/handoffs` + `/:id/acknowledge`, ghi chú mã hoá theo couple space, Idempotency-Key, thông báo `NOTI_HANDOFF_CREATED` tới bạn đời, BF-20261028-007) · App ✅ (ô “Bàn giao ca” ở Papa & Mama: bé, đã ăn/ngủ/dậy lúc, ghi chú, tuỳ chọn mở Lời nhờ; thẻ bàn giao mới nhất + “Đã nhận”; offline qua outbox, BF-20261028-007)

## 10. Hearts, cây gia đình, huy hiệu (§7.14, §7.15)

- [x] Hearts riêng tư (ledger, giới hạn/ngày) — UI ✅ · BE ✅ (`/hearts/me`, BF-20261018-009) · App ✅ (BF-20261018-012)
- [x] CARE-09 Cây gia đình (cấp + %) — UI ✅ · BE ✅ (BF-20261018-009) · App ✅ (BF-20261018-012; số liệu tuần `bloomedDaysThisWeek` từ API cây gia đình)
- [x] CARE-10 Huy hiệu — UI ✅ · BE ✅ (tính khi đọc BF-20261018-009; worker trao huy hiệu + thông báo BF-20261018-014, Codex) · App ✅ (BF-20261018-012/014)
- [x] CARE-11 Thống kê chăm con — **1.1** — UI ✅ · BE ✅ (`GET /families/:id/care-stats`: theo category / tuần / bé, ngày cây nở hoa, không chia theo người, bỏ COUPLE, feature `care.statistics`, BF-20261027-001, Codex) · App ✅ (đổi tuần, đổi bé, bản đọc gần nhất khi mất mạng, BF-20261027-001)

## 11. Papa & Mama Space (§7.16, §9.8)

- [x] US-01 Trang chính Papa & Mama — UI ✅ · BE ✅ (check-in, lời nhờ, cảm ơn) · App ✅ (check-in + lời nhờ BF-20261018-005, cảm ơn từ server; bản server không hiện câu hỏi mẫu — câu hỏi kết nối là bản 1.1 ở dòng riêng, BF-20261021-003)
- [x] US-02 Check-in cảm xúc — UI ✅ · BE ✅ · App ✅ (BF-20261018-003/005)
- [x] US-03/04 Lời nhờ (gửi, nhận, nhắc, hoàn thành, tối đa 5 đang mở) — UI ✅ · BE ✅ · App ✅ (BF-20261018-004/005)
- [x] US-05/06 Lời cảm ơn, bức tường cảm ơn — UI ✅ · BE ✅ · App ✅ (BF-20261018-007/009)
- [x] Đăng lời cảm ơn thành khoảnh khắc gia đình (bạn đời duyệt) trên app + tạo ký ức — BE ✅ (duyệt tạo ký ức PARENTS, BF-20261019-004, Codex) · App ✅ (gửi đề nghị BF-20261019-004; bạn đời duyệt/để riêng trên bức tường cảm ơn, BF-20261019-005)
- [x] US-07 Nhật ký riêng (mã hoá, chia sẻ đoạn) — UI ✅ · BE ✅ · App ✅ (BF-20261018-007/009)
- [x] Ảnh trong nhật ký riêng tải lên server (asset JOURNAL) — BE ✅ (bật tải JOURNAL riêng tư, BF-20261019-004) · App ✅ (BF-20261019-004)
- [x] US-15 Cài đặt Papa & Mama — UI ✅ · BE ✅ (`/me/us-settings`, BF-20261019-004, Codex) · App ✅ (giờ yên tĩnh/khoá nhật ký còn trên máy, BF-20261019-004)
- [x] US-08…13 Cầu nối khi bất đồng + nhánh an toàn — **1.1** — UI ✅ · BE ✅ (`/families/:id/us/bridges`: mời / góp ý vào phiên bạn đời đã mời, tham gia, tạm dừng, “Mình hiểu”, nói rõ hơn, bước tiếp theo + xác nhận, đóng khi cả hai đồng ý; chỉ ý đã chia sẻ, chủ đề/lời nhắn mã hoá, thời hạn lưu 0/7/30/90 ngày tự xoá nội dung, bỏ dở 14 ngày → EXPIRED, thông báo trung tính `NOTI_BRIDGE_INVITED`, BF-20261028-008; chuyển sang bảng có sẵn `us.conflict_*` + job dọn dẹp mỗi giờ, BF-20261028-009) · App ✅ (nháp riêng chỉ trên máy, gửi đúng ý đã chọn; các màn US-08…12 dùng server; US-13 an toàn hoàn toàn trên máy, không gọi server; viết lại US-09 dùng câu mẫu, AI ở 1.2, BF-20261028-008)
- [x] US-14 Tuần của hai ta — **1.1** — UI ✅ · BE ✅ (`GET /families/:id/us/week`: check-in, lời nhờ được hỗ trợ, lời cảm ơn, nhiệm vụ cùng nhau; không điểm, không chia theo người, BF-20261027-002) · App ✅ (BF-20261027-002)
- [x] Câu hỏi kết nối — **1.1** — BE ✅ (catalog câu hỏi có version, câu của ngày cố định cho hai người, câu trả lời mã hoá, chỉ hiện khi cả hai đã trả lời, BF-20261027-002) · App ✅ (khối câu hỏi US-01, trả lời / sửa trong ngày, BF-20261027-002)

## 12. Family Circle — người thân (§7.4, §9.9, §9.14; gói Family)

- [x] FAM-01 Tổng quan gia đình từ server — UI ✅ · BE ✅ (`/overview`, `/circle`, BF-20261019-004) · App ✅ (người thân + lời mời từ server, BF-20261019-004)
- [x] FAM-03 Mời người thân (wizard 5 bước, quyền theo từng bé) — UI ✅ · BE ✅ (`/invites/circle`, BF-20261019-004, Codex) · App ✅ (BF-20261019-004)
- [x] FAM-04/06 Chi tiết, sửa quyền, gỡ người thân — UI ✅ · BE ✅ (`/circle-members/*`, BF-20261019-004) · App ✅ (tắt thông báo còn trên máy, BF-20261019-004)
- [x] FAM-05 Lời mời đang chờ — UI ✅ · BE ✅ (thu hồi/gia hạn, BF-20261019-004) · App ✅ (BF-20261019-004)
- [x] FAM-07 Cài đặt gia đình — UI ✅ · BE ✅ (`PATCH /families` + `contentLocale`, `coverAssetId`/`coverUrl` BF-20261019-009; danh mục múi giờ `/catalog/timezones` BF-20261021-001) · App ✅ (tên, quyền riêng tư, ảnh bìa, ngôn ngữ nội dung BF-20261019-009; múi giờ từ danh mục server BF-20261021-001)
- [x] CIR-WAIT, CIR-01…06 App của người thân — UI ✅ · BE ✅ (lời mời CIRCLE, `/me/circles` có quyền theo bé, Circle tải ảnh lên, BF-20261019-005) · App ✅ (nhận lời mời, chờ duyệt, bảng tin, lời chúc/thả tim, đăng ảnh chờ duyệt, BF-20261019-005; tuỳ chọn thông báo CIR-06 còn trên máy)
- [x] Lọc ký ức theo quyền Circle (ACL §6.3) — BE ✅ (mọi đường đọc + media + cột mốc/thống kê hồ sơ khi bé gắn lẫn, BF-20261019-004/BF-20261019-005)
- [x] MEM-19 Duyệt ảnh người thân đăng — UI ✅ · BE ✅ (`pending-review`, approve/reject, BF-20261019-004, Codex) · App ✅ (BF-20261019-004)
- [x] CIR-05 Gia đình tạm dừng chia sẻ khi hết gói — UI ✅ · BE ✅ (403 `CIRCLE_PAUSED`, BF-20261019-004) · App ✅ (trạng thái từ `/me/circles`, chuyển màn khi mở lại, BF-20261019-005)

## 13. Tổng kết (Recap) (§7.19, §9.10)

- [x] REC-02 Tuần của nhà mình (job recap tuần) — UI ✅ · BE ✅ (job `recap.weekly-build`, `/recaps/weekly`, BF-20261019-007, Codex) · App ✅ (đọc recap mới nhất, BF-20261019-007; chia sẻ với người thân `PUT …/recaps/weekly/:id/share` (gói có Family Circle, người thân nhận `NOTI_WEEKLY_RECAP_SHARED`), lưu vào timeline `POST …/timeline` (một ký ức mỗi tuần, chỉ Bố Mẹ xem), tải ảnh tổng kết dựng trên máy, BF-20261030-004; người thân mở bản chia sẻ chỉ đọc từ thông báo hoặc CIR-06 → Tuần của nhà mình, BF-20261030-005)
- [x] Số liệu “Tuần này” ở HOME-01 từ server — UI ✅ · BE ✅ (`/home/week-stats`, BF-20261019-007, Codex) · App ✅ (BF-20261019-007)
- [x] REC-01 Câu chuyện ngày — **1.1** — UI ✅ · BE ✅ (`GET /children/:id/day-story?date`, `PUT/DELETE …/:date`: ký ức + ảnh trong ngày theo quyền xem, mỗi bé + ngày một câu chuyện, chỉ Parent, BF-20261028-006) · App ✅ (bản không AI: tự viết tiêu đề/đoạn văn, chọn ký ức + ảnh kèm + ảnh bìa, ai thấy; đoạn văn AI chờ mục AI 1.2, BF-20261028-006)
- [x] REC-03 Tháng tuổi — **1.1** — UI ✅ · BE ✅ (`GET /children/:id/month-recap`: ký ức / lần đầu / giọng nói của tháng tuổi theo `age_month`, ảnh tháng này và tháng trước, theo quyền xem của feed, BF-20261027-003) · App ✅ (story tháng tuổi từ server, ảnh tháng đã ký, ký ức đọc lại khi thiếu, BF-20261027-003)
- [x] REC-04 Year Story / Sách của con — **2.0** — UI 🟡 (không có frame Pencil; dựng theo Design System) · BE ✅ (`GET/PUT /children/:id/year-book/:year`: chương theo tháng, tự chọn ký ức/ảnh ưu tiên cột mốc, lưu chọn/bỏ + chú thích + tên sách/chương vào `app.recaps` period YEAR, URL ảnh ~1080px, chỉ Parent, `canExport` theo cờ gói `yearbook.export`, BF-20261028-013) · App ✅ (CHD-01 → Sách của con: chọn năm, chọn/bỏ ký ức và ảnh, sửa chú thích/tên, lưu offline-first qua outbox, xuất PDF dựng trên máy font BeVietnamPro rồi chia sẻ; gói dùng thử chỉ xem trước + nút Nâng cấp, BF-20261028-013). Sách cả nhà: `GET/PUT /families/:id/year-book/:year` (mọi ký ức của gia đình, `app.recaps` scope FAMILY), màn REC-04 chọn “bé / Cả nhà”, BF-20261030-001. Bản cho ông bà: Parent bật “Chia sẻ với ông bà, người thân” (gói có Family Circle, cờ `yearbook.circleShare`), người thân đọc bản chỉ đọc từ CIR-06 → Sách năm của nhà (`GET /families/:id/year-books`); xem trước PDF trong app (`printing` 5.14.3, mọi gói, xuất theo gói), BF-20261030-002; người thân nhận thông báo `NOTI_YEARBOOK_SHARED` khi sách mới được chia sẻ (mở Sách năm của nhà), BF-20261030-003.

## 14. Lịch & sự kiện (§7.20)

- [x] CARE-07 Lịch (âm lịch) — UI ✅ · BE ✅ (`/calendar`, âm lịch, sinh nhật/tròn tháng, BF-20261018-012, Antigravity) · App ✅ (BF-20261018-013)
- [x] CAL-02 Tạo sự kiện + nhắc — UI ✅ · BE ✅ (CRUD `/events` BF-20261018-012; job lập lịch + gửi nhắc vào hộp thư BF-20261018-013, Codex; mỗi nhắc tạo một lượt push ngay, chạm mở Lịch, BF-20261030-010) · App ✅ (BF-20261018-013)

## 15. Thông báo (§7.21)

- [ ] Push notification (APNs/FCM), đăng ký token — BE ✅ (worker gửi FCM, giờ yên tĩnh, trần 3/ngày, BF-20261018-014, Codex) · App ✅ (đăng ký token, BF-20261018-014; chạm thông báo — kể cả lúc app đang tắt — mở đúng màn theo `deepLink`, người thân không vào màn của Bố Mẹ, BF-20261030-005; thông báo đến khi app đang mở hiện thanh báo + “Xem”, BF-20261030-006) · 🟡 chưa thử FCM/APNs thật trên thiết bị
- [x] NOTI-01 Hộp thông báo (trong app) — UI ✅ · BE ✅ · App ✅ (BF-20261018-010/011)
- [x] Giờ yên tĩnh, ẩn nội dung, cài đặt từng loại — UI ✅ · BE ✅ (`/me/notification-settings`, BF-20261019-006) · App ✅ (BF-20261019-006; nhóm nhiệm vụ/cầu nối/cột mốc/recap/gói còn trên máy)
- [x] Email giao dịch (OTP qua mail chỉ dùng dev) — BE ✅ (outbox `mail.transactional` → worker riêng, 7 mẫu vi/en: xuất dữ liệu, hẹn xoá tài khoản/gia đình + nhắc, đổi số, thêm phương thức đăng nhập; chỉ email đã xác minh, BF-20261021-002, Codex; chưa thử SMTP production)

## 16. Tìm kiếm (§7.22)

- [x] MEM-15 Tìm kiếm cơ bản — UI ✅ · BE ✅ (`/search`, bỏ dấu, đúng ACL, BF-20261019-006) · App ✅ (BF-20261019-006)
- [x] MEM-16 Ngày này năm xưa — UI ✅ · BE ✅ (`/on-this-day`, BF-20261019-006) · App ✅ (BF-20261019-006; đầy đủ ở **1.1**)

## 17. Quyền riêng tư & an toàn (§7.23, §7.24)

- [x] Bảng điều khiển quyền riêng tư (SET) — UI ✅ · BE ✅ (`/privacy-overview`, BF-20261019-008, Codex) · App ✅ (người thân theo `/circle`, số đã chặn + mặc định ai xem từ server, BF-20261019-008)
- [x] RPT-01 Báo cáo nội dung — UI ✅ · BE ✅ (`POST /reports`, ẩn với tôi, BF-20261019-006) · App ✅ (BF-20261019-006)
- [x] RPT-02 Chặn người dùng, danh sách đã chặn — UI ✅ · BE ✅ (`/blocks`, ẩn ở feed/tìm kiếm/bình luận, BF-20261019-006) · App ✅ (BF-20261019-006)
- [x] Kiểm duyệt (moderation case) — BE ✅ (gom báo cáo theo đối tượng, ưu tiên/SLA, job `moderation.reconcile-sla` phục hồi + ESCALATED, BF-20261019-010, Codex; thao tác của nhân viên thuộc Admin CMS §21)

## 18. Gói dịch vụ (§5, §9.11)

- [x] Trial 7 ngày theo policy catalog — BE ✅ · App ✅ (BF-20261015-002, BF-20261015-012)
- [x] Catalog gói `GET /billing/plans` trên app — UI ✅ · BE ✅ · App ✅ (quota/feature từ server, giá Store còn trên máy, BF-20261019-006)
- [x] SUB-03 Gói của gia đình `GET /families/:fid/billing` — UI ✅ · BE ✅ · App ✅ (BF-20261019-006)
- [ ] SUB-01/02 Paywall + mua IAP (App Store / Google Play), xác minh receipt — UI ✅ · BE ✅ (BF-20261020-001) · App 🟡 (`in_app_purchase` StoreKit 2/Play: purchase-intent → Store → `purchases/verify` → hoàn tất giao dịch, huỷ không báo lỗi, BF-20261021-007; chưa cấu hình sản phẩm Store và chưa thử sandbox)
- [ ] SUB-04 Nâng cấp House → Family — UI ✅ · BE ✅ (`/billing/upgrade-options`, BF-20261020-001) · App 🟡 (mua Family qua cùng luồng IAP, BF-20261021-007; chưa thử sandbox)
- [x] SUB-05 Đạt giới hạn (photos/memory/storage) dùng mã lỗi server — UI ✅ · BE ✅ · App ✅ (sheet giới hạn theo `QUOTA_MEMORY_COUNT_EXCEEDED|QUOTA_STORAGE_EXCEEDED|QUOTA_PHOTOS_PER_MEMORY` khi lưu ký ức, lưu nháp/nâng cấp, BF-20261020-001)
- [x] SUB-06/07 Banner trạng thái, hết hạn/EXPIRED phản chiếu vào app — UI ✅ · BE ✅ (`statusBanner` trong `/billing`, worker nhắc trước hạn/ân hạn/hết hạn theo mốc, 5 template BILLING, BF-20261019-010, Codex) · App ✅ (gói/hạn/dung lượng/ân hạn từ `/billing`, BF-20261019-006)
- [x] Store server notifications, ân hạn, hoàn tiền — BE ✅ (`/webhooks/app-store`, `/webhooks/play`, worker `store-notifications`: gia hạn/ân hạn/hết hạn/huỷ tự gia hạn/hoàn tiền/thu hồi, BF-20261020-001, Codex; chưa thử Store thật)
- [x] Đọc dữ liệu khi gói hết hạn (allowlist §6.5) — BE ✅ (allowlist cụ thể: bootstrap, billing, đọc ký ức, media-grid, tải gốc, xuất dữ liệu; còn lại 402/403; đóng các đường đọc rộng cũ, BF-20261019-010, Codex)

## 19. Cài đặt cá nhân (§9.12)

- [x] SET hồ sơ cá nhân `PATCH /me` — UI ✅ · BE ✅ · App ✅ (tên hiển thị, BF-20261019-006; tên gọi/ảnh đại diện còn trên máy)
- [x] Hiển thị (dark mode, cỡ chữ), ngôn ngữ đồng bộ `PATCH /me/settings` — UI ✅ · BE ✅ · App ✅ (lưu trên máy + đồng bộ server, áp khi mở app, BF-20261019-008)
- [x] Cài đặt AI (tắt/bật, đồng ý) — UI ✅ · BE ✅ (`/me/ai-settings`, BF-20261019-006) · App ✅ (BF-20261019-006)
- [x] Trợ giúp, giới thiệu — UI ✅ · BE ✅ (`GET /support/help-center`: FAQ có version vi/en, liên hệ + đường dẫn pháp lý theo cấu hình, BF-20261021-003) · App ✅ (FAQ có câu trả lời, email/hotline/điều khoản/quyền riêng tư mở được khi server cấu hình, BF-20261021-003)

## 20. Rời gia đình, xoá tài khoản, xuất dữ liệu (§7.25)

- [x] Xoá tài khoản (bắt buộc Store) — UI ✅ · BE ✅ (chờ 30 ngày, huỷ, executor BF-20261018-012; xác thực lại OTP `/auth/reauth/*` BF-20261018-013, Codex; xác thực lại qua Apple/Google `POST /auth/reauth/apple|google`, BF-20261020-001) · App ✅ (BF-20261018-013; nút xác thực lại bằng Apple/Google đã liên kết thay bản mock, BF-20261030-003)
- [x] Xuất dữ liệu (export job, link tải) — UI ✅ · BE ✅ (JSON + manifest media, BF-20261018-012, Codex) · App ✅ (BF-20261018-013)
- [x] Người thân rời gia đình — UI ✅ · BE ✅ (`/circle/leave`, BF-20261019-004) · App ✅ (BF-20261019-005; “gỡ toàn bộ” gửi `removeContent` → ký ức vào thùng rác của gia đình, bình luận và cảm xúc bị gỡ (cảm xúc từ BF-20261030-004); Bố Mẹ nhận thông báo trung tính `NOTI_CIRCLE_LEFT`, BF-20261030-003)
- [x] Xoá gia đình (cả hai Parent đồng ý) — BE ✅ (`/families/:fid/deletion`, job hết hạn, BF-20261019-008, Codex) · App ✅ (OTP xác thực lại, chờ đồng ý, hẹn xoá, huỷ, BF-20261019-008)

## 21. Vận hành & Admin CMS (§7.26, §9.15)

- [x] Admin CMS web (`baby-admin/`) — ✅ (React + Vite + TS + Ant Design theo tài liệu kỹ thuật §24: đăng nhập email + mật khẩu + TOTP, menu theo vai trò, kiểm duyệt, khoá license, CSKH, catalog chỉ đọc; `admin-ci.yml`; đã chạy thật với backend + DB test, BF-20261021-006)
- [ ] Quản lý catalog nhiệm vụ/cột mốc/gợi ý/thông báo — BE 🟡 (nhiệm vụ: tạo nháp → publish → ngừng dùng có lý do + audit, BF-20261021-007, Codex; cột mốc: cột `version` (migration DDL) + nháp → publish → ngừng dùng có lý do + audit, BF-20261028-003; mẫu thông báo chưa có version — chờ chốt mô hình) · Admin 🟡 (form nhiệm vụ trong Catalog, BF-20261021-007; form cột mốc, BF-20261028-003)
- [x] Quản lý gói/plan version/trial policy — BE ✅ (tạo phiên bản nháp → publish có ngày hiệu lực → ngừng dùng, không sửa bản đang dùng, RBAC BILLING_OPS/OPS, audit, BF-20261021-007, Codex) · Admin ✅ (form phiên bản gói, chính sách dùng thử, BF-20261021-007)
- [x] Xử lý báo cáo, khoá license có audit — BE ✅ (`/admin/v1/moderation/*`, khoá/mở license có lý do + `AdminAuditEvent`, BF-20261021-002) · Admin ✅ (màn Kiểm duyệt: xem nội dung có lý do, đổi trạng thái, ẩn; màn Khoá license, BF-20261021-006)
- [x] Hỗ trợ khách hàng (support ticket) — UI ✅ · BE ✅ (`/support/*`, nội dung mã hoá, không cần gói còn hạn, BF-20261019-010, Codex) · App ✅ (gửi yêu cầu theo danh mục server + danh sách đã gửi, BF-20261019-010; xem/nhắn tiếp trong ticket đã có ở màn chi tiết yêu cầu)

## 22. Đa ngôn ngữ & accessibility (§7.27, §10.10–10.11)

- [x] Ngôn ngữ vi + en trên app, đổi ngay không khởi động lại (2026-10-07)
- [x] Server trả nội dung/lỗi theo `Accept-Language` — BE ✅ (vi/en, BF-20261019-008, Codex)
- [x] Dark mode, chữ lớn tới 200% (UI)

## 23. AI có kiểm soát — 1.2

- [x] **1.2** Gợi ý chú thích, câu chuyện ngày, gợi ý nhiệm vụ AI, viết lại nhẹ nhàng, tóm tắt Cầu nối — UI 🟡 (không có frame Pencil cho sheet AI; dựng theo Design System) · BE ✅ (OpenRouter `openrouter/free` qua `AI_*` env, `/families/:id/ai/{status,consents,captions,day-story,rewrite,bridge-summary}`: chỉ Parent, gói `ai.enabled` + `aiPerMonth`, cài đặt AI, đồng ý lần đầu mỗi tính năng, giữ chỗ/trừ hạn mức, ghi metadata lượt gọi không lưu nội dung, nhánh an toàn không gửi AI, BF-20261028-010; báo cáo nội dung AI thật: đích `AI_OUTPUT` + lý do `AI_CONTENT` vào luồng báo cáo/kiểm duyệt có sẵn, chỉ người nhận bản nháp báo cáo được, Admin xem đoạn được báo cáo + tính năng/model, BF-20261028-011; gợi ý nhiệm vụ: AI chỉ chọn trong catalog mẫu bé đủ điều kiện + thống kê nhóm 14 ngày, server kiểm lại từng lựa chọn; thử lại 1 lần trong cùng lượt khi model trả rỗng/sai định dạng, BF-20261028-012) · App 🟡 (gợi ý chú thích ở MEM-04, US-09 viết lại từ câu ở US-08, “Viết lại” REC-01 bằng AI, hộp đồng ý lần đầu, lượt còn lại ở SET-05, BF-20261028-010; “Báo cáo nội dung AI” gửi báo cáo thật ở MEM-04/US-09/REC-01, nút “✨ Tóm tắt giúp hai bạn” ở US-11, BF-20261028-011; “✨ Gợi ý cho hôm nay” ở CARE-04 → chọn một việc trả về CARE-03, BF-20261028-012)

## 24. Phát hành Store

- [ ] Build ký số iOS/Android, TestFlight / Internal testing — ❌
- [ ] Chính sách quyền riêng tư, điều khoản, age rating, privacy manifest — 🟡 (`ios/Runner/PrivacyInfo.xcprivacy` gắn vào target, không tracking; `docs/05_PHAP_LY_PHAT_HANH.md`: kê dữ liệu thu thập, Data safety, đề xuất age rating, BF-20261028-001; chưa có văn bản chính sách/điều khoản do người phụ trách pháp lý duyệt, chưa đặt `LEGAL_*_URL`)
- [x] Kiểm thử bất biến bảo mật §6.4 (release blocker) đầy đủ — ✅ (phần MVP: `security-invariants.spec.ts` quét 53 route cho người ngoài/Circle/bạn đời + bảng bao phủ 1–10 ở `baby-backend/docs/security-invariants.md`; sửa lịch/nhiệm vụ trả 403 lộ sự tồn tại → 404, BF-20261021-004. Phần 1.1 (Cầu nối, PREG-07) bổ sung khi có route; chưa pentest ngoài)

## 25. Nhắn tin trong gia đình (ngoài đặc tả v3; §12 Realtime)

- [x] Chat cả nhà + chat riêng Papa & Mama, realtime WebSocket, offline-first — UI ✅ (Pencil CHAT-01…CHAT-04b) · BE ✅ (`/families/:fid/chats`, lịch sử phân trang theo `seq`, gửi có Idempotency-Key, đã đọc; Socket.IO xác thực access token ES256, room `user:{id}`, Redis adapter Valkey nhiều instance, chỉ phát tín hiệu nhỏ; COUPLE mã hoá AES-256-GCM; outbox → push `NOTI_CHAT_FAMILY`/`NOTI_CHAT_COUPLE` chỉ cho người không online, BF-20261101-001) · App ✅ (danh sách, hội thoại, đang nhập / đã xem / đang gửi / gửi lỗi, outbox gửi lại khi có mạng, tự kết nối lại; lối vào Trang chủ, CIR-01, US-01; nhóm thông báo “Tin nhắn cả nhà” ở SET-03; chạy thật 2 tài khoản trên 2 simulator, BF-20261101-001). Chưa có: ảnh/tệp trong chat, sửa/xoá tin, màn thành viên, chat 1–1 với người thân.
