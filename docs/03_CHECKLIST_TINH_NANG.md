# Checklist tính năng Baby Family

Tạo 2026-10-18 (BF-20261018-001). Nguồn: [đặc tả nghiệp vụ](01_DAC_TA_NGHIEP_VU_BABY_FAMILY_v3.md) mục 7, 9, 16 và [tài liệu kỹ thuật](02_TAI_LIEU_KY_THUAT_BABY_FAMILY_v3.md); hiện trạng đối chiếu từ code, [API backend](../baby-backend/docs/api.md), [SESSIONS.md](../SESSIONS.md) và [SESSION.md của app](../baby-family-app/SESSION.md).

## Cách đọc

- `[x]` = **đã xong**: có API backend, app đã nối API thật (chế độ `BABY_FAMILY_API_URL`) và đã có test/kiểm chứng ghi trong nhật ký. `[ ]` = chưa xong.
- Sau mỗi dòng là trạng thái từng phần: **UI** = màn có trong app (phần lớn đang chạy bằng dữ liệu mock), **BE** = API backend, **App** = app gọi API thật. ✅ có · 🟡 một phần · ❌ chưa có.
- Gần như mọi màn MVP đã có UI dạng mock (đợt UI 2026-10-08 → 10-15). Việc còn lại chủ yếu là backend + nối API.
- Mỗi lần xong một dòng: tick `[x]`, ghi mã yêu cầu `BF-…` ở cuối dòng.
- Phase theo đặc tả §16.1: **MVP** (1.0), **1.1**, **1.2**, **2.0**.

## Tiến độ

- Tổng: 144 / 166 dòng đã xong (riêng MVP: 142 / 154).
- Đang làm: —. Xong gần nhất: BF-20261027-001 — PREG-07 Đặt tên cho con, CARE-11 Thống kê chăm con (backend + app). Tiếp theo (1.1 còn lại): US-14 Tuần của hai ta, Câu hỏi kết nối, REC-03 Tháng tuổi, Bàn giao ca; MVP còn lại cần cấu hình Store / Apple / Google / staging
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
- [ ] Offline-first: ghi trên máy trước, đồng bộ khi có mạng (`docs/04_THIET_KE_OFFLINE_FIRST.md`) — BE 🟡 (Idempotency-Key cho các lệnh xếp hàng được, `GET /families/:id/changes` cho ký ức/bình luận/cảm xúc, BF-20261022-001, Codex) · App 🟡 (outbox bền vững cho tạo ký ức: hiện ngay khi mất mạng, tự gửi khi có mạng, không trùng sau khi tắt app, BF-20261022-001; `OutboxRunner` chung cho bình luận, cảm xúc, hoàn thành nhiệm vụ + bảng nhiệm vụ mở được khi offline; kéo changes API: gỡ ký ức đã xoá, đọc lại ký ức đổi, cập nhật bình luận, BF-20261022-002; local DB bền vững (Hive mã hoá theo dòng) cho ký ức + bình luận, mở app offline có dữ liệu, chịu được server đổi/thêm field, BF-20261022-003; local DB bảng chung cho bảng nhiệm vụ và Papa & Mama (check-in, lời nhờ, cảm ơn, nhật ký riêng: đọc offline + tạo qua outbox), BF-20261022-004; thử thật Android + backend thật: tạo offline → mở lạnh offline → có mạng tự gửi đúng một lần, sửa 5 lỗi, BF-20261022-005; màn phụ (lịch sử, huy hiệu, thông báo, cài đặt, album…) dùng bản đọc gần nhất khi mất mạng, BF-20261026-007; chưa có: sửa ký ức, thao tác lời nhờ, tạo/đổi nhiệm vụ khi offline; chưa thử iOS (Flutter 3.44.5 không build được với Xcode 27.1))
- [ ] Môi trường staging + deploy — ❌
- [ ] Logging/monitoring production, cảnh báo sự cố — BE 🟡 (log JSON có cấu trúc, `/metrics` Prometheus có token, hook báo lỗi, `docs/observability.md`, BF-20261021-001, Codex; chưa nối Sentry/cảnh báo thật, worker chưa áp)

## 2. Tài khoản & đăng nhập (§7.1, §9.1)

- [x] SPL-01 Splash, ONB-01 Welcome — UI ✅
- [x] Đăng nhập số điện thoại + OTP (AUTH-02/03) — UI ✅ · BE ✅ · App ✅ (BF-20261015-012)
- [x] Hồ sơ cơ bản + đồng ý điều khoản (AUTH-04) — UI ✅ · BE ✅ · App ✅ (BF-20261015-012)
- [x] Refresh token xoay vòng, đăng xuất — BE ✅ · App ✅ (BF-20261015-012)
- [ ] Đăng nhập Apple — UI ✅ · BE ✅ (`POST /auth/apple`, BF-20261020-001) · App 🟡 (`sign_in_with_apple` + nonce SHA-256, phiên qua server, BF-20261021-007; chưa bật capability Sign in with Apple trong Xcode, chưa thử máy thật)
- [ ] Đăng nhập Google — UI ✅ · BE ✅ (`POST /auth/google`, BF-20261020-001) · App 🟡 (`google_sign_in` 7, client id qua `--dart-define GOOGLE_CLIENT_ID/GOOGLE_SERVER_CLIENT_ID`, BF-20261021-007; chưa cấu hình client id/URL scheme thật, chưa thử máy thật)
- [x] Avatar hồ sơ (upload ảnh AUTH-04) — UI ✅ · BE ✅ (`/me/avatar/*`, `PATCH /me {avatarAssetId}`, `avatarUrl`, BF-20261019-007, Codex) · App ✅ (BF-20261019-007)
- [ ] Liên kết/đổi số điện thoại, quản lý phương thức đăng nhập (SET bảo mật) — UI 🟡 (màn đổi số: xác thực lại → số mới → OTP, BF-20261019-010) · BE ✅ (đổi số `/me/phone/*` BF-20261018-015; `/me/sign-in-methods`, liên kết/gỡ Apple/Google, reauth bằng Apple/Google, BF-20261020-001, Codex) · App 🟡 (đổi số; trạng thái liên kết thật từ server, BF-20261020-001; liên kết/gỡ Apple/Google cần SDK)
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
- [ ] CHD-06 Tăng trưởng — **1.2** — UI ✅ · BE ❌ · App ❌

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
- [x] MEM-24 Kể cùng nhau — góc nhìn thứ hai — UI ✅ · BE ✅ (BF-20261019-002, Codex) · App ✅ (chữ; ghi âm góc nhìn chưa, BF-20261019-002)
- [x] MEM-20/21 Ảnh tháng & “Con lớn từng tháng”, collage — UI ✅ · BE ✅ (`/children/:id/monthly-photos`, BF-20261019-008, Codex) · App ✅ (BF-20261019-008; collage ghép trên app)
- [x] Gợi ý ghi lại (memory prompts) — UI ✅ · BE ✅ (catalog + bỏ qua, BF-20261019-002) · App ✅ (BF-20261019-002)
- [x] MEM-25 Hôm nay của bé (trình chiếu) — UI ✅ · BE ✅ (`/children/:id/today-story`, BF-20261019-009) · App ✅ (BF-20261019-009; “đã xem” lưu trên máy)
- [x] “Ai ở đó” (people), địa điểm, cảm xúc đầy đủ — UI ✅ (mục nâng cao trong trình soạn, BF-20261021-002) · BE ✅ (`people` qua `memory_people`, `feeling`, `locationLabel`, `/people-suggestions`, BF-20261021-002, Codex) · App ✅ (gửi/hiển thị người, cảm xúc, địa điểm, BF-20261021-002; gợi ý người từ server chưa dùng)
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
- [ ] Bàn giao ca (handoff) — **1.1** — BE ❌ · App ❌

## 10. Hearts, cây gia đình, huy hiệu (§7.14, §7.15)

- [x] Hearts riêng tư (ledger, giới hạn/ngày) — UI ✅ · BE ✅ (`/hearts/me`, BF-20261018-009) · App ✅ (BF-20261018-012)
- [x] CARE-09 Cây gia đình (cấp + %) — UI ✅ · BE ✅ (BF-20261018-009) · App ✅ (BF-20261018-012; số liệu tuần chưa có API → 0)
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
- [ ] US-08…13 Cầu nối khi bất đồng + nhánh an toàn — **1.1** — UI ✅ · BE ❌ · App ❌
- [ ] US-14 Tuần của hai ta — **1.1** — UI ✅ · BE ❌ · App ❌
- [ ] Câu hỏi kết nối — **1.1** — BE ❌ · App ❌

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

- [x] REC-02 Tuần của nhà mình (job recap tuần) — UI ✅ · BE ✅ (job `recap.weekly-build`, `/recaps/weekly`, BF-20261019-007, Codex) · App ✅ (đọc recap mới nhất, BF-20261019-007; chia sẻ/lưu recap lên server chưa có)
- [x] Số liệu “Tuần này” ở HOME-01 từ server — UI ✅ · BE ✅ (`/home/week-stats`, BF-20261019-007, Codex) · App ✅ (BF-20261019-007)
- [ ] REC-01 Câu chuyện ngày — **1.1** — UI ✅ · BE ❌ · App ❌
- [ ] REC-03 Tháng tuổi — **1.1** — UI ✅ · BE ❌ · App ❌
- [ ] REC-04 Year Story / Sách của con — **2.0** — ❌

## 14. Lịch & sự kiện (§7.20)

- [x] CARE-07 Lịch (âm lịch) — UI ✅ · BE ✅ (`/calendar`, âm lịch, sinh nhật/tròn tháng, BF-20261018-012, Antigravity) · App ✅ (BF-20261018-013)
- [x] CAL-02 Tạo sự kiện + nhắc — UI ✅ · BE ✅ (CRUD `/events` BF-20261018-012; job lập lịch + gửi nhắc vào hộp thư BF-20261018-013, Codex; push chưa) · App ✅ (BF-20261018-013)

## 15. Thông báo (§7.21)

- [ ] Push notification (APNs/FCM), đăng ký token — BE ✅ (worker gửi FCM, giờ yên tĩnh, trần 3/ngày, BF-20261018-014, Codex) · App ✅ (đăng ký token, BF-20261018-014) · 🟡 chưa thử FCM/APNs thật trên thiết bị
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

- [x] Xoá tài khoản (bắt buộc Store) — UI ✅ · BE ✅ (chờ 30 ngày, huỷ, executor BF-20261018-012; xác thực lại OTP `/auth/reauth/*` BF-20261018-013, Codex; xác thực lại qua Apple/Google chưa có vì server chưa có đăng nhập Apple/Google) · App ✅ (BF-20261018-013)
- [x] Xuất dữ liệu (export job, link tải) — UI ✅ · BE ✅ (JSON + manifest media, BF-20261018-012, Codex) · App ✅ (BF-20261018-013)
- [x] Người thân rời gia đình — UI ✅ · BE ✅ (`/circle/leave`, BF-20261019-004) · App ✅ (BF-20261019-005; gỡ nội dung đã đăng chưa có API)
- [x] Xoá gia đình (cả hai Parent đồng ý) — BE ✅ (`/families/:fid/deletion`, job hết hạn, BF-20261019-008, Codex) · App ✅ (OTP xác thực lại, chờ đồng ý, hẹn xoá, huỷ, BF-20261019-008)

## 21. Vận hành & Admin CMS (§7.26, §9.15)

- [x] Admin CMS web (`baby-admin/`) — ✅ (React + Vite + TS + Ant Design theo tài liệu kỹ thuật §24: đăng nhập email + mật khẩu + TOTP, menu theo vai trò, kiểm duyệt, khoá license, CSKH, catalog chỉ đọc; `admin-ci.yml`; đã chạy thật với backend + DB test, BF-20261021-006)
- [ ] Quản lý catalog nhiệm vụ/cột mốc/gợi ý/thông báo — BE 🟡 (nhiệm vụ: tạo nháp → publish → ngừng dùng có lý do + audit, BF-20261021-007, Codex; cột mốc/mẫu thông báo chưa có version) · Admin 🟡 (form nhiệm vụ trong Catalog, BF-20261021-007)
- [x] Quản lý gói/plan version/trial policy — BE ✅ (tạo phiên bản nháp → publish có ngày hiệu lực → ngừng dùng, không sửa bản đang dùng, RBAC BILLING_OPS/OPS, audit, BF-20261021-007, Codex) · Admin ✅ (form phiên bản gói, chính sách dùng thử, BF-20261021-007)
- [x] Xử lý báo cáo, khoá license có audit — BE ✅ (`/admin/v1/moderation/*`, khoá/mở license có lý do + `AdminAuditEvent`, BF-20261021-002) · Admin ✅ (màn Kiểm duyệt: xem nội dung có lý do, đổi trạng thái, ẩn; màn Khoá license, BF-20261021-006)
- [x] Hỗ trợ khách hàng (support ticket) — UI ✅ · BE ✅ (`/support/*`, nội dung mã hoá, không cần gói còn hạn, BF-20261019-010, Codex) · App ✅ (gửi yêu cầu theo danh mục server + danh sách đã gửi, BF-20261019-010; chưa xem/nhắn tiếp trong ticket)

## 22. Đa ngôn ngữ & accessibility (§7.27, §10.10–10.11)

- [x] Ngôn ngữ vi + en trên app, đổi ngay không khởi động lại (2026-10-07)
- [x] Server trả nội dung/lỗi theo `Accept-Language` — BE ✅ (vi/en, BF-20261019-008, Codex)
- [x] Dark mode, chữ lớn tới 200% (UI)

## 23. AI có kiểm soát — 1.2

- [ ] **1.2** Gợi ý chú thích, câu chuyện ngày, gợi ý nhiệm vụ AI, viết lại nhẹ nhàng, tóm tắt Cầu nối — UI 🟡 · BE ❌

## 24. Phát hành Store

- [ ] Build ký số iOS/Android, TestFlight / Internal testing — ❌
- [ ] Chính sách quyền riêng tư, điều khoản, age rating, privacy manifest — ❌
- [x] Kiểm thử bất biến bảo mật §6.4 (release blocker) đầy đủ — ✅ (phần MVP: `security-invariants.spec.ts` quét 53 route cho người ngoài/Circle/bạn đời + bảng bao phủ 1–10 ở `baby-backend/docs/security-invariants.md`; sửa lịch/nhiệm vụ trả 403 lộ sự tồn tại → 404, BF-20261021-004. Phần 1.1 (Cầu nối, PREG-07) bổ sung khi có route; chưa pentest ngoài)
