# BABY FAMILY — TÀI LIỆU KỸ THUẬT: KIẾN TRÚC, THIẾT KẾ & TRIỂN KHAI

> **Phiên bản:** 3.0 (thay thế “Tài liệu kỹ thuật v2.0 Multi-Child”)  
> **Ngày:** 06/10/2026 — cập nhật 07/10/2026 (mô hình Nhiệm vụ hằng ngày / Hearts riêng / Lời nhờ — mục 0 dòng 23)  
> **Đối tượng đọc:** Tech Lead • Backend (NodeJS) • Mobile (Flutter) • DevOps • QA • Security  
> **Tài liệu đi kèm:** `01_DAC_TA_NGHIEP_VU_BABY_FAMILY_v3.md` — mọi mã màn (`HOME-01`…), quy tắc (`BR-xxx`), tiêu chí (`AC-xxx`) tham chiếu tài liệu đó.  
> **Phạm vi:** thiết kế luồng, dữ liệu, API, màn hình ↔ API, xử lý nền, bảo mật, hạ tầng & triển khai. **Không** gồm phần khởi tạo base project (team tự setup) — nhưng có quy ước cấu trúc để base project tuân theo.

> **Database cập nhật 14/10/2026 — BF-20261013-006/BF-20261014-001:** xem [bộ thiết kế database](database/README.md), [Prisma schema backend](../baby-backend/prisma/schema.prisma) và [forward migration](../baby-backend/prisma/migrations/20261013150000_family_domain/migration.sql). Migration chỉ DDL, chưa áp dụng vào DB ứng dụng; [seed](../baby-backend/prisma/seed.ts) chạy riêng bằng `npm run db:seed`, không tự chạy khi migrate/start. API nghiệp vụ ngoài Note chưa triển khai. License/Pro thuộc **family gốc**, user là người thanh toán; không tự chuyển qua restore/renewal hoặc CSKH.

> **Quyết định bổ sung BF-20261013-005:** trial mặc định **604800 giây = 7 × 24 giờ từ policy có version**, expiry UTC cố định, thay ví dụ 90 ngày/3 tháng/kết thúc cuối ngày và lịch nhắc cũ. Giữ House/Family là catalog ban đầu, cho thêm gói bằng dữ liệu; client/server dùng capabilities. License không chuyển kể cả CSKH; Store gia hạn đã thanh toán sau payer xóa account vẫn cấp family gốc. Xem [billing](database/billing.md), [gap chưa chốt](database/requirements.md) và [chuẩn mở rộng](../.agents/skills/baby-family-team/references/extensibility-standards.md); các ví dụ kỹ thuật cũ phải được đối chiếu trước triển khai.

---

## MỤC LỤC

- [0. Thay đổi so với v2.0 & các điểm sai cần sửa](#0-thay-đổi-so-với-v20--các-điểm-sai-cần-sửa)
- [1. Nguyên tắc kiến trúc](#1-nguyên-tắc-kiến-trúc)
- [2. Technology stack](#2-technology-stack)
- [3. Kiến trúc tổng thể](#3-kiến-trúc-tổng-thể)
- [4. Backend NodeJS (NestJS)](#4-backend-nodejs-nestjs)
- [5. Xác thực & phiên đăng nhập](#5-xác-thực--phiên-đăng-nhập)
- [6. Phân quyền (Authorization)](#6-phân-quyền-authorization)
- [7. Cơ sở dữ liệu PostgreSQL](#7-cơ-sở-dữ-liệu-postgresql)
- [8. MongoDB](#8-mongodb)
- [9. Redis](#9-redis)
- [10. Media pipeline & MinIO](#10-media-pipeline--minio)
- [11. API contract](#11-api-contract)
- [12. Realtime](#12-realtime)
- [13. Hệ thống thông báo](#13-hệ-thống-thông-báo)
- [14. Jobs & Scheduler](#14-jobs--scheduler)
- [15. Mission engine, Hearts & Cây gia đình, Lời nhờ](#15-mission-engine-hearts--cây-gia-đình-lời-nhờ)
- [16. Papa & Mama Space — mã hoá & cô lập dữ liệu](#16-bố--mẹ-space--mã-hoá--cô-lập-dữ-liệu)
- [17. AI module](#17-ai-module)
- [18. Billing — In-App Purchase & Entitlement](#18-billing--in-app-purchase--entitlement)
- [19. Tìm kiếm, Timeline, Recap](#19-tìm-kiếm-timeline-recap)
- [20. Vòng đời dữ liệu: xoá, xuất, lưu giữ](#20-vòng-đời-dữ-liệu-xoá-xuất-lưu-giữ)
- [21. Bảo mật & tuân thủ](#21-bảo-mật--tuân-thủ)
- [22. Ứng dụng Flutter](#22-ứng-dụng-flutter)
- [23. Bản đồ Màn hình ↔ Route ↔ State ↔ API](#23-bản-đồ-màn-hình--route--state--api)
- [24. Admin CMS](#24-admin-cms)
- [25. Hạ tầng & triển khai (Docker)](#25-hạ-tầng--triển-khai-docker)
- [26. CI/CD](#26-cicd)
- [27. Observability](#27-observability)
- [28. Kiểm thử](#28-kiểm-thử)
- [29. Checklist phát hành App Store & Google Play](#29-checklist-phát-hành-app-store--google-play)
- [30. Kế hoạch triển khai (Sprint) & Rủi ro](#30-kế-hoạch-triển-khai-sprint--rủi-ro)

---

## 0. Thay đổi so với v2.0 & các điểm sai cần sửa

| # | Điểm ở v2.0 | Vấn đề | Sửa trong v3.0 |
|---|---|---|---|
| 1 | “Laravel hoặc NodeJS”, “Firebase Auth hoặc OIDC facade” | Chưa chốt | Chốt **NestJS (TypeScript) trên Node.js LTS**, auth tự quản (JWT + refresh rotation), xác minh Apple/Google/OTP phía server. Firebase chỉ dùng **FCM** (push). |
| 2 | Không có MongoDB, nhưng khách hàng muốn dùng Mongo | Chưa phân vai | PostgreSQL = **nguồn sự thật** (quan hệ, quyền, giao dịch). MongoDB = dữ liệu **append-only, khối lượng lớn, có TTL**: hộp thông báo, audit log, log sự kiện app, log AI (đã lược nội dung), log gửi push. Không bao giờ để một nghiệp vụ cần transaction trải trên 2 DB. |
| 3 | `memories.child_id` trong bảng Memory object (mục 5.1) | Mâu thuẫn N-N | Bỏ hoàn toàn. Liên kết qua `memory_children` với **composite foreign key** đảm bảo cùng `family_id` ở mức DB. |
| 4 | `family_circle_grants.child_id nullable = family-level grant` | Tự động lộ bé mới sinh, trái BR-006 | Grant **luôn** trỏ tới đúng 1 `child_id` **hoặc** 1 `pregnancy_id` (CHECK constraint). Không có grant cấp family. |
| 5 | Mission state machine `DRAFT→SCHEDULED→ACTIVE→COMPLETED` | Mâu thuẫn tài liệu nghiệp vụ | Một state machine duy nhất `TODO → DONE / EXPIRED / REMOVED` (mục 15.1) dùng chung với nghiệp vụ 7.13.5 (xem dòng 23). |
| 6 | Ví dụ API create mission dùng `child_id` + `assignee_type: BOTH` | Không có `target_scope`, `child_ids[]` | Chuẩn hoá payload (mục 11.6): `targetScope` + `childIds[]` + `owner: ME|TOGETHER`. |
| 7 | Visibility `family / parents_only` | Thiếu `PRIVATE` | Enum `PRIVATE | PARENTS | FAMILY`. |
| 8 | Invite TTL 24–72h | Quá ngắn cho ông bà | Partner 7 ngày, Circle 14 ngày (cấu hình được). |
| 9 | Deep link dạng `app://…`, chưa nói hạ tầng | Firebase Dynamic Links **đã ngừng hoạt động từ 25/08/2025** | Universal Links (iOS) + App Links (Android) trên domain riêng `babyfamily.vn`, trang web fallback cho người chưa cài app. |
| 10 | “strip EXIF GPS” chung chung; không nói HEIC | `sharp` bản prebuilt **không giải mã HEIC (HEVC)** | Client chuyển HEIC→JPEG trước khi upload; worker dùng `exiftool` xoá GPS không mất chất lượng cho bản gốc; video xoá metadata vị trí bằng `ffmpeg -map_metadata -1`. |
| 11 | Signed URL + “Private CDN” | Signed URL thay đổi mỗi lần ký → client tải lại ảnh liên tục; CDN cache sai cách có thể bỏ qua kiểm tra chữ ký | Client cache theo **khoá ổn định** `assetId_variant`; edge cache chỉ dùng CDN có kiểm tra token (mục 10.6). |
| 12 | Không nói Sign in with Apple revoke | Apple yêu cầu **thu hồi token SIWA** khi xoá tài khoản | Lưu refresh token Apple (mã hoá) lúc đăng nhập; gọi `/auth/revoke` trong deletion job. |
| 13 | Không nói acknowledge Google Play | Google **tự hoàn tiền** nếu không acknowledge trong 3 ngày | Server acknowledge ngay sau khi xác minh. |
| 14 | Không có gói House/Family | | Quyền sử dụng `INCOMPLETE → TRIAL(policy mặc định 7 ngày) → PAID → EXPIRED`, có `BLOCKED` riêng; plan/quota/features lấy catalog có version (mục 6.5, 18). Không có gói Free vĩnh viễn. |
| 21 | v2.0 cho dùng app khi mới có 1 Parent | Khách hàng xác nhận không cho phép | **Gate kích hoạt**: bắt buộc chọn vai trò; mọi API nghiệp vụ trả `403 FAMILY_NOT_ACTIVE` khi chưa đủ Bố + Mẹ; người thân chỉ dùng khi đã được mời (mục 6.5). |
| 22 | Không có đặc tả đa ngôn ngữ | Khách hàng yêu cầu hệ thống đa ngôn ngữ | Server i18n (11.8), Flutter l10n (22.12): locale theo từng user, `Accept-Language`, template/catalog đa ngôn ngữ có fallback `user → en → vi`. MVP: `vi` (mặc định), `en`. |
| 15 | Không có đăng nhập SĐT | Ông bà VN | OTP qua Zalo ZNS / SMS brandname (mục 5.3). |
| 16 | Không có âm lịch | Âm lịch Việt Nam tính theo **UTC+7**, khác lịch Trung Quốc (UTC+8) ở một số năm | Dùng thuật toán âm lịch VN (Hồ Ngọc Đức) với timezone = 7 ở cả server và client; **không** dùng thư viện âm lịch Trung Quốc. |
| 17 | MinIO như mặc định an toàn | Từ cuối 2025 MinIO Community **ngừng phát hành binary/Docker image chính thức và chuyển sang chế độ bảo trì** (cần kiểm tra lại tình trạng tại thời điểm triển khai) | Code chỉ dùng **S3 API chuẩn** qua AWS SDK v3 để có thể thay MinIO bằng SeaweedFS / Garage / Ceph RGW / S3 của cloud VN mà không đổi code (mục 10.8). |
| 18 | iOS Privacy Manifest chưa có | Bắt buộc với app & SDK từ 05/2024 | `PrivacyInfo.xcprivacy` trong checklist (mục 29). |
| 19 | Luật VN chưa đề cập | **Luật Bảo vệ dữ liệu cá nhân số 91/2025/QH15 (hiệu lực 01/01/2026)** + văn bản hướng dẫn; dữ liệu trẻ em | Mục 21.4: consent, hồ sơ đánh giá tác động, chuyển dữ liệu ra nước ngoài, lưu trữ tại VN. Cần luật sư xác nhận. |
| 20 | Không có cơ chế đồng bộ offline cụ thể | | Outbox phía client + delta sync API (mục 22.6). |
| 23 | Nhiệm vụ do hệ thống “gợi ý” (`SUGGESTED`) rồi Parent nhận/giao cho bạn đời (`PENDING`/`DECLINED`/`AWAITING_CONFIRM`… — 9 trạng thái, `mission_assignees`); Family Hearts cộng chung (`recent[]` lộ ai làm); “Nhờ hỗ trợ” (`us.support_requests`) tách rời việc giao nhiệm vụ; Cân bằng chăm sóc có “phân chia theo người” | Khách hàng chốt mô hình mới 07/10/2026 (C-14, C-15, C-16): tránh so sánh/áp lực giữa Papa & Mama | **Bảng nhiệm vụ hằng ngày** bày từ thư viện lúc 05:00 giờ gia đình — hai Parent cùng số lượng, tổng Hearts lệch ≤ 2, +1 Cùng nhau; 3 tab Của tôi / Của bạn đời / Cùng nhau; chỉ chủ nhiệm vụ tự hoàn thành; state machine 4 trạng thái `TODO/DONE/EXPIRED/REMOVED` (7.2.7, 15.1–15.3). **Hearts theo từng người, chỉ chính người đó thấy**, cộng dồn vào **Cây gia đình** (API chỉ trả cấp + %) (6.6, 15.5). **Không giao nhiệm vụ cho bạn đời** — thay bằng **Lời nhờ** `us.requests` (11.7, 15.8). **Thống kê chăm con** chỉ ở mức gia đình, bỏ `care_insight_optins` (15.7). Nghiệp vụ: 7.13–7.15, 7.16.2, CARE-01..12, US-03/04, BR-017..026, BR-067..070. |
| 24 | Ký ức chỉ có các loại cơ bản; không có ảnh tháng, góc nhìn thứ hai, câu nói của con, bộ sưu tập tự động, “Hôm nay của con”, gợi ý ghi lại; Trang chủ ghép từ nhiều API rời | Nghiệp vụ bổ sung 7.8.1, 7.8.4, 7.8.6–7.8.9, 7.10 (chương tháng), HOME-01/02/03, MEM-20..25, PREG-07, BR-071..073, AC-026..029 | Loại ký ức `QUOTE`, `MONTHLY_PHOTO`, `KEEPSAKE` + “Ai ở đó” (`memory_people`) + cảm xúc khoảnh khắc; `memory_perspectives` kế thừa visibility; `monthly_photos` (1 ảnh chính/bé/tháng tuổi — unique index); `memory_prompt_*`; `story_views`; view “Ảnh đẹp nhất”; tên dự định `us.pregnancy_name_*`; `pregnancies.carrier_user_id` (7.2.4–7.2.5, 7.2.8); aggregate Trang chủ (11.9); 19.5; 10.9; quyền 6.7. Lời nhờ: `expires_at = due_at + 2h`, hẹn ≤ 7 ngày. |

---

## 1. Nguyên tắc kiến trúc

1. **Modular monolith** trên NestJS: một codebase, nhiều module domain tách bạch, triển khai thành nhiều *process* (API, Worker, Scheduler, Realtime). Không microservices ở MVP — team nhỏ, cần tốc độ, transaction xuyên domain thường xuyên (vd. hoàn thành nhiệm vụ → tạo ký ức → cộng Hearts).
2. **PostgreSQL là nguồn sự thật**; ràng buộc nghiệp vụ quan trọng (2 Parent, cùng family, phạm vi nhiệm vụ) được **enforce ở DB** (unique partial index, composite FK, constraint trigger), không chỉ ở code.
3. **Authorization tập trung** (Policy layer) — mọi truy vấn dữ liệu bé đi qua `AccessContext`; không endpoint nào tự viết điều kiện quyền rời rạc.
4. **Couple data cô lập** — schema riêng `us`, mã hoá cấp ứng dụng, repository riêng không join với feed.
5. **Event-driven nội bộ bằng Transactional Outbox** — ghi sự kiện cùng transaction nghiệp vụ, publisher đẩy vào BullMQ; đảm bảo không mất thông báo/Hearts khi crash.
6. **Idempotency mọi nơi** — mọi POST thay đổi trạng thái nhận `Idempotency-Key`; webhook Store dedup theo event id.
7. **Media không đi qua API server** — upload/download trực tiếp object storage bằng presigned URL.
8. **Contract-first** — OpenAPI sinh từ NestJS, CI sinh Dart client cho Flutter; breaking change phải tăng version.
9. **Privacy by design** — log không chứa nội dung; analytics không chứa tên/ngày sinh/nội dung; AI nhận dữ liệu tối thiểu, đã ẩn danh tên bé.
10. **Cấu hình > code** — quota gói, điểm Hearts, giới hạn thông báo, catalog… nằm trong DB/Admin, không hard-code.
11. **Vendor-neutral** — S3 API chuẩn, AI qua interface, push qua interface, SMS/OTP qua interface.

---

## 2. Technology stack

> Phiên bản: dùng **bản stable/LTS mới nhất tại thời điểm khởi tạo project**, ghi cố định (pin) trong lockfile & Dockerfile. Bảng dưới là mốc tham khảo tại 10/2026.

| Layer | Công nghệ | Ghi chú lựa chọn |
|---|---|---|
| **Mobile** | Flutter **3.44.5** (fvm) + Dart 3.12 | iOS 15+, Android 8.0+ (minSdk 26), **targetSdk ≥ 36** (yêu cầu Google Play từ 31/08/2026) |
| State / DI | **hooks_riverpod + flutter_hooks** (Provider/ChangeNotifierProvider) | Theo base hanoicheck: Page → Controller (BaseNotifier) → Service → Repository |
| Routing | **auto_route** (AutoTabsRouter cho bottom tab) | Guard theo vai trò, deep link |
| Network | **dio + retrofit** (`AppClient`, envelope `BaseRespond`) | Interceptor auth/refresh/idempotency/trace |
| Local DB | **hive** (mã hoá AES-GCM) cho phiên & cài đặt; cache offline/outbox (drift/sqflite) thêm khi làm tính năng offline | |
| **Backend** | Node.js LTS (24.x) + **NestJS** + TypeScript | DI, Guards, Interceptors, module hoá |
| ORM | **Prisma** (schema + migration) — partial index/trigger viết **SQL thuần trong migration** | Có thể thay bằng Drizzle/Kysely nếu team quen SQL-first |
| Validation | class-validator / zod (chọn 1) | DTO strict, whitelist |
| Queue | **BullMQ** trên Redis | Delayed/repeatable job, retry, backoff |
| Realtime | Socket.IO + Redis adapter (hoặc WS gateway của NestJS) | Cập nhật tức thời Papa & Mama, nhiệm vụ |
| **DB chính** | **PostgreSQL 17** (hoặc 18) | JSONB, partial index, `pg_trgm`, `unaccent` |
| **Cache/Queue** | **Redis 7.x** (hoặc Valkey 8 — fork BSD) | Lưu ý giấy phép Redis 8 (AGPL/RSAL); Valkey là thay thế drop-in |
| **Document store** | **MongoDB 8.0** (replica set) | Inbox, audit, logs có TTL |
| **Object storage** | **MinIO** (S3 API) — hoặc tương thích S3 | Private bucket, presigned URL |
| Xử lý ảnh | sharp (libvips) + exiftool + blurhash | |
| Xử lý video/âm thanh | ffmpeg / ffprobe | Trong image worker riêng |
| Push | Firebase Cloud Messaging HTTP v1 (APNs qua FCM) | |
| OTP | Zalo ZNS (ưu tiên) + SMS brandname VN (fallback) | Qua interface `OtpSender` |
| Email (giao dịch) | SMTP provider (SES/Sendgrid/Mailgun…) | Ít dùng; chủ yếu xác nhận xoá tài khoản |
| AI | Interface `AiProvider` — mặc định Anthropic Claude | Mục 17 |
| IAP | StoreKit 2 (App Store Server API + Notifications V2) / Google Play Billing (Developer API + RTDN) | Thư viện chính thức `@apple/app-store-server-library`, `googleapis` |
| Reverse proxy | Nginx (hoặc Traefik) | TLS, rate limit, gzip, upload limits |
| Container | Docker, Docker Compose (dev/staging), Docker Swarm hoặc k3s (prod) | |
| Observability | Prometheus, Grafana, Loki, Alertmanager, OpenTelemetry, Sentry | |
| Admin CMS | React + Vite + Ant Design (hoặc Refine) | Web nội bộ |
| Web công khai | Next.js hoặc static site | Landing, chính sách, trang xoá tài khoản, fallback lời mời, AASA/assetlinks |

---

## 3. Kiến trúc tổng thể

### 3.1 Sơ đồ logic

```
                    ┌─────────────────────────────── Clients ───────────────────────────────┐
                    │  Flutter iOS/Android        Admin CMS (React)        Web (landing,     │
                    │  (Parent / Circle)          (nội bộ, VPN/IP allow)    invite, deletion)│
                    └───────┬───────────────────────────┬──────────────────────┬────────────┘
                            │ HTTPS/WSS                 │ HTTPS                │ HTTPS
                    ┌───────▼───────────────────────────▼──────────────────────▼────────────┐
                    │                    Nginx / Load balancer (TLS, rate limit)             │
                    │  api.babyfamily.vn   ws.babyfamily.vn   admin-api…   media.babyfamily.vn│
                    └───┬──────────────────────┬───────────────┬──────────────────┬─────────┘
                        │                      │               │                  │ presigned GET/PUT
          ┌─────────────▼─────────┐ ┌──────────▼─────────┐ ┌───▼──────────┐ ┌────▼──────────────┐
          │  API process (NestJS) │ │ Realtime process    │ │ Admin API     │ │  MinIO cluster     │
          │  REST /v1, guards,    │ │ Socket.IO gateway   │ │ (NestJS, MFA) │ │  (S3 API, private) │
          │  policy, outbox write │ │ Redis adapter       │ └───┬──────────┘ └────▲──────────────┘
          └──┬───────┬───────┬────┘ └──────────┬──────────┘     │                 │
             │       │       │                 │                │                 │ get/put objects
   ┌─────────▼─┐ ┌───▼────┐ ┌▼─────────┐  ┌────▼────┐           │      ┌──────────┴──────────────┐
   │PostgreSQL │ │ Redis  │ │ MongoDB  │◄─┤ pub/sub │           │      │ Worker processes        │
   │(primary + │ │cache,  │ │ inbox,   │  └─────────┘           │      │ • media (sharp, ffmpeg) │
   │ replica)  │ │BullMQ, │ │ audit,   │                        │      │ • notify / push / digest│
   │ source of │ │rate    │ │ logs TTL │                        │      │ • billing / store sync  │
   │ truth     │ │limit   │ │          │                        │      │ • ai                    │
   └─────▲─────┘ └───▲────┘ └────▲─────┘                        │      │ • deletion / export     │
         │           │           │                              │      │ • recap / search index  │
         └───────────┴───────────┴──────────────────────────────┴──────┤ • outbox publisher      │
                                                                       └──────────┬──────────────┘
                                                                                  │
                         ┌────────────────────────────────────────────────────────▼──────────┐
                         │ External: FCM/APNs • App Store Server API & Notifications V2 •     │
                         │ Google Play Developer API & RTDN (Pub/Sub push) • Zalo ZNS / SMS • │
                         │ AI provider • Sentry • SMTP                                         │
                         └────────────────────────────────────────────────────────────────────┘
   Scheduler process (1 instance active, leader lock Redis) → tạo repeatable jobs BullMQ
```

### 3.2 Vai trò của từng kho dữ liệu

| Kho | Lưu gì | Không lưu gì | Lý do |
|---|---|---|---|
| **PostgreSQL** | Người dùng, gia đình, Parent, Circle, grant, bé, thai kỳ, ký ức, asset metadata, bình luận, nhiệm vụ, Hearts ledger, Papa & Mama (mã hoá), gói, báo cáo, outbox, cấu hình, catalog | Log khối lượng lớn, nội dung media | Transaction, ràng buộc, join quyền |
| **MongoDB** | `notifications` (inbox 90 ngày), `audit_logs` (admin + bảo mật, 2 năm), `app_events` (analytics thô, 13 tháng), `ai_logs` (metadata, 90 ngày), `push_logs` (30 ngày), `client_errors` (30 ngày), `security_events` | Bất cứ thứ gì cần ràng buộc quan hệ hoặc là nguồn sự thật nghiệp vụ | Append-only, schema linh hoạt, TTL index, ghi nhiều |
| **Redis** | Cache AccessContext, bộ đếm rate-limit/quota ngày, OTP, idempotency, khoá phân tán, hàng đợi BullMQ, buffer gộp thông báo, Socket.IO adapter, denylist JWT | Dữ liệu cần bền vững lâu dài | Tốc độ, TTL |
| **MinIO** | Ảnh/video/âm thanh gốc & các biến thể, file xuất dữ liệu (ZIP), ảnh recap | Metadata (ở PG) | Dung lượng lớn |

### 3.3 Luồng sự kiện nội bộ (Transactional Outbox)

```
API request ──► BEGIN
                 ├─ ghi dữ liệu nghiệp vụ (vd. mission.status=DONE, mission_completions)
                 ├─ ghi heart_ledger theo từng người + family_trees (cùng transaction, idempotent)
                 └─ INSERT outbox_events(type='MissionCompleted', payload)
               COMMIT
Outbox publisher (worker, poll 200ms bằng SELECT … FOR UPDATE SKIP LOCKED)
   └─► BullMQ queue theo loại sự kiện ─► consumers:
          notify (push + inbox) • realtime fan-out • badge evaluator • recap invalidation
          • search indexer • analytics • care snapshot
```

**Domain events chuẩn** (payload **không bao giờ** chứa số Hearts cá nhân — BR-018): `UserRegistered`, `FamilyCreated`, `PartnerLinked`, `TrialStarted`, `TrialExpired`, `ParentAccountDeleted`, `CircleInviteCreated`, `CircleMemberJoined`, `CircleMemberRemoved`, `CircleGrantChanged`, `ChildAdded`, `ChildArchived`, `PregnancyCreated`, `PregnancyBirthConverted`, `PregnancyEnded`, `AssetReady`, `MemoryPublished`, `MemoryPendingReview`, `MemoryReviewed`, `MemoryUpdated`, `MemoryTrashed`, `PerspectiveAdded`, `PerspectiveUpdated`, `MonthlyPhotoSet`, `MonthlyPhotoDue`, `MemoryPromptUsed`, `CommentCreated`, `ReactionAdded`, `MilestoneRecorded`, `MissionBoardGenerated`, `MissionBoardLevelChanged`, `MissionCreated`, `MissionCompleted`, `MissionUndone`, `MissionExpired`, `FamilyTreeLevelUp`, `FamilyTreeBloomed`, `BadgeEarned`, `MoodShared`, `RequestSent`, `RequestResponded`, `RequestDone`, `AppreciationSent`, `ConflictInvited`, `RecapReady`, `EntitlementChanged`, `ReportCreated`, `AccountDeletionRequested`, `AccountDeleted`.

---

## 4. Backend NodeJS (NestJS)

### 4.1 Cấu trúc thư mục (quy ước cho base project)

```
apps/
  api/              # main.ts → HTTP REST /v1 (+ swagger ở non-prod)
  worker/           # main.ts → BullMQ processors (chọn queue qua env WORKER_QUEUES)
  scheduler/        # main.ts → đăng ký repeatable jobs, leader election
  realtime/         # main.ts → Socket.IO gateway
  admin-api/        # main.ts → /admin/v1 (guard admin, MFA)
libs/
  core/             # config, logger, errors, i18n keys, clock, ids (uuidv7), crypto
  db/               # prisma client, transaction helper, raw SQL repos
  mongo/            # mongo client, collections
  redis/            # redis client, locks, rate-limit, cache
  storage/          # S3 client (presign, multipart, head, delete)
  queue/            # BullMQ setup, queue names, job contracts
  outbox/           # outbox writer + publisher
  auth/             # JWT, guards, Apple/Google/OTP verifiers
  access/           # AccessContext resolver + policies  ◄── trung tâm phân quyền
  domain/
    identity/       # users, sessions, devices, consents, settings
    family/         # families, parents, invites, circle, couple space
    journey/        # children, pregnancies, birth conversion
    memory/         # memories, assets link, albums, milestones, comments, reactions, timeline, feed
    media/          # upload intents, processing, signing
    care/           # missions, daily board, series, templates, hearts (ledger cá nhân), family tree, badges, care stats
    us/             # moods, requests (Lời nhờ), appreciations, journal, conflicts, safety
    calendar/       # events, lunar
    recap/          # daily/weekly/monthly
    notification/   # resolver, templates, preferences, push, inbox, digest
    billing/        # plans, products, subscriptions, entitlements, apple, google
    ai/             # provider interface, features, prompts, safety
    trust/          # reports, blocks, moderation
    lifecycle/      # deletion, export, retention purge
    content/        # catalogs (moods, needs, prompts, safety resources), app-config
    sync/           # delta sync
  integrations/
    fcm/ zalo-zns/ sms/ apple/ google-play/ anthropic/ smtp/
prisma/
  schema.prisma
  migrations/       # SQL thuần cho constraint trigger, partial index
test/
  e2e/ authz-matrix/ fixtures/
```

### 4.2 Cross-cutting

| Thành phần | Đặc tả |
|---|---|
| **Request context** | Interceptor gắn `traceId` (header `X-Request-Id` hoặc sinh mới), `userId`, `deviceId`, `appVersion`, `platform`, `locale`, `timezone` vào AsyncLocalStorage |
| **AuthGuard** | Xác minh access JWT (ES256), kiểm tra `sid` không bị revoke (Redis denylist) |
| **FamilyScopeGuard** | Với route có `:familyId` hoặc resource có `family_id` → resolve `AccessContext` (mục 6) |
| **Policy decorators** | `@RequireParent()`, `@RequireChildAccess('VIEW'|'COMMENT'|'CONTRIBUTE', from='param:childId')`, `@RequireCouple()`, `@RequirePlan('FAMILY')`, `@RequireQuota('storage')` |
| **IdempotencyInterceptor** | Với POST/PUT/DELETE có header `Idempotency-Key` (UUID): Redis `SET idem:{userId}:{key} NX` lưu hash request + response 24h; lặp lại → trả response cũ; key trùng nhưng body khác → `409 IDEMPOTENCY_KEY_REUSED` |
| **Optimistic locking** | Resource sửa được có cột `version`; PATCH yêu cầu `If-Match: <version>`; sai → `412 VERSION_CONFLICT` kèm bản mới |
| **Error filter** | Chuẩn hoá lỗi (mục 11.2); không lộ stack trace; ghi Sentry với `traceId` |
| **Rate limit** | Redis sliding window theo `userId` + IP; cấu hình theo route (mục 21.3) |
| **i18n** | `LocaleResolver` (mục 11.8): locale = `users.locale` (đã đăng nhập) → `Accept-Language` → `vi`. Lỗi trả `message` đã dịch + `messageKey`; push/email/inbox render theo locale **người nhận**; catalog trả bản dịch theo locale người gọi |
| **Clock & timezone** | Mọi `timestamptz` lưu UTC; nghiệp vụ theo ngày (nhiệm vụ, Hearts cap, recap) dùng **timezone của gia đình** (`families.timezone`, mặc định `Asia/Ho_Chi_Minh`) |
| **ID** | UUIDv7 sinh ở app (sắp xếp theo thời gian, tốt cho index); mã ngắn (invite code) là base32 Crockford 8 ký tự |
| **Logging** | pino JSON; **cấm** log body request ở route nội dung (memories, us, ai); redact `authorization`, `token`, `otp`, `phone` |
| **Config** | `@nestjs/config` + schema validate; secrets từ Docker secrets/Vault, không từ file `.env` trong image |

### 4.3 Transaction helper

```ts
// libs/db/tx.ts — mọi thay đổi nghiệp vụ + outbox cùng transaction
await db.$transaction(async (tx) => {
  const { mission, completion } = await missionRepo.completeOrThrow(tx, missionId, actor, idemKey); // chỉ chủ nhiệm vụ (15.1)
  const memory  = input.photo ? await memoryService.createFromMission(tx, mission, input) : null;
  // Cùng nhau: MỖI Parent nhận đủ Hearts; nhiệm vụ của một Parent: chỉ chủ nhiệm vụ (BR-024)
  const earners = mission.ownerKind === 'TOGETHER' ? await parents.activeUserIds(tx, familyId) : [mission.ownerUserId];
  for (const userId of earners)
    await hearts.award(tx, { familyId, userId, source: ['MISSION', completion.id],
                             reason: mission.source === 'CUSTOM' || !mission.templateId ? 'CUSTOM_COMPLETED' : 'MISSION_COMPLETED',
                             amount: mission.hearts });
  if (memory) await hearts.award(tx, { familyId, userId: actor, source: ['MISSION_PHOTO', completion.id], reason: 'MISSION_PHOTO', amount: 2 });
  await outbox.add(tx, 'MissionCompleted', { missionId: mission.id, familyId, actor, memoryId: memory?.id }); // không chứa Hearts
}, { isolationLevel: 'ReadCommitted', timeout: 10_000 });
```

---

## 5. Xác thực & phiên đăng nhập

### 5.1 Token

| Token | Định dạng | Thời hạn | Lưu ở client |
|---|---|---|---|
| Access token | JWT **ES256**, claims: `sub` (userId), `sid` (sessionId), `iat`, `exp`, `ver` (token version) | 15 phút | Bộ nhớ |
| Refresh token | 256-bit random (opaque), DB lưu **SHA-256 hash** | 90 ngày trượt (sliding), tuyệt đối 1 năm | `flutter_secure_storage` (Keychain/Keystore) |
| Re-auth token | JWT ngắn hạn 5 phút, `scope=reauth` | 5 phút | Bộ nhớ — dùng cho xoá tài khoản, xoá gia đình |

**Refresh rotation + phát hiện tái sử dụng:** mỗi lần `POST /v1/auth/refresh` cấp refresh mới, đánh dấu cái cũ `replaced_by`. Nếu một refresh **đã bị thay** được dùng lại → coi như bị đánh cắp → revoke **toàn bộ chuỗi session** đó, ghi `security_events`.

Không đưa `familyId`/role vào JWT — quyền thay đổi thường xuyên (gỡ người thân phải có hiệu lực ngay), nên resolve mỗi request qua AccessContext (có cache ngắn + version).

### 5.2 Apple & Google

**Sign in with Apple**
1. Client lấy `identityToken` + `authorizationCode` (+ `nonce` raw do client sinh, gửi hash SHA-256 cho Apple).
2. Server xác minh `identityToken`: chữ ký với JWKS `https://appleid.apple.com/auth/keys`, `iss=https://appleid.apple.com`, `aud` = bundle id (iOS) hoặc service id (Android/web), `exp`, `nonce` khớp.
3. Server đổi `authorizationCode` lấy **refresh token Apple** (`POST https://appleid.apple.com/auth/token` với client secret JWT ký bằng key .p8) → lưu **mã hoá** vào `auth_identities.provider_refresh_token_enc` — dùng để **revoke khi xoá tài khoản** (bắt buộc theo Apple).
4. `sub` của Apple là `provider_uid`. Email có thể là relay `@privaterelay.appleid.com`; tên chỉ có ở lần đăng nhập đầu → client gửi kèm.

**Google Sign-In**
- Client gửi `idToken`; server xác minh bằng `google-auth-library` (`aud` thuộc danh sách client id iOS/Android/Web), `email_verified`.

### 5.3 Số điện thoại + OTP

```
POST /v1/auth/phone/otp      { phone: "+84912345678", channel: "ZALO"|"SMS", captchaToken? }
  → chuẩn hoá E.164 (libphonenumber), kiểm tra rate limit:
      otp:send:{phoneHash}  ≤ 5/giờ, ≥ 60s giữa 2 lần
      otp:ip:{ip}           ≤ 20/giờ
  → sinh mã 6 số (crypto.randomInt), lưu Redis otp:{phoneHash} = {hash(code), attempts:0} TTL 300s
  → OtpSender.send(channel) — Zalo ZNS template; lỗi/không có Zalo → fallback SMS
  → 202 { expiresIn: 300, resendIn: 60, channelUsed }
POST /v1/auth/phone/verify   { phone, code, deviceInfo }
  → so sánh constant-time; sai → attempts++ (≥5 → xoá OTP, khoá 15 phút)
  → đúng → tìm/tạo user theo auth_identities(PHONE, phoneE164) → cấp token
```
- `phoneHash` = HMAC-SHA256(pepper, E.164) — Redis key không lộ số điện thoại.
- Chống SMS pumping: chặn đầu số quốc tế không hỗ trợ, giới hạn theo IP/ASN, có thể bật captcha (Turnstile/reCAPTCHA Enterprise hoặc App Check/Play Integrity) khi phát hiện bất thường.
- **Chi phí OTP:** Zalo ZNS rẻ hơn SMS brandname đáng kể; cần đăng ký Zalo OA + template ZNS được duyệt.

### 5.4 Liên kết nhiều phương thức

`POST /v1/me/identities/{provider}` (yêu cầu re-auth) — gắn thêm Apple/Google/Phone vào tài khoản hiện tại; nếu identity đã thuộc tài khoản khác → `409 IDENTITY_IN_USE` (không tự gộp). Không cho gỡ phương thức cuối cùng.

### 5.5 Thiết bị & phiên

- `user_sessions` 1–1 với thiết bị đăng nhập; `user_devices` lưu push token (FCM registration token), nền tảng, phiên bản app, locale, timezone.
- `DELETE /v1/me/sessions/{id}` → revoke + thêm `sid` vào Redis denylist đến khi access token hết hạn (15 phút) + xoá push token của thiết bị đó.
- Đăng xuất: xoá push token để không nhận thông báo trên máy đã đăng xuất.

### 5.6 Khoá ứng dụng

Thuần client (`local_auth`): khi app vào background > N phút (mặc định 1) → yêu cầu sinh trắc học/PIN. PIN lưu hash trong secure storage. Không liên quan server.

---

## 6. Phân quyền (Authorization)

### 6.1 AccessContext

Mỗi request có `familyId` (từ path hoặc từ resource) → resolve:

```ts
interface AccessContext {
  userId: string;
  familyId: string;
  role: 'PARENT' | 'CIRCLE' | 'NONE';
  parentSlot?: 'A' | 'B';
  coupleSpaceId?: string;          // chỉ khi family có 2 Parent ACTIVE & couple_space ACTIVE
  partnerUserId?: string;
  circleMemberId?: string;
  circleStatus?: 'ACTIVE' | 'SUSPENDED_PLAN' | 'PAUSED';
  childGrants: Map<string /*childId*/, 'VIEW' | 'COMMENT' | 'CONTRIBUTE'>;
  pregnancyGrants: Map<string, 'VIEW' | 'COMMENT' | 'CONTRIBUTE'>;
  allowDownload: boolean;
  familyStatus: 'WAITING_PARTNER' | 'ACTIVE' | 'PARTNER_LEFT' | 'DELETION_SCHEDULED';
  accessPhase: 'INCOMPLETE' | 'TRIAL' | 'PAID' | 'EXPIRED' | 'BLOCKED'; // mục 6.5
  planCode?: string;                 // catalog mở rộng, không dùng làm quyền
  capabilities: Record<string, boolean>;
  trialEndsAt?: string;
  blockedUserIds: Set<string>;     // người mà user này chặn / bị chặn trong family
  version: number;                  // = families.access_version
}
```

**Cache:** Redis `ac:{userId}:{familyId}` TTL 300s, gắn `version`. Mọi thay đổi ảnh hưởng quyền (parent/circle/grant/gói/chặn) chạy `UPDATE families SET access_version = access_version + 1` trong cùng transaction → request sau so sánh version (đọc `acv:{familyId}` trong Redis, được set sau commit) → cache miss → resolve lại. Kết quả: **gỡ người thân có hiệu lực ở request kế tiếp** (BR-042).

**Quy tắc khi `role=CIRCLE`:** nếu capability `circle.enabled` không được cấp, hoặc membership/grant/family gate không cho phép ⇒ `circleStatus=SUSPENDED_PLAN` ⇒ endpoint nội dung trả `403 FAMILY_SHARING_PAUSED` (client hiển thị CIR-05). Không kiểm `planCode == FAMILY`.

### 6.2 Ma trận policy (backend)

| Policy | Điều kiện |
|---|---|
| `isParent` | `role=PARENT` |
| `canViewChild(c)` | `isParent` ∨ `childGrants.has(c)` (với `circleStatus=ACTIVE`) |
| `canViewPregnancy(p)` | `isParent` ∨ `pregnancyGrants.has(p)` |
| `canViewMemory(m)` | xem 6.3 |
| `canComment(m)` | `canViewMemory(m)` ∧ `m.comments_enabled` ∧ (`isParent` ∨ ∃ child/pregnancy của m mà grant ≥ COMMENT ∨ (m là family moment ∧ ∃ grant ≥ COMMENT)) ∧ tác giả không chặn user |
| `canCreateMemory(childIds, pregnancyId)` | `isParent` ∨ (mọi childId có grant = CONTRIBUTE ∧ pregnancy grant = CONTRIBUTE nếu có ∧ không phải family moment) |
| `canEditMemory(m, fields)` | tác giả: mọi trường; Parent không phải tác giả: chỉ `children`, `visibility`, `archived`, `removeFromFamily` |
| `canDeleteMemory(m)` | tác giả ∨ `isParent` (Parent xoá ký ức người thân = “gỡ khỏi gia đình”) |
| `canDownload(asset)` | `isParent` ∨ (`allowDownload` ∧ `canViewMemory`) |
| `canManageFamily` | `isParent` |
| `canUseCouple` | `isParent` ∧ `coupleSpaceId != null` |
| `canReadCoupleItem(item)` | `canUseCouple` ∧ (`item.ownerUserId = userId` ∨ `item.shared = true`) |
| `canReadMission(m)` | `isParent` (Circle luôn 403); nhiệm vụ PARENT của bạn đời chỉ trả `PartnerMissionDto` (6.6) |
| `canActOnMission(m)` | `isParent` ∧ (`m.owner_kind = TOGETHER` ∨ `m.owner_user_id = userId`) — complete/undo/swap/remove/carry-over/PATCH; không có “làm hộ” (BR-024) → `403 MISSION_NOT_OWNER` |
| `canCreateMission(owner)` | `isParent` ∧ `owner ∈ {ME, TOGETHER}` (TOGETHER cần `coupleSpaceId`); chủ là bạn đời → `422 MISSION_OWNER_INVALID` (BR-020) |
| `canReadHearts(u)` | `u = userId` — không ngoại lệ, kể cả bạn đời (BR-018) |
| `canReadFamilyTree` | `isParent` ∨ (`role=CIRCLE` ∧ `families.settings.circleCanSeeTree`) — chỉ cấp + % (6.6) |
| `canUseRequests` | `canUseCouple` — Circle không bao giờ (BR-070) |
| `canActOnRequest(r, action)` | người nhận: seen/accept/decline/done/acknowledge/remind-me; người gửi: cancel/self-do (15.8) |
| `canPurchase` | `isParent` |
| `canAddPerspective(m)` | `isParent` ∧ `m.author_role = PARENT` ∧ `m.author_user_id = partnerUserId` ∧ `m.status = PUBLISHED` ∧ `canViewMemory(m)` (6.7) |
| `canEditPerspective(p)` | tác giả góc nhìn; tác giả ký ức gốc chỉ được đổi `hiddenFromCircle` |
| `canSetMonthlyPhoto(child)` | `isParent` (Circle không đặt/đổi ảnh tháng chính, không tạo `MONTHLY_PHOTO`) |
| `canUseNameCandidates` | `canUseCouple` (Circle không bao giờ) |

### 6.3 Lọc ký ức theo quyền (SQL chuẩn)

**Parent:**
```sql
WHERE m.family_id = :familyId
  AND m.deleted_at IS NULL
  AND (
        (m.status = 'PUBLISHED' AND m.visibility IN ('PARENTS','FAMILY'))
     OR (m.status = 'PENDING_REVIEW')                                   -- Parent duyệt
     OR (m.author_user_id = :userId AND m.status IN ('PUBLISHED','PROCESSING','DRAFT') ) -- gồm PRIVATE của mình
      )
```

**Circle member** (`:childIds` = child grant đang ACTIVE, `:pregIds` = pregnancy grant):
```sql
WHERE m.family_id = :familyId
  AND m.deleted_at IS NULL
  AND ( (m.status = 'PUBLISHED' AND m.visibility = 'FAMILY')
        OR (m.author_user_id = :userId AND m.status IN ('PUBLISHED','PENDING_REVIEW','REJECTED','PROCESSING')) )
  AND (
        EXISTS (SELECT 1 FROM memory_children mc
                 WHERE mc.memory_id = m.id AND mc.child_id = ANY(:childIds))
     OR (m.pregnancy_id = ANY(:pregIds))
     OR (m.pregnancy_id IS NULL
         AND NOT EXISTS (SELECT 1 FROM memory_children mc WHERE mc.memory_id = m.id))  -- family moment
      )
  AND m.author_user_id <> ALL(:blockedUserIds)
```

**Response shaping (BR-013):** khi trả `children[]` của ký ức cho Circle, **lọc bỏ** child không nằm trong `childGrants` (không trả id/tên/avatar/số lượng). Thư niêm phong (`kind=LETTER`, `unlock_at > now()`, người xem ≠ tác giả) → trả bản rút gọn `{ id, kind, sealed: true, unlockAt, authorLabel }`, không body/asset.

### 6.4 Bất biến cần kiểm thử tự động (release blocker)

1. User không liên quan không đọc được *bất kỳ* resource nào của family khác dù đoán đúng UUID (trả `404`, không `403`, để không lộ sự tồn tại).
2. Circle không gọi được bất kỳ endpoint `/v1/us/*` (gồm Lời nhờ), `/missions*`, `/care/*`, `/hearts*`, `/billing` mua; `/family-tree` chỉ khi `circleCanSeeTree` và chỉ nhận cấp + %.
3. Circle chỉ được share Hana: không lấy được Haru qua `/children/{haruId}`, `/timeline?child_id=haru`, `/memories/{id}` (field children đã lọc), deep link, search, on-this-day, recap.
4. Bị gỡ → request tiếp theo `403`; presign mới bị từ chối.
5. `child_ids` thuộc family khác trong POST/PATCH → `422 CHILD_NOT_IN_FAMILY` (và DB FK cũng chặn).
6. Partner không đọc được `journal`, `mood` chưa share, `conflict_entries.draft` của người kia.
7. **Hearts riêng tư:** không endpoint nào trả Hearts của người khác — Parent B gọi mọi endpoint (board mọi tab, `/missions/{id}` của A, lịch, lịch sử, sync, bootstrap, `/us/*`, recap, inbox, export gia đình) → JSON không chứa Hearts của A; `/family-tree` không có tổng tuyệt đối (28.4).
8. `POST /missions` với chủ là bạn đời → `422 MISSION_OWNER_INVALID`; B gọi complete/undo/swap/remove/PATCH trên nhiệm vụ PARENT của A → `403 MISSION_NOT_OWNER`.
9. Lời nhờ không bao giờ lộ cho Circle (feed, timeline, calendar, search, recap, thông báo) và không xuất hiện trong tab nhiệm vụ.
10. **Góc nhìn thứ hai (BR-071):** Circle chỉ thấy góc nhìn khi xem được ký ức gốc và `hidden_from_circle = false` — ở mọi đường đọc (chi tiết, feed, timeline, bộ sưu tập “Cả hai cùng kể”, search, recap, “Hôm nay của con”, export); Circle không tạo được góc nhìn; tên dự định cho con (PREG-07) không bao giờ lộ cho Circle.

---
### 6.5 Gate kích hoạt gia đình & dùng thử (đã xác nhận với khách hàng)

**Vai trò khi onboarding** — `users.onboarding_role ∈ {PARENT_FATHER, PARENT_MOTHER, CIRCLE, null}`; `null` ⇒ client bắt buộc vào ONB-03. Vào bằng lời mời ⇒ vai trò lấy theo lời mời.

**Trạng thái quyền sử dụng** (`billing.family_entitlements.access_phase`, tính bởi `recomputeEntitlement`):

| access_phase | Điều kiện | API nghiệp vụ |
|---|---|---|
| `INCOMPLETE` | `families.status = WAITING_PARTNER` (hoặc `PARTNER_LEFT` sau khi một Parent xoá tài khoản) | Chặn (allowlist bên dưới) |
| `TRIAL` | đủ 2 Parent ACTIVE và `now() < trial_ends_at` | Cho phép, quota `TRIAL` (10 GB, **không** Circle) |
| `PAID` | có grant trả phí hiệu lực (gồm grace đã được xác minh) | Cho phép theo plan version/capabilities; không suy quyền từ tên gói |
| `EXPIRED` | hết trial và không có subscription hiệu lực | Chặn (allowlist) |
| `BLOCKED` | license bị khóa theo quyết định có audit | Chặn nghiệp vụ, giữ các quyền dữ liệu/an toàn được đặc tả |

**`ActivationGuard` (global, chạy sau AuthGuard + FamilyScopeGuard)**
- `familyStatus = WAITING_PARTNER` → mọi route có `familyId` trả `403 FAMILY_NOT_ACTIVE`, **trừ** allowlist: `GET /families/{fid}/bootstrap`, `PATCH /families/{fid}` (tên, cover), `POST|GET|DELETE …/invites/partner`, `POST /invites/{id}/approve|reject`, `POST /families/{fid}/cancel`.
- `familyStatus = PARTNER_LEFT` (chỉ xảy ra khi một Parent **xoá tài khoản** — MVP không có API rời gia đình/tách bạn đời) → chỉ cho các `GET` đọc nội dung + tải về + mời bạn đời mới; mọi ghi trả `403 FAMILY_NOT_ACTIVE`.
- `accessPhase = EXPIRED` → mọi route nghiệp vụ trả `402 SUBSCRIPTION_REQUIRED`, **trừ** allowlist: `bootstrap`, `/billing/*`, `/exports*`, `/families/{fid}/media-grid` & `GET /memories/{id}` + `download-urls` (phục vụ tải dữ liệu về), `/me*`, `/auth/*`, `/support/*`, `/reports`, `/me/deletion*`. Circle: `402` được map thành `403 FAMILY_SHARING_PAUSED`.
- Route không có `familyId` của user `onboarding_role=CIRCLE` chưa có membership: chỉ `/me*`, `/invites/*`, `/auth/*`.
- Các job nền (bày bảng nhiệm vụ, nhắc, hết hạn lời nhờ, recap, digest) **bỏ qua** family có `access_phase ∈ {INCOMPLETE, EXPIRED, BLOCKED}`.

**Kích hoạt (trong transaction `acceptPartnerInvite` / `approvePartner`)**
```
INSERT family_parents(slot B) → families.status = ACTIVE → INSERT couple_spaces
→ eligible = NOT EXISTS (SELECT 1 FROM billing.trial_consumptions WHERE user_id IN (A,B) OR identity_hash IN (…))
→ eligible ? (TỰ ĐỘNG cấp — không qua Store: trial_policy = publishedPolicy(), trial_started_at = now(), trial_ends_at = now() + trial_policy.duration_seconds,
              INSERT trial_consumptions cho cả A và B)
           : access_phase = EXPIRED (ONB-ACT hiển thị "Chọn gói để bắt đầu")
→ access_version++ → outbox PartnerLinked, TrialStarted
```
Nếu Parent B đang có gia đình `WAITING_PARTNER` của riêng mình (rỗng) → cùng transaction đánh dấu gia đình đó `DELETED` (không có dữ liệu do BR-052).

**Chống lạm dụng dùng thử:** `trial_consumptions(user_id, identity_hash)` — `identity_hash` = HMAC của mọi `auth_identities.provider_uid` (Apple sub, Google sub, SĐT) của user tại thời điểm dùng thử ⇒ tạo tài khoản mới cùng SĐT/Apple ID không lấy lại được trial.

### 6.6 Quyền riêng tư Hearts, nhiệm vụ của bạn đời & Lời nhờ (BR-018, BR-020, BR-024, BR-070)

| Quy tắc | Hiện thực |
|---|---|
| Hearts chỉ trả cho **chính chủ** | Endpoint Hearts duy nhất là `GET /families/{fid}/hearts/me` (không có tham số `userId`, không có `/hearts/{userId}`). `HeartsRepository` chỉ có hàm đọc theo `ctx.userId`. Các trường Hearts cá nhân (`myHeartsToday`, `myHeartsAwarded`, `heartsAwarded`) chỉ được serializer gắn khi chủ thể = người gọi. Bootstrap không chứa Hearts. |
| Cây gia đình chỉ cấp + % | `GET /families/{fid}/family-tree` trả `level`, `progressPercent` (làm tròn xuống số nguyên), `flowers`, số lá/hoa hôm nay — **không** trả `total_hearts`, Hearts ngày/tuần của gia đình (vì “tổng cây − Hearts của tôi” = Hearts bạn đời). Circle (khi `circleCanSeeTree`) chỉ nhận `{level, progressPercent, flowers}`. |
| Nhiệm vụ của bạn đời không có Hearts | 2 DTO tách biệt: `MyMissionDto` (chủ nhiệm vụ hoặc TOGETHER — có `hearts`, `source`, `canSwap`) và `PartnerMissionDto` (whitelist `id, title, category, childIds, status, completedAt, late, thanked`). Nhiệm vụ `EXPIRED`/`REMOVED` của bạn đời không trả (nghiệp vụ 7.13.5). Áp dụng cho board, lịch, lịch sử, chi tiết, sync, realtime. |
| Không làm hộ / không giao | `canActOnMission` cho mọi hành động ghi (`403 MISSION_NOT_OWNER`); tạo cho bạn đời → `422 MISSION_OWNER_INVALID` + CHECK ở DB (7.2.7). |
| Lời nhờ chỉ hai Parent | Route `/us/requests*` dưới `canUseCouple`; bảng ở schema `us` (DB role admin không đọc được); feed/timeline/calendar/search/recap/export gia đình **không** đọc `us.requests`; board chỉ trả `openRequestCount`. Circle → `403 NOT_PARENT`. |
| Không Hearts ở kênh khác | Outbox payload, realtime, push/inbox, recap, export gia đình, analytics không chứa Hearts cá nhân (13.1, 19.4, 20.2). Xuất dữ liệu **cá nhân** có `hearts.json` của chính mình. |

> Chấp nhận bạn đời có thể suy luận gián tiếp (thấy ✓, % cây nhích lên) — nguyên tắc là **không bao giờ trình bày hai con số cạnh nhau để so sánh** (nghiệp vụ 7.14.1).

### 6.7 Ký ức mở rộng: góc nhìn thứ hai, “Ai ở đó”, ảnh tháng, yêu thích, đặt tên (BR-071..073)

| Quy tắc | Hiện thực |
|---|---|
| Góc nhìn kế thừa visibility (BR-071) | `memory_perspectives` **không có** cột visibility; mọi truy vấn đọc góc nhìn JOIN ký ức gốc và áp đúng điều kiện 6.3 của ký ức gốc. Circle nhận góc nhìn chỉ khi xem được ký ức gốc **và** `hidden_from_circle = false`. Ký ức gốc đổi visibility hẹp lại → góc nhìn hẹp theo ngay (không có bản sao quyền). Ký ức gốc `TRASHED/ARCHIVED` → góc nhìn ẩn theo. Huy hiệu “Cả hai cùng kể” cho Circle tính trên góc nhìn họ được thấy. |
| Ai được thêm góc nhìn | `canAddPerspective` (6.2): chỉ bạn đời của tác giả ký ức (Parent), 1 góc nhìn/Parent/ký ức (unique) → trùng `409 PERSPECTIVE_EXISTS`; ký ức của chính mình / do Circle đăng → `422 PERSPECTIVE_NOT_ALLOWED`; Circle → `403 NOT_PARENT`. |
| Sửa/xoá góc nhìn | Chỉ tác giả góc nhìn. Tác giả ký ức gốc chỉ được `PATCH /perspectives/{id} {hiddenFromCircle}`; trường khác → `403`. |
| “Ai ở đó” | `memory_people.user_id` chỉ nhận Parent/Circle member ACTIVE của family (service kiểm tra); tên tự do lưu nguyên văn; **không nhận diện khuôn mặt**. Trả về như một phần ký ức (theo quyền xem ký ức); thành viên đã rời → hiển thị `displayName` ẩn danh. |
| Ảnh tháng | `canSetMonthlyPhoto` (Parent). Ảnh chính phải thuộc ký ức gắn đúng bé/thai kỳ đó (FK `memory_assets`). Ô ảnh tháng trả cho Circle chỉ khi xem được ký ức chứa ảnh. |
| Yêu thích | Danh sách yêu thích là **cá nhân** (không API đọc yêu thích của người khác); “Ảnh đẹp nhất của nhà mình” chỉ lộ **giao** của hai danh sách (view `v_family_best_memories`), chỉ trả cho Parent. |
| Seen-state & gợi ý | `story_views`, `memory_prompt_deliveries` đọc/ghi theo `ctx.userId`; không trả trạng thái của người khác. |
| Đặt tên cho con [1.1] | Bảng ở schema `us` (mã hoá DEK COUPLE), route `/us/pregnancies/{id}/name-candidates*` dưới `canUseCouple`; feed/timeline/export gia đình không đọc. Cột mốc “Chọn được tên” tạo ở visibility `PARENTS` (đổi được). |

## 7. Cơ sở dữ liệu PostgreSQL

### 7.1 Quy ước

- Schema backend: `app` (nghiệp vụ chung), `us` (Papa & Mama — tách để phân quyền DB user & audit), `billing`, `ops` (outbox, config, catalog); `public` giữ Note mẫu. Prisma đăng ký multi-schema, không tự gộp vào một schema.
- PK: `uuid`; domain migration dùng PostgreSQL18 `uuidv7()` mặc định, hỗ trợ UUID hợp lệ do app tạo cho offline/idempotency. Bảng log tăng nhanh có thể dùng `bigint identity`.
- Thời gian: `timestamptz(3)` (UTC). Ngày nghiệp vụ theo giờ địa phương: `date` + cột `*_local_date` khi cần group.
- **Bắt buộc mọi bảng do dự án quản lý có đủ ba cột**, kể cả bảng nối, job/history và outbox: `created_at timestamptz(3) NOT NULL DEFAULT now()`, `updated_at timestamptz(3) NOT NULL DEFAULT now()` (trigger khi UPDATE), `deleted_at timestamptz(3) NULL DEFAULT NULL`. Không tự sửa bảng hệ thống PostgreSQL/Prisma/package.
- Soft delete là mặc định; repository lọc dòng active nhất quán. Dữ liệu cần purge vật lý có `purge_after`/retention riêng. `version int default 1` cho bảng sửa được. Xem [chuẩn database](../.agents/skills/baby-family-team/references/database-standards.md).
- **Composite FK** `(x_id, family_id)` để DB tự đảm bảo “cùng gia đình” (mẫu: `UNIQUE (id, family_id)` ở bảng cha).
- Extension: `pgcrypto`, `pg_trgm`, `unaccent`, `citext`.
- Cột mã hoá cấp ứng dụng: kiểu `bytea`, hậu tố `_enc` (mục 16).

### 7.2 DDL

> DDL dưới đây là bản tham khảo trước BF-20261013-004/005, giữ để truy vết; **không dùng để deploy**. [Migration backend hiện tại](../baby-backend/prisma/migrations/20261013150000_family_domain/migration.sql), [Prisma schema](../baby-backend/prisma/schema.prisma) và [thiết kế database](database/README.md) là nguồn cấu trúc: catalog plans/version/trial policy thay enum/quota cứng; đủ audit/FK/trigger và family-owned license. Check/trigger/partial index giữ trong migration DDL; dữ liệu catalog ở seed riêng. Migration domain chưa áp dụng vào DB ứng dụng.

> Cập nhật theo quyết định người dùng ngày 2026-10-13: ví dụ DDL cũ bên dưới có thể chưa liệt kê đủ ba cột audit. Khi triển khai, bắt buộc bổ sung theo §7.1 cho mọi bảng dự án; không dùng thiếu sót trong ví dụ để miễn quy tắc. Đây là cập nhật đặc tả, chưa phải migration đã áp dụng. Cron/job thực hiện theo [chuẩn history/retry/recovery](../baby-backend/docs/jobs.md).

#### 7.2.1 Extensions & enums

```sql
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE EXTENSION IF NOT EXISTS unaccent;
CREATE EXTENSION IF NOT EXISTS citext;

CREATE SCHEMA IF NOT EXISTS app;
CREATE SCHEMA IF NOT EXISTS us;
CREATE SCHEMA IF NOT EXISTS billing;
CREATE SCHEMA IF NOT EXISTS ops;

-- Identity
CREATE TYPE app.user_status        AS ENUM ('ACTIVE','DELETION_PENDING','DELETED','SUSPENDED');
CREATE TYPE app.auth_provider      AS ENUM ('APPLE','GOOGLE','PHONE');
CREATE TYPE app.platform           AS ENUM ('IOS','ANDROID','WEB');
-- Family
CREATE TYPE app.family_status      AS ENUM ('WAITING_PARTNER','ACTIVE','PARTNER_LEFT','DELETION_SCHEDULED','DELETED');
CREATE TYPE app.onboarding_role    AS ENUM ('PARENT_FATHER','PARENT_MOTHER','CIRCLE');
CREATE TYPE app.parent_slot        AS ENUM ('A','B');
CREATE TYPE app.parent_kind        AS ENUM ('FATHER','MOTHER');           -- nhãn gốc; tên gọi tuỳ chỉnh ở call_name
CREATE TYPE app.member_status      AS ENUM ('ACTIVE','LEFT','REMOVED');
CREATE TYPE app.couple_status      AS ENUM ('ACTIVE','DISABLED','UNLINKED');
CREATE TYPE app.invite_type        AS ENUM ('PARTNER','CIRCLE');
CREATE TYPE app.invite_status      AS ENUM ('PENDING','AWAITING_APPROVAL','ACCEPTED','DECLINED','REVOKED','EXPIRED');
CREATE TYPE app.circle_relation    AS ENUM ('GRANDFATHER_PATERNAL','GRANDMOTHER_PATERNAL','GRANDFATHER_MATERNAL','GRANDMOTHER_MATERNAL',
                                            'AUNT_PATERNAL','AUNT_MATERNAL','UNCLE_PATERNAL','UNCLE_MATERNAL','COUSIN','SIBLING_ADULT',
                                            'CAREGIVER','OTHER');
CREATE TYPE app.circle_status      AS ENUM ('ACTIVE','PAUSED','SUSPENDED_PLAN','REMOVED','LEFT');
CREATE TYPE app.grant_permission   AS ENUM ('VIEW','COMMENT','CONTRIBUTE');
CREATE TYPE app.grant_status       AS ENUM ('ACTIVE','PAUSED','REVOKED');
-- Journey
CREATE TYPE app.pregnancy_status   AS ENUM ('ACTIVE','COMPLETED','PAUSED','ENDED_PRIVATE','ARCHIVED');
CREATE TYPE app.child_status       AS ENUM ('ACTIVE','ARCHIVED','MEMORIAL','DELETED');
CREATE TYPE app.gender             AS ENUM ('MALE','FEMALE','UNSPECIFIED');
-- Memory & media
CREATE TYPE app.asset_kind         AS ENUM ('IMAGE','VIDEO','AUDIO');
CREATE TYPE app.asset_status       AS ENUM ('PENDING_UPLOAD','UPLOADED','PROCESSING','READY','FAILED','DELETED');
CREATE TYPE app.memory_kind        AS ENUM ('MOMENT','DIARY','VOICE','QUOTE','MONTHLY_PHOTO','KEEPSAKE','LETTER','ULTRASOUND','BUMP','MILESTONE','MISSION','STORY');
CREATE TYPE app.moment_feeling     AS ENUM ('LOVE','JOY','TOUCHED','SURPRISED','PEACEFUL','PROUD');   -- “Cảm xúc của khoảnh khắc” (7.8.1)
CREATE TYPE app.memory_status      AS ENUM ('DRAFT','PROCESSING','PENDING_REVIEW','PUBLISHED','REJECTED','ARCHIVED','TRASHED','PURGED');
CREATE TYPE app.visibility         AS ENUM ('PRIVATE','PARENTS','FAMILY');
CREATE TYPE app.reaction_type      AS ENUM ('LOVE','CUTE','HAHA','TOUCHED','CLAP');
-- Care
-- (mô hình bảng nhiệm vụ hằng ngày — nghiệp vụ 7.13, C-14..C-16)
CREATE TYPE app.mission_scope      AS ENUM ('CHILD','MULTI_CHILD','FAMILY','COUPLE');
CREATE TYPE app.mission_owner_kind AS ENUM ('PARENT','TOGETHER');                   -- không có “giao cho bạn đời” (BR-020)
CREATE TYPE app.mission_role_fit   AS ENUM ('ANY_PARENT','PREGNANT_MOTHER','PARTNER_OF_PREGNANT','TOGETHER');
CREATE TYPE app.mission_category   AS ENUM ('CARE','BONDING','PLAY','OUTDOOR','MEMORY','TOGETHER','SUPPORT','SELF','COUPLE','PREP','HOME','CUSTOM');
CREATE TYPE app.mission_status     AS ENUM ('TODO','DONE','EXPIRED','REMOVED');     -- thay 9 trạng thái cũ (7.13.5)
CREATE TYPE app.mission_source     AS ENUM ('SYSTEM','LIBRARY','CUSTOM','SERIES');
CREATE TYPE app.mission_board_level AS ENUM ('LIGHT','MEDIUM','HEAVY');             -- Nhẹ 2 / Vừa 3 / Nhiều 4 mỗi Parent
-- Us
CREATE TYPE us.mood                AS ENUM ('GOOD','OKAY','TIRED','EXHAUSTED','STRESSED','SAD','UPSET','UPSET_WITH_PARTNER','OVERWHELMED','LONELY','NEED_AFFECTION');
CREATE TYPE us.need                AS ENUM ('BREAK','HELP_CHILD','QUIET','HUG','TALK','REASSURANCE');
CREATE TYPE us.request_kind        AS ENUM ('TASK','NEED');                          -- Lời nhờ (7.16.2)
CREATE TYPE us.request_status      AS ENUM ('SENT','SEEN','ACCEPTED','DONE','DECLINED','ACKNOWLEDGED','EXPIRED','CANCELLED');
CREATE TYPE us.request_urgency     AS ENUM ('NORMAL','SOON');
CREATE TYPE us.request_due_kind    AS ENUM ('NOW','TODAY_AT','TONIGHT','TOMORROW');
CREATE TYPE us.conflict_status     AS ENUM ('PRIVATE_DRAFT','INVITED','ACTIVE','PAUSED','AGREED','RESOLVED','CLOSED','EXPIRED');
-- Billing
CREATE TYPE billing.plan           AS ENUM ('HOUSE','FAMILY');                       -- gói trả phí
CREATE TYPE billing.access_state   AS ENUM ('INCOMPLETE','TRIAL','HOUSE','FAMILY','EXPIRED');
CREATE TYPE billing.quota_tier     AS ENUM ('TRIAL','HOUSE','FAMILY');
CREATE TYPE billing.store          AS ENUM ('APPLE','GOOGLE');
CREATE TYPE billing.sub_status     AS ENUM ('TRIAL','ACTIVE','GRACE','ON_HOLD','PAUSED','CANCELED_ACTIVE','EXPIRED','REVOKED','REFUNDED');
-- Trust
CREATE TYPE app.report_target      AS ENUM ('MEMORY','COMMENT','USER','AI_OUTPUT','ALBUM');
CREATE TYPE app.report_reason      AS ENUM ('INAPPROPRIATE','HARASSMENT','PRIVACY','CHILD_SAFETY','SPAM','AI_CONTENT','OTHER');
CREATE TYPE app.report_status      AS ENUM ('NEW','TRIAGE','IN_REVIEW','ACTION_TAKEN','NO_VIOLATION','NEED_INFO','CLOSED');
```

#### 7.2.2 Identity

```sql
CREATE TABLE app.users (
  id                 uuid PRIMARY KEY,
  display_name       varchar(80)  NOT NULL,
  avatar_asset_id    uuid,
  locale             varchar(10)  NOT NULL DEFAULT 'vi',
  timezone           varchar(64)  NOT NULL DEFAULT 'Asia/Ho_Chi_Minh',
  status             app.user_status NOT NULL DEFAULT 'ACTIVE',
  onboarding_role    app.onboarding_role,                      -- null ⇒ bắt buộc chọn ở ONB-03
  token_version      int          NOT NULL DEFAULT 1,       -- tăng để vô hiệu mọi access token
  last_active_at     timestamptz,
  created_at         timestamptz  NOT NULL DEFAULT now(),
  updated_at         timestamptz  NOT NULL DEFAULT now(),
  deleted_at         timestamptz
);

CREATE TABLE app.auth_identities (
  id                           uuid PRIMARY KEY,
  user_id                      uuid NOT NULL REFERENCES app.users(id),
  provider                     app.auth_provider NOT NULL,
  provider_uid                 varchar(255) NOT NULL,          -- Apple sub / Google sub / E.164 phone
  email                        citext,
  provider_refresh_token_enc   bytea,                          -- Apple refresh token (để revoke)
  created_at                   timestamptz NOT NULL DEFAULT now(),
  last_used_at                 timestamptz,
  UNIQUE (provider, provider_uid)
);
CREATE INDEX ON app.auth_identities(user_id);

CREATE TABLE app.user_sessions (
  id                   uuid PRIMARY KEY,
  user_id              uuid NOT NULL REFERENCES app.users(id),
  device_id            uuid,
  refresh_token_hash   bytea NOT NULL UNIQUE,
  replaced_by          uuid,
  platform             app.platform,
  app_version          varchar(20),
  ip_created           inet,
  created_at           timestamptz NOT NULL DEFAULT now(),
  last_used_at         timestamptz NOT NULL DEFAULT now(),
  expires_at           timestamptz NOT NULL,
  absolute_expires_at  timestamptz NOT NULL,
  revoked_at           timestamptz,
  revoke_reason        varchar(40)
);
CREATE INDEX ON app.user_sessions(user_id) WHERE revoked_at IS NULL;

CREATE TABLE app.user_devices (
  id                 uuid PRIMARY KEY,
  user_id            uuid NOT NULL REFERENCES app.users(id),
  platform           app.platform NOT NULL,
  push_token         text,
  push_enabled       boolean NOT NULL DEFAULT false,      -- quyền thông báo OS
  app_version        varchar(20),
  os_version         varchar(40),
  device_model       varchar(80),
  locale             varchar(10),
  timezone           varchar(64),
  last_seen_at       timestamptz NOT NULL DEFAULT now(),
  created_at         timestamptz NOT NULL DEFAULT now(),
  UNIQUE (push_token)
);
CREATE INDEX ON app.user_devices(user_id);

CREATE TABLE app.user_consents (
  id          uuid PRIMARY KEY,
  user_id     uuid NOT NULL REFERENCES app.users(id),
  document    varchar(40) NOT NULL,     -- TERMS | PRIVACY | DATA_PROCESSING | CHILD_DATA | AI_<FEATURE> | MARKETING
  version     varchar(20) NOT NULL,
  granted     boolean NOT NULL,
  ip          inet,
  platform    app.platform,
  created_at  timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX ON app.user_consents(user_id, document, created_at DESC);

CREATE TABLE app.user_settings (
  user_id                    uuid PRIMARY KEY REFERENCES app.users(id),
  notification_prefs         jsonb   NOT NULL DEFAULT '{}',  -- {MEMORY:true, MISSION:true, US:true, ... , mutedUserIds:[]}
  quiet_start                time    NOT NULL DEFAULT '22:00',
  quiet_end                  time    NOT NULL DEFAULT '06:30',
  hide_sensitive_preview     boolean NOT NULL DEFAULT true,
  circle_digest_mode         varchar(10) NOT NULL DEFAULT 'DIGEST',   -- INSTANT | DIGEST
  circle_digest_time         time    NOT NULL DEFAULT '19:00',
  mood_share_default         varchar(10) NOT NULL DEFAULT 'ASK',      -- ASK | ALWAYS | NEVER
  request_soon_bypass_quiet  boolean NOT NULL DEFAULT true,   -- Lời nhờ “Sớm nhé” vẫn push trong giờ yên tĩnh (người nhận tắt được)
  us_lock_enabled            boolean NOT NULL DEFAULT false,
  ai_enabled                 boolean NOT NULL DEFAULT true,
  ai_features                jsonb   NOT NULL DEFAULT '{}',
  theme                      varchar(10) NOT NULL DEFAULT 'SYSTEM',
  text_scale                 numeric(3,2) NOT NULL DEFAULT 1.00,
  show_lunar                 boolean NOT NULL DEFAULT true,
  memory_prompts_enabled     boolean NOT NULL DEFAULT true,   -- “Gợi ý ghi lại” (BR-073, tắt được)
  perspective_suggest        boolean NOT NULL DEFAULT true,   -- “Bạn cũng ở đó chứ?” khi bạn đời ghi cột mốc (≤ 1/ngày)
  daily_story_suggest        boolean NOT NULL DEFAULT true,   -- 21:00 gợi ý gói Câu chuyện ngày
  updated_at                 timestamptz NOT NULL DEFAULT now()
);
```

#### 7.2.3 Family, Parent, Couple, Invite, Circle

```sql
CREATE TABLE app.families (
  id                   uuid PRIMARY KEY,
  name                 varchar(80) NOT NULL,
  cover_asset_id       uuid,
  status               app.family_status NOT NULL DEFAULT 'WAITING_PARTNER',
  activated_at         timestamptz,                    -- lúc đủ Bố + Mẹ
  timezone             varchar(64) NOT NULL DEFAULT 'Asia/Ho_Chi_Minh',
  content_locale       varchar(10) NOT NULL DEFAULT 'vi',
  settings             jsonb NOT NULL DEFAULT '{
      "defaultVisibility": null,
      "requireCircleReview": true,
      "circleCanSeeTree": false,
      "traditionalUseLunar": false,
      "milestoneSuggestions": true,
      "showLunar": true }',
  access_version       int NOT NULL DEFAULT 1,
  created_by           uuid NOT NULL REFERENCES app.users(id),
  created_at           timestamptz NOT NULL DEFAULT now(),
  updated_at           timestamptz NOT NULL DEFAULT now(),
  deletion_scheduled_at timestamptz,
  deleted_at           timestamptz
);

CREATE TABLE app.family_parents (
  id               uuid PRIMARY KEY,
  family_id        uuid NOT NULL REFERENCES app.families(id),
  user_id          uuid NOT NULL REFERENCES app.users(id),
  slot             app.parent_slot NOT NULL,
  kind             app.parent_kind NOT NULL,
  call_name        varchar(20) NOT NULL,                 -- mặc định "Papa"/"Mama"; người dùng đổi: "Bố", "Ba", "Má"...
  status           app.member_status NOT NULL DEFAULT 'ACTIVE',
  joined_at        timestamptz NOT NULL DEFAULT now(),
  left_at          timestamptz
);
-- SQL migration: tối đa 2 Parent/Family (mỗi slot 1 người) & 1 user chỉ là Parent ở 1 family đang hoạt động
CREATE UNIQUE INDEX uq_family_parent_slot   ON app.family_parents(family_id, slot) WHERE status = 'ACTIVE';
CREATE UNIQUE INDEX uq_parent_one_family    ON app.family_parents(user_id)          WHERE status = 'ACTIVE';
CREATE UNIQUE INDEX uq_family_parent_user   ON app.family_parents(family_id, user_id) WHERE status = 'ACTIVE';

CREATE TABLE app.couple_spaces (
  id                uuid PRIMARY KEY,
  family_id         uuid NOT NULL REFERENCES app.families(id),
  parent_a_user_id  uuid NOT NULL REFERENCES app.users(id),
  parent_b_user_id  uuid NOT NULL REFERENCES app.users(id),
  status            app.couple_status NOT NULL DEFAULT 'ACTIVE',
  key_id            uuid,                                -- DEK của couple (mục 16)
  created_at        timestamptz NOT NULL DEFAULT now(),
  disabled_at       timestamptz,
  CHECK (parent_a_user_id <> parent_b_user_id)
);
CREATE UNIQUE INDEX uq_couple_active ON app.couple_spaces(family_id) WHERE status = 'ACTIVE';

CREATE TABLE app.family_invites (
  id                  uuid PRIMARY KEY,
  family_id           uuid NOT NULL REFERENCES app.families(id),
  type                app.invite_type NOT NULL,
  inviter_user_id     uuid NOT NULL REFERENCES app.users(id),
  token_hash          bytea NOT NULL UNIQUE,            -- SHA-256(token 32 byte)
  code_hash           bytea NOT NULL UNIQUE,            -- HMAC(pepper, code 8 ký tự)
  payload             jsonb NOT NULL,                   -- PARTNER: {kind, message}
                                                        -- CIRCLE: {relation, displayName, allowDownload, message,
                                                        --          grants:[{childId|pregnancyId, permission}]}
  require_final_approval boolean NOT NULL DEFAULT true, -- PARTNER
  status              app.invite_status NOT NULL DEFAULT 'PENDING',
  expires_at          timestamptz NOT NULL,
  accepted_by_user_id uuid REFERENCES app.users(id),
  accepted_at         timestamptz,
  decided_at          timestamptz,
  created_at          timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX ON app.family_invites(family_id, status);
-- Mỗi family chỉ 1 lời mời PARTNER đang chờ
CREATE UNIQUE INDEX uq_partner_invite_pending ON app.family_invites(family_id)
  WHERE type = 'PARTNER' AND status IN ('PENDING','AWAITING_APPROVAL');

CREATE TABLE app.circle_members (
  id               uuid PRIMARY KEY,
  family_id        uuid NOT NULL REFERENCES app.families(id),
  user_id          uuid NOT NULL REFERENCES app.users(id),
  relation         app.circle_relation NOT NULL,
  display_name     varchar(40) NOT NULL,                 -- "Bà nội"
  allow_download   boolean NOT NULL DEFAULT false,
  status           app.circle_status NOT NULL DEFAULT 'ACTIVE',
  invited_by       uuid REFERENCES app.users(id),
  joined_at        timestamptz NOT NULL DEFAULT now(),
  ended_at         timestamptz,
  UNIQUE (id, family_id)
);
CREATE UNIQUE INDEX uq_circle_member ON app.circle_members(family_id, user_id)
  WHERE status IN ('ACTIVE','PAUSED','SUSPENDED_PLAN');
CREATE INDEX ON app.circle_members(user_id) WHERE status IN ('ACTIVE','PAUSED','SUSPENDED_PLAN');
```

> Ràng buộc “Parent không đồng thời là Circle của **chính** family đó” và “tối đa 12 Circle (gồm lời mời chờ)” enforce trong service với `SELECT … FOR UPDATE` trên dòng `families` (khoá theo family khi thêm thành viên/mời).

#### 7.2.4 Journey: thai kỳ, bé, grant

```sql
CREATE TABLE app.pregnancies (
  id                  uuid PRIMARY KEY,
  family_id           uuid NOT NULL REFERENCES app.families(id),
  seq_no              smallint NOT NULL,
  nickname            varchar(40) NOT NULL,
  due_date            date,
  expected_count      smallint NOT NULL DEFAULT 1 CHECK (expected_count BETWEEN 1 AND 4),
  status              app.pregnancy_status NOT NULL DEFAULT 'ACTIVE',
  cover_asset_id      uuid,
  show_size_content   boolean NOT NULL DEFAULT true,
  carrier_user_id     uuid REFERENCES app.users(id),           -- “Người mang thai” (hồ sơ thai kỳ): mặc định Parent kind=MOTHER, đổi được;
                                                               -- bày bảng nhiệm vụ đọc trường này (15.3)
  bump_photo_cadence  varchar(10) NOT NULL DEFAULT 'WEEKLY',   -- WEEKLY | EVERY_4W | OFF — nhắc ảnh bụng (7.8.7, PREG-02)
  created_by          uuid NOT NULL REFERENCES app.users(id),
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now(),
  completed_at        timestamptz,
  version             int NOT NULL DEFAULT 1,
  UNIQUE (family_id, seq_no),
  UNIQUE (id, family_id)
);

CREATE TABLE app.children (
  id                uuid PRIMARY KEY,
  family_id         uuid NOT NULL REFERENCES app.families(id),
  pregnancy_id      uuid,
  birth_order       smallint,
  name              varchar(60),
  nickname          varchar(40),
  birth_date        date NOT NULL,
  birth_time        time,
  gender            app.gender NOT NULL DEFAULT 'UNSPECIFIED',
  color_index       smallint NOT NULL CHECK (color_index BETWEEN 1 AND 8),
  avatar_asset_id   uuid,
  cover_asset_id    uuid,
  profile           jsonb NOT NULL DEFAULT '{}',          -- nameStory, favorites...
  birth_stats       jsonb,                                -- {weightGram, lengthMm} — chỉ lưu
  status            app.child_status NOT NULL DEFAULT 'ACTIVE',
  sort_order        smallint NOT NULL DEFAULT 0,
  monthly_photo_mode  varchar(10) NOT NULL DEFAULT 'AUTO',    -- AUTO: hằng tháng tới 12 tháng, sau đó 3 tháng/lần | MONTHLY
  monthly_photo_lunar boolean NOT NULL DEFAULT false,         -- ngày tròn tháng tính theo âm lịch
  created_by        uuid NOT NULL REFERENCES app.users(id),
  created_at        timestamptz NOT NULL DEFAULT now(),
  updated_at        timestamptz NOT NULL DEFAULT now(),
  archived_at       timestamptz,
  version           int NOT NULL DEFAULT 1,
  CHECK (name IS NOT NULL OR nickname IS NOT NULL),
  UNIQUE (id, family_id),
  FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.pregnancies(id, family_id)
);
CREATE INDEX ON app.children(family_id, status);
CREATE UNIQUE INDEX uq_child_birth_order ON app.children(pregnancy_id, birth_order) WHERE pregnancy_id IS NOT NULL;

-- Idempotency cho birth conversion
CREATE TABLE app.birth_conversions (
  pregnancy_id     uuid PRIMARY KEY REFERENCES app.pregnancies(id),
  idempotency_key  uuid NOT NULL UNIQUE,
  child_ids        uuid[] NOT NULL,
  created_by       uuid NOT NULL,
  created_at       timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE app.circle_grants (
  id                 uuid PRIMARY KEY,
  family_id          uuid NOT NULL,
  circle_member_id   uuid NOT NULL,
  child_id           uuid,
  pregnancy_id       uuid,
  permission         app.grant_permission NOT NULL,
  status             app.grant_status NOT NULL DEFAULT 'ACTIVE',
  created_by         uuid NOT NULL REFERENCES app.users(id),
  created_at         timestamptz NOT NULL DEFAULT now(),
  updated_at         timestamptz NOT NULL DEFAULT now(),
  CHECK ((child_id IS NOT NULL)::int + (pregnancy_id IS NOT NULL)::int = 1),   -- đúng 1 đối tượng
  FOREIGN KEY (circle_member_id, family_id) REFERENCES app.circle_members(id, family_id),
  FOREIGN KEY (child_id, family_id)         REFERENCES app.children(id, family_id),
  FOREIGN KEY (pregnancy_id, family_id)     REFERENCES app.pregnancies(id, family_id)
);
CREATE UNIQUE INDEX uq_grant_child ON app.circle_grants(circle_member_id, child_id)     WHERE child_id IS NOT NULL;
CREATE UNIQUE INDEX uq_grant_preg  ON app.circle_grants(circle_member_id, pregnancy_id) WHERE pregnancy_id IS NOT NULL;
CREATE INDEX ON app.circle_grants(family_id, child_id) WHERE status = 'ACTIVE';

CREATE TABLE app.blocks (
  family_id        uuid NOT NULL REFERENCES app.families(id),
  blocker_user_id  uuid NOT NULL REFERENCES app.users(id),
  blocked_user_id  uuid NOT NULL REFERENCES app.users(id),
  created_at       timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (family_id, blocker_user_id, blocked_user_id)
);
```

#### 7.2.5 Media & Memory

```sql
CREATE TABLE app.assets (
  id                 uuid PRIMARY KEY,
  family_id          uuid NOT NULL REFERENCES app.families(id),
  uploader_user_id   uuid NOT NULL REFERENCES app.users(id),
  kind               app.asset_kind NOT NULL,
  purpose            varchar(20) NOT NULL DEFAULT 'MEMORY',   -- MEMORY | AVATAR | COVER | JOURNAL | RECAP | EXPORT
  status             app.asset_status NOT NULL DEFAULT 'PENDING_UPLOAD',
  storage_key        text NOT NULL,                           -- fam/{familyId}/a/{assetId}/orig
  multipart_upload_id text,
  mime               varchar(60) NOT NULL,
  declared_size      bigint NOT NULL,
  size_bytes         bigint,                                  -- tổng gồm variants, cập nhật khi READY
  width              int, height int, duration_ms int,
  sha256             bytea,                                   -- client tính, server xác minh
  captured_at        timestamptz,                             -- từ EXIF trước khi strip
  blurhash           varchar(64),
  variants           jsonb NOT NULL DEFAULT '{}',             -- {"t320":{"key":..,"w":..,"h":..,"bytes":..},"m1080":..,"l2048":..,"poster":..,"mp4":..}
  keep_original      boolean NOT NULL DEFAULT false,          -- gói Family
  failure_reason     varchar(60),
  created_at         timestamptz NOT NULL DEFAULT now(),
  ready_at           timestamptz,
  deleted_at         timestamptz,
  purge_after        timestamptz,
  UNIQUE (id, family_id)
);
CREATE INDEX ON app.assets(family_id, status);
CREATE UNIQUE INDEX uq_asset_dedup ON app.assets(family_id, sha256) WHERE sha256 IS NOT NULL AND deleted_at IS NULL;
CREATE INDEX ON app.assets(status, created_at) WHERE status IN ('PENDING_UPLOAD','UPLOADED','PROCESSING'); -- dọn rác

CREATE TABLE app.memories (
  id                 uuid PRIMARY KEY,
  family_id          uuid NOT NULL REFERENCES app.families(id),
  author_user_id     uuid NOT NULL REFERENCES app.users(id),
  author_role        varchar(10) NOT NULL,                    -- PARENT | CIRCLE (snapshot)
  kind               app.memory_kind NOT NULL DEFAULT 'MOMENT',
  title              varchar(120),
  body               text,                                     -- ≤ 20.000 ký tự (validate app)
  body_format        varchar(10) NOT NULL DEFAULT 'PLAIN',     -- PLAIN | RICH (delta JSON)
  occurred_at        timestamptz NOT NULL,
  occurred_local_date date NOT NULL,                           -- theo timezone family, dùng cho nhóm/On this day
  visibility         app.visibility NOT NULL,
  status             app.memory_status NOT NULL,
  pregnancy_id       uuid,
  pregnancy_week     smallint,
  source_type        varchar(20),                              -- MISSION | RESHARE | RECAP
  source_id          uuid,
  location_label     varchar(120),
  feeling            app.moment_feeling,                       -- “Cảm xúc của khoảnh khắc” (tuỳ chọn)
  quote_context      varchar(200),                             -- QUOTE: “Con nói khi nào?”
  perspective_count  smallint NOT NULL DEFAULT 0,              -- số góc nhìn ACTIVE (badge “Cả hai cùng kể” — Parent view)
  comments_enabled   boolean NOT NULL DEFAULT true,
  -- Thư / time capsule
  unlock_at          timestamptz,
  -- Duyệt ký ức người thân
  reviewed_by        uuid REFERENCES app.users(id),
  reviewed_at        timestamptz,
  reject_reason      varchar(200),
  -- Vòng đời
  published_at       timestamptz,
  archived_at        timestamptz,
  trashed_at         timestamptz,
  trashed_by         uuid,
  purge_after        timestamptz,
  deleted_at         timestamptz,                              -- PURGED
  search_tsv         tsvector,                                 -- unaccent(title || body || location)
  comment_count      int NOT NULL DEFAULT 0,
  reaction_count     int NOT NULL DEFAULT 0,
  created_at         timestamptz NOT NULL DEFAULT now(),
  updated_at         timestamptz NOT NULL DEFAULT now(),
  version            int NOT NULL DEFAULT 1,
  UNIQUE (id, family_id),
  FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.pregnancies(id, family_id),
  CHECK (author_role IN ('PARENT','CIRCLE')),
  CHECK (kind <> 'QUOTE' OR (body IS NOT NULL AND char_length(body) <= 280)),   -- Câu nói của con ≤ 280 ký tự
  CHECK (kind <> 'MONTHLY_PHOTO' OR author_role = 'PARENT')
);
CREATE INDEX ix_mem_family_time   ON app.memories(family_id, occurred_at DESC, id DESC) WHERE deleted_at IS NULL;
CREATE INDEX ix_mem_family_pub    ON app.memories(family_id, published_at DESC, id DESC) WHERE status = 'PUBLISHED';
CREATE INDEX ix_mem_pending       ON app.memories(family_id, created_at) WHERE status = 'PENDING_REVIEW';
CREATE INDEX ix_mem_onthisday     ON app.memories(family_id, (extract(month FROM occurred_local_date)), (extract(day FROM occurred_local_date))) WHERE status = 'PUBLISHED';
CREATE INDEX ix_mem_search        ON app.memories USING gin (search_tsv);
CREATE INDEX ix_mem_trash         ON app.memories(purge_after) WHERE status = 'TRASHED';
CREATE INDEX ix_mem_kind          ON app.memories(family_id, kind, occurred_at DESC) WHERE status = 'PUBLISHED';     -- bộ sưu tập theo loại
CREATE INDEX ix_mem_today         ON app.memories(family_id, occurred_local_date, published_at) WHERE status = 'PUBLISHED'; -- “Hôm nay của con”

CREATE TABLE app.memory_children (
  memory_id   uuid NOT NULL,
  child_id    uuid NOT NULL,
  family_id   uuid NOT NULL,
  added_by    uuid,
  age_month   smallint NOT NULL,          -- tháng tuổi của bé tại occurred_local_date (service tính; tính lại khi đổi ngày) → chương tháng
  created_at  timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (memory_id, child_id),
  FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id) ON DELETE CASCADE,
  FOREIGN KEY (child_id,  family_id) REFERENCES app.children(id, family_id)            -- cùng family ở mức DB
);
CREATE INDEX ix_mc_child ON app.memory_children(child_id, memory_id);
CREATE INDEX ix_mc_child_month ON app.memory_children(child_id, age_month);   -- chương tháng (7.10)

CREATE TABLE app.memory_assets (
  memory_id   uuid NOT NULL,
  asset_id    uuid NOT NULL,
  family_id   uuid NOT NULL,
  sort_order  smallint NOT NULL,
  is_cover    boolean NOT NULL DEFAULT false,
  PRIMARY KEY (memory_id, asset_id),
  FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id) ON DELETE CASCADE,
  FOREIGN KEY (asset_id,  family_id) REFERENCES app.assets(id, family_id)
);
CREATE INDEX ON app.memory_assets(asset_id);    -- reference count khi purge

CREATE TABLE app.milestone_templates (
  code            varchar(40) PRIMARY KEY,
  category        varchar(20) NOT NULL,       -- TRADITIONAL | EMOTION | MOTOR | LANGUAGE | FOOD | BODY | EXPERIENCE | FAMILY | PREGNANCY
  icon            varchar(40) NOT NULL,
  title_i18n      jsonb NOT NULL,             -- {"vi":"Thôi nôi","en":"First birthday"}
  prompt_i18n     jsonb,
  is_traditional  boolean NOT NULL DEFAULT false,
  date_rule       jsonb,                      -- {"type":"OFFSET","months":1,"lunarOption":true} | {"type":"FIRST_LUNAR_NEW_YEAR"}
  remind_days_before smallint,
  sort_order      int NOT NULL DEFAULT 0,
  status          varchar(10) NOT NULL DEFAULT 'ACTIVE'
);

CREATE TABLE app.milestones (
  id              uuid PRIMARY KEY,
  family_id       uuid NOT NULL,
  child_id        uuid,                       -- cột mốc của bé
  pregnancy_id    uuid,                       -- cột mốc thai kỳ (17.2: que thử 2 vạch, nghe tim thai, chọn được tên…)
  from_milestone_id uuid,                     -- bản sao sang bé khi birth conversion (sinh đôi → 1 bản/bé)
  memory_id       uuid NOT NULL,
  template_code   varchar(40) REFERENCES app.milestone_templates(code),
  custom_title    varchar(80),
  occurred_on     date NOT NULL,
  created_by      uuid NOT NULL REFERENCES app.users(id),
  created_at      timestamptz NOT NULL DEFAULT now(),
  deleted_at      timestamptz,
  CHECK (template_code IS NOT NULL OR custom_title IS NOT NULL),
  CHECK ((child_id IS NOT NULL)::int + (pregnancy_id IS NOT NULL)::int = 1),
  FOREIGN KEY (child_id, family_id)  REFERENCES app.children(id, family_id),
  FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.pregnancies(id, family_id),
  FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id)
);
CREATE UNIQUE INDEX uq_milestone_once ON app.milestones(child_id, template_code)
  WHERE template_code IS NOT NULL AND deleted_at IS NULL;
CREATE UNIQUE INDEX uq_preg_milestone_once ON app.milestones(pregnancy_id, template_code)
  WHERE pregnancy_id IS NOT NULL AND template_code IS NOT NULL AND deleted_at IS NULL;
CREATE INDEX ON app.milestones(child_id, occurred_on);

CREATE TABLE app.albums (
  id               uuid PRIMARY KEY,
  family_id        uuid NOT NULL REFERENCES app.families(id),
  owner_user_id    uuid NOT NULL REFERENCES app.users(id),
  name             varchar(60) NOT NULL,
  cover_memory_id  uuid,
  is_sensitive     boolean NOT NULL DEFAULT false,      -- album “Tắm bé & riêng tư”
  created_at       timestamptz NOT NULL DEFAULT now(),
  deleted_at       timestamptz,
  UNIQUE (id, family_id)
);
CREATE TABLE app.album_memories (
  album_id   uuid NOT NULL,
  memory_id  uuid NOT NULL,
  family_id  uuid NOT NULL,
  added_by   uuid NOT NULL,
  added_at   timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (album_id, memory_id),
  FOREIGN KEY (album_id, family_id)  REFERENCES app.albums(id, family_id) ON DELETE CASCADE,
  FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id) ON DELETE CASCADE
);

CREATE TABLE app.comments (
  id                 uuid PRIMARY KEY,
  family_id          uuid NOT NULL,
  memory_id          uuid NOT NULL,
  author_user_id     uuid NOT NULL REFERENCES app.users(id),
  parent_comment_id  uuid REFERENCES app.comments(id),
  body               varchar(1000) NOT NULL,
  status             varchar(10) NOT NULL DEFAULT 'ACTIVE',   -- ACTIVE | DELETED | HIDDEN (moderation)
  created_at         timestamptz NOT NULL DEFAULT now(),
  edited_at          timestamptz,
  deleted_at         timestamptz,
  FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id) ON DELETE CASCADE
);
CREATE INDEX ON app.comments(memory_id, created_at);

CREATE TABLE app.reactions (
  memory_id   uuid NOT NULL REFERENCES app.memories(id) ON DELETE CASCADE,
  user_id     uuid NOT NULL REFERENCES app.users(id),
  type        app.reaction_type NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (memory_id, user_id)
);

CREATE TABLE app.favorites (
  user_id    uuid NOT NULL REFERENCES app.users(id),
  memory_id  uuid NOT NULL REFERENCES app.memories(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, memory_id)
);

CREATE TABLE app.memory_pins (
  child_id   uuid NOT NULL REFERENCES app.children(id),
  memory_id  uuid NOT NULL REFERENCES app.memories(id) ON DELETE CASCADE,
  pinned_by  uuid NOT NULL,
  position   smallint NOT NULL CHECK (position BETWEEN 1 AND 3),
  PRIMARY KEY (child_id, position)
);
CREATE INDEX ON app.favorites(memory_id);

-- “Ảnh đẹp nhất của nhà mình” = ký ức được CẢ HAI Parent ACTIVE yêu thích (7.8.4); yêu thích riêng không lộ
CREATE VIEW app.v_family_best_memories AS
SELECT m.family_id, f.memory_id, max(f.created_at) AS best_since
FROM app.favorites f
JOIN app.memories m        ON m.id = f.memory_id AND m.status = 'PUBLISHED'
JOIN app.family_parents fp ON fp.family_id = m.family_id AND fp.user_id = f.user_id AND fp.status = 'ACTIVE'
GROUP BY m.family_id, f.memory_id
HAVING count(DISTINCT f.user_id) = 2;

CREATE TABLE app.memory_people (                  -- “Ai ở đó” (7.8.1) — KHÔNG nhận diện khuôn mặt
  id            bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  memory_id     uuid NOT NULL,
  family_id     uuid NOT NULL,
  user_id       uuid REFERENCES app.users(id),    -- Parent / người thân của gia đình (service kiểm tra thành viên ACTIVE)
  display_name  varchar(40),                      -- tên gõ tự do (“Cô Hạnh hàng xóm”)
  sort_order    smallint NOT NULL DEFAULT 0,
  added_by      uuid NOT NULL REFERENCES app.users(id),
  CHECK ((user_id IS NULL) <> (display_name IS NULL)),          -- đúng 1 trong 2
  FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id) ON DELETE CASCADE
);
CREATE UNIQUE INDEX uq_mem_people_user ON app.memory_people(memory_id, user_id) WHERE user_id IS NOT NULL;
CREATE INDEX ON app.memory_people(user_id) WHERE user_id IS NOT NULL;

CREATE TABLE app.memory_perspectives (            -- “Kể cùng nhau — Góc nhìn thứ hai” (7.8.6, BR-071)
  id                  uuid PRIMARY KEY,
  family_id           uuid NOT NULL,
  memory_id           uuid NOT NULL,
  author_user_id      uuid NOT NULL REFERENCES app.users(id),   -- Parent, là bạn đời của tác giả ký ức gốc (service)
  body                varchar(1000),
  audio_asset_id      uuid,
  hidden_from_circle  boolean NOT NULL DEFAULT false,           -- tác giả ký ức gốc CHỈ được đổi cờ này
  status              varchar(10) NOT NULL DEFAULT 'ACTIVE',    -- ACTIVE | TRASHED (vào/ra thùng rác cùng ký ức gốc)
  trashed_at          timestamptz,
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now(),
  version             int NOT NULL DEFAULT 1,
  -- KHÔNG có cột visibility: luôn kế thừa ký ức gốc (6.7)
  UNIQUE (memory_id, author_user_id),                           -- tối đa 1 góc nhìn/Parent/ký ức
  UNIQUE (id, family_id),
  FOREIGN KEY (memory_id, family_id) REFERENCES app.memories(id, family_id) ON DELETE CASCADE,
  FOREIGN KEY (audio_asset_id, family_id) REFERENCES app.assets(id, family_id)
);
CREATE TABLE app.memory_perspective_assets (       -- ≤ 10 ảnh/video mỗi góc nhìn
  perspective_id  uuid NOT NULL,
  asset_id        uuid NOT NULL,
  family_id       uuid NOT NULL,
  sort_order      smallint NOT NULL,
  PRIMARY KEY (perspective_id, asset_id),
  FOREIGN KEY (perspective_id, family_id) REFERENCES app.memory_perspectives(id, family_id) ON DELETE CASCADE,
  FOREIGN KEY (asset_id, family_id)       REFERENCES app.assets(id, family_id)
);
CREATE INDEX ON app.memory_perspective_assets(asset_id);    -- reference count khi purge

CREATE TABLE app.monthly_photos (                 -- ảnh tháng CHÍNH (7.8.7, BR-072) — 1 dòng = 1 ô MEM-20 / PREG-02
  id             uuid PRIMARY KEY,
  family_id      uuid NOT NULL,
  child_id       uuid,
  month_index    smallint CHECK (month_index BETWEEN 0 AND 240),   -- tháng tuổi; 0 = ảnh chào đời
  pregnancy_id   uuid,
  preg_week      smallint CHECK (preg_week BETWEEN 4 AND 42),      -- ảnh bụng theo tuần
  memory_id      uuid NOT NULL,                   -- ký ức chứa ảnh (thường kind = MONTHLY_PHOTO / BUMP)
  asset_id       uuid NOT NULL,                   -- ảnh được chọn làm ảnh chính
  sticker        jsonb,                           -- {"template":"STAR_01","label":"6 tháng","locale":"vi","x":0.1,"y":0.8,"scale":1}
                                                  -- LỚP HIỂN THỊ — không burn vào ảnh gốc (10.9)
  set_by         uuid NOT NULL REFERENCES app.users(id),
  set_at         timestamptz NOT NULL DEFAULT now(),
  CHECK ((child_id IS NOT NULL AND month_index IS NOT NULL AND pregnancy_id IS NULL AND preg_week IS NULL)
      OR (pregnancy_id IS NOT NULL AND preg_week IS NOT NULL AND child_id IS NULL AND month_index IS NULL)),
  FOREIGN KEY (child_id, family_id)     REFERENCES app.children(id, family_id),
  FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.pregnancies(id, family_id),
  FOREIGN KEY (memory_id, family_id)    REFERENCES app.memories(id, family_id) ON DELETE CASCADE,
  FOREIGN KEY (memory_id, asset_id)     REFERENCES app.memory_assets(memory_id, asset_id) ON DELETE CASCADE
);
-- Đúng 1 ảnh chính/bé/tháng tuổi (BR-072); đổi ảnh chính = UPSERT ON CONFLICT, ký ức cũ giữ nguyên
CREATE UNIQUE INDEX uq_monthly_child ON app.monthly_photos(child_id, month_index) WHERE child_id IS NOT NULL;
CREATE UNIQUE INDEX uq_bump_week     ON app.monthly_photos(pregnancy_id, preg_week) WHERE pregnancy_id IS NOT NULL;

CREATE TABLE app.memory_prompt_templates (       -- catalog “Gợi ý ghi lại” (nghiệp vụ 17.6), quản trị ở ADM catalog
  code           varchar(30) PRIMARY KEY,
  stage          varchar(10) NOT NULL,           -- PREGNANCY | CHILD | ANY
  min_age_days   int, max_age_days int,
  min_preg_week  smallint, max_preg_week smallint,
  target_kind    app.memory_kind NOT NULL,       -- loại ký ức mở ra: QUOTE | VOICE | MOMENT | DIARY | LETTER | MONTHLY_PHOTO | BUMP
  text_i18n      jsonb NOT NULL,                 -- {"vi":"Từ mới {childName} nói tuần này là gì?","en":"…"} — Content duyệt: không câu gây tội lỗi
  weight         smallint NOT NULL DEFAULT 10,
  status         varchar(10) NOT NULL DEFAULT 'ACTIVE',
  version        int NOT NULL DEFAULT 1,
  updated_at     timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE app.memory_prompt_deliveries (      -- gợi ý đã phát cho từng Parent (BR-073)
  id             bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  family_id      uuid NOT NULL REFERENCES app.families(id),
  user_id        uuid NOT NULL REFERENCES app.users(id),
  local_date     date NOT NULL,
  template_code  varchar(30) NOT NULL REFERENCES app.memory_prompt_templates(code),
  child_id       uuid,                           -- bé được hỏi (hoặc pregnancy_id)
  pregnancy_id   uuid,
  status         varchar(10) NOT NULL DEFAULT 'SHOWN',   -- SHOWN | USED | DISMISSED | REPLACED
  memory_id      uuid,                           -- USED: ký ức tạo từ gợi ý
  created_at     timestamptz NOT NULL DEFAULT now(),
  acted_at       timestamptz
);
-- Tối đa 1 gợi ý hiệu lực/ngày/Parent; “Gợi ý khác” = dòng cũ REPLACED + dòng mới (≤ prompts.maxNextPerDay)
CREATE UNIQUE INDEX uq_prompt_day ON app.memory_prompt_deliveries(user_id, local_date) WHERE status IN ('SHOWN','USED');
CREATE INDEX ix_prompt_recent ON app.memory_prompt_deliveries(user_id, local_date DESC, template_code);   -- không lặp 30 ngày

CREATE TABLE app.story_views (                   -- “Hôm nay của con”: mốc đã xem theo TỪNG người (7.8.9, AC-028)
  user_id        uuid NOT NULL REFERENCES app.users(id),
  subject_type   varchar(10) NOT NULL,           -- CHILD | PREGNANCY
  subject_id     uuid NOT NULL,
  local_date     date NOT NULL,
  seen_until     timestamptz NOT NULL,           -- published_at lớn nhất người này đã xem
  updated_at     timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, subject_type, subject_id, local_date)
);

-- Trigger cập nhật search_tsv (SQL migration)
CREATE FUNCTION app.memories_tsv() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
  NEW.search_tsv := to_tsvector('simple',
      unaccent(coalesce(NEW.title,'') || ' ' || coalesce(NEW.body,'') || ' ' || coalesce(NEW.location_label,'')));
  RETURN NEW;
END $$;
CREATE TRIGGER trg_memories_tsv BEFORE INSERT OR UPDATE OF title, body, location_label
  ON app.memories FOR EACH ROW EXECUTE FUNCTION app.memories_tsv();
```

> **Ký ức mở rộng:** xoá ký ức gốc → `memory_perspectives.status = TRASHED` trong cùng transaction (khôi phục/purge đi theo ký ức gốc; `monthly_photos` của ký ức bị xoá khỏi ô, khôi phục gắn lại nếu ô còn trống); `perspective_count` cập nhật cùng transaction; `memory_children.age_month` tính lại khi đổi `occurred_at` hoặc ngày sinh bé. Birth conversion sao chép cột mốc thai kỳ sang từng bé (`from_milestone_id`).
>
> **Lưu ý `unaccent` trong index/trigger:** `unaccent()` không phải IMMUTABLE nên không dùng trực tiếp trong expression index; dùng trigger như trên (hoặc wrapper IMMUTABLE có chỉ định dictionary). Cấu hình text search `'simple'` vì PostgreSQL không có stemmer tiếng Việt; bỏ dấu giúp tìm “thoi noi” ra “thôi nôi”.

#### 7.2.6 Lịch & sự kiện

```sql
CREATE TABLE app.events (
  id               uuid PRIMARY KEY,
  family_id        uuid NOT NULL REFERENCES app.families(id),
  type             varchar(20) NOT NULL,          -- CHILD | FAMILY | COUPLE | MEMORY_REMINDER | NOTE
  title            varchar(120) NOT NULL,
  notes            text,
  all_day          boolean NOT NULL DEFAULT true,
  start_at         timestamptz NOT NULL,
  end_at           timestamptz,
  is_lunar         boolean NOT NULL DEFAULT false,
  lunar_month      smallint, lunar_day smallint, lunar_leap boolean,
  repeat_yearly    boolean NOT NULL DEFAULT false,
  invite_circle    boolean NOT NULL DEFAULT false,  -- chỉ có hiệu lực ở gói FAMILY
  reminder_offsets int[] NOT NULL DEFAULT '{}',     -- phút trước sự kiện
  created_by       uuid NOT NULL REFERENCES app.users(id),
  created_at       timestamptz NOT NULL DEFAULT now(),
  deleted_at       timestamptz,
  UNIQUE (id, family_id)
);
CREATE TABLE app.event_children (
  event_id uuid NOT NULL, child_id uuid NOT NULL, family_id uuid NOT NULL,
  PRIMARY KEY (event_id, child_id),
  FOREIGN KEY (event_id, family_id) REFERENCES app.events(id, family_id) ON DELETE CASCADE,
  FOREIGN KEY (child_id, family_id) REFERENCES app.children(id, family_id)
);

CREATE TABLE app.prep_items (                      -- checklist chuẩn bị đón bé
  id            uuid PRIMARY KEY,
  family_id     uuid NOT NULL,
  pregnancy_id  uuid NOT NULL,
  group_code    varchar(20) NOT NULL,              -- HOSPITAL_BAG | NEWBORN | NURSERY | PAPERS | CUSTOM
  title         varchar(120) NOT NULL,
  sort_order    int NOT NULL DEFAULT 0,
  done_at       timestamptz, done_by uuid,
  mission_id    uuid,
  FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.pregnancies(id, family_id)
);
```

#### 7.2.7 Care: nhiệm vụ hằng ngày, Hearts, Cây gia đình, huy hiệu

> Mô hình theo nghiệp vụ 7.13–7.15 (C-14..C-16): bảng nhiệm vụ hằng ngày bày từ thư viện, chủ nhiệm vụ = một Parent hoặc **Cùng nhau** (không có giao cho bạn đời), Hearts ghi theo **từng người**, Cây gia đình là tổng cache. Các bảng cũ `mission_assignees`, `family_hearts`, `care_insight_optins` và enum `assignee_mode`, `mission_origin` **đã bỏ**.

```sql
CREATE TABLE app.mission_templates (                -- thư viện định sẵn (nghiệp vụ 17.1), quản trị ở ADM-06..10
  id                  uuid PRIMARY KEY,
  code                varchar(20) NOT NULL UNIQUE,   -- PG-04, NB-05, …
  stage               varchar(10) NOT NULL,          -- PREGNANCY | CHILD | ANY
  min_age_days        int,  max_age_days int,        -- CHILD
  min_preg_week       smallint, max_preg_week smallint,
  category            app.mission_category NOT NULL, -- gồm SELF (chăm bản thân mẹ bầu/sau sinh); không dùng CUSTOM
  suggested_scope     app.mission_scope NOT NULL,
  role_fit            app.mission_role_fit NOT NULL DEFAULT 'ANY_PARENT',
                                                     -- PREGNANT_MOTHER = người mang thai (tuần ≥ 28) / mẹ ≤ 6 tuần sau sinh;
                                                     -- PARTNER_OF_PREGNANT = bạn đời của người đó; TOGETHER = chỉ bày ở tab Cùng nhau;
                                                     -- ngoài thai kỳ & hậu sản không gán theo giới
  hearts              smallint NOT NULL CHECK (hearts BETWEEN 1 AND 10),   -- dùng để cân bằng bảng ngày (BR-019)
  duration_min        smallint NOT NULL,
  multi_child_ok      boolean NOT NULL DEFAULT true, -- cho phép gắn ≥ 2 bé (MULTI_CHILD)
  requestable         boolean NOT NULL DEFAULT true, -- dùng được khi gửi Lời nhờ TASK (US-03)
  title_i18n          jsonb NOT NULL,
  desc_i18n           jsonb,
  memory_prompt_i18n  jsonb,
  tags                text[] NOT NULL DEFAULT '{}',
  weight              smallint NOT NULL DEFAULT 10,  -- trọng số chọn ngẫu nhiên
  rollout_pct         smallint NOT NULL DEFAULT 100,
  status              varchar(10) NOT NULL DEFAULT 'ACTIVE',
  version             int NOT NULL DEFAULT 1,
  updated_at          timestamptz NOT NULL DEFAULT now(),
  CHECK (category <> 'CUSTOM'),
  CHECK (suggested_scope <> 'COUPLE' OR role_fit = 'TOGETHER')     -- “Hai ta” luôn là Cùng nhau
);
CREATE INDEX ix_tpl_pick   ON app.mission_templates(stage, role_fit, category) WHERE status = 'ACTIVE';
CREATE INDEX ix_tpl_hearts ON app.mission_templates(category, hearts)          WHERE status = 'ACTIVE';  -- ứng viên Đổi (Hearts ±1)

CREATE TABLE app.mission_family_settings (          -- cấu hình CẤP GIA ĐÌNH (CARE-12), áp dụng cho cả hai Parent
  family_id          uuid PRIMARY KEY REFERENCES app.families(id),
  board_level        app.mission_board_level NOT NULL DEFAULT 'MEDIUM',   -- áp dụng từ bảng ngày kế tiếp
  updated_by         uuid REFERENCES app.users(id),  -- ai đổi cũng được → outbox MissionBoardLevelChanged báo người kia
  updated_at         timestamptz NOT NULL DEFAULT now(),
  version            int NOT NULL DEFAULT 1
);

CREATE TABLE app.mission_preferences (              -- cài đặt riêng từng Parent (CARE-12)
  family_id            uuid NOT NULL REFERENCES app.families(id),
  user_id              uuid NOT NULL REFERENCES app.users(id),
  disabled_categories  app.mission_category[] NOT NULL DEFAULT '{}', -- category không muốn nhận (vẫn bày đủ số lượng)
  board_push_time      time NOT NULL DEFAULT '07:00',               -- giờ thông báo “bảng nhiệm vụ hôm nay”
  evening_carry_over   boolean NOT NULL DEFAULT true,               -- 21:00 hỏi chuyển nhiệm vụ TỰ THÊM sang mai
  default_reminder_min smallint,                                    -- nhắc mặc định khi tự thêm
  PRIMARY KEY (family_id, user_id)
);

-- Bảng nhiệm vụ của một ngày (1 dòng/gia đình/ngày) — khoá idempotent của job bày bảng
CREATE TABLE app.daily_mission_boards (
  family_id          uuid NOT NULL REFERENCES app.families(id),
  board_date         date NOT NULL,                  -- ngày theo timezone family
  level              app.mission_board_level NOT NULL,
  per_parent_count   smallint NOT NULL,              -- 2 | 3 | 4 (bằng nhau cho hai Parent — BR-019)
  together_count     smallint NOT NULL,              -- 0..1
  balance_diff       smallint NOT NULL CHECK (balance_diff BETWEEN 0 AND 2),  -- |ΣHearts A − ΣHearts B| lúc bày
  generator_version  smallint NOT NULL,
  seed               bigint NOT NULL,                -- tái lập kết quả khi debug
  generated_at       timestamptz NOT NULL DEFAULT now(),
  bloomed_at         timestamptz,                    -- cả hai xong hết bộ SYSTEM + Cùng nhau → cây nở hoa
  PRIMARY KEY (family_id, board_date)
);

-- Phần của từng Parent trong bảng ngày — CHỈ phục vụ audit/đếm lượt Đổi, KHÔNG bao giờ trả qua API
CREATE TABLE app.daily_mission_board_parents (
  family_id          uuid NOT NULL,
  board_date         date NOT NULL,
  user_id            uuid NOT NULL REFERENCES app.users(id),
  quota_count        smallint NOT NULL,              -- số nhiệm vụ SYSTEM được bày
  hearts_total       smallint NOT NULL,              -- tổng Hearts bộ lúc bày (audit BR-019, nội bộ)
  swaps_used         smallint NOT NULL DEFAULT 0 CHECK (swaps_used BETWEEN 0 AND 3),   -- Đổi ≤ 3 lần/người/ngày
  PRIMARY KEY (family_id, board_date, user_id),
  FOREIGN KEY (family_id, board_date) REFERENCES app.daily_mission_boards(family_id, board_date) ON DELETE CASCADE
);

CREATE TABLE app.mission_series (                   -- chỉ cho nhiệm vụ TỰ THÊM (7.13.6); không tính định mức
  id                uuid PRIMARY KEY,
  family_id         uuid NOT NULL REFERENCES app.families(id),
  created_by        uuid NOT NULL REFERENCES app.users(id),
  owner_kind        app.mission_owner_kind NOT NULL,
  owner_user_id     uuid REFERENCES app.users(id),   -- = created_by khi PARENT; null khi TOGETHER
  template_id       uuid REFERENCES app.mission_templates(id),   -- null = tự gõ (2 Hearts)
  title             varchar(120) NOT NULL,
  note              varchar(500),
  category          app.mission_category NOT NULL,
  target_scope      app.mission_scope NOT NULL,
  hearts            smallint NOT NULL CHECK (hearts BETWEEN 1 AND 10),
  child_ids         uuid[] NOT NULL DEFAULT '{}',    -- snapshot; validate cùng family ở service
  rrule             text NOT NULL,                   -- RFC 5545: DAILY | BYDAY=MO..FR | SA,SU | chọn thứ | INTERVAL=N | BYMONTHDAY=X
  time_of_day       time,
  reminder_offset_min smallint,
  start_date        date NOT NULL,
  end_date          date,
  paused_ranges     jsonb NOT NULL DEFAULT '[]',     -- [{"from":"2026-10-10","to":"2026-10-15"}] — “Tạm dừng chuỗi”
  generated_until   date,
  status            varchar(10) NOT NULL DEFAULT 'ACTIVE',   -- ACTIVE | PAUSED | ENDED
  created_at        timestamptz NOT NULL DEFAULT now(),
  version           int NOT NULL DEFAULT 1,
  UNIQUE (id, family_id),
  CHECK ((owner_kind = 'PARENT') = (owner_user_id IS NOT NULL)),
  CHECK (owner_kind = 'TOGETHER' OR owner_user_id = created_by),          -- BR-020
  CHECK (target_scope <> 'COUPLE' OR owner_kind = 'TOGETHER'),
  CHECK (template_id IS NOT NULL OR hearts = 2)                           -- tự gõ = 2 Hearts (BR-069)
);

CREATE TABLE app.missions (
  id                 uuid PRIMARY KEY,
  family_id          uuid NOT NULL REFERENCES app.families(id),
  board_date         date NOT NULL,                      -- ngày của bảng theo timezone family
  owner_kind         app.mission_owner_kind NOT NULL,    -- PARENT | TOGETHER
  owner_user_id      uuid REFERENCES app.users(id),      -- Parent chủ nhiệm vụ; NULL khi TOGETHER
  source             app.mission_source NOT NULL,        -- SYSTEM (bày 05:00) | LIBRARY | CUSTOM | SERIES
  template_id        uuid REFERENCES app.mission_templates(id),
  series_id          uuid,
  swapped_from_id    uuid,                               -- nhiệm vụ SYSTEM bị Đổi ra (CARE-05)
  swap_count         smallint NOT NULL DEFAULT 0,        -- số lần đã đổi trong chuỗi đổi (mới = cũ + 1)
  ref_type           varchar(20),                        -- PREP_ITEM | CONFLICT_STEP | REQUEST (“Tự mình làm”) — chỉ truy vết
  ref_id             uuid,
  title              varchar(120) NOT NULL,
  note               varchar(500),
  category           app.mission_category NOT NULL,
  target_scope       app.mission_scope NOT NULL,
  hearts             smallint NOT NULL CHECK (hearts BETWEEN 1 AND 10),  -- snapshot khi tạo; tự gõ = 2 (BR-069)
  status             app.mission_status NOT NULL DEFAULT 'TODO',
  scheduled_time     time,
  due_at             timestamptz,                        -- board_date + scheduled_time → UTC
  reminder_at        timestamptz,
  memory_prompt      boolean NOT NULL DEFAULT true,
  completed_by       uuid REFERENCES app.users(id),      -- người bấm (TOGETHER: một trong hai)
  completed_at       timestamptz,
  late               boolean NOT NULL DEFAULT false,     -- ghi muộn: EXPIRED → DONE trước hết ngày board_date + 1
  removed_reason     varchar(15),                        -- SKIPPED_TODAY | SWAPPED | DELETED | CARRIED_OVER | SERIES_EDIT | CHILD_ARCHIVED
  removed_at         timestamptz,
  created_by         uuid REFERENCES app.users(id),      -- null = hệ thống (SYSTEM, SERIES)
  created_at         timestamptz NOT NULL DEFAULT now(),
  updated_at         timestamptz NOT NULL DEFAULT now(),
  version            int NOT NULL DEFAULT 1,
  UNIQUE (id, family_id),
  FOREIGN KEY (series_id, family_id) REFERENCES app.mission_series(id, family_id),
  CHECK ((owner_kind = 'PARENT') = (owner_user_id IS NOT NULL)),
  CHECK (source IN ('SYSTEM','SERIES') OR owner_kind = 'TOGETHER' OR owner_user_id = created_by), -- BR-020: không tạo cho bạn đời
  CHECK ((source = 'SERIES') = (series_id IS NOT NULL)),
  CHECK (source <> 'CUSTOM' OR (template_id IS NULL AND hearts = 2)),
  CHECK (target_scope <> 'COUPLE' OR owner_kind = 'TOGETHER'),
  CHECK ((status = 'DONE') = (completed_at IS NOT NULL AND completed_by IS NOT NULL)),
  CHECK (NOT late OR status = 'DONE'),
  CHECK ((status = 'REMOVED') = (removed_reason IS NOT NULL))
);
-- Bảng ngày theo tab (CARE-01): Của tôi / Của bạn đời / Cùng nhau
CREATE INDEX ix_missions_board ON app.missions(family_id, board_date, owner_kind, owner_user_id) WHERE status <> 'REMOVED';
-- Bày bảng idempotent + 1 template không xuất hiện 2 lần trong bộ hệ thống của một ngày
CREATE UNIQUE INDEX uq_board_template ON app.missions(family_id, board_date, template_id)
  WHERE source = 'SYSTEM' AND status <> 'REMOVED';
-- Không lặp trong 14 ngày (tra template đã dùng gần đây, mọi trạng thái)
CREATE INDEX ix_missions_tpl_recent ON app.missions(family_id, board_date, template_id) WHERE template_id IS NOT NULL;
CREATE INDEX ix_missions_due     ON app.missions(due_at) WHERE status = 'TODO' AND due_at IS NOT NULL;
CREATE INDEX ix_missions_expire  ON app.missions(board_date) WHERE status = 'TODO';                    -- job hết ngày
CREATE INDEX ix_missions_history ON app.missions(family_id, owner_user_id, board_date DESC) WHERE status IN ('DONE','EXPIRED');
-- 1 instance/chuỗi/ngày ⇒ Hearts tối đa 1 lần/chuỗi/ngày
CREATE UNIQUE INDEX uq_series_day ON app.missions(series_id, board_date) WHERE series_id IS NOT NULL AND status <> 'REMOVED';

CREATE TABLE app.mission_children (
  mission_id  uuid NOT NULL,
  child_id    uuid NOT NULL,
  family_id   uuid NOT NULL,
  PRIMARY KEY (mission_id, child_id),
  FOREIGN KEY (mission_id, family_id) REFERENCES app.missions(id, family_id) ON DELETE CASCADE,
  FOREIGN KEY (child_id,  family_id)  REFERENCES app.children(id, family_id)
);
CREATE INDEX ON app.mission_children(child_id);

CREATE TABLE app.mission_events (                   -- nhật ký (REMOVED chỉ còn ở đây)
  id            bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  mission_id    uuid NOT NULL REFERENCES app.missions(id) ON DELETE CASCADE,
  actor_user_id uuid,
  type          varchar(30) NOT NULL,   -- GENERATED|CREATED|SWAPPED|REMOVED|COMPLETED|LATE_COMPLETED|UNDONE|EXPIRED|
                                        -- CARRIED_OVER|EDITED|THANKED
  data          jsonb,                  -- không ghi Hearts của người khác
  created_at    timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX ON app.mission_events(mission_id, created_at);

CREATE TABLE app.mission_completions (
  id               uuid PRIMARY KEY,
  mission_id       uuid NOT NULL REFERENCES app.missions(id),
  completed_by     uuid NOT NULL REFERENCES app.users(id),
  completed_at     timestamptz NOT NULL DEFAULT now(),
  late             boolean NOT NULL DEFAULT false,
  note             varchar(500),
  memory_id        uuid REFERENCES app.memories(id),
  idempotency_key  uuid NOT NULL UNIQUE,
  undone_at        timestamptz
);
-- Chỉ 1 completion hiệu lực / nhiệm vụ → chặn hai người cùng bấm “Xong cùng nhau”
-- (TOGETHER: 1 completion → 2 dòng heart_ledger, mỗi Parent 1 dòng, cùng source_id = completion.id)
CREATE UNIQUE INDEX uq_mission_completion_active ON app.mission_completions(mission_id) WHERE undone_at IS NULL;

-- Hearts: sổ cái bất biến THEO TỪNG NGƯỜI (BR-017, BR-018) — API chỉ đọc dòng của chính người gọi
CREATE TABLE app.heart_ledger (
  id             bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  family_id      uuid NOT NULL REFERENCES app.families(id),
  user_id        uuid NOT NULL REFERENCES app.users(id),   -- người NHẬN Hearts (Parent)
  source_type    varchar(20) NOT NULL,   -- MISSION | MISSION_PHOTO | REQUEST | MEMORY | PERSPECTIVE | MILESTONE | APPRECIATION
  source_id      uuid NOT NULL,          -- MISSION, MISSION_PHOTO: mission_completions.id (hoàn tác rồi làm lại = completion mới)
                                         -- REQUEST: us.requests.id • MEMORY: memories.id • MILESTONE • APPRECIATION
  reason         varchar(30) NOT NULL,   -- MISSION_COMPLETED | CUSTOM_COMPLETED | MISSION_PHOTO | REQUEST_DONE |
                                         -- MEMORY_CREATED | PERSPECTIVE_ADDED | MILESTONE_RECORDED | APPRECIATION_SENT | REVERSAL
  amount         smallint NOT NULL,      -- > 0; âm CHỈ ở bút toán ngược
  reversal_of    bigint REFERENCES app.heart_ledger(id),
  local_date     date NOT NULL,          -- ngày ghi nhận theo timezone family (trần/ngày, “hôm nay”, “tuần này”)
  created_at     timestamptz NOT NULL DEFAULT now(),
  CHECK ((reason = 'REVERSAL') = (reversal_of IS NOT NULL)),
  CHECK ((reason = 'REVERSAL' AND amount < 0) OR (reason <> 'REVERSAL' AND amount > 0))
);
CREATE UNIQUE INDEX uq_heart_once     ON app.heart_ledger(user_id, source_type, source_id, reason) WHERE reversal_of IS NULL; -- idempotent
CREATE UNIQUE INDEX uq_heart_reversal ON app.heart_ledger(reversal_of) WHERE reversal_of IS NOT NULL;                     -- đảo ≤ 1 lần
CREATE INDEX ix_heart_user_day ON app.heart_ledger(user_id, local_date DESC);   -- lịch sử “Hearts của tôi” (CARE-09)
CREATE INDEX ON app.heart_ledger(family_id, created_at);

-- Bộ đếm theo người/ngày: enforce trần trong CÙNG transaction bằng khoá dòng (thay Redis counter của v2)
CREATE TABLE app.heart_daily_counters (
  family_id      uuid NOT NULL REFERENCES app.families(id),
  user_id        uuid NOT NULL REFERENCES app.users(id),
  local_date     date NOT NULL,
  total          smallint NOT NULL DEFAULT 0 CHECK (total >= 0),  -- ≤ hearts.dailyCap (75/người/ngày — BR-069)
  custom_count   smallint NOT NULL DEFAULT 0,   -- số lần tính Hearts CUSTOM (≤ 3)
  photo_count    smallint NOT NULL DEFAULT 0,   -- đính ảnh khi hoàn thành (≤ 5)
  memory_count   smallint NOT NULL DEFAULT 0,   -- tạo ký ức + thêm góc nhìn (≤ 5, dùng chung)
  thanks_count   smallint NOT NULL DEFAULT 0,   -- gửi cảm ơn (≤ 3)
  PRIMARY KEY (user_id, local_date)
);

-- Cây gia đình: tổng Hearts của hai Parent (cache; nguồn đúng = ledger). Không lưu phần đóng góp theo người.
CREATE TABLE app.family_trees (
  family_id      uuid PRIMARY KEY REFERENCES app.families(id),
  total_hearts   int NOT NULL DEFAULT 0 CHECK (total_hearts >= 0), -- KHÔNG trả qua API (6.6)
  level          smallint NOT NULL DEFAULT 1,     -- 1..7 theo ngưỡng 0/100/300/700/1500/3000/6000 (ops.app_config tree.levels); không giảm
  fruits         smallint NOT NULL DEFAULT 0,     -- cấp 7: mỗi 3.000 tiếp theo một “quả”
  flowers        int NOT NULL DEFAULT 0,          -- số ngày cây nở hoa (“Những ngày tròn đầy”)
  updated_at     timestamptz NOT NULL DEFAULT now(),
  version        int NOT NULL DEFAULT 1
);

CREATE TABLE app.badges (
  code         varchar(30) PRIMARY KEY,
  title_i18n   jsonb NOT NULL, desc_i18n jsonb NOT NULL,
  icon         varchar(60) NOT NULL,
  rule         jsonb NOT NULL,   -- {"metric":"MISSION_COMPLETED","filter":{"tags":["bedtime"]},"count":7,"window":"ALL"} — không dựa trên Hearts cá nhân
  scope        varchar(10) NOT NULL DEFAULT 'FAMILY',   -- FAMILY | CIRCLE_MEMBER
  status       varchar(10) NOT NULL DEFAULT 'ACTIVE'
);
CREATE TABLE app.family_badges (
  id           bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  family_id    uuid NOT NULL REFERENCES app.families(id),
  badge_code   varchar(30) NOT NULL REFERENCES app.badges(code),
  subject_user_id uuid,                        -- với badge CIRCLE_MEMBER (null = badge của gia đình)
  achieved_at  timestamptz NOT NULL DEFAULT now(),
  UNIQUE NULLS NOT DISTINCT (family_id, badge_code, subject_user_id)   -- PG15+
);

CREATE TABLE app.care_weekly_snapshots (         -- Thống kê chăm con — CHỈ cấp gia đình (BR-025)
  family_id   uuid NOT NULL,
  week_start  date NOT NULL,
  child_id    uuid,                            -- null = toàn family
  metrics     jsonb NOT NULL,                  -- {"byCategory":{"CARE":12,..},"together":5,"bloomedDays":4} — KHÔNG có byUser
  computed_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE NULLS NOT DISTINCT (family_id, week_start, child_id)          -- PK không được chứa cột NULL
);
```

**Constraint trigger — phạm vi nhiệm vụ vs số bé (BR-021):**

```sql
CREATE FUNCTION app.check_mission_scope() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE v_scope app.mission_scope; v_cnt int; v_id uuid;
BEGIN
  v_id := COALESCE(NEW.mission_id, OLD.mission_id, NEW.id);
  SELECT target_scope INTO v_scope FROM app.missions WHERE id = v_id;
  IF v_scope IS NULL THEN RETURN NULL; END IF;           -- mission đã bị xoá
  SELECT count(*) INTO v_cnt FROM app.mission_children WHERE mission_id = v_id;
  IF (v_scope = 'CHILD' AND v_cnt <> 1)
     OR (v_scope = 'MULTI_CHILD' AND v_cnt < 2)
     OR (v_scope IN ('FAMILY','COUPLE') AND v_cnt <> 0) THEN
    RAISE EXCEPTION 'MISSION_SCOPE_MISMATCH scope=% children=%', v_scope, v_cnt USING ERRCODE = '23514';
  END IF;
  RETURN NULL;
END $$;

CREATE CONSTRAINT TRIGGER trg_mission_scope_m AFTER INSERT OR UPDATE OF target_scope ON app.missions
  DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION app.check_mission_scope();
CREATE CONSTRAINT TRIGGER trg_mission_scope_c AFTER INSERT OR DELETE ON app.mission_children
  DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION app.check_mission_scope();
```

> **Chủ nhiệm vụ** (`owner_user_id`) phải là Parent ACTIVE của cùng family: kiểm tra ở service (join `family_parents`; không FK được vì unique index là partial) + test tự động. CHECK `owner_user_id = created_by` chặn ngay ở DB việc tạo nhiệm vụ cho bạn đời (BR-020); nhiệm vụ `SYSTEM`/`SERIES` do worker tạo đi qua cùng hàm kiểm tra của service.
>
> **Cô lập Hearts ở tầng code/DB:** chỉ `HeartsRepository` (module `care/hearts`) được đọc `heart_ledger`, `heart_daily_counters`, `daily_mission_board_parents.hearts_total` (lint `no-restricted-imports` như 16.2); repository chỉ có hàm đọc theo `ctx.userId`. View cho `bf_readonly_analytics` không có cột `user_id` của ledger.

#### 7.2.8 Papa & Mama (schema `us`)

```sql
CREATE TABLE us.mood_checkins (
  id               uuid PRIMARY KEY,
  couple_space_id  uuid NOT NULL REFERENCES app.couple_spaces(id),
  user_id          uuid NOT NULL REFERENCES app.users(id),
  mood             us.mood NOT NULL,
  energy           smallint CHECK (energy BETWEEN 1 AND 5),
  needs            us.need[] NOT NULL DEFAULT '{}',
  note_enc         bytea,                         -- mã hoá bằng DEK cá nhân (không bao giờ đọc được bởi partner nếu không share)
  shared           boolean NOT NULL DEFAULT false,
  shared_fields    text[] NOT NULL DEFAULT '{}',  -- mood | energy | needs | note
  shared_note_enc  bytea,                         -- bản note đã chia sẻ (mã hoá bằng DEK couple)
  expires_at       timestamptz NOT NULL,
  seen_by_partner_at timestamptz,
  created_at       timestamptz NOT NULL DEFAULT now(),
  deleted_at       timestamptz
);
CREATE INDEX ON us.mood_checkins(couple_space_id, created_at DESC);
CREATE INDEX ON us.mood_checkins(user_id, created_at DESC);

CREATE TABLE us.mood_responses (
  id          uuid PRIMARY KEY,
  checkin_id  uuid NOT NULL REFERENCES us.mood_checkins(id) ON DELETE CASCADE,
  user_id     uuid NOT NULL,
  type        varchar(20) NOT NULL,     -- SEEN | ASK_NEED | TAKE_OVER | HUG
  request_id  uuid,                     -- TAKE_OVER (“Để mình lo”) → Lời nhờ TASK ACCEPTED, volunteered = true
  created_at  timestamptz NOT NULL DEFAULT now()
);

-- Lời nhờ (nghiệp vụ 7.16.2) — thay us.support_requests; cách DUY NHẤT để nhờ bạn đời (C-16).
-- Không bao giờ trả cho Circle, không nằm trong tab nhiệm vụ (BR-070).
CREATE TABLE us.requests (
  id                uuid PRIMARY KEY,
  family_id         uuid NOT NULL REFERENCES app.families(id),
  couple_space_id   uuid NOT NULL REFERENCES app.couple_spaces(id),
  sender_user_id    uuid NOT NULL REFERENCES app.users(id),
  receiver_user_id  uuid NOT NULL REFERENCES app.users(id),   -- = bạn đời; với TASK là người làm
  kind              us.request_kind NOT NULL,                  -- TASK (Nhờ một việc) | NEED (Mình đang cần…)
  need_code         us.need,                                   -- NEED: QUIET|HUG|TALK|REASSURANCE • TASK: BREAK|HELP_CHILD|null
  template_id       uuid REFERENCES app.mission_templates(id),-- TASK chọn từ thư viện (requestable = true)
  title_enc         bytea,                                     -- TASK tự gõ — DEK COUPLE
  duration_min      smallint CHECK (duration_min IN (15,30,60)),  -- BREAK “Cần nghỉ 15/30/60 phút”
  content_key       bytea NOT NULL,                            -- HMAC(pepper, kind|need|template|title chuẩn hoá) — chặn gửi lại 12h
  message_enc       bytea,                                     -- lời nhắn — DEK COUPLE
  due_kind          us.request_due_kind,                       -- TASK; NEED = null
  due_at            timestamptz,                               -- quy đổi từ due_kind theo timezone family; ≤ created_at + 7 ngày (15.8)
  urgency           us.request_urgency NOT NULL DEFAULT 'NORMAL',
  status            us.request_status NOT NULL DEFAULT 'SENT',
  volunteered       boolean NOT NULL DEFAULT false,            -- tạo từ “Để mình lo” ở check-in (sinh thẳng ACCEPTED)
  decline_reason    varchar(30),                               -- mã lý do nhanh (tuỳ chọn) — không phạt
  ack_type          varchar(15),                               -- NEED: SEEN | HUG | TALK_TIME | ENCOURAGED
  talk_at           timestamptz,                               -- NEED TALK: giờ hẹn nói chuyện
  reminder_at       timestamptz,                               -- tối đa 1 lần nhắc, do NGƯỜI NHẬN chọn (không có nút giục)
  hearts_awarded    smallint NOT NULL DEFAULT 0 CHECK (hearts_awarded >= 0),  -- TASK DONE: Hearts thực cộng cho người làm;
                                                               -- chỉ serialize cho receiver (6.6)
  self_mission_id   uuid,                                      -- “Tự mình làm” sau khi bị từ chối
  seen_at           timestamptz,
  responded_at      timestamptz,                               -- accept / decline / acknowledge
  done_at           timestamptz,
  cancelled_at      timestamptz,
  expires_at        timestamptz NOT NULL,                      -- TASK: due_at + 2h • NEED: created_at + 12h
  created_at        timestamptz NOT NULL DEFAULT now(),
  updated_at        timestamptz NOT NULL DEFAULT now(),
  version           int NOT NULL DEFAULT 1,
  UNIQUE (id, family_id),
  CHECK (sender_user_id <> receiver_user_id),
  CHECK (due_at IS NULL OR due_at <= created_at + interval '7 days'),
  CHECK ((kind = 'NEED' AND need_code IN ('QUIET','HUG','TALK','REASSURANCE'))
      OR (kind = 'TASK' AND (need_code IS NULL OR need_code IN ('BREAK','HELP_CHILD')))),
  CHECK (kind = 'NEED' OR template_id IS NOT NULL OR title_enc IS NOT NULL OR need_code IS NOT NULL),
  CHECK (kind = 'TASK' OR (hearts_awarded = 0 AND template_id IS NULL AND due_kind IS NULL)),   -- NEED không quy đổi Hearts (BR-068)
  CHECK (status NOT IN ('ACCEPTED','DONE') OR kind = 'TASK'),
  CHECK (status <> 'ACKNOWLEDGED' OR kind = 'NEED'),
  CHECK (NOT volunteered OR kind = 'TASK')
);
-- Tối đa 5 lời nhờ đang mở / người gửi (BR-067): đếm trên index này dưới khoá couple_spaces FOR UPDATE
CREATE INDEX ix_req_open_sender  ON us.requests(sender_user_id)
  WHERE status IN ('SENT','SEEN','ACCEPTED') AND volunteered = false;
-- Bị từ chối → không gửi lại cùng nội dung trong 12 giờ (BR-067)
CREATE INDEX ix_req_resend_block ON us.requests(sender_user_id, content_key, responded_at DESC) WHERE status = 'DECLINED';
CREATE INDEX ix_req_couple       ON us.requests(couple_space_id, status, created_at DESC);  -- “Lời nhờ đang mở” 2 chiều
CREATE INDEX ix_req_expire       ON us.requests(expires_at) WHERE status IN ('SENT','SEEN','ACCEPTED');

-- Đặt tên cho con [1.1] (PREG-07) — chỉ Papa & Mama
CREATE TABLE us.pregnancy_name_candidates (
  id               uuid PRIMARY KEY,
  family_id        uuid NOT NULL REFERENCES app.families(id),
  couple_space_id  uuid NOT NULL REFERENCES app.couple_spaces(id),
  pregnancy_id     uuid NOT NULL,
  name_enc         bytea NOT NULL,                -- DEK COUPLE
  meaning_enc      bytea,                         -- ý nghĩa tên — DEK COUPLE
  added_by         uuid NOT NULL REFERENCES app.users(id),
  chosen_at        timestamptz,                   -- “Chọn tên này” (≤ expected_count tên được chọn — service)
  chosen_by        uuid,
  deleted_at       timestamptz,
  created_at       timestamptz NOT NULL DEFAULT now(),
  FOREIGN KEY (pregnancy_id, family_id) REFERENCES app.pregnancies(id, family_id)
);
CREATE INDEX ON us.pregnancy_name_candidates(pregnancy_id) WHERE deleted_at IS NULL;
CREATE TABLE us.pregnancy_name_votes (           -- ❤ “thích” của từng Parent (KHÔNG phải điểm Hearts); 2 phiếu = “Cả hai thích”
  candidate_id  uuid NOT NULL REFERENCES us.pregnancy_name_candidates(id) ON DELETE CASCADE,
  user_id       uuid NOT NULL REFERENCES app.users(id),
  created_at    timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (candidate_id, user_id)
);

CREATE TABLE us.request_children (              -- bé của lời nhờ (tuỳ chọn) — composite FK cùng family
  request_id  uuid NOT NULL,
  child_id    uuid NOT NULL,
  family_id   uuid NOT NULL,
  PRIMARY KEY (request_id, child_id),
  FOREIGN KEY (request_id, family_id) REFERENCES us.requests(id, family_id) ON DELETE CASCADE,
  FOREIGN KEY (child_id,  family_id)  REFERENCES app.children(id, family_id)
);

CREATE TABLE us.appreciations (
  id                  uuid PRIMARY KEY,
  couple_space_id     uuid NOT NULL REFERENCES app.couple_spaces(id),
  from_user_id        uuid NOT NULL, to_user_id uuid NOT NULL,
  body_enc            bytea NOT NULL,          -- DEK couple
  sticker             varchar(40),
  linked_type         varchar(10), linked_id uuid,     -- MISSION | MEMORY | REQUEST (💛 nhanh trên việc đã xong)
  family_share_status varchar(10) NOT NULL DEFAULT 'NONE',  -- NONE | REQUESTED | APPROVED | DECLINED
  family_memory_id    uuid,                    -- ký ức tạo khi được đồng ý
  seen_at             timestamptz,
  reaction            varchar(20),
  created_at          timestamptz NOT NULL DEFAULT now(),
  deleted_by_from_at  timestamptz, deleted_by_to_at timestamptz
);
CREATE INDEX ON us.appreciations(couple_space_id, created_at DESC);

CREATE TABLE us.journal_entries (
  id           uuid PRIMARY KEY,
  user_id      uuid NOT NULL REFERENCES app.users(id),
  family_id    uuid NOT NULL REFERENCES app.families(id),
  title_enc    bytea,
  body_enc     bytea NOT NULL,               -- DEK cá nhân → crypto-shred khi xoá tài khoản
  mood         us.mood,
  asset_ids    uuid[] NOT NULL DEFAULT '{}', -- asset purpose=JOURNAL (chỉ chủ sở hữu ký URL được)
  created_at   timestamptz NOT NULL DEFAULT now(),
  updated_at   timestamptz NOT NULL DEFAULT now(),
  deleted_at   timestamptz
);
CREATE INDEX ON us.journal_entries(user_id, created_at DESC);

CREATE TABLE us.conflict_sessions (
  id               uuid PRIMARY KEY,
  couple_space_id  uuid NOT NULL REFERENCES app.couple_spaces(id),
  opened_by        uuid NOT NULL,
  status           us.conflict_status NOT NULL DEFAULT 'PRIVATE_DRAFT',
  topic            varchar(20),
  next_step        jsonb,                     -- {"code":"TALK_AFTER_SLEEP","at":"...","missionId":..}
  next_step_confirmed_by uuid[] NOT NULL DEFAULT '{}',
  retention_days   smallint NOT NULL DEFAULT 30,    -- 0 = xoá ngay khi đóng
  purge_at         timestamptz,
  invited_at       timestamptz, joined_at timestamptz, closed_at timestamptz,
  last_activity_at timestamptz NOT NULL DEFAULT now(),
  created_at       timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE us.conflict_entries (
  id                 uuid PRIMARY KEY,
  session_id         uuid NOT NULL REFERENCES us.conflict_sessions(id) ON DELETE CASCADE,
  user_id            uuid NOT NULL,
  feelings           text[] NOT NULL DEFAULT '{}',
  needs              text[] NOT NULL DEFAULT '{}',
  draft_enc          bytea,                   -- DEK cá nhân — KHÔNG BAO GIỜ trả cho partner
  shared_points_enc  bytea,                   -- DEK couple — những ý người dùng chọn chia sẻ
  share_status       varchar(10) NOT NULL DEFAULT 'PRIVATE',   -- PRIVATE | SHARED
  understood_at      timestamptz,
  clarify_requested_at timestamptz,
  created_at         timestamptz NOT NULL DEFAULT now(),
  updated_at         timestamptz NOT NULL DEFAULT now(),
  UNIQUE (session_id, user_id)
);
-- Lưu ý: KHÔNG ghi bất kỳ dấu vết nào khi user mở màn Safety (US-13).

CREATE TABLE us.connection_answers (            -- câu hỏi kết nối hằng ngày [1.1]
  couple_space_id uuid NOT NULL, prompt_code varchar(30) NOT NULL, local_date date NOT NULL,
  user_id uuid NOT NULL, answer_enc bytea NOT NULL, created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (couple_space_id, local_date, user_id)
);

-- Khoá mã hoá (envelope)
CREATE TABLE us.data_keys (
  id           uuid PRIMARY KEY,
  owner_type   varchar(10) NOT NULL,          -- USER | COUPLE
  owner_id     uuid NOT NULL,
  wrapped_dek  bytea NOT NULL,                -- DEK bọc bởi KEK (Vault Transit / KMS)
  kek_version  int NOT NULL,
  created_at   timestamptz NOT NULL DEFAULT now(),
  destroyed_at timestamptz,                   -- crypto-shredding
  UNIQUE (owner_type, owner_id)
);
```

> **Phân quyền DB:** tạo DB role `bf_app` (API/worker) có quyền trên `app`, `us`, `billing`, `ops`; role `bf_admin_api` **không có** `SELECT` trên schema `us` (admin không thể đọc dữ liệu Papa & Mama kể cả khi có bug trong admin API). Role `bf_readonly_analytics` chỉ đọc view tổng hợp không chứa nội dung.

#### 7.2.9 Recap, AI, Thông báo cấu hình

```sql
CREATE TABLE app.recaps (
  id             uuid PRIMARY KEY,
  family_id      uuid NOT NULL REFERENCES app.families(id),
  scope          varchar(10) NOT NULL,         -- FAMILY | CHILD
  child_id       uuid,
  period         varchar(12) NOT NULL,         -- DAY | WEEK | MONTH_AGE | YEAR
  period_start   date NOT NULL, period_end date NOT NULL,
  status         varchar(12) NOT NULL DEFAULT 'READY',   -- GENERATING | READY | SAVED | SHARED | DISMISSED
  content        jsonb NOT NULL,               -- {"stats":{..},"memoryIds":[..],"text":"...","pages":[..]}
  content_parents_only jsonb,                  -- phần chỉ Parent thấy (vd. số lời cảm ơn)
  cover_asset_id uuid,
  visibility     app.visibility NOT NULL DEFAULT 'PARENTS',
  memory_id      uuid,                         -- khi lưu vào timeline
  created_at     timestamptz NOT NULL DEFAULT now(),
  UNIQUE NULLS NOT DISTINCT (family_id, scope, child_id, period, period_start)
);

CREATE TABLE app.ai_usage_monthly (
  family_id uuid NOT NULL, month date NOT NULL, used int NOT NULL DEFAULT 0,
  PRIMARY KEY (family_id, month)
);

CREATE TABLE ops.notification_templates (
  code        varchar(40) NOT NULL,            -- MISSIONS_TODAY, REQUEST_RECEIVED, MOOD_SHARED, ... (không template nào có biến Hearts)
  locale      varchar(10) NOT NULL,
  title       varchar(120) NOT NULL,
  body        varchar(300) NOT NULL,           -- biến {{partnerCallName}}, {{childNames}}, ...
  sensitive   boolean NOT NULL DEFAULT false,
  hidden_title varchar(120), hidden_body varchar(300),  -- bản khi ẩn nội dung màn hình khoá
  category    varchar(20) NOT NULL,            -- MEMORY | MISSION | US | CONFLICT | APPRECIATION | MILESTONE | RECAP | CIRCLE | BILLING | SYSTEM | MARKETING
  priority    varchar(10) NOT NULL DEFAULT 'NORMAL',  -- NORMAL | HIGH (không tính vào trần 3/ngày)
  enabled     boolean NOT NULL DEFAULT true,
  PRIMARY KEY (code, locale)
);
```

#### 7.2.10 Billing

```sql
CREATE TABLE billing.products (
  product_id   varchar(60) PRIMARY KEY,       -- bf_house_yearly, bf_family_yearly
  store        billing.store NOT NULL,
  plan         billing.plan NOT NULL,
  period       varchar(10) NOT NULL,          -- P1Y | P1M
  active       boolean NOT NULL DEFAULT true
);

CREATE TABLE billing.plan_quotas (
  tier     billing.quota_tier PRIMARY KEY,
  quotas   jsonb NOT NULL
  -- TRIAL:  {"storageBytes":10737418240,"photosPerMemory":30,"videoMaxSec":180,"videoMaxHeight":1080,
  --          "audioMaxSec":300,"circleMax":0,"aiPerMonth":30,"keepOriginal":false,"careStats":true,"trialDays":7}
  -- HOUSE:  {"storageBytes":53687091200,"memoryCount":null,"photosPerMemory":30,"videoMaxSec":180,"videoMaxHeight":1080,
  --          "audioMaxSec":300,"albums":null,"letters":null,"series":null,"circleMax":0,"aiPerMonth":100,"keepOriginal":false,"careStats":true}
  -- FAMILY: {"storageBytes":214748364800,..., "photosPerMemory":50,"videoMaxSec":600,"audioMaxSec":600,"circleMax":12,"aiPerMonth":300,"keepOriginal":true}
);

CREATE TABLE billing.subscriptions (
  id                       uuid PRIMARY KEY,
  family_id                uuid REFERENCES app.families(id),      -- null khi đã tách khỏi family
  payer_user_id            uuid NOT NULL REFERENCES app.users(id),
  store                    billing.store NOT NULL,
  product_id               varchar(60) NOT NULL REFERENCES billing.products(product_id),
  plan                     billing.plan NOT NULL,
  original_transaction_id  varchar(100),       -- Apple
  purchase_token           text,               -- Google (token mới nhất)
  linked_purchase_token    text,               -- Google (token cũ khi upgrade/downgrade)
  app_account_token        uuid,               -- Apple appAccountToken = users.id ; Google obfuscatedAccountId = hash(users.id)
  status                   billing.sub_status NOT NULL,
  auto_renew               boolean NOT NULL DEFAULT true,
  in_trial                 boolean NOT NULL DEFAULT false,
  current_period_start     timestamptz,
  current_period_end       timestamptz,
  grace_until              timestamptz,
  environment              varchar(12) NOT NULL,   -- PRODUCTION | SANDBOX
  last_verified_at         timestamptz,
  superseded_by            uuid,
  created_at               timestamptz NOT NULL DEFAULT now(),
  updated_at               timestamptz NOT NULL DEFAULT now()
);
CREATE UNIQUE INDEX uq_sub_apple  ON billing.subscriptions(original_transaction_id) WHERE store = 'APPLE';
CREATE UNIQUE INDEX uq_sub_google ON billing.subscriptions(md5(purchase_token))    WHERE store = 'GOOGLE';
CREATE INDEX ON billing.subscriptions(family_id, status);

CREATE TABLE billing.store_notifications (
  id                uuid PRIMARY KEY,
  store             billing.store NOT NULL,
  notification_id   varchar(120) NOT NULL,     -- Apple notificationUUID / Pub/Sub messageId
  type              varchar(60), subtype varchar(60),
  payload_hash      bytea NOT NULL,
  received_at       timestamptz NOT NULL DEFAULT now(),
  processed_at      timestamptz,
  error             text,
  UNIQUE (store, notification_id)
);

CREATE TABLE billing.family_entitlements (
  family_id               uuid PRIMARY KEY REFERENCES app.families(id),
  access_state            billing.access_state NOT NULL DEFAULT 'INCOMPLETE',
  plan                    billing.plan,                         -- gói trả phí đang hiệu lực (null khi TRIAL/EXPIRED)
  trial_started_at        timestamptz,
  trial_ends_at           timestamptz,
  source_subscription_id  uuid,
  valid_until             timestamptz,
  in_grace                boolean NOT NULL DEFAULT false,
  updated_at              timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE billing.trial_consumptions (           -- chống lạm dụng dùng thử (BR-054)
  user_id        uuid NOT NULL REFERENCES app.users(id),
  identity_hash  bytea NOT NULL,                     -- HMAC(pepper, provider:provider_uid)
  family_id      uuid NOT NULL REFERENCES app.families(id),
  started_at     timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, identity_hash)
);
CREATE INDEX ON billing.trial_consumptions(identity_hash);

CREATE TABLE billing.family_usage (
  family_id          uuid PRIMARY KEY REFERENCES app.families(id),
  storage_bytes      bigint NOT NULL DEFAULT 0,
  memory_count       int NOT NULL DEFAULT 0,
  album_count        int NOT NULL DEFAULT 0,
  active_series      int NOT NULL DEFAULT 0,
  letter_count       int NOT NULL DEFAULT 0,
  updated_at         timestamptz NOT NULL DEFAULT now()
);
```

#### 7.2.11 Trust & Safety, Lifecycle, Ops

```sql
CREATE TABLE app.reports (
  id                 uuid PRIMARY KEY,
  reporter_user_id   uuid NOT NULL REFERENCES app.users(id),
  family_id          uuid REFERENCES app.families(id),
  target_type        app.report_target NOT NULL,
  target_id          uuid NOT NULL,
  target_owner_id    uuid,
  reason             app.report_reason NOT NULL,
  detail             varchar(1000),
  severity           smallint NOT NULL DEFAULT 2,     -- 1 = cao nhất (CHILD_SAFETY)
  status             app.report_status NOT NULL DEFAULT 'NEW',
  auto_hidden        boolean NOT NULL DEFAULT false,
  hide_for_reporter  boolean NOT NULL DEFAULT false,
  sla_due_at         timestamptz NOT NULL,
  created_at         timestamptz NOT NULL DEFAULT now(),
  closed_at          timestamptz
);
CREATE INDEX ON app.reports(status, severity, created_at);

CREATE TABLE app.report_hides (                -- “Ẩn với tôi”
  user_id uuid NOT NULL, target_type app.report_target NOT NULL, target_id uuid NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(), PRIMARY KEY (user_id, target_type, target_id)
);

CREATE TABLE ops.moderation_cases (
  id               uuid PRIMARY KEY,
  report_ids       uuid[] NOT NULL,
  target_type      app.report_target NOT NULL, target_id uuid NOT NULL,
  priority         smallint NOT NULL,
  status           varchar(15) NOT NULL DEFAULT 'OPEN',   -- OPEN | IN_REVIEW | RESOLVED
  assignee_admin_id uuid,
  sla_due_at       timestamptz NOT NULL,
  created_at       timestamptz NOT NULL DEFAULT now(),
  resolved_at      timestamptz
);
CREATE TABLE ops.moderation_actions (
  id          uuid PRIMARY KEY,
  case_id     uuid NOT NULL REFERENCES ops.moderation_cases(id),
  admin_id    uuid NOT NULL,
  action      varchar(30) NOT NULL,      -- NO_ACTION | REMOVE_CONTENT | WARN | SUSPEND | REMOVE_MEMBER | BAN | ESCALATE_LEGAL
  reason_note varchar(1000) NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE app.deletion_requests (
  id                  uuid PRIMARY KEY,
  user_id             uuid NOT NULL REFERENCES app.users(id),
  source              varchar(10) NOT NULL,           -- APP | WEB | ADMIN
  family_choice       varchar(20) NOT NULL,           -- NONE | DELETE_FAMILY | PARTNER_CONTINUES
  shared_content_choice varchar(20) NOT NULL,         -- KEEP_ANONYMIZED | DELETE
  status              varchar(12) NOT NULL DEFAULT 'SCHEDULED',  -- SCHEDULED | CANCELLED | RUNNING | COMPLETED | FAILED
  requested_at        timestamptz NOT NULL DEFAULT now(),
  execute_after       timestamptz NOT NULL,           -- +30 ngày
  completed_at        timestamptz,
  steps               jsonb NOT NULL DEFAULT '{}'     -- tiến độ từng bước (idempotent resume)
);
CREATE UNIQUE INDEX uq_deletion_active ON app.deletion_requests(user_id) WHERE status IN ('SCHEDULED','RUNNING');

CREATE TABLE app.export_jobs (
  id            uuid PRIMARY KEY,
  requester_id  uuid NOT NULL REFERENCES app.users(id),
  family_id     uuid,
  scope         varchar(10) NOT NULL,        -- FAMILY | PERSONAL
  status        varchar(12) NOT NULL DEFAULT 'QUEUED',
  storage_key   text, size_bytes bigint,
  expires_at    timestamptz,
  created_at    timestamptz NOT NULL DEFAULT now(),
  completed_at  timestamptz
);

CREATE TABLE ops.outbox_events (
  id             bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  event_type     varchar(60) NOT NULL,
  aggregate_id   uuid,
  family_id      uuid,
  payload        jsonb NOT NULL,
  created_at     timestamptz NOT NULL DEFAULT now(),
  published_at   timestamptz,
  attempts       int NOT NULL DEFAULT 0
);
CREATE INDEX ix_outbox_unpublished ON ops.outbox_events(id) WHERE published_at IS NULL;

CREATE TABLE ops.sync_tombstones (            -- phục vụ delta sync xoá/thu hồi
  id           bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  family_id    uuid NOT NULL,
  entity_type  varchar(20) NOT NULL,          -- MEMORY | CHILD | MISSION | COMMENT | ...
  entity_id    uuid NOT NULL,
  audience     varchar(10) NOT NULL DEFAULT 'ALL',  -- ALL | CIRCLE (thu hồi riêng với người thân)
  created_at   timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX ON ops.sync_tombstones(family_id, id);

CREATE TABLE ops.app_config (
  key         varchar(60) PRIMARY KEY,         -- hearts.rules, hearts.dailyCap, tree.levels, mission.board, request.limits, prompts.maxNextPerDay, monthlyPhoto.remindAt, notif.dailyCap, invite.ttl, minAppVersion.ios ...
  value       jsonb NOT NULL,
  updated_by  uuid, updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE ops.content_items (               -- moods, needs, câu mẫu, prompts, nguồn hỗ trợ an toàn, nội dung tuần thai
  type        varchar(30) NOT NULL,            -- MOOD | NEED | NEED_TEMPLATE | REQUEST_TEMPLATE | HARSH_WORD | MONTH_STICKER | PREG_SIZE | DIARY_PROMPT | THANKS_PROMPT | CONNECTION_PROMPT | SAFETY_RESOURCE | PREG_WEEK
  code        varchar(40) NOT NULL,
  locale      varchar(10) NOT NULL,
  data        jsonb NOT NULL,
  sort_order  int NOT NULL DEFAULT 0,
  status      varchar(10) NOT NULL DEFAULT 'ACTIVE',
  version     int NOT NULL DEFAULT 1,
  PRIMARY KEY (type, code, locale)
);

CREATE TABLE ops.admin_users (
  id uuid PRIMARY KEY, email citext UNIQUE NOT NULL, password_hash text NOT NULL,
  totp_secret_enc bytea NOT NULL, roles text[] NOT NULL, status varchar(10) NOT NULL DEFAULT 'ACTIVE',
  last_login_at timestamptz, created_at timestamptz NOT NULL DEFAULT now()
);
```

### 7.3 Truy vấn quan trọng

**Timeline một bé (Parent), cursor pagination:**
```sql
SELECT m.*
FROM app.memories m
JOIN app.memory_children mc ON mc.memory_id = m.id AND mc.child_id = :childId
WHERE m.family_id = :familyId
  AND <điều kiện quyền Parent ở 6.3>
  AND (m.occurred_at, m.id) < (:cursorAt, :cursorId)
ORDER BY m.occurred_at DESC, m.id DESC
LIMIT 30;
```
Ký ức thai kỳ trong timeline của bé: sau birth conversion, worker **chèn `memory_children`** cho mọi ký ức có `pregnancy_id = child.pregnancy_id` (giữ `pregnancy_id`) → query timeline bé không cần nhánh đặc biệt.

**Family timeline (loại trùng tự nhiên):** query trên `memories` theo `family_id` — mỗi ký ức là 1 dòng nên không trùng; `children[]` lấy bằng 1 query phụ `WHERE memory_id = ANY(:ids)`.

**Sibling moments:** `HAVING count(mc.child_id) >= 2`.

**On this day:** `extract(month/day FROM occurred_local_date) = :m/:d AND occurred_local_date < :today` (+ điều kiện quyền).

**Kiểm tra quota trước upload** (trong transaction, khoá dòng usage):
```sql
SELECT storage_bytes FROM billing.family_usage WHERE family_id = :f FOR UPDATE;
-- storage_bytes + declared_size <= quota.storageBytes ? cho phép : 402 QUOTA_STORAGE_EXCEEDED
```
`storage_bytes` cộng **dự phòng** khi tạo upload intent (`declared_size`), hiệu chỉnh khi READY (kích thước thực gồm variants), trừ khi asset bị purge.

### 7.4 Migration & dữ liệu ban đầu (seed)

- **Vị trí:** `baby-backend/prisma/schema.prisma`, `prisma/migrations/` và `prisma/seed.ts`. `baby-database/` chỉ có server/Compose, host data, backups và scripts vận hành; không giữ schema/migration hoặc init seed.
- **Migration chỉ DDL:** tạo/thay cấu trúc, constraints/indexes/functions/triggers. Không chứa thao tác CRUD/DML, seed, import hoặc backfill dữ liệu. Áp dụng migration đã commit bằng `npm run db:migrate:deploy`; không gộp seed vào command, Compose migrate job hoặc startup API.
- **Catalog seed chạy riêng:** `npm run db:seed` từ backend, dùng [prisma/seed.ts](../baby-backend/prisma/seed.ts) đọc [catalog.json](../baby-backend/prisma/seeds/catalog.json), kiểm tra đích `DATABASE_URL` trước khi chạy. Seed hiện có billing plans/plan_versions/trial_policies, quota/features và default-trial config; trial mặc định604800 giây. Version đã được cấp không sửa hồi tố. Không xác nhận catalog đã có trong DB ứng dụng khi mới tạo script.
- **Nội dung cần bổ sung khi triển khai:** Store product mappings đã xác minh, milestone catalog VN, mission templates (≥ 90 ngày nội dung/giai đoạn; Hearts1–10 và role_fit), memory prompts, stickers, badges, vi/en notification templates và app config khác. Đây là backlog nội dung, không phải tất cả đã nằm trong seed hiện tại; dữ liệu riêng từng family tạo qua service khi kích hoạt.
- Chiến lược schema: **expand → contract** qua release tương thích; không DROP cột cùng release với code mới. Nếu cần chuyển dữ liệu giữa hai bước, dùng command/backfill riêng có checkpoint, review và kiểm chứng; không viết DML vào migration.

---
## 8. MongoDB

Replica set 3 node (bắt buộc cho production — cần cho TTL ổn định, failover và transactions nếu dùng). Database `bf_logs`.

| Collection | Mục đích | Trường chính | Index | Lưu giữ |
|---|---|---|---|---|
| `notifications` | Hộp thông báo trong app (NOTI-01) | `_id`, `userId`, `familyId`, `tab` (`US`/`FAMILY`), `category`, `templateCode`, `params` (đã render an toàn), `title`, `body`, `deepLink`, `entity` {type,id}, `childIds`, `groupKey`, `count` (gộp), `readAt`, `createdAt` | `{userId:1, createdAt:-1}`, `{userId:1, readAt:1}`, `{groupKey:1}` , TTL `createdAt` | 90 ngày |
| `audit_logs` | Thao tác admin, thay đổi quyền, xoá, đăng nhập bất thường | `actorType` (USER/ADMIN/SYSTEM), `actorId`, `action`, `resource` {type,id}, `familyId`, `reason`, `ip`, `ua`, `metadata` (đã redact), `at` | `{resource.id:1, at:-1}`, `{actorId:1, at:-1}`, TTL | 2 năm |
| `security_events` | Refresh reuse, OTP brute force, rate-limit vượt ngưỡng | `type`, `userId`, `ip`, `details`, `at` | `{userId:1, at:-1}`, TTL | 1 năm |
| `app_events` | Analytics thô (privacy-first, mục 27.3) | `event`, `userIdPseudo`, `familyIdPseudo`, `props`, `platform`, `appVersion`, `at` | `{event:1, at:-1}`, TTL | 13 tháng |
| `ai_logs` | Metadata request AI — **không nội dung** | `feature`, `familyIdPseudo`, `provider`, `model`, `promptVersion`, `inputTokens`, `outputTokens`, `latencyMs`, `stopReason`, `safetyFlag`, `userAction`, `at` | `{feature:1, at:-1}`, TTL | 90 ngày |
| `push_logs` | Kết quả gửi FCM | `userId`, `deviceId`, `templateCode`, `fcmMessageId`, `result`, `errorCode`, `at` | `{userId:1, at:-1}`, TTL | 30 ngày |
| `client_errors` | Lỗi non-crash từ app (bổ sung Sentry) | `code`, `screen`, `appVersion`, `platform`, `at` | TTL | 30 ngày |

**Quy tắc:** không ghi nội dung ký ức, chú thích, tin nhắn Papa & Mama, số điện thoại đầy đủ, tên bé vào Mongo. Thông báo trong inbox lưu `title/body` đã render — với thông báo nhạy cảm chỉ lưu bản **trung tính** (“Mẹ vừa chia sẻ trạng thái”), nội dung thật tải từ API khi mở.

Ghi vào Mongo luôn **bất đồng bộ** (qua queue hoặc fire-and-forget có retry) — Mongo chậm/hỏng không được làm hỏng request nghiệp vụ.

---

## 9. Redis

| Key / Queue | Kiểu | TTL | Mục đích |
|---|---|---|---|
| `ac:{userId}:{familyId}` | string (JSON) | 300s | Cache AccessContext |
| `acv:{familyId}` | string | — | access_version hiện tại |
| `sess:deny:{sid}` | string | 15 phút | Session đã revoke |
| `otp:{phoneHash}` | hash | 300s | Mã OTP (hash) + attempts |
| `otp:send:{phoneHash}`, `otp:ip:{ip}` | counter | 1h | Giới hạn gửi |
| `rl:{route}:{userId|ip}` | sorted set | theo cửa sổ | Rate limit sliding window |
| `idem:{userId}:{key}` | string | 24h | Idempotency |
| `lock:{name}` | string (Redlock đơn node) | ngắn | Khoá phân tán (scheduler leader, birth conversion, entitlement recompute) |
| `quota:day:{familyId}:{yyyymmdd}:{metric}` | counter | 48h | Trần ngày **không phải Hearts** (vd. số lời cảm ơn gửi/ngày). Trần Hearts nằm ở `app.heart_daily_counters` (PG, cùng transaction) |
| `swap:opt:{missionId}:{userId}` | string (JSON) | 10 phút | 3 lựa chọn Đổi nhiệm vụ đã phát (CARE-05) — `POST /swap` chỉ nhận template trong tập này |
| `quiet:user:{userId}` | string | theo khung (mặc định 60 phút) | Khung “Cần yên tĩnh” sau khi lời nhờ NEED QUIET được xác nhận — giữ push không gấp |
| `notif:cap:{userId}:{yyyymmdd}` | counter | 48h | Trần 3 push không gấp/ngày |
| `notif:grp:{userId}:{groupKey}` | hash | 30 phút | Buffer gộp reaction/comment |
| `home:{familyId}:{userId}:{subject}` | string (JSON) | 30s | Cache aggregate Trang chủ (11.9), xoá khi có sự kiện của family |
| `persp:suggest:{userId}:{yyyymmdd}` | string | 48h | Gợi ý “Kể thêm góc nhìn” ≤ 1/ngày |
| `presence:{userId}` | string | 60s | Online (Socket.IO) — giảm push khi đang mở app |
| `bull:*` | BullMQ | — | Hàng đợi |

**Queues BullMQ** (mỗi queue có concurrency, retry, backoff riêng):

| Queue | Job | Retry |
|---|---|---|
| `outbox` | publish sự kiện | vô hạn có backoff |
| `media` | `process-image`, `process-video`, `process-audio`, `render-collage`, `purge-asset` | 5, exponential |
| `notify` | `resolve-and-dispatch`, `group-flush`, `digest-circle` | 5 |
| `push` | `send-fcm` | 3 (bỏ token khi `UNREGISTERED`) |
| `mission` | `generate-board`, `materialize-series`, `expire`, `reminder`, `evening-carry-over`, `request-expire`, `request-reminder` | 3 |
| `billing` | `verify-apple`, `verify-google`, `ack-google`, `apply-notification`, `recompute-entitlement`, `reconcile` | 8 |
| `ai` | `run-feature` (nếu chạy bất đồng bộ) | 2 |
| `recap` | `weekly`, `month-age`, `daily-suggest`, `monthly-photo-reminder`, `memory-prompt-pick` | 3 |
| `lifecycle` | `delete-account`, `delete-family`, `purge-trash`, `purge-orphans`, `purge-conflicts`, `export` | 10, resume theo `steps` |
| `search` | `reindex-memory` | 3 |

---

## 10. Media pipeline & MinIO

### 10.1 Bucket & key

| Bucket | Nội dung | Policy |
|---|---|---|
| `bf-media` | Ảnh/video/âm thanh của gia đình | **Private**, chặn mọi public ACL; versioning BẬT; lifecycle: xoá noncurrent version sau 30 ngày; abort multipart chưa hoàn tất sau 1 ngày |
| `bf-exports` | ZIP xuất dữ liệu | Private, lifecycle xoá sau 7 ngày |
| `bf-public` | Ảnh minh hoạ, sticker, ảnh bìa mặc định (không phải dữ liệu người dùng) | Public read qua CDN |

Key (không chứa tên/email/tên bé):
```
fam/{familyId}/a/{assetId}/orig            # bản gốc (hoặc bản HQ đã strip metadata)
fam/{familyId}/a/{assetId}/t320.webp       # thumbnail lưới
fam/{familyId}/a/{assetId}/m1080.webp      # xem trong feed
fam/{familyId}/a/{assetId}/l2048.jpg       # toàn màn hình
fam/{familyId}/a/{assetId}/v720.mp4 | v1080.mp4 | poster.jpg   # video
fam/{familyId}/a/{assetId}/a.m4a           # âm thanh
usr/{userId}/j/{assetId}/...               # ảnh nhật ký riêng (Papa & Mama) — tách prefix theo user
```

### 10.2 Luồng upload

```
Flutter                                 API                                     MinIO            Worker
  │ 1. chọn ảnh → (HEIC→JPEG) → tính sha256, kích thước, w/h, duration
  │ POST /v1/media/upload-intents  ─────►│ kiểm tra: quyền tạo ký ức, mime cho phép,
  │  {familyId, kind, mime, size,         │ kích thước/thời lượng theo gói, quota dung lượng,
  │   sha256, width, height, durationMs,  │ dedup (family_id, sha256) → nếu trùng trả existingAssetId
  │   purpose}                            │ tạo asset PENDING_UPLOAD, giữ chỗ quota
  │◄──────────── {assetId, upload: {mode:"single", url, headers, expiresAt}}   (≤ 20MB)
  │             hoặc {mode:"multipart", uploadId, partSize: 8MB, parts:[{n,url}]}  (> 20MB)
  │ 2. PUT trực tiếp ─────────────────────────────────────────────────────────►│
  │    (background upload, resume được theo part)                              │
  │ 3. POST /v1/media/{id}/complete {parts:[{n,etag}]} ─►│ CompleteMultipart/HEAD object:
  │                                       │ size ≤ declared+5%, Content-Type khớp
  │                                       │ → status UPLOADED → enqueue media.process ───────────────►│
  │◄──────────── 202 {status:"PROCESSING"}                                                           │
  │ 4. POST /v1/memories {assetIds:[...]} (có thể gọi ngay, không chờ READY)                         │
  │    → memory.status = PROCESSING (chỉ tác giả thấy)                                               │
  │                                                                     5. worker: tải về tmp,
  │                                                                        magic bytes, giải mã,
  │                                                                        trích captured_at, strip,
  │                                                                        sinh variants, blurhash,
  │                                                                        upload variants, READY
  │                                                                     6. nếu mọi asset của memory READY
  │                                                                        → memory PUBLISHED / PENDING_REVIEW
  │                                                                        → outbox MemoryPublished → push
  │◄────── realtime `memory.updated` / lần sync kế tiếp
```

- Presigned PUT hết hạn 15 phút (part: 1 giờ); client xin lại URL qua `POST /v1/media/{id}/parts` nếu hết hạn khi đang resume.
- **Presigned PUT không giới hạn kích thước** → bắt buộc xác minh ở bước `complete` (HEAD) và xoá object nếu vượt.
- Asset `PENDING_UPLOAD`/`UPLOADED` quá 24h không gắn memory → job `purge-orphans` xoá object + hoàn quota.
- Backup trigger: bật **MinIO bucket notification** (webhook → `POST /internal/storage-events`, xác thực bằng token) để bắt trường hợp client upload xong nhưng mất mạng trước khi gọi `complete`; job `reconcile-uploads` mỗi 15 phút kiểm tra asset `PENDING_UPLOAD` đã có object.

### 10.3 Xử lý ảnh

| Bước | Công cụ | Chi tiết |
|---|---|---|
| Xác định định dạng | `file-type` (magic bytes) | Chỉ nhận JPEG, PNG, WebP, HEIC/HEIF (nếu worker build libvips có libheif+libde265 — mặc định **không**, client phải convert), GIF tĩnh |
| Chống “decompression bomb” | sharp `limitInputPixels` = 100MP | |
| Trích ngày chụp | `exifr` đọc `DateTimeOriginal` + `OffsetTimeOriginal` | Lưu `captured_at` để gợi ý ngày xảy ra |
| Xoay theo EXIF | sharp `.rotate()` | Trước khi strip |
| Biến thể | sharp | `t320.webp` (q70, cạnh dài 320), `m1080.webp` (q80), `l2048.jpg` (q85, progressive) — mọi biến thể **không có metadata** |
| Bản gốc | Gói FAMILY: `exiftool -gps:all= -xmp:geotag= -overwrite_original` (giữ nguyên pixel) • Gói khác: thay bản gốc bằng bản re-encode cạnh dài 3072 q90 không metadata, xoá raw | Gói đổi sau này không “khôi phục” được gốc cũ — ghi rõ trong FAQ |
| Placeholder | `blurhash` (4×3) | Hiển thị khi đang tải |
| Kiểm duyệt tự động [1.1] | Hash matching CSAM (đánh giá dịch vụ phù hợp, vd. PhotoDNA qua đối tác) | Chỉ khi có pháp lý & quy trình rõ — không tự phân tích ảnh bé bằng AI bên thứ 3 |

### 10.4 Xử lý video & âm thanh

```bash
ffprobe -v error -show_streams -show_format -of json in.mov                 # duration, codec, rotation
ffmpeg -i in.mov -map_metadata -1 -map 0:v:0 -map 0:a:0? \
  -c:v libx264 -preset veryfast -crf 23 -profile:v high -pix_fmt yuv420p \
  -vf "scale='if(gt(iw,ih),-2,min(1080,iw))':'if(gt(iw,ih),min(1080,ih),-2)'" \
  -c:a aac -b:a 128k -movflags +faststart v1080.mp4
ffmpeg -ss 1 -i v1080.mp4 -frames:v 1 -q:v 3 poster.jpg
ffmpeg -i in.m4a -map_metadata -1 -c:a aac -b:a 96k a.m4a                     # âm thanh
```
- Thời lượng vượt gói → `FAILED(DURATION_EXCEEDED)` (client đã chặn trước, đây là lớp phòng thủ).
- `-map_metadata -1` xoá atom vị trí (`©xyz`) của iPhone/Android.
- HLS adaptive streaming: phase 2.0 (khi video dài nhiều).
- Worker video chạy container riêng (CPU nặng), concurrency = số core/2.

### 10.5 Phát URL xem (signed GET)

- API trả ký ức kèm `media[]`: `{assetId, kind, w, h, durationMs, blurhash, urls:{t320, m1080, l2048|v720|v1080, poster}, urlsExpireAt}`.
- URL ký bằng S3 presign, **TTL 1 giờ**, chỉ ký sau khi `canViewMemory` = true. Batch ký: `POST /v1/media/urls {assetIds[]}` (tối đa 100) cho trường hợp URL hết hạn khi cuộn dài.
- Tải bản gốc: `POST /v1/memories/{id}/download-urls` (kiểm `canDownload`), presign có `response-content-disposition=attachment; filename="BabyFamily_2026-03-12_1.jpg"`, TTL 10 phút, ghi audit.
- Asset ảnh nhật ký riêng (`purpose=JOURNAL`) chỉ ký cho chủ sở hữu.

### 10.6 Cache & CDN

- **Client:** `cached_network_image` với `cacheKey = "${assetId}_${variant}"` → URL ký thay đổi không làm tải lại; cache trong thư mục cache của app (OS sandbox), giới hạn 1–2GB, xoá khi đăng xuất/bị gỡ khỏi gia đình.
- **MVP:** không edge cache; `media.babyfamily.vn` (Nginx) proxy tới MinIO, giữ nguyên query chữ ký để MinIO tự xác minh. **Không bật `proxy_cache` theo URI bỏ chữ ký** (sẽ cho phép truy cập không kiểm tra quyền).
- **Khi cần scale:** CDN hỗ trợ **token authentication** (ký HMAC + hết hạn, CDN tự xác minh token rồi mới trả cache; cache key bỏ token) đặt trước MinIO; API ký token CDN thay vì presign S3.

### 10.7 Xoá & tham chiếu

- Xoá memory → `memory_assets` cascade; job `purge-asset` chỉ xoá object khi `NOT EXISTS memory_assets WHERE asset_id=…` và asset không phải avatar/cover đang dùng.
- Thùng rác: memory `TRASHED` giữ asset; sau `purge_after` (30 ngày) → `PURGED` → purge asset → trừ `family_usage.storage_bytes`.
- Versioning bucket giữ bản noncurrent 30 ngày → ghi trong Chính sách quyền riêng tư: “dữ liệu đã xoá có thể tồn tại trong bản sao lưu tối đa 30 ngày (object) / 35 ngày (DB backup)”.

### 10.8 Lựa chọn object storage & rủi ro MinIO

| Phương án | Ưu | Nhược |
|---|---|---|
| MinIO tự host (distributed, erasure coding) | Như yêu cầu, quen thuộc | Tình trạng phát hành bản Community thay đổi từ 2025 (chỉ mã nguồn / bảo trì) → tự build image hoặc dùng bản thương mại; cần đội vận hành |
| SeaweedFS / Garage / Ceph RGW | Mã nguồn mở, S3 API | Cần thử nghiệm tương thích presign/multipart |
| S3-compatible của cloud VN (Viettel, FPT, VNG, CMC…) | Dữ liệu ở VN, không tự vận hành, có SLA | Chi phí theo GB, phụ thuộc nhà cung cấp |

**Quyết định kỹ thuật:** code dùng `@aws-sdk/client-s3` + `@aws-sdk/s3-request-presigner` với `forcePathStyle` cấu hình được; không dùng API riêng của MinIO (trừ admin/notification ở tầng hạ tầng). Đổi backend = đổi endpoint + credential.

**Ước tính dung lượng** (để lập kế hoạch, cần đo thực tế): 1 gia đình hoạt động ≈ 1.500 ảnh/năm × ~1,2MB (gốc+variants sau nén) + 60 video × 25MB ≈ **3,3 GB/năm**. 10.000 gia đình ≈ 33 TB/năm dữ liệu hữu dụng → MinIO EC:4+2 ≈ 50 TB raw. Đây là chi phí lớn nhất của hệ thống → quota gói và nén là bắt buộc.

### 10.9 Ảnh tháng: sticker, khung hướng dẫn & collage

- **Sticker tháng là lớp hiển thị**, không burn vào ảnh: lưu JSON ở `monthly_photos.sticker` (mẫu, nhãn đã dịch theo locale người chụp, vị trí/tỉ lệ); client vẽ chồng khi hiển thị; bản gốc & biến thể ảnh **không bị sửa** (MEM-21). Mẫu sticker: `ops.content_items type=MONTH_STICKER` (SVG/PNG ở bucket tĩnh, nhãn i18n, ETag).
- **Khung hướng dẫn** (bóng mờ ảnh tháng trước): client tải biến thể `m1080` của ảnh tháng liền trước qua `/children/{id}/monthly-photos`; không xử lý phía server.
- **Collage 4/9/12 ô** (MEM-20): `POST /children/{id}/monthly-photos/collage` → job `media.render-collage`: sharp composite từ biến thể `l2048`, nền màu bé, nhãn tuổi + (tuỳ chọn) sticker và tiêu đề vẽ bằng `@napi-rs/canvas`/`satori` với font đóng gói (Nunito, Be Vietnam Pro); output JPEG q90 **không metadata** tại `fam/{fid}/x/{exportId}.jpg`, URL presign 24h, tự xoá sau 7 ngày, không tính quota lưu trữ. Chỉ Parent; chỉ lưu thành ký ức khi người dùng chọn “Lưu vào ký ức”.
- **So sánh 2 tháng / 2–4 tuần bụng bầu**: thuần client.
- **Video tua nhanh** [1.1]: ffmpeg ghép ảnh tháng (crossfade, 1 giây/ảnh) trong cùng queue `media`.

---

## 11. API contract

### 11.1 Quy ước chung

| Mục | Quy ước |
|---|---|
| Base URL | `https://api.babyfamily.vn/v1` (staging: `api-staging…`) |
| Định dạng | JSON UTF-8, `camelCase`, thời gian ISO-8601 UTC (`2026-10-06T12:30:00Z`), ngày `YYYY-MM-DD` (theo timezone family) |
| Envelope thành công | `{ "data": <payload> }`; danh sách: `{ "data": [...], "nextCursor": "…" }` (ví dụ ở 11.4–11.6 là nội dung bên trong `data`) |
| Headers gửi lên | `Authorization: Bearer <access>`, `Accept-Language: vi`, `X-App-Version: 1.0.0+12`, `X-Platform: ios|android`, `X-Timezone: Asia/Ho_Chi_Minh`, `X-Request-Id`, `Idempotency-Key` (POST thay đổi trạng thái), `If-Match: <version>` (PATCH) |
| Phân trang | Cursor: `?cursor=<opaque>&limit=30` → `{ items, nextCursor }` (cursor = base64url của `(sortKey,id)`) |
| Scope gia đình | Đường dẫn chứa `familyId` cho truy vấn danh sách; resource đơn lẻ (`/memories/{id}`) tự suy ra family và kiểm tra quyền |
| Không tồn tại / không có quyền | Resource của family người dùng không thuộc → **404** (không phân biệt để tránh dò); có thuộc family nhưng thiếu quyền → **403** + code |
| Phiên bản | Breaking change → `/v2`; thêm trường không breaking; client bỏ qua trường lạ |
| Min app version | `GET /v1/app-config` trả `minVersion`; API có thể trả `426 UPGRADE_REQUIRED` |

### 11.2 Định dạng lỗi

```json
{
  "error": {
    "code": "REQUEST_RESEND_BLOCKED",
    "messageKey": "errors.request.resendBlocked",
    "message": "Bạn có thể gửi lại lời nhờ này sau 12 giờ.",
    "details": { "retryAfter": "2026-10-07T00:30:00Z" },
    "fieldErrors": [{ "field": "childIds", "code": "REQUIRED" }],
    "traceId": "01J9X…"
  }
}
```

| HTTP | Khi nào | Ví dụ code |
|---|---|---|
| 400 | Request sai định dạng | `VALIDATION_FAILED` |
| 401 | Token sai/hết hạn | `AUTH_TOKEN_EXPIRED`, `AUTH_SESSION_REVOKED` |
| 402 | Vượt quota / cần gói / hết dùng thử | `SUBSCRIPTION_REQUIRED` (EXPIRED), `QUOTA_STORAGE_EXCEEDED`, `PLAN_REQUIRED_FAMILY`, `AI_QUOTA_EXCEEDED` |
| 403 | Thiếu quyền | `FAMILY_NOT_ACTIVE` (chưa đủ Bố + Mẹ), `ROLE_NOT_SELECTED`, `NOT_PARENT`, `CHILD_ACCESS_DENIED`, `FAMILY_SHARING_PAUSED`, `COUPLE_NOT_LINKED`, `MISSION_NOT_OWNER` (thao tác trên nhiệm vụ của bạn đời), `REQUEST_NOT_PARTICIPANT` |
| 404 | Không có/không thấy | `NOT_FOUND` |
| 409 | Xung đột trạng thái | `ALREADY_PARENT_OF_ANOTHER_FAMILY`, `PARENT_SLOTS_FULL`, `MISSION_ALREADY_COMPLETED`, `INVALID_MISSION_TRANSITION`, `MISSION_UNDO_WINDOW_CLOSED`, `INVALID_REQUEST_TRANSITION`, `REQUEST_REMINDER_USED`, `PERSPECTIVE_EXISTS`, `IDEMPOTENCY_KEY_REUSED`, `INVITE_ALREADY_USED` |
| 410 | Hết hạn | `INVITE_EXPIRED` (client hiển thị chung INV-02) |
| 412 | Sai version | `VERSION_CONFLICT` |
| 422 | Vi phạm nghiệp vụ | `CHILD_NOT_IN_FAMILY`, `MISSION_SCOPE_MISMATCH`, `MISSION_OWNER_INVALID` (chủ là bạn đời — BR-020), `MISSION_SWAP_LIMIT` (> 3 lần/ngày), `MISSION_SWAP_NOT_ALLOWED` (không phải SYSTEM / lựa chọn không hợp lệ), `MISSION_LATE_WINDOW_CLOSED` (quá hết ngày D+1), `CIRCLE_LIMIT_REACHED`, `REQUEST_OPEN_LIMIT` (5 lời nhờ đang mở), `REQUEST_RESEND_BLOCKED` (12 giờ sau khi bị từ chối, `details.retryAfter`), `REQUEST_DUE_INVALID` (hẹn ở quá khứ hoặc > 7 ngày), `PERSPECTIVE_NOT_ALLOWED`, `MEMORY_KIND_NOT_ALLOWED`, `MONTH_INDEX_MISMATCH` |
| 426 | App quá cũ | `UPGRADE_REQUIRED` |
| 429 | Rate limit | `RATE_LIMITED` + `Retry-After` |
| 5xx | Lỗi hệ thống | `INTERNAL` |

### 11.3 Danh mục endpoint

#### Auth & Me
| Method | Path | Mô tả | Màn |
|---|---|---|---|
| POST | `/auth/apple` | `{identityToken, authorizationCode, nonce, fullName?, device}` → tokens | AUTH-01 |
| POST | `/auth/google` | `{idToken, device}` | AUTH-01 |
| POST | `/auth/phone/otp` | Gửi OTP | AUTH-02 |
| POST | `/auth/phone/verify` | Xác minh OTP → tokens | AUTH-03 |
| POST | `/auth/refresh` | `{refreshToken}` → rotate | — |
| POST | `/auth/logout` | revoke session hiện tại | SET-01 |
| POST | `/auth/reauth` | xác thực lại (Apple/Google/OTP) → reauthToken | SET-09, US-15 |
| GET | `/me` | Hồ sơ + danh sách gia đình (role mỗi family) + trạng thái onboarding | SPL-01 |
| PATCH | `/me` | tên, avatar, locale, timezone | AUTH-04, SET-02 |
| GET/PATCH | `/me/settings` | cài đặt cá nhân | SET-03..06 |
| POST | `/me/consents` | ghi nhận đồng ý | AUTH-04, AI |
| GET | `/me/sessions` · DELETE `/me/sessions/{id}` · POST `/me/sessions/revoke-all` | thiết bị | SET-07 |
| POST | `/me/devices` | đăng ký/cập nhật push token | ONB-10 |
| POST/DELETE | `/me/identities/{provider}` | liên kết/huỷ phương thức đăng nhập | SET-02 |

#### Family, Invite, Circle
| Method | Path | Mô tả | Màn |
|---|---|---|---|
| PUT | `/me/onboarding-role` | `{role: PARENT_FATHER|PARENT_MOTHER|CIRCLE}` (đổi được khi chưa là thành viên gia đình nào) | ONB-03 |
| POST | `/families` | Tạo gia đình `{name, parent:{kind, callName}}` (`callName` bỏ trống → mặc định `Papa`/`Mama` theo `kind`) → status `WAITING_PARTNER` (**không** nhận children/pregnancies — BR-052) | ONB-06 |
| POST | `/families/{fid}/cancel` | Huỷ gia đình đang chờ (rỗng) | ONB-WAIT |
| POST | `/families/{fid}/children` · `/pregnancies` | chỉ khi ACTIVE (dùng cho thiết lập ONB-04/05 và về sau) | ONB-05, CHD-04 |
| GET | `/families/{fid}/bootstrap` | **Payload khởi động**: family, parents, coupleSpace, subjects (bé+thai kỳ theo quyền), my role/grants, entitlement+quota usage, settings, unread counts | SPL-01, HOME |
| PATCH | `/families/{fid}` · PATCH `/families/{fid}/settings` | sửa tên/cover/cài đặt | FAM-01, FAM-07 |
| DELETE | `/families/{fid}` | lên lịch xoá gia đình (reauth) | FAM-07 |
| POST | `/families/{fid}/invites/partner` | tạo lời mời bạn đời → `{inviteId, url, code, qrPayload, expiresAt}` | ONB-07, FAM-02 |
| POST | `/families/{fid}/invites/circle` | tạo lời mời người thân `{relation, displayName, grants[], allowDownload, message}` | FAM-03 |
| GET | `/families/{fid}/invites` · DELETE `/invites/{id}` | danh sách / thu hồi | FAM-05 |
| POST | `/invites/resolve` | `{token}` hoặc `{code}` → preview (không lộ dữ liệu ngoài preview) | INV-01, INV-05 |
| POST | `/invites/accept` | `{token|code, callName?}` → `{status: JOINED|AWAITING_APPROVAL, familyId}`; Partner invite: nếu người nhận đang có gia đình `WAITING_PARTNER` rỗng → tự huỷ gia đình đó; chấp nhận thành công → kích hoạt + bắt đầu trial (6.5) | INV-01 |
| POST | `/invites/decline` | | INV-01 |
| POST | `/invites/{id}/approve` · `/reject` | Parent A duyệt cuối | thông báo → sheet |
| GET | `/families/{fid}/circle` | danh sách người thân + grants | FAM-01 |
| GET/PATCH | `/circle-members/{id}` | `{displayName, relation, allowDownload, status: ACTIVE|PAUSED}` | FAM-04 |
| PUT | `/circle-members/{id}/grants` | thay toàn bộ `[{childId|pregnancyId, permission}]` | FAM-04 |
| POST | `/circle-members/{id}/remove` | `{contentAction: KEEP|REMOVE}` | FAM-06 |
| POST | `/families/{fid}/leave` | người thân rời | SET-10 |
| POST | `/families/{fid}/share-new-child` | `{childId, members:[{circleMemberId, permission}]}` | CHD-04 |

#### Bé & thai kỳ
| Method | Path | Mô tả | Màn |
|---|---|---|---|
| GET | `/families/{fid}/subjects` | bé + thai kỳ cho switcher (đã lọc quyền) | SW-01 |
| POST | `/families/{fid}/children` | thêm bé (cảnh báo trùng `409 POSSIBLE_DUPLICATE` nếu không có `force:true`) | CHD-04 |
| GET/PATCH | `/children/{id}` | hồ sơ (PATCH If-Match; gồm `monthlyPhotoMode`, `monthlyPhotoLunar`) | CHD-01/02 |
| POST | `/children/{id}/archive` · `/restore` · DELETE `/children/{id}` | | CHD-05 |
| GET | `/children/{id}/milestones` | bảng “Những lần đầu” | MEM-12 |
| POST | `/families/{fid}/pregnancies` | thêm thai kỳ | ONB-05a, CHD-04 |
| PATCH | `/pregnancies/{id}` | sửa (gồm `carrierUserId` — “Người mang thai”, `bumpPhotoCadence`) | PREG-01 |
| GET | `/pregnancies/{id}/milestones` | cột mốc thai kỳ đã có/chưa có (17.2) | PREG-01, HOME-03 |
| POST | `/pregnancies/{id}/birth` | **Idempotency-Key bắt buộc** `{babies:[{name,nickname,birthDate,birthTime,gender,avatarAssetId,birthStats}], announceToCircle}` → `{childIds}` | PREG-05 |
| POST | `/pregnancies/{id}/add-newborn` | thêm bé sinh cùng thai kỳ | 13.2 |
| POST | `/pregnancies/{id}/end` | `{mode: PAUSE|ENDED_PRIVATE, makeMemoriesParentsOnly}` | PREG-06 |
| GET/POST/PATCH | `/pregnancies/{id}/prep-items` | checklist | PREG-04 |

#### Media
| Method | Path | Mô tả |
|---|---|---|
| POST | `/media/upload-intents` | xem 10.2 |
| POST | `/media/{id}/parts` | xin lại URL part |
| POST | `/media/{id}/complete` | hoàn tất upload |
| GET | `/media/{id}` | trạng thái + urls |
| POST | `/media/urls` | ký lại hàng loạt |

#### Memories, Timeline, Album, Comment
| Method | Path | Mô tả | Màn |
|---|---|---|---|
| POST | `/memories` | tạo (xem 11.5) | MEM-05, CIR-04 |
| GET | `/memories/{id}` | chi tiết (đã shaping theo quyền) | MEM-07 |
| PATCH | `/memories/{id}` | sửa (If-Match) | MEM-09 |
| PUT | `/memories/{id}/children` | `{childIds[], familyMoment}` → trả `{affectedViewers: {lost: n, gained: n}}` khi `dryRun=true` để cảnh báo | MEM-07 |
| PATCH | `/memories/{id}/visibility` | `{visibility, dryRun?}` | MEM-07 |
| POST | `/memories/{id}/archive` · `/unarchive` | | MEM-07 |
| DELETE | `/memories/{id}` | vào thùng rác | MEM-07 |
| POST | `/memories/{id}/restore` · DELETE `/memories/{id}/purge` | | MEM-17 |
| POST | `/memories/{id}/review` | `{decision: APPROVE|REJECT, reason?, childIds?, visibility?}` | MEM-19 |
| POST | `/memories/{id}/download-urls` | URL tải gốc | MEM-08 |
| POST | `/memories/{id}/reshare` | chia sẻ lại (On this day) | MEM-16 |
| GET | `/families/{fid}/feed?childId&cursor` | bảng tin (sort `published_at`) | HOME-01, CIR-01 |
| GET | `/families/{fid}/timeline?childId|pregnancyId&filter&cursor` | timeline (sort `occurred_at`), kèm thẻ hệ thống (tròn tháng, chào đời…) được ghép ở server | MEM-01 |
| GET | `/families/{fid}/media-grid?childId&kind&cursor` | lưới ảnh | MEM-02 |
| GET | `/families/{fid}/pending-reviews` | chờ duyệt | MEM-19 |
| GET | `/families/{fid}/trash` · `/drafts` | | MEM-17/18 |
| GET | `/families/{fid}/on-this-day?date&childId` | | MEM-16 |
| GET | `/families/{fid}/search?q&childId&kind&authorId&year&cursor` | | MEM-15 |
| PUT/DELETE | `/memories/{id}/reaction` | `{type}` | MEM-07 |
| GET/POST | `/memories/{id}/comments` | | MEM-10 |
| PATCH/DELETE | `/comments/{id}` | | MEM-10 |
| PUT/DELETE | `/memories/{id}/favorite` | | MEM-07 |
| PUT/DELETE | `/children/{cid}/pins/{position}` | ghim | MEM-01 |
| GET/POST | `/families/{fid}/albums` · PATCH/DELETE `/albums/{id}` · POST/DELETE `/albums/{id}/memories` | | MEM-03 |
| GET | `/milestone-templates?locale` | catalog (cache dài, ETag) | MEM-11 |
| POST | `/milestones` · PATCH/DELETE `/milestones/{id}` | `{childId|pregnancyId, memoryId?, templateCode|customTitle, occurredOn}` | MEM-11 |
| GET | `/families/{fid}/home?subject=ALL|child:{id}|pregnancy:{id}` | **aggregate Trang chủ** (11.9): các khối đã sắp theo ngữ cảnh | HOME-01/02/03, CIR-01 |
| GET | `/families/{fid}/today-stories?date` | vòng “Hôm nay của …”: `[{subjectType, subjectId, coverUrl, count, unseen}]` — `unseen` theo người gọi | HOME-01, HOME-02 |
| GET | `/families/{fid}/today-stories/{subjectType}/{subjectId}?date` | ký ức hôm nay của bé/thai kỳ (đã lọc quyền) để trình chiếu | MEM-25 |
| POST | `/families/{fid}/today-stories/{subjectType}/{subjectId}/seen` | `{date, seenUntil}` → hết viền “chưa xem” (chỉ của người gọi, AC-028) | MEM-25 |
| GET | `/children/{id}/chapters?fromMonth&toMonth` | chương tháng: `[{monthIndex, from, to, cover (ảnh tháng|null), memoryCount, firstsCount, quotesCount}]` | MEM-01, HOME-02 |
| GET | `/children/{id}/monthly-photos?year` · `/pregnancies/{id}/bump-photos` | lưới ảnh tháng (12 ô/năm, ô trống = null, kèm `due` theo `monthly_photo_mode`) / ảnh bụng theo tuần | MEM-20, PREG-02, HOME-02/03 |
| PUT · DELETE | `/children/{id}/monthly-photos/{monthIndex}` · `/pregnancies/{id}/bump-photos/{week}` | `{memoryId, assetId, sticker?}` đặt/đổi ảnh chính (BR-072, Parent) — ký ức cũ giữ nguyên / bỏ ảnh chính | MEM-20, MEM-21 |
| POST | `/children/{id}/monthly-photos/collage` | `{monthIndexes (4|9|12), layout, withStickers, title}` → `{exportId}`; `GET /exports/{id}` lấy URL 24h (10.9) | MEM-20 |
| GET | `/content/MONTH_STICKER?locale` | mẫu sticker tháng (ETag) | MEM-21 |
| POST | `/memories/{id}/perspectives` | `{body?, assetIds[≤10], audioAssetId?}` — chỉ bạn đời của tác giả (6.7); +2 Hearts (chung trần “tạo ký ức”) | MEM-24 |
| PATCH · DELETE | `/perspectives/{id}` | tác giả góc nhìn: nội dung (If-Match) / xoá; tác giả ký ức gốc: chỉ `{hiddenFromCircle}` | MEM-07, MEM-24 |
| GET | `/families/{fid}/collections?childId|pregnancyId` | thẻ bộ sưu tập tự động + album: `[{code, title, coverUrl, count}]` (theo quyền người gọi) | MEM-22 |
| GET | `/families/{fid}/collections/{code}?childId&cursor` | `code ∈ MONTHLY | FIRSTS | QUOTES | VOICES | LETTERS | KEEPSAKES | TOLD_TOGETHER | SIBLINGS | VIDEOS | MY_FAVORITES | FAMILY_BEST | FROM_CIRCLE | PREGNANCY` (19.5) | MEM-22 |
| GET | `/families/{fid}/memory-prompts/today` | gợi ý hôm nay của người gọi `{deliveryId, text, targetKind, childId|pregnancyId}` hoặc `null` (tắt / đã bỏ qua) | HOME-01/02 |
| POST | `/memory-prompts/{deliveryId}/next` · `/dismiss` · `/used {memoryId}` | Gợi ý khác (≤ `prompts.maxNextPerDay`) / Bỏ qua (hết hôm nay) / đã dùng | HOME-01/02 |

#### Calendar
| GET | `/families/{fid}/calendar?from&to&childId` | nhiệm vụ (của bạn đời: `PartnerMissionDto`, không Hearts) + sự kiện + ngày đặc biệt (tròn tháng, sinh nhật, âm lịch); không chứa Lời nhờ | CARE-07 |
|---|---|---|---|
| POST · PATCH · DELETE | `/events`, `/events/{id}` | | CAL-02 |

#### Care
| Method | Path | Mô tả | Màn |
|---|---|---|---|
| GET | `/families/{fid}/missions/board?date&tab=MINE|PARTNER|TOGETHER&childId` | bảng nhiệm vụ ngày (11.6): `tree` (lá/tổng/nở hoa), `tabs` (số việc xong/tổng), `myHeartsToday` (chỉ của người gọi, chỉ khi `tab=MINE`), `swapsLeft`, `items[]`, `openRequestCount`; hôm nay chưa có bảng → bày ngay (15.3) | CARE-01, HOME |
| GET | `/families/{fid}/missions?from&to&owner=ME|PARTNER|TOGETHER&status&childId&category&cursor` | lịch sử/lịch; `owner=PARTNER` chỉ trả `DONE` dạng `PartnerMissionDto` | CARE-07/08 |
| POST | `/missions` | tự thêm (11.6): `owner: ME|TOGETHER` — chủ là bạn đời → `422 MISSION_OWNER_INVALID` | CARE-03 |
| GET | `/missions/{id}` | chi tiết + events; nhiệm vụ của bạn đời → `PartnerMissionDto` (không Hearts, không hành động) | CARE-02 |
| PATCH | `/missions/{id}?apply=THIS|FOLLOWING` | sửa giờ/nhắc/ghi chú/bé — nhiệm vụ tự thêm của mình hoặc Cùng nhau (SYSTEM: chỉ giờ/nhắc) | CARE-02 |
| POST | `/missions/{id}/complete` | **Idempotency-Key** `{note?, photo?: {assetIds, caption, childIds, visibility}}` → `{mission, myHeartsAwarded, memoryId, tree}`; nhiệm vụ `EXPIRED` của hôm qua → ghi muộn (`late`) | CARE-06 |
| POST | `/missions/{id}/undo` | hoàn tác ≤ 10 giây (server chấp nhận ≤ 30 giây) → bút toán ngược; quá hạn → `409 MISSION_UNDO_WINDOW_CLOSED` | CARE-06 |
| GET | `/missions/{id}/swap-options` | 3 lựa chọn cùng bé/giai đoạn, Hearts ±1 + `optionsToken`, `swapsLeft` (chỉ SYSTEM, chủ nhiệm vụ) | CARE-05 |
| POST | `/missions/{id}/swap` | `{templateId, optionsToken}` → `{removedId, mission}`; hết lượt → `422 MISSION_SWAP_LIMIT` | CARE-05 |
| POST | `/missions/{id}/remove` | Bỏ khỏi hôm nay (SYSTEM) / Xoá (tự thêm) → `REMOVED`, 0 Hearts, không báo bạn đời | CARE-02, CARE-05 |
| POST | `/missions/{id}/carry-over` | chuyển nhiệm vụ tự thêm `TODO` sang ngày mai (lời hỏi 21:00) | CARE-01 |
| GET | `/families/{fid}/mission-series` · PATCH `/mission-series/{id}` | chuỗi lặp của tôi + Cùng nhau; `{status: ACTIVE|PAUSED|ENDED, pausedRanges, ...}` (Tạm dừng chuỗi) | CARE-02 |
| GET | `/mission-templates?childId|pregnancyId&category&roleFit&durationMax&requestable&q` | thư viện (có `hearts`, `roleFit`, `durationMin`) | CARE-04, US-03 |
| GET/PUT | `/families/{fid}/mission-settings` | `{boardLevel: LIGHT|MEDIUM|HEAVY}` cấp gia đình — áp dụng từ bảng ngày kế tiếp, outbox báo Parent kia | CARE-12 |
| GET/PUT | `/families/{fid}/mission-preferences/me` | `{disabledCategories, boardPushTime, eveningCarryOver, defaultReminderMin}` | CARE-12 |
| GET | `/families/{fid}/hearts/me?cursor` | **chỉ của người gọi** (6.6): `{today, week, total, dailyCap, history[]}` — `history[]` = `{at, amount, reason, title}` của chính mình | CARE-09, CARE-01 |
| GET | `/families/{fid}/family-tree` | `{level, levelName, progressPercent, fruits, flowers, bloomedDaysThisWeek, today: {leaves, total, bloomed}}` — **không** có số Hearts | CARE-09, HOME |
| GET | `/families/{fid}/badges` | | CARE-10 |
| GET | `/families/{fid}/care/stats?week&childId` | thống kê **cấp gia đình** (15.7): `byCategory`, `together`, `bloomedDays`, `disclaimerKey` — không theo người | CARE-11 |

#### Us (Papa & Mama) — mọi route yêu cầu `canUseCouple`
| Method | Path | Mô tả | Màn |
|---|---|---|---|
| GET | `/us/today` | mood mình, mood partner đã share, lời nhờ đang mở (2 chiều), câu hỏi hôm nay, cảm ơn gần đây, nhiệm vụ hai ta | US-01, HOME (rút gọn: `/us/summary`) |
| POST | `/us/checkins` | `{mood, energy?, needs[], note?, share:{enabled, fields[]}}` | US-02 |
| GET | `/us/checkins?owner=me|partner&cursor` | lịch sử (partner: chỉ bản đã share) | US-14 |
| DELETE | `/us/checkins` | xoá lịch sử mood của mình | US-15 |
| POST | `/us/checkins/{id}/responses` | `{type: SEEN|ASK_NEED|TAKE_OVER|HUG, templateId?}` — `TAKE_OVER` (“Để mình lo”) tạo Lời nhờ TASK `ACCEPTED`, `volunteered=true` | US-01 |
| GET | `/us/requests?box=OPEN|SENT|RECEIVED|HISTORY&cursor` | Lời nhờ (2 chiều); `box=OPEN` cho US-01, thẻ HOME-01, dòng nhắc CARE-01 | US-01, US-04 |
| POST | `/us/requests` | gửi lời nhờ (11.7) — `422 REQUEST_OPEN_LIMIT` / `REQUEST_RESEND_BLOCKED` | US-03 |
| GET | `/us/requests/{id}` | chi tiết (giải mã lời nhắn); `heartsAwarded` chỉ có khi người gọi là người làm | US-04 |
| POST | `/us/requests/{id}/seen` | người nhận mở → `SEEN` | US-04 |
| POST | `/us/requests/{id}/accept` · `/decline {reasonCode?}` · `/done` | người nhận; `done` (TASK) → +5 Hearts cho người làm | US-04 |
| POST | `/us/requests/{id}/acknowledge` | NEED: `{type: SEEN|HUG|TALK_TIME|ENCOURAGED, talkAt?}` | US-04 |
| POST | `/us/requests/{id}/remind-me` | `{at}` — chỉ người nhận, tối đa 1 lần (không có nút giục cho người gửi) | US-04 |
| POST | `/us/requests/{id}/cancel` · `/self-do` | người gửi: huỷ / “Tự mình làm” sau khi bị từ chối (tạo nhiệm vụ của tôi, `ref_type=REQUEST`) | US-04 |
| POST/GET | `/us/appreciations` | gửi / danh sách; 💛 nhanh: `{linkedType: MISSION|REQUEST, linkedId, quick: true}` (server điền câu mặc định) | US-05/06, CARE-01, US-04 |
| POST | `/us/appreciations/{id}/react` · `/share-request` · `/share-respond {approve}` · DELETE | | US-06 |
| GET/POST | `/us/pregnancies/{id}/name-candidates` | [1.1] danh sách `{id, name, meaning, addedBy, likedByMe, likedByPartner, bothLike, chosen}` / thêm `{name, meaning?}` | PREG-07 |
| PUT/DELETE | `/us/name-candidates/{id}/like` | ❤ của người gọi | PREG-07 |
| POST | `/us/name-candidates/{id}/choose` | chọn tên → cột mốc thai kỳ `NAME_CHOSEN` (visibility `PARENTS`) + gợi ý điền tên ở PREG-05 | PREG-07 |
| DELETE | `/us/name-candidates/{id}` | người đã thêm | PREG-07 |
| GET/POST/PATCH/DELETE | `/us/journal`, `/us/journal/{id}` | nhật ký riêng (chỉ chủ) | US-07 |
| POST | `/us/journal/{id}/share` | `{excerpt}` → tạo tin chia sẻ cho partner | US-07 |
| POST | `/us/conflicts` | mở phiên riêng tư | US-08 |
| PUT | `/us/conflicts/{id}/my-entry` | `{feelings, needs, draft?, sharedPoints[]}` | US-08 |
| POST | `/us/conflicts/{id}/invite` · `/respond {JOIN|LATER, laterAt?|NOT_READY}` · `/understood` · `/clarify` · `/next-step {code, at?, custom?}` · `/next-step/confirm` · `/pause` · `/close` | | US-10..12 |
| GET | `/us/conflicts/{id}` | trả `myEntry` (đầy đủ) + `partnerShared` (chỉ sharedPoints) | US-11 |
| POST | `/us/safety-check` | `{text}` → `{flag: NONE|SAFETY}` — **không lưu text, không log** | US-08 |
| GET | `/content/safety-resources?region` | danh sách đường dây | US-13 |
| GET/PATCH | `/us/settings` | | US-15 |

#### AI, Recap, Notification, Billing, Trust, Lifecycle, Sync, Config
| Method | Path | Mô tả | Màn |
|---|---|---|---|
| POST | `/ai/caption-suggestions` · `/ai/daily-story` · `/ai/rewrite` · `/ai/conflict-summary` | mục 17 | MEM-05, REC-01, US-09 |
| POST | `/ai/outputs/{id}/feedback` | `{action: ACCEPTED|EDITED|REJECTED}` | — |
| GET | `/families/{fid}/recaps?period&childId` · GET `/recaps/{id}` | | REC-* |
| POST | `/recaps/{id}/save {visibility}` · `/share` · `/dismiss` | | REC-02 |
| GET | `/notifications?tab&cursor` · GET `/notifications/unread-count` · POST `/notifications/read {ids[]|all}` | Mongo | NOTI-01 |
| GET | `/billing/plans` | gói + giá hiển thị (giá thật lấy từ Store SDK) | SUB-01 |
| GET | `/families/{fid}/billing` | entitlement, payer, store, usage, quota | SUB-03 |
| GET | `/families/{fid}/billing/eligibility?productId` | có được mua không (gia đình đã có gói?) | SUB-01 |
| POST | `/billing/apple/transactions` | `{signedTransactionInfo}` (JWS) | SUB-02 |
| POST | `/billing/google/purchases` | `{productId, purchaseToken}` | SUB-02 |
| POST | `/billing/restore` | `{apple:{signedTransactions[]}|google:{purchaseTokens[]}}` | SUB-01/03 |
| POST | `/webhooks/apple/asn` · `/webhooks/google/rtdn` | server-to-server | — |
| POST | `/reports` · GET `/me/reports` | | RPT-01, SET-11 |
| POST | `/blocks` · DELETE `/blocks/{userId}` · GET `/me/blocks` | | RPT-02, SET-13 |
| GET | `/me/deletion-preview` | tác động xoá | SET-09 |
| POST | `/me/deletion` · `/me/deletion/cancel` | | SET-09 |
| POST | `/exports` · GET `/exports/{id}` | | SET-08 |
| GET | `/families/{fid}/sync?cursor` | delta sync (22.6) | toàn app |
| GET | `/app-config` | minVersion, flags, quota, content versions, remote copy | SPL-01 |
| GET | `/content/{type}?locale` | moods, needs, prompts… (ETag) | US-02… |
| POST | `/support/tickets` | yêu cầu hỗ trợ | SET-11 |

### 11.4 Bootstrap response (rút gọn)

```json
{
  "family": { "id": "…", "name": "Nhà của Hana", "status": "ACTIVE", "timezone": "Asia/Ho_Chi_Minh",
              "settings": { "requireCircleReview": true, "showLunar": true } },
  "me": { "role": "PARENT", "slot": "A", "callName": "Mama" },
  "parents": [ { "userId": "…", "slot": "A", "callName": "Mama", "avatarUrl": "…" },
               { "userId": "…", "slot": "B", "callName": "Papa", "avatarUrl": "…" } ],
  "couple": { "linked": true },
  "subjects": [
    { "type": "CHILD", "id": "…", "displayName": "Hana", "birthDate": "2024-06-02", "colorIndex": 1, "status": "ACTIVE" },
    { "type": "CHILD", "id": "…", "displayName": "Haru", "birthDate": "2026-05-01", "colorIndex": 2, "status": "ACTIVE" },
    { "type": "PREGNANCY", "id": "…", "displayName": "Thai #3 • Bơ", "dueDate": "2027-02-14", "status": "ACTIVE" }
  ],
  "entitlement": { "accessPhase": "PAID", "planCode": "FAMILY", "trialEndsAt": null, "validUntil": "2027-09-30T00:00:00Z", "inGrace": false,
                   "capabilities": { "circle.enabled": true },
                   "quota": { "storageBytes": 214748364800, "circleMax": 12, "videoMaxSec": 600 },
                   "usage": { "storageBytes": 5368709120, "circleCount": 4 } },
  "unread": { "notifications": 3, "pendingReviews": 1, "openRequests": 1, "us": true },
  "accessVersion": 42
}
```
Với **Circle**: `parents` chỉ có `callName` + avatar, `couple` bị bỏ, `subjects` chỉ bé được grant, không có `entitlement.usage`, không có `unread.openRequests`. Bootstrap **không** chứa Hearts (kể cả của chính mình) — lấy riêng ở `/families/{fid}/hearts/me`.

### 11.5 Tạo ký ức

```http
POST /v1/memories
Idempotency-Key: 6f7c…
{
  "familyId": "…",
  "kind": "MOMENT",
  "assetIds": ["a1","a2","a3"],
  "coverAssetId": "a1",
  "title": null,
  "body": "Lần đầu Hana bế em Haru 🥹",
  "childIds": ["hana","haru"],          // [] + "familyMoment": true cho khoảnh khắc gia đình
  "familyMoment": false,
  "pregnancyId": null,
  "occurredAt": "2026-10-05T09:12:00+07:00",
  "visibility": "FAMILY",
  "albumIds": [],
  "milestone": null,                     // { "childId": "hana", "templateCode": "MEET_SIBLING" }
  "feeling": "TOUCHED",                  // LOVE | JOY | TOUCHED | SURPRISED | PEACEFUL | PROUD — tuỳ chọn
  "people": [{ "userId": "…" }, { "name": "Cô Hạnh" }],   // “Ai ở đó” — tuỳ chọn, không nhận diện khuôn mặt
  "quoteContext": null,                  // kind=QUOTE: “Con nói khi nào?”; body ≤ 280; audio tuỳ chọn qua assetIds
  "monthlyPhoto": null,                  // kind=MONTHLY_PHOTO: { "childId": "haru", "monthIndex": 6, "assetId": "a1", "sticker": {…}, "setPrimary": true }
                                         //   thai kỳ: { "pregnancyId": "…", "pregWeek": 24, … }
  "promptDeliveryId": null,              // tạo từ “Gợi ý ghi lại” → delivery USED
  "locationLabel": "Nhà bà ngoại",
  "commentsEnabled": true
}
→ 201 { "memory": { "id": "…", "status": "PROCESSING", "version": 1, … } }
```
Validate: (1) `childIds` thuộc family (DB FK chặn lần 2), (2) gia đình > 1 bé và không chọn bé ⇒ phải `familyMoment=true`, (3) Circle: mọi child có grant CONTRIBUTE, không được `familyMoment`, `visibility` bị ép `FAMILY`, status = `PENDING_REVIEW` nếu `requireCircleReview`, (4) gói House/Free: `visibility=FAMILY` bị hạ thành `PARENTS` (không có Circle) — client không hiển thị lựa chọn này, (5) quota `memoryCount`, `photosPerMemory`, (6) `QUOTE`: đúng 1 bé, body ≤ 280 ký tự (DB CHECK), tuổi hiển thị tính từ `occurred_local_date` (AC-029); (7) `MONTHLY_PHOTO`: chỉ Parent (Circle → `422 MEMORY_KIND_NOT_ALLOWED`), đúng 1 bé (hoặc thai kỳ + tuần), `monthIndex` phải bằng tháng tuổi tại `occurredAt` (sai → `422 MONTH_INDEX_MISMATCH`), `setPrimary` → UPSERT `monthly_photos` cùng transaction (BR-072); (8) `KEEPSAKE`: ≥ 1 ảnh; (9) `people[].userId` là thành viên ACTIVE của family; (10) `memory_children.age_month` do server tính. Hearts `MEMORY_CREATED` +2 khi có nội dung.

### 11.6 Tạo nhiệm vụ & bảng nhiệm vụ ngày

```http
POST /v1/missions
Idempotency-Key: …
{
  "familyId": "…",
  "templateId": "…",                    // từ thư viện (Hearts theo template) hoặc null + title (CUSTOM = 2 Hearts)
  "title": "Đọc sách cho Hana & Haru",
  "category": "BONDING",
  "targetScope": "MULTI_CHILD",         // CHILD | MULTI_CHILD | FAMILY | COUPLE
  "childIds": ["hana","haru"],
  "owner": "ME",                        // ME | TOGETHER — không có lựa chọn bạn đời (BR-020)
  "boardDate": "2026-10-07",
  "scheduledTime": "19:30",
  "recurrence": { "rrule": "FREQ=WEEKLY;BYDAY=MO,WE,FR", "endDate": null },   // null = một lần
  "reminderOffsetMin": 15,
  "note": null,
  "memoryPrompt": true
}
→ 201 { "mission": { "id": "…", "status": "TODO", "source": "LIBRARY", "ownerKind": "PARENT", "hearts": 5, … }, "seriesId": null }
```
Server: (1) scope/children (BR-021); (2) `owner ∉ {ME, TOGETHER}` hoặc body có `ownerUserId` ≠ người gọi → `422 MISSION_OWNER_INVALID` với `details.hint = "SEND_REQUEST"` (client hiện “Muốn nhờ Mama? Gửi lời nhờ →”); (3) `COUPLE` ⇒ `TOGETHER`, `TOGETHER` cần couple linked; (4) Hearts = `template.hearts` hoặc 2 (CUSTOM) — client **không** gửi Hearts; (5) `boardDate` từ hôm nay tới +60 ngày; (6) quota `series`; (7) nhiệm vụ tự thêm **không** tính định mức. `TOGETHER` → outbox `MissionCreated` (Parent kia nhận thông báo trung tính, gộp). Không có trạng thái chờ nhận/từ chối.

**Bảng ngày** — `GET /v1/families/{fid}/missions/board?date=2026-10-07&tab=MINE`:
```json
{
  "date": "2026-10-07", "level": "MEDIUM",
  "tree": { "leaves": 7, "total": 10, "bloomed": false },          // đếm việc của cả nhà, không Hearts
  "tabs": { "mine": { "done": 2, "total": 4 }, "partner": { "done": 3, "total": 4 }, "together": { "done": 0, "total": 1 } },
  "myHeartsToday": 12,                                               // chỉ của người gọi; chỉ có khi tab=MINE
  "swapsLeft": 2,
  "openRequestCount": 1,                                             // dòng nhắc “1 lời nhờ đang mở →” (mở US-04)
  "items": [
    { "id": "…", "ownerKind": "PARENT", "mine": true, "source": "SYSTEM", "title": "Đọc sách tranh 10 phút",
      "category": "BONDING", "childIds": ["hana"], "hearts": 5, "status": "TODO", "scheduledTime": null,
      "canSwap": true, "late": false }
  ]
}
```
- `tab=PARTNER` → `items[]` là `PartnerMissionDto { id, title, category, childIds, status (TODO|DONE), completedAt, late, thanked }` — **không** có `hearts`, `source`, `canSwap`, không có `myHeartsToday`/`swapsLeft`; nhiệm vụ `EXPIRED`/`REMOVED` của bạn đời không trả (6.6).
- `tab=TOGETHER` → có `hearts` (mỗi người nhận đủ khi xong).
- Lời nhờ **không** nằm trong `items[]` (BR-070).

### 11.7 Gửi lời nhờ

```http
POST /v1/us/requests
Idempotency-Key: …
{
  "kind": "TASK",                       // TASK (Nhờ một việc) | NEED (Mình đang cần…)
  "templateId": "…",                    // TASK từ thư viện; hoặc "title" tự gõ; hoặc "needCode": "BREAK" + "durationMin": 30
  "title": null,
  "needCode": null,                     // NEED: QUIET | HUG | TALK | REASSURANCE
  "durationMin": null,
  "childIds": ["haru"],                 // tuỳ chọn
  "dueKind": "TONIGHT",                 // TASK: NOW | TODAY_AT | TONIGHT | TOMORROW
  "dueAt": null,                        // bắt buộc với TODAY_AT; tuỳ chọn với TOMORROW; ≤ 7 ngày từ lúc gửi
  "urgency": "NORMAL",                  // NORMAL | SOON
  "message": "Tối nay anh tắm cho Haru giúp em nhé, em hơi mệt 💛"
}
→ 201 { "request": { "id": "…", "status": "SENT", "expiresAt": "…" }, "openCount": 3, "openLimit": 5 }
```
Server: `canUseCouple`; người nhận luôn là bạn đời (không chọn); trong transaction khoá `couple_spaces` `FOR UPDATE` → đếm theo `ix_req_open_sender` ≥ 5 → `422 REQUEST_OPEN_LIMIT`; có lời nhờ `DECLINED` cùng `content_key` trong 12 giờ → `422 REQUEST_RESEND_BLOCKED` + `details.retryAfter`; tính `due_at` (≤ 7 ngày, sai → `422 REQUEST_DUE_INVALID`) và `expires_at = due_at + 2h` (15.8); mã hoá `title`/`message` bằng DEK COUPLE; outbox `RequestSent`. Lời nhắn: client kiểm tra từ ngữ gay gắt bằng từ điển `GET /content/HARSH_WORD` (cục bộ, không gửi server) và gợi ý câu mẫu `GET /content/REQUEST_TEMPLATE`; AI viết lại [1.2] qua `/ai/rewrite`. Response/thông báo của **người gửi** không bao giờ chứa Hearts.

### 11.8 Đa ngôn ngữ phía server (i18n)

**Ngôn ngữ hỗ trợ:** cấu hình `ops.app_config['i18n.supportedLocales'] = ["vi","en"]`, `defaultLocale = "vi"`, chuỗi fallback **`<locale người dùng> → en → vi`**. Mã locale dạng BCP-47 rút gọn theo ngôn ngữ (`vi`, `en`; về sau `ja`, `ko`, …).

**Xác định locale của request (`LocaleResolver`, interceptor toàn cục):**
1. User đã đăng nhập → `users.locale` (client cập nhật qua `PATCH /v1/me {locale}` khi người dùng đổi ngôn ngữ).
2. Chưa đăng nhập / chưa có → header `Accept-Language` (lấy ngôn ngữ đầu tiên được hỗ trợ).
3. Không khớp → `vi`.
Locale gắn vào request context (AsyncLocalStorage) để service/serializer dùng.

**Locale của người nhận (thông báo, email, SMS):** luôn dùng `users.locale` của **người nhận**, không dùng locale của người gây ra sự kiện (BR-063). Worker `notify` render template theo từng người nhận.

**Phân loại nội dung & cách lưu**

| Loại | Cách lưu | Ví dụ |
|---|---|---|
| Thông báo lỗi API | Bảng dịch lỗi trong code backend (`i18n/<locale>/errors.json`, key = `error.code`), server trả `message` đã dịch + `messageKey` | `FAMILY_NOT_ACTIVE` → “Gia đình chưa đủ Bố và Mẹ.” / “Your family needs both parents to continue.” |
| Template thông báo/email/SMS | `ops.notification_templates (code, locale, …)` — 1 dòng / locale; ICU MessageFormat cho biến & số nhiều | `REQUEST_RECEIVED` vi/en |
| Catalog hệ thống | Cột `*_i18n jsonb` (`{"vi": "...", "en": "..."}`) ở `mission_templates`, `milestone_templates`, `badges`; `ops.content_items (type, code, locale, data)` cho mood/need/prompt/safety/tuần thai | `title_i18n` |
| Nội dung người dùng | Lưu nguyên văn, **không** dịch, **không** gắn locale | caption, nhật ký, bình luận |
| Văn bản pháp lý | Mỗi locale 1 phiên bản (`TERMS`, `PRIVACY` + `version` + `locale`); `user_consents` lưu locale của bản người dùng đã đồng ý | |

**Serialize catalog:** API trả **chuỗi đã chọn theo locale** (`title`), không trả nguyên object `title_i18n` cho app (giảm payload, tránh client tự xử lý). Hàm chung `pickI18n(i18nJson, locale)` áp dụng fallback `locale → en → vi`. Cache Redis theo khoá có locale: `catalog:missions:v{version}:{locale}`; response có `ETag` khác nhau theo locale (`Vary: Accept-Language` cho endpoint public).

**Định dạng phía server:** ngày giờ trong nội dung push/email format bằng `Intl` (`Intl.DateTimeFormat(locale, {timeZone: family.timezone})`); số nhiều bằng ICU (`@formatjs/intl-messageformat` hoặc `i18next` + ICU). **Timezone không suy ra từ locale.**

**AI:** request AI gửi kèm `language = users.locale`; system prompt yêu cầu trả lời đúng ngôn ngữ đó; ẩn danh tên vẫn áp dụng (17.2).

**Admin & quy trình dịch:**
- ADM-19 hiển thị độ phủ bản dịch theo locale cho mọi catalog/template; xuất/nhập CSV/XLIFF.
- Template thông báo chỉ được `enabled` khi đủ bản `vi` + `en`.
- CI backend: test so khớp key `errors.json` giữa các locale; test mọi `notification_templates.code` có đủ locale bắt buộc.

**Bảng/cột liên quan (đã có ở mục 7):** `users.locale`, `families.content_locale` (ngôn ngữ mặc định cho nội dung sinh tự động dùng chung cả nhà, vd. tên recap), `ops.notification_templates.locale`, `ops.content_items.locale`, `*_i18n jsonb`.

**API liên quan:** `PATCH /v1/me {locale}`; mọi request gửi `Accept-Language`; `GET /v1/app-config` trả `supportedLocales`, `defaultLocale`.

### 11.9 Trang chủ — aggregate HOME-01/02/03

`GET /v1/families/{fid}/home?subject=ALL` trả phần trên màn trong 1 request; feed cuộn tiếp qua `/families/{fid}/feed?cursor`.
```json
{
  "subject": "ALL", "partOfDay": "EVENING",
  "blocks": [
    { "type": "TODAY_STORIES", "items": [ { "subjectType": "CHILD", "subjectId": "haru", "coverUrl": "…", "count": 4, "unseen": true } ] },
    { "type": "US_SUMMARY", "partnerMood": { "mood": "OVERWHELMED", "needs": ["QUIET"] }, "openRequestCount": 1 },
    { "type": "SPECIAL_DAY", "kind": "MONTHIVERSARY", "childId": "haru", "monthIndex": 6, "cta": "MONTHLY_PHOTO", "hasMonthlyPhoto": false },
    { "type": "MISSIONS", "tree": { "leaves": 4, "total": 8, "bloomed": false }, "myTodo": [ "…≤ 3" ], "myHeartsToday": 9 },
    { "type": "PROMPT", "deliveryId": 812, "text": "Từ mới Hana nói tuần này là gì?", "targetKind": "QUOTE", "childId": "hana" },
    { "type": "FEED_HEAD", "items": [ "…≤ 5" ], "nextCursor": "…" },
    { "type": "WEEK_SUMMARY", "moments": 12, "firsts": 2, "quotes": 1, "thumbs": [ "…4" ] },
    { "type": "TREE_MINI", "level": 3, "progressPercent": 64 }
  ]
}
```
- **Thứ tự trong mảng = thứ tự hiển thị**; server áp bảng “ưu tiên khối theo ngữ cảnh” của HOME-01: có lời nhờ đang mở / bạn đời chia sẻ “Quá tải” → `US_SUMMARY` ngay sau `TODAY_STORIES`; ngày đặc biệt → `SPECIAL_DAY` dạng lớn, ẩn `PROMPT`; sau 19:00 → `MISSIONS` thu gọn nếu đã xong hết và `FEED_HEAD` lên trên `MISSIONS`. Tối đa 8 khối; khối rỗng bị bỏ; gia đình mới → `ONBOARDING_CHECKLIST`. `SPECIAL_DAY` không có ngày đặc biệt → `ON_THIS_DAY`.
- **HOME-02** (`subject=child:{id}`): `CHILD_HEADER` (bìa = ảnh tháng mới nhất, tuổi, ngày sinh dương + âm, đếm ngược mốc tiếp theo), `QUICK_ACTIONS`, `TODAY_STRIP`, `MONTH_CHAPTER`, `RECENT_FIRSTS` (+ `nextFirstHint` theo giai đoạn, **không** kèm tuổi chuẩn), `LATEST_QUOTE` hoặc `LATEST_VOICE`, `MONTHLY_ROW`, `MISSIONS` (của tôi, lọc bé), `ON_THIS_DAY`, `US_SUMMARY` (không lọc bé), `FEED_HEAD` (lọc bé).
- **HOME-03** (`subject=pregnancy:{id}`): `PREG_HEADER` (tuần + ngày, số ngày còn lại, tam cá nguyệt, `sizeContent` nếu bật), `QUICK_ACTIONS`, `BUMP_WEEKS`, `PREG_FIRSTS`, `PREP_PROGRESS`, `MISSIONS`, `TOLD_TOGETHER`, `NAME_CANDIDATES` [1.1] (chỉ Parent có couple linked; chỉ số tên + số “Cả hai thích”), `BIRTH_CTA` (tuần ≥ 36). Thai kỳ đã lưu trữ riêng tư → `404`.
- **Quyền:** `MISSIONS.myHeartsToday` chỉ của người gọi (6.6); `US_SUMMARY`, `NAME_CANDIDATES` chỉ khi `canUseCouple`; Circle chỉ nhận `TODAY_STORIES` (lọc quyền), `SPECIAL_DAY` (sinh nhật/tròn tháng của bé được chia sẻ), `FEED_HEAD`.
- **Hiện thực:** mỗi khối là 1 provider độc lập chạy song song (timeout 300 ms/khối — lỗi/timeout thì bỏ khối, không trả 500); cache Redis `home:{fid}:{uid}:{subject}` 30 giây, xoá khi có sự kiện của family.

---
## 12. Realtime

- Gateway Socket.IO tại `wss://ws.babyfamily.vn`, xác thực bằng access token khi handshake (`auth.token`), refresh khi hết hạn bằng event `auth.refresh`.
- **Room:** `user:{userId}` (mọi sự kiện cá nhân), `family:{familyId}:parents`, `family:{familyId}:circle:{childId}` (không dùng — thay vào đó server fan-out theo user để không lộ cấu trúc room).
- **Nguyên tắc:** realtime chỉ gửi **tín hiệu nhỏ** `{type, entity, id, version}`; client gọi API để lấy dữ liệu (đảm bảo quyền luôn được kiểm tra qua REST). Không bao giờ gửi nội dung Papa & Mama qua socket.
- Sự kiện: `memory.created|updated|deleted`, `comment.created`, `reaction.changed`, `mission.changed` (chỉ id/version — client gọi lại API đã shaping 6.6), `tree.changed`, `perspective.changed`, `story.hint` (vòng “Hôm nay của …” có ảnh mới), `us.mood.shared`, `us.request.changed`, `us.appreciation.received`, `us.conflict.changed`, `entitlement.changed`, `access.changed` (client re-bootstrap), `sync.hint`.
- Khi user online (`presence`) và đang mở đúng màn → worker notify có thể **bỏ push** cho sự kiện không quan trọng (giảm làm phiền).
- Scale ngang: Redis adapter; sticky session ở Nginx (`ip_hash` hoặc cookie) nếu dùng long-polling fallback.

---

## 13. Hệ thống thông báo

### 13.1 Pipeline

```
Domain event (outbox) ─► notify.resolve-and-dispatch
   1. Map event → templateCode + danh sách người nhận (RecipientResolver theo bảng 13.2)
   2. Với mỗi người nhận:
        a. Kiểm tra quyền xem entity tại thời điểm gửi (AccessContext) — tránh gửi cho người vừa bị gỡ
        b. Dedup: key = eventId+userId (Redis SET NX 24h) → sự kiện nhiều bé chỉ 1 thông báo
        c. Preferences: category tắt? người gửi bị mute? người nhận chặn tác giả?
        d. Ghi inbox (Mongo) — luôn ghi (trừ category bị tắt hoàn toàn)
        e. Gộp: nếu template có groupKey (reaction/comment) → đẩy vào notif:grp, lên lịch group-flush sau 30 phút
        f. Trần ngày: priority NORMAL và notif:cap ≥ 3 → chỉ inbox, không push
        g. Giờ yên tĩnh (theo timezone thiết bị/người dùng) → lên lịch push vào quiet_end (delay job)
           ngoại lệ: Lời nhờ SOON khi người nhận bật request_soon_bypass_quiet
           người nhận đang “Cần yên tĩnh” (quiet:user:{id}, hoặc check-in đã share có nhu cầu QUIET còn hiệu lực)
           → lời nhờ NORMAL và push không gấp chỉ ghi inbox, push dời tới khi hết khung
        h. Online & đang xem → bỏ push (tuỳ template)
        i. Render: locale người nhận; sensitive && hide_sensitive_preview → dùng hidden_title/hidden_body
        j. Enqueue push.send-fcm cho từng device push_enabled
        k. Không Hearts trong thông báo (BR-018, BR-026): template không có biến Hearts, params qua whitelist;
           CI fail nếu template/params chứa “hearts”/“💗” kèm số
   3. push.send-fcm: FCM HTTP v1; xử lý lỗi UNREGISTERED/INVALID_ARGUMENT → xoá token
```

### 13.2 Bảng sự kiện → người nhận

| Event | Template | Người nhận | Sensitive | Priority |
|---|---|---|---|---|
| `PartnerLinked` | `PARTNER_JOINED` | Parent A | — | HIGH |
| `CircleInviteAccepted` (cần duyệt) | `PARTNER_APPROVAL_NEEDED` | Parent A | — | HIGH |
| `CircleMemberJoined` | `CIRCLE_JOINED` | 2 Parent | — | NORMAL |
| `MemoryPublished` | `MEMORY_NEW` | Parent còn lại (nếu visibility ≠ PRIVATE) + Circle có quyền **và** chọn INSTANT (DIGEST → gom) | — | NORMAL |
| `MemoryPendingReview` | `MEMORY_REVIEW_NEEDED` | 2 Parent | — | NORMAL |
| `MemoryReviewed` | `MEMORY_APPROVED/REJECTED` | Tác giả (Circle) | — | NORMAL |
| `CommentCreated` | `COMMENT_NEW` (group) | Tác giả ký ức + người đã bình luận (không gồm người viết) có quyền | — | NORMAL |
| `ReactionAdded` | `REACTION_NEW` (group) | Tác giả ký ức | — | NORMAL |
| `MilestoneRecorded` | `MILESTONE_NEW` | Parent còn lại + Circle có quyền với bé | — | NORMAL |
| `PregnancyBirthConverted` | `BABY_ARRIVED` | Circle được chọn báo tin | — | HIGH |
| `MissionBoardGenerated` → `missions-today-push` | `MISSIONS_TODAY` (“Hôm nay có 3 việc nhỏ của bạn và 1 việc cùng nhau”) | Mỗi Parent (theo `board_push_time`) | — | NORMAL |
| Reminder | `MISSION_REMINDER` | Chủ nhiệm vụ (TOGETHER: cả hai) | — | HIGH |
| `MissionCreated` (TOGETHER, do người kia tạo) | `MISSION_TOGETHER_ADDED` (gộp) | Parent còn lại | — | NORMAL |
| `MissionCompleted` (TOGETHER) | `MISSION_TOGETHER_DONE` (“Papa đã đánh dấu Xong cùng nhau: …” + 💛) | Parent còn lại | — | NORMAL |
| `MissionBoardLevelChanged` | `MISSION_LEVEL_CHANGED` (trung tính) | Parent còn lại | — | NORMAL |
| Hỏi 21:00 | `MISSION_CARRY_OVER` | Chủ nhiệm vụ tự thêm còn `TODO` (nếu bật) | — | NORMAL |
| `FamilyTreeLevelUp`, `FamilyTreeBloomed` | `TREE_LEVEL_UP`, `TREE_BLOOMED` | 2 Parent — **chỉ inbox, không push** (BR-026); nội dung chỉ có cấp/hình cây | — | — |
| `MoodShared` | `MOOD_SHARED` | Partner | **Có** | NORMAL |
| `RequestSent` | `REQUEST_RECEIVED` (TASK) / `REQUEST_NEED_RECEIVED` (NEED) | Người nhận | **Có** | `SOON` → HIGH, `NORMAL` → NORMAL |
| `RequestResponded` | `REQUEST_ACCEPTED`, `REQUEST_DECLINED` (trung tính + nút “Tự mình làm”), `REQUEST_ACKNOWLEDGED` | Người gửi | **Có** | NORMAL |
| `RequestDone` | `REQUEST_DONE` (“Papa đã tắm cho Haru 💛” + nút Cảm ơn) | Người gửi | **Có** | NORMAL |
| Nhắc do người nhận chọn | `REQUEST_REMINDER` | Người nhận (tối đa 1) | **Có** | NORMAL |
| `AppreciationSent` | `APPRECIATION_NEW` | Partner | Có (tuỳ chọn hiện nội dung) | NORMAL |
| `ConflictInvited` | `CONFLICT_INVITE` | Partner | **Có** | NORMAL |
| `RecapReady` | `RECAP_WEEK_READY` | 2 Parent | — | NORMAL |
| Ngày đặc biệt | `TRADITIONAL_UPCOMING`, `BIRTHDAY` | 2 Parent (+ Circle với sinh nhật) | — | NORMAL |
| `MonthlyPhotoDue` (job 09:00) | `MONTHLY_PHOTO_DUE` (“Hôm nay Haru tròn 6 tháng 🎉 — Chụp ảnh tháng”) | 2 Parent — **push chỉ khi chưa có ảnh tháng**, có rồi chỉ thẻ Trang chủ | — | NORMAL |
| Nhắc ảnh bụng | `BUMP_PHOTO_DUE` | 2 Parent (theo `bump_photo_cadence`) | — | NORMAL |
| `PerspectiveAdded` | `PERSPECTIVE_ADDED` (“Papa đã kể thêm góc nhìn về khoảnh khắc của Hana”) | Tác giả ký ức gốc | — | NORMAL |
| `MilestoneRecorded` (bởi bạn đời) | `PERSPECTIVE_SUGGEST` (“Bạn cũng ở đó chứ? Kể thêm góc nhìn của bạn nhé.”) | Parent còn lại nếu bật `perspective_suggest` — ≤ 1/ngày | — | NORMAL |
| Gợi ý 21:00 | `DAILY_STORY_SUGGEST` | Parent bật `daily_story_suggest`, bé có ≥ 3 ký ức hôm nay | — | NORMAL (chỉ inbox nếu chạm trần) |
| `EntitlementChanged` | `PLAN_EXPIRING`, `PLAN_GRACE`, `PLAN_EXPIRED` | Payer (+ Parent kia) | — | HIGH |
| Digest 19:00 | `CIRCLE_DIGEST` | Circle chọn DIGEST | — | NORMAL |

> Thông báo ký ức/góc nhìn/ảnh tháng cho Circle luôn qua kiểm tra quyền ở bước 2a (BR-071). “Gợi ý ghi lại” **không** gửi push (chỉ thẻ Trang chủ, BR-073); không template nào có câu gây tội lỗi kiểu “Đã N ngày bạn chưa…”.
>
> Không thông báo khi bạn đời hoàn thành nhiệm vụ của riêng họ, khi nhiệm vụ hết hạn/bị Bỏ/bị Đổi, hay khi lời nhờ hết hạn. **Không template nào nhắc tới Hearts** (của mình hay của người khác); thông báo Lời nhờ không bao giờ gửi cho Circle.

### 13.3 Payload FCM

```json
{
  "message": {
    "token": "<fcm token>",
    "notification": { "title": "Baby Family", "body": "Bạn có một cập nhật mới từ Papa & Mama" },
    "data": { "type": "REQUEST_RECEIVED", "entityId": "…", "familyId": "…", "deepLink": "babyfamily://us", "nid": "<inboxId>" },
    "android": { "priority": "HIGH", "collapse_key": "us", "notification": { "channel_id": "us", "tag": "us" } },
    "apns": { "headers": { "apns-priority": "10", "apns-collapse-id": "us" },
              "payload": { "aps": { "thread-id": "us", "badge": 4, "sound": "default" } } }
  }
}
```
- **Android channels:** `missions`, `memories`, `us` (importance default, có thể ẩn trên lock screen), `circle_digest`, `billing`, `system`.
- `data` **không chứa** nội dung nhạy cảm, tên bé (khi sensitive), hay URL ảnh có chữ ký.
- iOS Notification Service Extension [1.1] để tải ảnh thumbnail cho thông báo ký ức mới (rich push) — chỉ khi không sensitive.

### 13.4 Lịch nhắc nhiệm vụ

- Khi mission `TODO` có `reminder_at` → BullMQ delayed job `mission.reminder` với `jobId = reminder:{missionId}:{version}` gửi **chủ nhiệm vụ** (TOGETHER: cả hai); sửa/hoàn thành/bỏ/đổi → remove job cũ (jobId thay đổi theo version nên job cũ khi chạy tự kiểm tra version và bỏ qua).
- Tối đa 2 nhắc/nhiệm vụ (đúng giờ + nhắc lại nếu chủ nhiệm vụ chọn).
- Lời nhờ: người nhận chọn “Nhắc mình lúc…” → delayed job `mission.request-reminder` (`jobId = req-reminder:{requestId}`), tối đa 1 lần; huỷ khi lời nhờ rời `SENT/SEEN/ACCEPTED`. Không có cơ chế nhắc/giục do người gửi kích hoạt (BR-067).

---

## 14. Jobs & Scheduler

Scheduler process giữ **leader lock** (`lock:scheduler`, gia hạn 15s) và đăng ký repeatable jobs. Job theo giờ địa phương chạy **mỗi 15 phút** và xử lý các family có `timezone` đang ở khung giờ mục tiêu (bucket theo timezone) — vì gia đình có thể ở nhiều múi giờ.

| Job | Lịch | Việc |
|---|---|---|
| `generate-daily-board` | 05:00 giờ family | Bày bảng nhiệm vụ ngày cho từng family (15.3); `jobId = board:{familyId}:{date}` + kiểm tra `daily_mission_boards` trong transaction ⇒ idempotent. Family vừa kích hoạt giữa ngày → consumer `PartnerLinked` bày ngay; `GET …/missions/board` hôm nay mà chưa có bảng cũng gọi cùng hàm |
| `missions-today-push` | `board_push_time` của từng Parent (mặc định 07:00) | `MISSIONS_TODAY`: số việc của tôi + Cùng nhau, **không** Hearts (không gửi nếu 0) |
| `materialize-series` | 02:00 hằng ngày | Tạo instance (`source=SERIES`) cho 14 ngày tới, bỏ `paused_ranges`; không tính định mức |
| `evening-carry-over` | 21:00 giờ family | Parent bật `evening_carry_over`: nhiệm vụ **tự thêm** (`LIBRARY`/`CUSTOM`) còn `TODO` hôm nay → 1 thông báo gộp `MISSION_CARRY_OVER`; `SYSTEM`/`SERIES` không hỏi |
| `expire-missions` | 00:05 giờ family | `TODO` có `board_date` < hôm nay → `EXPIRED` **im lặng** (không push, không trừ Hearts). Cửa sổ ghi muộn (tới hết `board_date + 1`) kiểm tra lúc complete, không cần job |
| `expire-moods` | mỗi 15 phút | (logic đọc dựa `expires_at`, job chỉ phát realtime cập nhật) |
| `expire-requests` | mỗi 15 phút | Lời nhờ `SENT/SEEN/ACCEPTED` có `expires_at ≤ now()` → `EXPIRED` im lặng (0 Hearts), realtime `us.request.changed` |
| `daily-story-suggest` | 21:00 giờ family | Bé có ≥ 3 ký ức hôm nay và Parent bật `daily_story_suggest` → `DAILY_STORY_SUGGEST` “Gói lại thành Câu chuyện ngày?” (REC-01; inbox, không push nếu đã chạm trần) |
| `monthly-photo-reminder` | 09:00 giờ family | Bé có **ngày tròn tháng** hôm nay (dương lịch, hoặc âm lịch nếu `monthly_photo_lunar`; ngày sinh 29–31 mà tháng không có → ngày cuối tháng) và tháng đó cần ảnh (`AUTO`: < 12 tháng mọi tháng, ≥ 12 tháng mỗi 3 tháng; `MONTHLY`: mọi tháng) → thẻ `SPECIAL_DAY` + `MONTHLY_PHOTO_DUE` (push chỉ khi chưa có `monthly_photos`) |
| `bump-photo-reminder` | 09:00 giờ family | Thai kỳ ACTIVE theo `bump_photo_cadence`, tuần này chưa có ảnh bụng chính → `BUMP_PHOTO_DUE` |
| `memory-prompt-pick` | 06:00 giờ family | Chọn sẵn 1 “Gợi ý ghi lại”/Parent bật gợi ý (19.5); `GET …/memory-prompts/today` chọn lười nếu job chưa chạy; idempotent nhờ `uq_prompt_day` |
| `story-views-cleanup` | 03:15 hằng ngày | Xoá `story_views` > 7 ngày, `memory_prompt_deliveries` > 90 ngày |
| `weekly-recap` | CN 18:00 tạo, 19:00 push | `recaps` WEEK cho family + từng bé |
| `month-age` | 08:00 giờ family | Bé tròn tháng hôm nay → recap MONTH_AGE (thẻ “Chụp ảnh tháng” do `monthly-photo-reminder`) |
| `traditional-reminders` | 08:00 | Đầy tháng/100 ngày/thôi nôi (dương hoặc âm lịch) trước 3 ngày & đúng ngày; sinh nhật |
| `on-this-day` | 07:30 | Đánh dấu có ký ức “ngày này” để Home hiển thị (không push mặc định) |
| `circle-digest` | `circle_digest_time` của từng người thân | Gom ký ức mới trong 24h |
| `pregnancy-overdue-check` | 09:00 thứ Hai | Quá dự sinh 14 ngày → hỏi nhẹ |
| `invite-expire` | mỗi giờ | `PENDING` quá hạn → `EXPIRED` |
| `trial-reminders` | 09:00 giờ family | Theo reminder offsets của trial policy/version đã cấp, tính từ trial_ends_at → push + banner cho cả hai Parent; không hardcode lịch 90 ngày cũ |
| `trial-expiry` | mỗi 15 phút | `TRIAL` hết hạn → `EXPIRED` (recompute) |
| `waiting-partner-nudge` | 10:00 | Gia đình chờ 2/5/10 ngày → nhắc Parent A gửi lại lời mời |
| `waiting-family-cleanup` | hằng ngày | Gia đình `WAITING_PARTNER` > 90 ngày không hoạt động → `DELETED` |
| `trial-ended-notify` | khi `TrialExpired` | Push + inbox cho Papa & Mama: “Thời gian dùng thử đã kết thúc, nâng cấp để tiếp tục” (copy lấy thời hạn server, mặc định 7 ngày) |
| `expired-retention` | hằng ngày | Gia đình EXPIRED: nhắc nâng cấp 1 lần/tháng; ngày thứ 335 & 358 → báo trước 30/7 ngày (push + email/SMS); ngày 365 → `delete-family` |
| `care-snapshots` | 01:00 thứ Hai | Tính `care_weekly_snapshots` tuần trước (cấp gia đình, không theo người) |
| `hearts-reconcile` | Chủ nhật 04:30 | Đối soát `family_trees.total_hearts = Σ heart_ledger.amount` và `heart_daily_counters` 7 ngày gần nhất; lệch → sửa + alert |
| `purge-trash` | 03:00 | Memory `TRASHED` quá 30 ngày → `PURGED` + purge asset |
| `purge-orphans` | mỗi giờ | Asset chưa gắn > 24h |
| `purge-conflicts` | 03:30 | Phiên Cầu nối quá `purge_at` → xoá entries (giữ dòng metadata nếu user không xoá) |
| `deletion-executor` | mỗi 15 phút | `deletion_requests` đến hạn → chạy (20.1) |
| `billing-reconcile` | mỗi 6 giờ | Subscription sắp/đã hết hạn chưa nhận notification → hỏi Store API |
| `entitlement-sweep` | mỗi giờ | Hết grace/hết hạn → recompute |
| `storage-recount` | Chủ nhật 04:00 | Tính lại `family_usage` từ `assets` (chống lệch) |
| `outbox-cleanup` | hằng ngày | Xoá outbox đã publish > 7 ngày |
| `reconcile-uploads` | mỗi 15 phút | 10.2 |

---

## 15. Mission engine, Hearts & Cây gia đình, Lời nhờ

> Chuẩn nghiệp vụ: 7.13 (nhiệm vụ hằng ngày), 7.14 (Hearts & Cây gia đình), 7.15 (Thống kê chăm con), 7.16.2 (Lời nhờ); BR-017..026, BR-067..070; AC-030..038.

### 15.1 Bảng chuyển trạng thái nhiệm vụ (ai được làm gì)

```
 [bày 05:00 / tự thêm / lặp] ──► TODO ──complete──► DONE ──undo ≤10s──► TODO (hoặc EXPIRED nếu là ghi muộn)
                                  │
                                  ├──swap / remove / carry-over / sửa chuỗi──► REMOVED
                                  └──hết ngày 23:59──► EXPIRED ──complete (đến hết D+1)──► DONE (late)
```

| Từ | Hành động | Ai | Sang | Ghi chú |
|---|---|---|---|---|
| — | bày bảng (05:00) | Hệ thống | `TODO` | `source=SYSTEM`, owner = Parent A / Parent B / `TOGETHER` (15.3) |
| — | tự thêm | Parent | `TODO` | `source=LIBRARY|CUSTOM`; owner ∈ {chính mình, `TOGETHER`}; bạn đời → `422 MISSION_OWNER_INVALID` |
| — | sinh từ chuỗi | Hệ thống | `TODO` | `source=SERIES`, owner theo chuỗi |
| `TODO` | complete | chủ (PARENT: `owner_user_id`; TOGETHER: một trong hai Parent) | `DONE` | idempotent, 1 completion; TOGETHER: mỗi Parent nhận đủ Hearts |
| `DONE` | undo (≤ 10 giây; server ≤ 30 giây) | người đã bấm hoàn thành | `TODO` (`late` → `EXPIRED`) | Hearts `REVERSAL` cho mọi dòng ledger của completion |
| `TODO` | swap | chủ; chỉ `SYSTEM` | `REMOVED(SWAPPED)` + nhiệm vụ mới `TODO` | ≤ 3 lần/người/ngày; Hearts mới = cũ ± 1 |
| `TODO` | remove | chủ | `REMOVED(SKIPPED_TODAY|DELETED)` | không phạt, 0 Hearts, không báo bạn đời |
| `TODO` | carry-over | chủ; chỉ `LIBRARY`/`CUSTOM` | `REMOVED(CARRIED_OVER)` + bản sao `TODO` ngày mai | từ lời hỏi 21:00 |
| `TODO` (tương lai) | sửa chuỗi THIS/FOLLOWING, tạm dừng chuỗi | chủ chuỗi | `REMOVED(SERIES_EDIT)` | |
| `TODO` | hết ngày (23:59 giờ family) | Hệ thống | `EXPIRED` | im lặng |
| `EXPIRED` | complete (ghi muộn) đến hết `board_date + 1` | chủ | `DONE` (`late=true`) | vẫn được Hearts; quá hạn → `422 MISSION_LATE_WINDOW_CLOSED` |

Không còn hành động accept/decline/propose-time/hand-to-partner/confirm/snooze/skip/cancel; bạn đời chỉ xem và gửi 💛 trên việc đã xong (BR-024). Hiện thực: `MissionStateMachine.transition(mission, action, actor)` — bảng trên là **dữ liệu** (map), mọi endpoint hành động gọi chung hàm này; transition không hợp lệ → `409 INVALID_MISSION_TRANSITION`; actor không phải chủ → `403 MISSION_NOT_OWNER`. Update dùng `WHERE id=:id AND version=:v` (optimistic).

### 15.2 Hoàn thành — đảm bảo 1 lần, Cùng nhau, ghi muộn, hoàn tác

```sql
-- trong transaction; :actor đã qua canActOnMission; :today theo timezone family
UPDATE app.missions
   SET status='DONE', completed_at=now(), completed_by=:actor,
       late = (status = 'EXPIRED'),                                   -- vế phải đọc giá trị CŨ
       version=version+1
 WHERE id=:id AND version=:v
   AND (owner_kind='TOGETHER' OR owner_user_id=:actor)
   AND (status='TODO' OR (status='EXPIRED' AND board_date >= :today - 1));   -- 0 dòng → 409/422 theo trạng thái thực
INSERT INTO app.mission_completions(...) VALUES (...);                -- uq_mission_completion_active chặn 2 người cùng bấm
-- Hearts (15.5): PARENT → 1 dòng cho chủ; TOGETHER → 1 dòng cho MỖI Parent (cùng source_id = completion.id);
-- có ảnh → +2 MISSION_PHOTO cho người bấm; nhiệm vụ nhiều bé vẫn chỉ 1 completion, 1 dòng/người (BR-022)
```
Retry cùng `Idempotency-Key` → trả kết quả cũ (Redis), hoặc `mission_completions.idempotency_key` unique.

**Hoàn tác** (`POST /missions/{id}/undo`, chỉ người đã bấm, `now() − completion.completed_at ≤ 30s`): `undone_at = now()` → mission về `TODO` (nếu `late` thì về `EXPIRED`), xoá `completed_*`, `late=false` → `hearts.reverse()` cho mọi dòng ledger có `source_id = completion.id` (cả hai Parent với TOGETHER, gồm `MISSION_PHOTO`) → ký ức đã tạo từ ảnh **giữ nguyên** (người dùng tự xoá nếu muốn) → outbox `MissionUndone`. Quá hạn → `409 MISSION_UNDO_WINDOW_CLOSED`.

**Cây hôm nay:** sau mỗi complete/undo tính lại `leaves = count(DONE)` và `bloomed` = mọi nhiệm vụ `SYSTEM` (cả hai bộ + Cùng nhau) của ngày đã `DONE`; lần đầu nở hoa → `daily_mission_boards.bloomed_at`, `family_trees.flowers + 1`, outbox `FamilyTreeBloomed` (undo không thu hồi bông hoa đã nở).

### 15.3 Bày bảng nhiệm vụ hằng ngày (thuật toán cân bằng)

```
generateBoard(familyId, date):                       // job generate-daily-board, jobId = board:{familyId}:{date}
  BEGIN
  SELECT pg_advisory_xact_lock(hashtext('board:' || familyId || ':' || date))
  if EXISTS daily_mission_boards(familyId, date): COMMIT; return                 // idempotent (retry, chạy song song)
  fam = families(familyId); if fam.status ≠ ACTIVE or access_phase ∉ {TRIAL, PAID}: return
  level = mission_family_settings.board_level                                    // LIGHT | MEDIUM | HEAVY
  n     = {LIGHT: 2, MEDIUM: 3, HEAVY: 4}[level]                                 // bằng nhau cho A và B (BR-019)
  nTog  = level = LIGHT ? (rng() < 0.5 ? 1 : 0) : 1
  target = app_config mission.board.targetHearts[level]                          // MEDIUM 12–15/người (LIGHT/HEAVY: cấu hình)
  rng   = seeded(hash(familyId, date, generatorVersion))                         // tái lập khi debug
  subjects = children ACTIVE (tuổi theo ngày) + pregnancies ACTIVE (tuần thai)
  [A, B]   = family_parents ACTIVE
  carrier  = pregnancies.carrier_user_id của thai kỳ ACTIVE (tuần thai lớn nhất)
          ?? pregnancies.carrier_user_id của thai kỳ sinh ra bé ≤ 42 ngày tuổi (children.pregnancy_id)
          ?? parent(kind = MOTHER)                       // bé không có hồ sơ thai kỳ
  phase(p) = LATE_PREGNANCY_OR_POSTPARTUM: có thai kỳ tuần ≥ 28 hoặc bé ≤ 42 ngày tuổi
                → p = carrier ? 'CARRIER' : 'PARTNER_OF_CARRIER'
             EARLY_PREGNANCY (tuần < 28)  → như trên nhưng chỉ yêu cầu 1 việc SELF cho carrier
             else 'NORMAL'
  recent   = template_id của missions(familyId, board_date ∈ [date−14, date−1])   // mọi trạng thái — không lặp 14 ngày

  pool(p) = templates WHERE status=ACTIVE ∧ rollout(pct, familyId) ∧ category ∉ prefs(p).disabled_categories
                       ∧ template_id ∉ recent ∧ role_fit ≠ TOGETHER
                       ∧ role_fit hợp lệ: PREGNANT_MOTHER chỉ cho CARRIER; PARTNER_OF_PREGNANT chỉ cho PARTNER_OF_CARRIER;
                                          ANY_PARENT cho cả hai
                       ∧ khớp ≥ 1 subject (tuổi bé / tuần thai) → gắn scope:
                            CHILD (1 bé) | MULTI_CHILD (≥ 2 bé cùng khớp ∧ multi_child_ok) | FAMILY
            (pool quá nhỏ → nới “không lặp” 14 → 7 → 0 ngày, ghi metric board_pool_relaxed)
  w(t, p) = t.weight
          × 2.0 nếu phase(p)=CARRIER(late/postpartum) ∧ t.category = SELF
          × 1.8 nếu phase(p)=PARTNER_OF_CARRIER(late/postpartum) ∧ t.category ∈ {SUPPORT, CARE}
          × 1.5 nếu bạn đời có mood TIRED/EXHAUSTED/OVERWHELMED (đã share) trong 12h ∧ t.category = SUPPORT
          × 1.3 nếu category ít xuất hiện 7 ngày qua (đa dạng)
  must(p) = CARRIER (mọi giai đoạn thai kỳ/hậu sản) → ≥ 1 SELF trong bộ

  best = null
  repeat K = 50 lần:
     setA = weightedSample(pool(A), n, w, rng, ưu tiên khác category, thoả must(A))
     setB = weightedSample(pool(B) \ setA, n, w, rng, …, thoả must(B))
     assignChildren(setA ∪ setB)        // nhiều bé: lần lượt gán cho bé đang ít việc nhất (cả hai bộ),
                                        // mỗi bé ≥ 1 việc nếu 2n ≥ số bé; hoà → rng
     diff  = |Σhearts(setA) − Σhearts(setB)|
     score = 10·max(0, diff − 2) + dist(ΣA, target) + dist(ΣB, target) + childImbalance
     best  = min(best, score)
     if diff ≤ 2 ∧ ΣA, ΣB ∈ target: break
  if best.diff > 2:                      // sửa cục bộ: đổi 1 nhiệm vụ của bộ nặng hơn bằng template cùng điều kiện, Hearts nhỏ hơn
     repeat ≤ 20: swapOne(heavierSet); if diff ≤ 2: break
  if vẫn > 2: n = n − 1 cho CẢ HAI bộ (giữ bằng nhau) và chạy lại; metric board_balance_fallback
  together = weightedSample(templates role_fit = TOGETHER ∧ không lặp 14 ngày, nTog)   // cần couple linked

  INSERT daily_mission_boards(familyId, date, level, n, nTog, diff, generatorVersion, seed)
  INSERT daily_mission_board_parents (A, n, ΣA), (B, n, ΣB)               // audit nội bộ, không trả API
  INSERT missions(source=SYSTEM, status=TODO, board_date=date, hearts=t.hearts, owner = A | B | TOGETHER) + mission_children
  outbox MissionBoardGenerated {familyId, date}                              // không có Hearts
  COMMIT
```
- Đổi mức (CARE-12) áp dụng từ bảng ngày **kế tiếp**; bảng đã bày giữ nguyên.
- Gợi ý AI [1.2]: LLM chỉ **rerank** `pool(p)` trước bước lấy mẫu; ràng buộc cân bằng (BR-019) luôn do code kiểm — không cho LLM sinh nhiệm vụ tự do.

**Đổi nhiệm vụ (CARE-05):**
```
swapOptions(mission, actor):           // chỉ source=SYSTEM, status=TODO, canActOnMission
  pool = điều kiện như pool(owner) ∪ (TOGETHER: role_fit=TOGETHER), giữ child_ids/scope,
         |t.hearts − mission.hearts| ≤ 1, template chưa có trong bảng hôm nay
  chọn 3 (ưu tiên khác category) → Redis swap:opt:{missionId}:{actor} TTL 10 phút → {options, optionsToken, swapsLeft}
swap(mission, templateId, optionsToken):
  BEGIN; SELECT … FROM daily_mission_board_parents WHERE (family, date, actor) FOR UPDATE
  swaps_used ≥ 3 → 422 MISSION_SWAP_LIMIT; templateId ∉ options → 422 MISSION_SWAP_NOT_ALLOWED
  mission cũ → REMOVED(SWAPPED); INSERT mission mới (SYSTEM, swapped_from_id, swap_count + 1, cùng owner/bé)
  swaps_used + 1; COMMIT
```
Mỗi lần Đổi lệch tối đa ±1 Hearts; BR-019 được đảm bảo tại thời điểm bày (ghi ở `balance_diff`). Nhiệm vụ Cùng nhau đổi bởi ai thì tính vào lượt của người đó.

### 15.4 Recurrence

- Chỉ cho **nhiệm vụ tự thêm** (7.13.6): Hằng ngày / Ngày thường / Cuối tuần / Chọn thứ / Mỗi N ngày / Hằng tháng (ngày X). Lưu RRULE (RFC 5545) + `timezone` family; dùng thư viện `rrule` (JS) để sinh ngày; `materialize-series` tạo instance (`source=SERIES`) tới `today+14`, `uq_series_day` chống trùng ⇒ Hearts tối đa 1 lần/chuỗi/ngày. Không tính định mức.
- Sửa “lần này và các lần sau”: kết thúc series cũ tại ngày trước, tạo series mới từ ngày đó; instance tương lai chưa hoàn thành của series cũ → `REMOVED(SERIES_EDIT)`.
- `paused_ranges` (Tạm dừng chuỗi) loại ngày trong khoảng; bé được lưu trữ → series có bé đó chuyển `PAUSED`.

### 15.5 Hearts (ledger theo từng người) & Cây gia đình

| reason | Hearts (cho người làm) | Trần / người / ngày | Ghi chú |
|---|---|---|---|
| `MISSION_COMPLETED` | theo template (1–10, snapshot `missions.hearts`) | — | TOGETHER: mỗi Parent đủ Hearts; chuỗi: 1 lần/chuỗi/ngày |
| `CUSTOM_COMPLETED` | 2 | 3 lần | nhiệm vụ tự gõ (kể cả chuỗi tự gõ) |
| `MISSION_PHOTO` | +2 | 5 lần | đính ảnh khi hoàn thành (ký ức sinh từ nhiệm vụ không cộng thêm `MEMORY_CREATED`) |
| `REQUEST_DONE` | +5 | — | Lời nhờ TASK `DONE`, cho **người làm** |
| `MEMORY_CREATED` | +2 | 5 lần | |
| `PERSPECTIVE_ADDED` | +2 | chung 5 lần với `MEMORY_CREATED` | góc nhìn thứ hai có nội dung (7.8.6); xoá góc nhìn không thu hồi |
| `MILESTONE_RECORDED` | +5 | — | |
| `APPRECIATION_SENT` | +2 | 3 lần | cho người gửi lời cảm ơn |
| Lời nhờ NEED, bỏ/hết hạn/từ chối, Circle thả tim | 0 | — | không bao giờ âm (BR-017) |
| **Tổng** | | **75** | `hearts.dailyCap` |

```ts
award(tx, { familyId, userId, source: [type, id], reason, amount }) {
  // 0. localDate = today(family.timezone); amount ≤ 0 → return 0
  // 1. INSERT heart_daily_counters(user, localDate) ON CONFLICT DO NOTHING;
  //    SELECT … FOR UPDATE                                   → khoá theo người/ngày (2 request song song không vượt trần)
  // 2. trần theo loại (custom/photo/memory/thanks) đã đủ → return 0 (hành động nghiệp vụ vẫn thành công)
  // 3. grant = min(amount, dailyCap − counters.total); grant ≤ 0 → return 0
  // 4. INSERT heart_ledger(user_id = userId, …, amount = grant) ON CONFLICT (uq_heart_once) DO NOTHING
  //    → không insert (retry) → return dòng cũ (idempotent)
  // 5. UPDATE counters SET total += grant, <loại>_count += 1
  // 6. UPDATE family_trees SET total_hearts += grant, level = GREATEST(level, levelFor(total_hearts)) RETURNING level
  //    → lên cấp → outbox FamilyTreeLevelUp {familyId, level}   (không kèm userId, không kèm số Hearts)
  // return grant                                              → chỉ trả trong response của chính userId
}
reverse(tx, ledgerRow) {
  // INSERT heart_ledger(user_id = ledgerRow.user_id, reason='REVERSAL', amount = −ledgerRow.amount, reversal_of = ledgerRow.id)
  //   (uq_heart_reversal chặn đảo 2 lần) → counters.total −= ; <loại>_count −= 1 (ngày của dòng gốc)
  // → family_trees.total_hearts = GREATEST(0, total_hearts − amount); cấp đã đạt KHÔNG giảm
}
```
- **Nguồn đúng là ledger**; `family_trees` và `heart_daily_counters` là cache trong cùng transaction, đối soát bởi job `hearts-reconcile`.
- **Quyền xem (BR-018):** `HeartsService.mine(ctx)` là cửa đọc duy nhất: `today` = Σ ledger `local_date = hôm nay`, `week` = 7 ngày, `total` = Σ toàn bộ của **người gọi**; `history[]` chỉ dòng `user_id = ctx.userId` (REVERSAL hiển thị gộp — không hiện “bị trừ”). Không có API tổng Hearts theo user khác, không có so sánh, không “Hearts tuần này của gia đình”.
- **Cây gia đình:** `levelFor(total)` theo `tree.levels` (0/100/300/700/1500/3000/6000; cấp 7 mỗi 3.000 thêm 1 quả). `progressPercent = floor(100 × (total − min(level)) / (min(level+1) − min(level)))` (cấp 7: tiến độ tới quả kế tiếp). API trả `level`, `progressPercent`, `fruits`, `flowers` — **không** trả `total_hearts`.
- Nhiệm vụ MULTI_CHILD: 1 completion → 1 dòng/người (BR-022).

### 15.6 Badge evaluator

Consumer các event `MissionCompleted`, `MemoryPublished`, `AppreciationSent`, `RequestDone`, `FamilyTreeBloomed`, `CommentCreated` (Circle) → với mỗi badge ACTIVE có `rule.metric` khớp → đếm (query có index, hoặc counter Redis có đối soát) → đạt ngưỡng & chưa có → insert `family_badges` (unique) → outbox `BadgeEarned`. Huy hiệu là của **gia đình** (trừ huy hiệu ghi nhận người thân); rule không dựa trên Hearts cá nhân hay so sánh hai Parent (nghiệp vụ 7.14.3).

### 15.7 Thống kê chăm con (cấp gia đình) [1.1]

Job tuần + tính on-demand cho tuần hiện tại (cache Redis 10 phút); chỉ gói House/Family:
```sql
SELECT mc.child_id, m.category, count(DISTINCT m.id) AS done
FROM app.missions m
JOIN app.mission_completions mcpl ON mcpl.mission_id = m.id AND mcpl.undone_at IS NULL
LEFT JOIN app.mission_children mc ON mc.mission_id = m.id
WHERE m.family_id = :f AND m.status = 'DONE'
  AND m.board_date >= :weekStart AND m.board_date < :weekEnd
  AND m.target_scope <> 'COUPLE'                       -- BR-023: “Hai ta” không tính chăm con
GROUP BY 1, 2;
-- KHÔNG select/group theo completed_by, owner_user_id (BR-025)
```
Tổng family dùng `count(DISTINCT m.id)` (không nhân theo số bé); `bloomedDays` = số `daily_mission_boards.bloomed_at` trong tuần. Response luôn kèm `disclaimerKey`; không phân chia theo người, không gợi ý “ai làm ít hơn”, không push (BR-026), không dùng cho Cầu nối/AI, Circle không gọi được.

### 15.8 Lời nhờ — state machine & quy tắc (nghiệp vụ 7.16.2)

```
SENT ──mở──► SEEN ──accept──► ACCEPTED ──done──► DONE (TASK: +5 Hearts cho người làm)
  │            ├──decline──► DECLINED (không phạt; người gửi có “Tự mình làm”)
  │            └──acknowledge (NEED)──► ACKNOWLEDGED
  ├──cancel (người gửi)──► CANCELLED
  └──quá expires_at (TASK: due_at + 2h • NEED: 12h)──► EXPIRED (im lặng)
```

| Từ | Hành động | Ai | Sang | Ghi chú |
|---|---|---|---|---|
| — | gửi (`POST /us/requests`) | người gửi | `SENT` | ≤ 5 đang mở/người gửi; chặn gửi lại cùng `content_key` 12h sau `DECLINED` |
| — | “Để mình lo” (check-in) | bạn đời của người check-in | `ACCEPTED` | `kind=TASK`, `volunteered=true`, sender = người check-in, receiver = người nhận lo; không tính giới hạn 5 |
| `SENT` | seen | người nhận | `SEEN` | |
| `SENT`/`SEEN` | accept | người nhận (TASK) | `ACCEPTED` | |
| `SENT`/`SEEN` | decline `{reasonCode?}` | người nhận | `DECLINED` | luôn có “Hôm nay không được”, 0 Hearts, không phạt |
| `SENT`/`SEEN` | acknowledge `{type}` | người nhận (NEED) | `ACKNOWLEDGED` | QUIET → `quiet:user:{sender}` (khung mặc định 60 phút); TALK_TIME → `talk_at`; ENCOURAGED → kèm lời cảm ơn/động viên; 0 Hearts |
| `ACCEPTED` | done | người nhận (người làm) | `DONE` | `hearts.award(receiver, ['REQUEST', id], 'REQUEST_DONE', 5)` → `hearts_awarded`; người gửi nhận `REQUEST_DONE` + Cảm ơn |
| `SENT`/`SEEN`/`ACCEPTED` | remind-me `{at}` | người nhận | (giữ) | tối đa 1 lần (`409 REQUEST_REMINDER_USED`) |
| `SENT`/`SEEN`/`ACCEPTED` | cancel | người gửi | `CANCELLED` | |
| `SENT`/`SEEN`/`ACCEPTED` | quá `expires_at` | Hệ thống | `EXPIRED` | im lặng, 0 Hearts |
| `DECLINED` | self-do | người gửi | (giữ `DECLINED`) | tạo nhiệm vụ của tôi `TODO` (`ref_type=REQUEST`, `self_mission_id`) |

- **Hạn:** TASK `due_at` = NOW → `created_at` (lúc gửi); TODAY_AT → giờ chọn; TONIGHT → 20:00 hôm nay (`request.tonightAt`); TOMORROW → giờ chọn (mặc định 09:00 ngày mai). `due_at` phải ở tương lai (trừ NOW) và ≤ `created_at + 7 ngày` → sai `422 REQUEST_DUE_INVALID`. `expires_at = due_at + 2h`. NEED: `expires_at = created_at + 12h` (`talk_at` cũng ≤ 7 ngày).
- **Không có nút giục:** không tồn tại endpoint nhắc/giục cho người gửi; nhắc duy nhất do người nhận chọn.
- **Giờ yên tĩnh & “Cần yên tĩnh”** của người nhận: xem 13.1 bước g (`SOON` được push nếu người nhận bật `request_soon_bypass_quiet`).
- Lời nhờ **không** tạo nhiệm vụ cho người nhận và không xuất hiện trong tab nhiệm vụ (BR-070); chỉ ở US-01, US-04, thẻ Papa & Mama HOME-01, thông báo và dòng nhắc CARE-01 (`openRequestCount`).
- Hiện thực: `RequestStateMachine.transition(request, action, actor)` (map như bảng trên); sai → `409 INVALID_REQUEST_TRANSITION`; actor không phải người gửi/nhận đúng vai → `403 REQUEST_NOT_PARTICIPANT`.

---

## 16. Papa & Mama Space — mã hoá & cô lập dữ liệu

### 16.1 Envelope encryption

```
KEK (Key Encryption Key)  — trong HashiCorp Vault Transit (khuyến nghị) / KMS cloud VN / HSM
   │  wrap/unwrap
   ▼
DEK (Data Encryption Key, AES-256) — 1 cho mỗi USER (dữ liệu riêng tư) + 1 cho mỗi COUPLE (dữ liệu đã chia sẻ)
   │  lưu dạng wrapped trong us.data_keys; DEK đã unwrap cache trong RAM process ≤ 5 phút
   ▼
Ciphertext = AES-256-GCM(DEK, plaintext, iv=12 byte random, aad = "<table>:<column>:<rowId>:<ownerId>")
   lưu bytea: [version 1B][keyId 16B][iv 12B][tag 16B][ciphertext]
```

| Dữ liệu | Khoá | Ai giải mã được qua API |
|---|---|---|
| `mood_checkins.note_enc` | DEK USER | Chỉ chủ |
| `mood_checkins.shared_note_enc` | DEK COUPLE | Hai Parent |
| `requests.message_enc`, `requests.title_enc` (Lời nhờ) | DEK COUPLE | Hai Parent |
| `pregnancy_name_candidates.name_enc`, `meaning_enc` [1.1] | DEK COUPLE | Hai Parent |
| `appreciations.body_enc` | DEK COUPLE | Hai Parent |
| `journal_entries.*_enc` | DEK USER | Chỉ chủ |
| `conflict_entries.draft_enc` | DEK USER | Chỉ chủ |
| `conflict_entries.shared_points_enc` | DEK COUPLE | Hai Parent (sau khi chia sẻ) |
| `connection_answers.answer_enc` | DEK USER → khi cả hai trả lời, copy sang DEK COUPLE | |
| `auth_identities.provider_refresh_token_enc` | DEK hệ thống riêng | Chỉ service auth |

- **Crypto-shredding:** xoá tài khoản → `destroyed_at` + xoá `wrapped_dek` của USER → mọi bản sao lưu chứa ciphertext cũ trở nên vô dụng. Một Parent xoá tài khoản → nội dung couple do người đó gửi bị xoá; phần của người còn lại re-encrypt sang DEK USER của họ rồi huỷ DEK COUPLE.
- Không mã hoá đầu-cuối (E2EE) ở MVP vì cần server xử lý thông báo, AI theo yêu cầu, xuất dữ liệu; nhưng **admin/DB dump không đọc được** nếu không có quyền Vault. E2EE có thể xem xét ở 2.x cho nhật ký riêng.

### 16.2 Cô lập ở tầng code

- Module `domain/us` có repository riêng; **cấm** module khác import repository `us` (lint rule `no-restricted-imports`).
- Feed/recap/export gia đình không có quyền đọc schema `us` (dùng DB role khác cho worker export nếu tách được).
- Response DTO của partner được **whitelist**: `PartnerMoodDto {mood?, energy?, needs?, note?}` chỉ chứa trường thuộc `shared_fields`.
- Test tự động: snapshot toàn bộ JSON response các endpoint gia đình/circle → assert không chứa khoá `mood`, `journal`, `conflict`, `appreciation`, `request`.
- Tương tự cho Hearts (module `care/hearts`): repository chỉ đọc theo `ctx.userId`; snapshot response của Parent B không chứa Hearts của Parent A (6.6, 28.4).

### 16.3 Safety check

`POST /us/safety-check` chạy **cục bộ trên server** (từ điển tiếng Việt + regex có dấu/không dấu, cấu hình ở Admin) [1.1], và tuỳ chọn phân loại bằng AI [1.2] **chỉ khi** user đã bật AI. Không lưu text, không log, không gửi analytics. Client cũng có bản từ điển (tải qua `/content`) để kiểm tra offline.

---

## 17. AI module

### 17.1 Kiến trúc

```ts
interface AiProvider {
  generate<T>(req: {
    feature: AiFeature; model: string; system: string; input: string;
    schema: JSONSchema;              // structured output
    maxTokens: number; effort?: 'low'|'medium'|'high';
  }): Promise<{ data: T; usage: {input:number; output:number}; stopReason: string }>;
}
// Hiện thực: AnthropicProvider (mặc định, @anthropic-ai/sdk), có thể thêm provider khác.
```

| Feature | Model mặc định | Ghi chú |
|---|---|---|
| `REWRITE` (viết lại nhẹ nhàng) | `claude-opus-5-5` (effort `low`) | Ngắn, cần tinh tế tiếng Việt |
| `CAPTION` | `claude-opus-5-5` (effort `low`) | |
| `DAILY_STORY`, `WEEKLY_RECAP` | `claude-opus-5-5` (effort `medium`) | |
| `MISSION_RERANK` [1.2] | `claude-opus-5-5` (effort `low`) | Chạy trong job `generate-daily-board` (không có endpoint client); chỉ sắp xếp lại `pool` template có sẵn trước bước cân bằng (15.3); BR-019 do code kiểm |
| `CONFLICT_SUMMARY` | `claude-opus-5-5` (effort `medium`) | Nhạy cảm nhất |

> Model cấu hình **theo từng feature** trong `ops.app_config` (`ai.models`). Team có thể chuyển feature khối lượng lớn (caption, rerank) sang `claude-sonnet-5-5` hoặc `claude-haiku-4-5` để giảm chi phí/độ trễ **sau khi** chạy bộ đánh giá chất lượng tiếng Việt — đây là quyết định chi phí của PO/Tech Lead.

**Lưu ý khi gọi API Claude (Node SDK `@anthropic-ai/sdk`):**
- Dùng **structured outputs** (`output_config.format` với JSON schema) để nhận `{"variants":[{"style":"NEUTRAL","text":"…"}]}` thay vì parse text tự do.
- Luôn kiểm tra `stop_reason` trước khi đọc nội dung; `refusal` → trả client “Không tạo được gợi ý lúc này”, không retry vòng lặp; `max_tokens` → coi như lỗi.
- Không dùng assistant prefill (bị từ chối ở các model hiện tại).
- Timeout 20s cho feature đồng bộ; retry 1 lần với lỗi 429/5xx (SDK có `maxRetries`).
- Chính sách dữ liệu: ký thoả thuận xử lý dữ liệu (DPA) với nhà cung cấp; kiểm tra điều kiện lưu giữ dữ liệu/zero-retention của tài khoản API trước khi bật cho nội dung Papa & Mama; ghi rõ trong Chính sách quyền riêng tư & hồ sơ chuyển dữ liệu ra nước ngoài (21.4).

### 17.2 Tối thiểu hoá dữ liệu gửi AI

1. Chỉ gửi trường người dùng chọn (câu cần viết lại, chú thích các ký ức đã tick).
2. **Ẩn danh tên**: thay tên bé/Bố/Mẹ bằng token `[BÉ_1]`, `[BỐ]`, `[MẸ]` trước khi gửi, khôi phục khi nhận về.
3. Không gửi ảnh ở MVP AI; tuổi bé gửi dạng bucket (“8 tháng”).
4. Không bao giờ gửi: nhật ký riêng, nháp xung đột chưa chia sẻ, danh sách thành viên, vị trí, SĐT/email.

### 17.3 Prompt mẫu (versioned trong repo `prompts/<feature>/v<N>.md`)

```
[SYSTEM — REWRITE v3]
Bạn là trợ lý giúp một người cha/mẹ diễn đạt lại một câu nói gửi cho bạn đời bằng tiếng Việt.
- Giữ nguyên ý chính và nhu cầu của người viết; không thêm lời xin lỗi nếu họ không viết.
- Không phán xét ai đúng/sai, không chẩn đoán tâm lý, không dùng nhãn bệnh lý.
- Trả về đúng 3 phiên bản: NEUTRAL (trung tính), WARM (ấm áp), SHORT (ngắn gọn ≤ 20 từ).
- Xưng hô theo ngữ cảnh người dùng cung cấp (vd. anh/em, ba/mẹ).
- Nếu câu có dấu hiệu đe doạ, bạo lực hoặc nguy hiểm: đặt "safety": true và không viết lại.
[USER]
{"language":"vi","callNames":{"self":"[MẸ]","partner":"[BỐ]"},"text":"Anh lúc nào cũng về muộn, em làm hết mọi thứ"}
```
Output schema: `{ safety: boolean, variants: [{ style: "NEUTRAL"|"WARM"|"SHORT", text: string }] }`.

### 17.4 Kiểm soát

- Hậu kiểm output: bộ lọc từ khoá chẩn đoán (“trầm cảm”, “rối loạn”…), từ phán xét (“lỗi của”, “%”), độ dài; vi phạm → loại phiên bản đó.
- Quota theo gói: `ai_usage_monthly` (+ Redis counter); vượt → `402 AI_QUOTA_EXCEEDED`.
- Rate limit: 10 request/phút/user.
- Log `ai_logs` chỉ metadata; `promptVersion` để A/B và debug.
- Nút **Báo cáo nội dung AI** → `POST /reports {targetType: AI_OUTPUT, targetId: aiRequestId, detail}`; khi báo cáo, client gửi kèm nội dung output do người dùng tự chọn đính (có đồng ý) vì server không lưu output.

---

## 18. Billing — In-App Purchase & Entitlement

### 18.1 Cấu hình Store

| | App Store Connect | Google Play Console |
|---|---|---|
| Nhóm | Subscription Group `baby_family_premium`: Level 1 = `bf_family_yearly`, Level 2 = `bf_house_yearly` | Subscriptions `bf_house_yearly`, `bf_family_yearly`; base plan `yearly-autorenew`; product/base-plan mapping từ catalog, không trial offer |
| Dùng thử | **Không dùng Introductory Offer** — gói vẫn bán trên Store; dùng thử từ policy/version (mặc định **7 ngày**) do server **tự động cấp** khi gia đình đủ Bố + Mẹ (6.5) | Không cấu hình free trial trên base plan; trial do server cấp theo policy/version |
| Grace period | Bật Billing Grace Period (16 ngày) | Grace period + Account hold (cấu hình) |
| Thông báo server | App Store Server Notifications **V2** → `https://api.babyfamily.vn/v1/webhooks/apple/asn` (prod & sandbox URL riêng) | RTDN: Cloud Pub/Sub topic → **push subscription** tới `/v1/webhooks/google/rtdn` (xác minh OIDC token của Pub/Sub) |
| API server | App Store Server API (key .p8, issuer id, key id) | Google Play Developer API (service account có quyền tài chính) |
| Family Sharing | **Tắt** | — |

### 18.2 Luồng mua (client ↔ server)

```
1. SUB-01: GET /families/{fid}/billing/eligibility?productId=bf_family_yearly
      → {canPurchase, reason?: "FAMILY_ALREADY_HAS_PLAN"|"NOT_PAYER_UPGRADE", currentPlan, payer}
2. Server tạo purchase_intent đã bind family/license và product; client lấy giá/offer từ Store SDK (in_app_purchase), hiển thị giá Store trả về (đã địa phương hoá)
3. Mua:
   iOS (StoreKit 2): purchase với appAccountToken = purchase_intent.app_account_token (UUID server cấp)
   Android (Play Billing): setObfuscatedAccountId = sha256(users.id)[0..64]; upgrade dùng oldPurchaseToken + ReplacementMode
4. Client gửi bằng chứng:
   iOS → POST /billing/apple/transactions {signedTransactionInfo}
   Android → POST /billing/google/purchases {productId, purchaseToken}
5. Server xác minh:
   Apple: SignedDataVerifier (@apple/app-store-server-library) kiểm chữ ký JWS + chuỗi chứng chỉ Apple Root,
          bundleId, environment; lấy trạng thái đầy đủ bằng getAllSubscriptionStatuses(originalTransactionId)
   Google: purchases.subscriptionsv2.get(packageName, token) → kiểm obfuscatedExternalAccountId,
          lineItems[].productId, expiryTime, subscriptionState; nếu acknowledgementState = PENDING → acknowledge NGAY
          (không acknowledge trong 3 ngày → Google tự hoàn tiền)
6. Resolve purchase_intent đã bind family/license → verify/dedup transaction → upsert subscription + license_grant vào family gốc → recomputeEntitlement(familyId)
7. Client chỉ “finish/complete” transaction ở SDK sau khi server trả 200 (tránh mất giao dịch)
8. Trả {entitlement} → client cập nhật UI; realtime entitlement.changed cho Parent kia
```

### 18.3 Webhook

- Apple ASN V2: verify `signedPayload` → `notificationUUID` dedup (`store_notifications`) → các type chính: `SUBSCRIBED`, `DID_RENEW`, `DID_CHANGE_RENEWAL_STATUS`, `DID_CHANGE_RENEWAL_PREF` (đổi gói ở kỳ sau), `DID_FAIL_TO_RENEW` (+`GRACE_PERIOD`), `GRACE_PERIOD_EXPIRED`, `EXPIRED`, `REFUND`, `REVOKE`, `OFFER_REDEEMED` → cập nhật subscription → recompute.
- Google RTDN: payload chỉ báo token + type (`SUBSCRIPTION_PURCHASED/RENEWED/IN_GRACE_PERIOD/ON_HOLD/CANCELED/EXPIRED/REVOKED/RECOVERED/PAUSED…`) → luôn **gọi lại subscriptionsv2.get** để lấy trạng thái thật → cập nhật. `linkedPurchaseToken` → đánh dấu subscription cũ `superseded_by`.
- Mọi xử lý idempotent; lỗi → retry với backoff; backlog > 100 → alert.

### 18.4 Tính entitlement

```ts
recomputeEntitlement(familyId):            // transaction/lock PostgreSQL theo family/license
  license = family_licenses where family_id = familyId
  grants = verified license_grants of license, not revoked, valid_from <= now < valid_until
           (Store paid renewal vẫn giữ family này dù purchaser đã xóa)
  selected = highest immutable plan_versions.entitlement_rank among valid grants
  phase = license blocked ? BLOCKED
        : family not ready ? INCOMPLETE
        : selected is trial ? TRIAL
        : selected exists   ? PAID
        :                     EXPIRED
  planCode/quotas/features = selected.plan_version (không enum tên gói)
  capabilities = features intersect current membership/privacy and rollout policy
  upsert family_entitlements + access_version + outbox in one transaction
  Circle access depends on capabilities["circle.enabled"], not planCode == FAMILY

```
- **Người trả tiền xóa tài khoản:** license/subscription luôn thuộc family gốc, không chuyển kể cả CSKH. Purchaser có thể anonymize/null theo retention; renewal Store đã xác minh và thanh toán vẫn cấp grant cho family gốc. Xóa account không tự hủy auto-renew tại Store; không dùng family hiện tại của payer để bind quyền.
- **Downgrade quota:** không xoá; `QuotaGuard` chặn hành động tạo mới vượt quota.
- **Điều kiện mua (BR-055):** `GET /families/{fid}/billing/eligibility` trả `canPurchase=false, reason=FAMILY_NOT_ACTIVE` khi chưa đủ hai Parent; server từ chối tạo purchase intent mới. Giao dịch đã xác minh giữ family binding gốc kể cả lifecycle/membership đổi trước khi webhook tới; không lưu subscription owner-null rồi tự gán theo payer hiện tại. Unknown binding cần reconciliation có audit, không đoán tenant.
- **Hết trial:** job `trial-expiry` (mỗi15 phút) chọn family `access_phase=TRIAL AND trial_ends_at <= now()` → recompute từ các grant còn hiệu lực; chỉ chuyển EXPIRED nếu không còn grant khác. API kiểm expiry trực tiếp, không cho dùng thêm đến lần cron kế tiếp.

### 18.5 Restore

`POST /billing/restore`: client gửi giao dịch hiện có (iOS JWS; Android tokens) → server xác minh/dedup → resolve binding family gốc. Caller có quyền family gốc thì khôi phục entitlement ở đó; family khác trả ownership conflict, không chuyển license, không tạo grant/trial trùng. Giao dịch mới bind qua purchase intent được server tạo trước purchase, không theo family đang chọn khi webhook tới.

### 18.6 Môi trường test

- iOS: StoreKit Configuration file (local), Sandbox tester, TestFlight; Android: license testers, internal testing track, test card. Staging backend dùng webhook URL sandbox riêng.

---

## 19. Tìm kiếm, Timeline, Recap

### 19.1 Tìm kiếm

- PostgreSQL FTS (`search_tsv` đã `unaccent`, config `simple`) + `pg_trgm` cho gần đúng tên album/cột mốc. Query: `plainto_tsquery('simple', unaccent(:q))` + điều kiện quyền (6.3) + filter.
- Đủ cho MVP (quy mô hàng chục nghìn ký ức/family). Khi cần semantic search [2.x] → `pgvector` với embeddings chỉ của nội dung đã chia sẻ, opt-in.

### 19.2 Timeline ghép thẻ hệ thống

Server ghép vào kết quả timeline các “thẻ ảo” không lưu DB: tròn tháng, chào đời, đầy tháng/100 ngày/thôi nôi (theo date_rule + âm lịch nếu chọn), sinh nhật, phân cách tuần thai, recap đã lưu, thư niêm phong. Thẻ ảo có `id` xác định (`sys:monthiversary:{childId}:{n}`) để client cache ổn định.

**Chương tháng (chế độ bé, 7.10):** timeline của bé chèn thẻ `sys:chapter:{childId}:{monthIndex}` mở đầu mỗi tháng tuổi: bìa = `monthly_photos` của tháng (null → khung “Thêm ảnh tháng N”), khoảng ngày, `memoryCount` / `firstsCount` / `quotesCount` lấy theo `memory_children.age_month` (index `ix_mc_child_month`) — đếm theo quyền người xem; thẻ “Tổng kết tháng” nếu recap MONTH_AGE đã lưu. Thẻ `QUOTE` (trích dẫn lớn, tuổi tại ngày xảy ra), huy hiệu “Cả hai cùng kể” (`perspective_count > 0`, với Circle chỉ tính góc nhìn không ẩn), `feeling`, `people[]` đi kèm thẻ.

### 19.3 Âm lịch Việt Nam

- Module `libs/core/lunar-vn` hiện thực thuật toán chuyển đổi âm–dương (Hồ Ngọc Đức) với **timeZone = 7.0**; có bảng test đối chiếu các năm lệch với lịch Trung Quốc.
- Client Flutter dùng cùng thuật toán (port Dart) để hiển thị offline; server là nguồn đúng cho nhắc nhở.
- Tháng nhuận: nếu đầy tháng/thôi nôi rơi vào tháng nhuận → theo lựa chọn gia đình (mặc định tháng thường).

### 19.4 Recap

- Weekly: query ký ức PUBLISHED trong tuần (Parent view), chọn tối đa 10 ảnh nổi bật theo điểm = reactions×2 + comments + is_milestone×5 + có chú thích; stats tích cực (số ngày cây nở hoa, cấp Cây gia đình); `content_parents_only` gồm số lời cảm ơn/lời nhờ đã xong (từ `us`, chỉ đếm chung, không nội dung, không theo người). Recap **không** chứa Hearts (cá nhân hay tổng) và không so sánh hai Parent (BR-018).
- Recap share cho Circle: lọc lại theo quyền **từng người xem** khi họ mở (không chụp cứng danh sách).
- Ảnh tổng kết (story image) render server-side bằng `@napi-rs/canvas`/`satori` [1.1].

### 19.5 Hôm nay của con, Bộ sưu tập, Gợi ý ghi lại, Ảnh tháng

**Hôm nay của con (7.8.9):** không materialize — truy vấn `memories` `PUBLISHED`, `occurred_local_date = hôm nay` (index `ix_mem_today`) theo bé (`memory_children`) hoặc thai kỳ, **áp điều kiện quyền 6.3 của người xem** (Circle chỉ thấy ký ức được phép). `unseen = EXISTS(ký ức có published_at > story_views.seen_until ∧ author ≠ người xem)`; xem xong client gọi `…/seen {seenUntil}` (giữ giá trị lớn nhất — AC-028). Realtime `story.hint` khi có ký ức mới hôm nay.

**Bộ sưu tập (7.8.4):** ảo, không lưu bảng; mỗi `code` là 1 predicate trên `memories` + điều kiện quyền:

| code | Predicate |
|---|---|
| `MONTHLY` | JOIN `monthly_photos` (ảnh chính) |
| `FIRSTS` | JOIN `milestones` (`deleted_at IS NULL`) |
| `QUOTES` / `VOICES` / `KEEPSAKES` / `LETTERS` | `kind = QUOTE` / `VOICE` / `KEEPSAKE` / `LETTER` (thư niêm phong trả dạng rút gọn 6.3) |
| `TOLD_TOGETHER` | `perspective_count > 0` (Circle: EXISTS góc nhìn `hidden_from_circle = false`) |
| `SIBLINGS` | `(SELECT count(*) FROM memory_children WHERE memory_id = m.id) ≥ 2` (Circle: ≥ 2 bé **được grant**) |
| `VIDEOS` | EXISTS asset `kind = VIDEO` |
| `MY_FAVORITES` | `favorites.user_id = người gọi` |
| `FAMILY_BEST` | JOIN `v_family_best_memories` — chỉ Parent |
| `FROM_CIRCLE` | `author_role = CIRCLE` |
| `PREGNANCY` | `pregnancy_id = :id` |

Số lượng/bìa của thẻ tính theo người xem, cache Redis 5 phút theo `(family, viewerScope, subject)`.

**Gợi ý ghi lại (7.8.8, BR-073):**
```
pickPrompt(user, family, date):                 // job 06:00 hoặc lười khi GET today
  if !user_settings.memory_prompts_enabled: return null
  if EXISTS delivery(user, date, status ∈ {SHOWN, USED, DISMISSED}): return delivery hiệu lực (DISMISSED → null)
  subjects = bé/thai kỳ ACTIVE của family (Parent luôn thấy hết)
  pool = templates ACTIVE khớp tuổi/tuần thai của ≥ 1 subject
         ∧ code ∉ delivery(user, date − 30 … date − 1)            // không lặp 30 ngày
  t = weightedRandom(pool, seed = hash(user, date, seq)); subject = subject khớp, ưu tiên bé ít ký ức 7 ngày qua
  INSERT delivery(SHOWN) ON CONFLICT (uq_prompt_day) DO NOTHING → trả dòng hiện có nếu tranh chấp
next(delivery): seq < prompts.maxNextPerDay (mặc định 3) → REPLACED + pickPrompt (loại template vừa REPLACED)
dismiss(delivery): DISMISSED → hết hôm nay; used(delivery, memoryId): USED
```
Văn bản render `pickI18n(text_i18n, locale)` với `{childName}`; catalog được Content duyệt (không câu gây tội lỗi) + test lint từ khoá.

**Ảnh tháng (7.8.7, BR-072):** `month_index` = số tháng tròn giữa `birth_date` và ngày chụp (`occurred_local_date`) theo lịch dương (hoặc âm nếu `monthly_photo_lunar`); tháng 0 = ảnh chào đời. Bỏ lỡ ngày tròn tháng vẫn thêm được cho mọi ô (ô quá khứ trống ở MEM-20). Đặt ảnh chính = `INSERT … ON CONFLICT (child_id, month_index) WHERE child_id IS NOT NULL DO UPDATE SET memory_id, asset_id, sticker, set_by, set_at` — 2 request song song vẫn còn đúng 1 dòng; ký ức cũ không bị đổi.

---

## 20. Vòng đời dữ liệu: xoá, xuất, lưu giữ

### 20.1 Xoá tài khoản (deletion orchestration)

```
POST /me/deletion {familyChoice, sharedContentChoice, reauthToken}
  → validate: nếu là Parent duy nhất → familyChoice ∈ {DELETE_FAMILY}; nếu có partner → PARTNER_CONTINUES
  → users.status = DELETION_PENDING; revoke tất cả sessions; xoá push tokens; token_version++
  → deletion_requests(execute_after = now()+30d); email/SMS xác nhận (nếu có)
  → nếu payer: hiển thị hướng dẫn huỷ subscription trong Store (server không huỷ được)
Đăng nhập lại trong 30 ngày → hỏi khôi phục → cancel → ACTIVE

deletion-executor (khi đến hạn), từng bước idempotent, lưu tiến độ vào steps:
  1. Apple: POST https://appleid.apple.com/auth/revoke với refresh token đã lưu (nếu có)
  2. us.*: xoá journal, mood, conflict entries của user; xoá DEK USER (crypto-shred)
     couple_space → UNLINKED; dữ liệu couple đã chia sẻ (gồm us.requests): xoá phần do user gửi
  3. Circle memberships → LEFT
  4. Nội dung gia đình do user tạo:
       KEEP_ANONYMIZED → author hiển thị "Người dùng đã rời" (giữ author_user_id trỏ user đã xoá)
       DELETE → memories TRASHED→PURGED ngay, comments xoá; góc nhìn thứ hai của user theo cùng lựa chọn
     memory_people.user_id của user → display_name “Người dùng đã rời”
     heart_ledger / heart_daily_counters của user: giữ dòng (user đã ẩn danh) để Cây gia đình không tụt cấp;
       không ai khác đọc được (6.6); missions của user còn TODO → REMOVED
  5. Nếu DELETE_FAMILY: xoá toàn bộ family (memories, assets, children, missions, circle…) theo batch
     → purge object MinIO theo prefix fam/{familyId}/
  6. Parent: family_parents.status = LEFT; family → PARTNER_LEFT (nếu còn partner) → recompute entitlement
  7. users: xoá PII (display_name → "Người dùng đã rời", avatar, auth_identities, consents giữ bản ghi
     tối thiểu theo luật), status = DELETED
  8. Mongo: xoá notifications của user; audit giữ (đã pseudonymize)
  9. Đánh dấu COMPLETED; gửi xác nhận (nếu còn kênh)
```
- Trang web xoá tài khoản (Google Play yêu cầu): `https://babyfamily.vn/xoa-tai-khoan` → đăng nhập OTP/Apple/Google trên web → cùng API.
- Backup: dữ liệu đã xoá tồn tại trong backup tối đa 35 ngày rồi tự hết theo vòng quay backup; ciphertext Papa & Mama vô dụng do crypto-shred.

### 20.2 Xuất dữ liệu

- Job `export`: stream từ DB → tạo ZIP trực tiếp lên MinIO (multipart, không giữ cả file trong RAM — dùng `archiver` + `@aws-sdk/lib-storage`).
- Cấu trúc ZIP gia đình: `/media/{yyyy}/{yyyy-mm-dd}_{memoryId}_{n}.jpg`, `/monthly/{tênBé}/{MM}_thang.jpg` (ảnh tháng chính, không burn sticker), `/memories.json` (gồm góc nhìn thứ hai, “Ai ở đó”, cảm xúc, câu nói), `/memories.csv`, `/children.json`, `/milestones.json`, `/index.html` (xem offline).
- Cá nhân: thêm `/my_private/journal.json`, `moods.json`, `appreciations.json`, `requests.json` (lời nhờ mình gửi/nhận, giải mã), `name_candidates.json` (tên dự định, nếu có), `hearts.json` (**chỉ Hearts của chính mình**).
- ZIP gia đình **không** chứa Hearts cá nhân hay Lời nhờ (chỉ cấp Cây gia đình); nhiệm vụ xuất kèm trạng thái, không kèm Hearts.
- Link tải presign 24h, file tự xoá sau 7 ngày; giới hạn theo gói.

### 20.3 Bảng lưu giữ

| Dữ liệu | Thời hạn |
|---|---|
| Ký ức/ảnh | Đến khi xoá; thùng rác 30 ngày |
| Asset chưa gắn | 24 giờ |
| Mood | Đến khi người dùng xoá (hiển thị “hiện tại” 6h) |
| Phiên Cầu nối | 0/7/30/90 ngày sau đóng (mặc định 30) |
| Lời mời | Hết hạn 7/14 ngày, xoá bản ghi sau 90 ngày |
| Thông báo inbox | 90 ngày |
| Log AI (metadata) | 90 ngày |
| Audit log | 2 năm |
| Analytics thô | 13 tháng |
| Backup DB | 35 ngày (PITR 14 ngày) |
| Object version cũ | 30 ngày |
| Tài khoản chờ xoá | 30 ngày |
| Dữ liệu giao dịch (subscription) | Theo luật kế toán/thuế (giữ tối thiểu, không gồm nội dung) |

---

## 21. Bảo mật & tuân thủ

### 21.1 Threat model & giảm thiểu

| Mối đe doạ | Tác động | Giảm thiểu |
|---|---|---|
| Link mời bị lộ/chuyển nhầm | Người lạ xem ảnh bé | Token 256-bit hash, dùng 1 lần, TTL, duyệt cuối (partner), preview tối thiểu, rate limit `/invites/resolve` (10/phút/IP), thông báo Parent khi có người tham gia |
| IDOR (đoán UUID) | Lộ dữ liệu chéo gia đình | AccessContext mọi request, 404 cho resource ngoài family, composite FK, test ma trận |
| Bucket public / URL lộ | Lộ hàng loạt | Bucket private + policy deny public; presign sau kiểm quyền; TTL 1h; key không đoán được |
| Admin tò mò | Lộ dữ liệu Papa & Mama | DB role admin không có quyền schema `us`; mã hoá cấp ứng dụng; case-based access; audit; MFA |
| Mất điện thoại | Truy cập trái phép | Token trong Keychain/Keystore, khoá app sinh trắc, đăng xuất từ xa, refresh rotation |
| SMS pumping/OTP brute force | Chi phí, chiếm tài khoản | Rate limit đa tầng, captcha khi bất thường, 5 lần sai, OTP 5 phút |
| Lộ dữ liệu qua AI | Rò rỉ tâm sự | Chỉ gửi khi user bấm, ẩn danh tên, không log nội dung, DPA |
| Lộ GPS trong ảnh | Lộ địa chỉ nhà | Strip GPS mọi bản lưu/phát |
| Cache còn sau khi bị gỡ | Vi phạm quyền | `access.changed` → client purge; URL hết hạn ≤ 1h; sync tombstones `audience=CIRCLE` |
| CSAM / lạm dụng | Pháp lý nghiêm trọng | Báo cáo ưu tiên, ẩn ngay, quy trình pháp lý, không có chia sẻ công khai |
| Webhook giả mạo | Cấp gói trái phép | Xác minh JWS Apple / OIDC Pub/Sub; luôn gọi lại Store API |
| Injection/XSS (admin CMS hiển thị nội dung người dùng) | Chiếm phiên admin | Escape mặc định React, CSP chặt, admin trên domain riêng + IP allowlist/VPN |
| Supply chain | Mã độc | Lockfile, `npm audit`/Dependabot, Trivy quét image, pin base image theo digest |

### 21.2 Hardening

- TLS 1.2+ (ưu tiên 1.3), HSTS, OCSP stapling; chứng chỉ Let's Encrypt/cert thương mại tự gia hạn.
- Nginx: `client_max_body_size 2m` cho API (media không đi qua API), timeouts, `limit_req` theo IP, chặn method lạ.
- NestJS: `helmet`, CORS chỉ cho admin & web domain, `ValidationPipe({whitelist:true, forbidNonWhitelisted:true})`, giới hạn độ sâu JSON.
- DB/Redis/Mongo/MinIO **không public**, chỉ trong private network; user DB riêng cho từng process theo least privilege.
- Secrets: Docker secrets / Vault; xoay khoá định kỳ (JWT signing key có `kid`, hỗ trợ 2 khoá song song khi xoay).
- Mobile: MASVS L1 — không log token, `android:allowBackup="false"` (hoặc rules loại trừ dữ liệu nhạy cảm), network security config chỉ HTTPS, obfuscate Dart (`--obfuscate --split-debug-info`), không nhúng secret trong app. Certificate pinning: **không bật ở MVP** (rủi ro brick app khi đổi cert) — cân nhắc pin public key CA trung gian ở 2.x.
- Admin: 2FA TOTP bắt buộc, session 8h, IP allowlist, mọi thao tác audit.
- Pentest độc lập trước khi phát hành; bug bounty sau.

### 21.3 Rate limit mặc định

| Route | Giới hạn |
|---|---|
| `/auth/phone/otp` | 5/giờ/số, 20/giờ/IP |
| `/auth/*` khác | 30/phút/IP |
| `/invites/resolve`, `/invites/accept` | 10/phút/IP, 30/giờ/user |
| Tạo lời mời | 5/ngày/family (partner), 30/ngày/family (circle) |
| `POST /memories`, upload-intents | 120/giờ/user |
| Bình luận | 30/phút/user |
| AI | 10/phút/user + quota tháng |
| Báo cáo | 20/giờ/user |
| `POST /us/requests` | 20/giờ/user (ngoài giới hạn nghiệp vụ 5 lời nhờ đang mở) |
| `GET /missions/{id}/swap-options` | 30/giờ/user |
| Mặc định | 600/phút/user |

### 21.4 Tuân thủ pháp lý Việt Nam (checklist — cần luật sư xác nhận)

- **Luật Bảo vệ dữ liệu cá nhân (số 91/2025/QH15, hiệu lực 01/01/2026)** và các nghị định hướng dẫn (thay thế/kế thừa Nghị định 13/2023/NĐ-CP):
  - Thu thập **đồng ý** rõ ràng, tách bạch theo mục đích (tài khoản, dữ liệu của con, AI, marketing) — bảng `user_consents` lưu phiên bản & thời điểm.
  - Dữ liệu của **trẻ em** là nhóm cần bảo vệ đặc biệt — app adult-directed, cha mẹ là người cung cấp & đồng ý thay cho con.
  - Lập **hồ sơ đánh giá tác động xử lý dữ liệu cá nhân** và (nếu có) **hồ sơ chuyển dữ liệu ra nước ngoài** (FCM/Google, Apple, nhà cung cấp AI, Sentry SaaS…) theo mẫu & thủ tục của cơ quan chuyên trách.
  - Quyền của chủ thể: truy cập, chỉnh sửa, xoá, rút đồng ý, xuất dữ liệu — đã có chức năng.
  - Thông báo vi phạm dữ liệu theo thời hạn luật định → quy trình incident response.
  - Chỉ định bộ phận/nhân sự bảo vệ dữ liệu.
- **Lưu trữ dữ liệu tại Việt Nam:** khuyến nghị host DB + object storage tại data center VN (Viettel IDC, FPT, VNG, CMC…) — đơn giản hoá nghĩa vụ theo Luật An ninh mạng & Nghị định 53/2022 và tăng niềm tin.
- **Dịch vụ có nội dung người dùng tạo:** rà soát với luật sư xem ứng dụng chia sẻ riêng tư trong gia đình có thuộc diện quản lý dịch vụ mạng xã hội theo Nghị định 147/2024/NĐ-CP hay không và nghĩa vụ đi kèm.
- **Thanh toán qua Store:** nghĩa vụ thuế với doanh thu qua Apple/Google — kế toán xác nhận.
- **Quốc tế (khi mở rộng):** GDPR (EU), COPPA (Mỹ — giữ adult-directed, không có tài khoản trẻ em).

---
## 22. Ứng dụng Flutter

> **Base đã dựng (07/10/2026):** `baby-family-app/` theo kiến trúc base hanoicheck — auto_route + hooks_riverpod/flutter_hooks + dio/retrofit + freezed + hive, cấu trúc `lib/data/{dto,model,remote,repository,repository_imp,service,service_imp,provider}`, `lib/page/{general,parent,circle}/<screen>/`, `lib/utils/{constants,helper,router,widget}`. Quy tắc chi tiết: `baby-family-app/AGENTS.md` và `.skills/`. **Khi mục 22.1–22.9 dưới đây (thiết kế ban đầu: go_router, drift, riverpod_generator) khác với base, base project và `.skills` là chuẩn.**

### 22.1 Cấu trúc (feature-first, phân lớp)

```
lib/
  main_dev.dart | main_staging.dart | main_prod.dart      # flavors
  app/
    app.dart                  # MaterialApp.router, theme, l10n
    router/                   # go_router: routes.dart, guards.dart, deeplinks.dart
    bootstrap/                # init Sentry, Firebase (FCM), drift, dio, secure storage
  core/
    api/                      # dio, interceptors, client sinh từ OpenAPI (package riêng: packages/bf_api)
    auth/                     # token store, refresh, session state
    db/                       # drift database, tables, DAOs
    sync/                     # outbox runner, delta sync, connectivity
    media/                    # picker, heic convert, hashing, upload manager (background)
    push/                     # FCM, local notifications, routing từ notification
    design/                   # tokens, theme, components (BfButton, BfCard, ChildChip…)
    l10n/                     # ARB vi/en (flutter gen-l10n)
    lunar/                    # âm lịch VN (UTC+7)
    utils/                    # age formatter, date, result types
    analytics/                # privacy-first event logger
  features/
    onboarding/  auth/  invite/  home/  child_switcher/  memories/  pregnancy/
    children/  care/  calendar/  us/  family/  circle/  recap/  notifications/
    billing/  settings/  safety/  search/
      └── <feature>/
            data/            # repositories (API + drift), DTO mapping
            domain/          # models (freezed), rules thuần (vd. tuổi bé, validate phạm vi nhiệm vụ)
            application/     # Riverpod providers/notifiers (state + use cases)
            presentation/    # screens, widgets
packages/
  bf_api/                    # Dart client sinh từ OpenAPI (openapi-generator dart-dio) — CI cập nhật
```

### 22.2 Thư viện (chọn bản đang được bảo trì tại thời điểm khởi tạo)

| Mục đích | Package |
|---|---|
| State/DI | `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator` |
| Router | `go_router` |
| Model | `freezed`, `json_serializable` |
| HTTP | `dio` (+ client sinh từ OpenAPI) |
| Local DB | `drift`, `sqlite3_flutter_libs` |
| Secure storage | `flutter_secure_storage` |
| Ảnh | `image_picker` (multi + Android Photo Picker), `flutter_image_compress` (HEIC→JPEG, resize), `extended_image`/`photo_view` (zoom) |
| Hash | `crypto` (sha256 stream trong isolate) |
| Upload nền | `background_downloader` (hỗ trợ upload nền iOS URLSession / Android WorkManager) |
| Cache ảnh | `cached_network_image` + `flutter_cache_manager` (cacheKey ổn định) |
| Video | `video_player` (+ `chewie` nếu cần UI) |
| Âm thanh | `record` (ghi), `just_audio` (phát) |
| Push | `firebase_core`, `firebase_messaging`, `flutter_local_notifications` |
| Deep link | `app_links` |
| IAP | `in_app_purchase` (đảm bảo dùng StoreKit 2 trên iOS) |
| Đăng nhập | `sign_in_with_apple`, `google_sign_in` |
| Sinh trắc | `local_auth` |
| Chia sẻ | `share_plus`; QR: `qr_flutter`, quét: `mobile_scanner` |
| Kết nối mạng | `connectivity_plus` |
| i18n | `flutter_localizations`, `intl` |
| Blurhash | `flutter_blurhash` |
| Lỗi/crash | `sentry_flutter` |
| Kiểm thử | `flutter_test`, `mocktail`, `patrol` (E2E) |

> **Tránh** `ffmpeg_kit_flutter` (dự án gốc đã ngừng phát hành 2025) — không nén video trên máy ở MVP; giới hạn thời lượng khi chọn (`maxDuration`) và để server transcode.

### 22.3 State & ngữ cảnh

```dart
// Phiên đăng nhập
@riverpod class Session extends _$Session { /* unauthenticated | authenticated(user) | expired */ }

// Gia đình hiện tại (từ /families/{fid}/bootstrap; refresh khi access.changed/entitlement.changed)
@riverpod class FamilyContext extends _$FamilyContext { /* family, me(role,slot), parents, subjects, entitlement, accessVersion */ }

// Bé đang chọn — CHỈ là preference hiển thị, không phải quyền
@riverpod class SelectedSubject extends _$SelectedSubject {
  // ALL | child(id) | pregnancy(id); lưu SharedPreferences theo familyId;
  // nếu subject không còn trong FamilyContext.subjects → về ALL
}

// Provider dữ liệu luôn nhận (familyId, subjectFilter) → cache key khác nhau, không lẫn bé
@riverpod Future<Page<MemoryCard>> timeline(Ref ref, TimelineQuery q) { ... }
```
- Màn Papa & Mama **không** watch `SelectedSubject`.
- **Chăm con:** `MissionBoard(fid, date, tab)` (3 tab Của tôi / Của {bạn đời} / Cùng nhau); tab bạn đời dùng model `PartnerMission` **không có trường hearts** (không thể hiển thị nhầm); `MyHearts(fid)` chỉ dùng ở tab Của tôi, CARE-06, CARE-09 và **không** lưu xuống đĩa; `FamilyTree(fid)` chỉ có cấp + %; `OpenRequests` cho dòng nhắc CARE-01, thẻ HOME-01, US-01. Hoàn thành offline: ✓ + lá hiện lạc quan, số “+N 💗” chỉ hiện khi server trả `myHeartsAwarded`.
- **Trang chủ & ký ức:** `HomeBlocks(fid, subject)` render đúng thứ tự `blocks[]` từ server (11.9); `TodayStories(fid, date)` cập nhật `unseen` lạc quan khi xem xong rồi gọi `…/seen`; `MonthlyPhotos(childId, year)`; `Collections(fid, subject)`; `MemoryPrompt(fid)`; `Chapters(childId)`. Sticker tháng vẽ bằng widget overlay (không ghi vào file ảnh); camera MEM-21 hiển thị bóng mờ ảnh tháng trước (opacity chỉnh được).
- **Lời nhờ:** `RequestComposer`, `RequestDetail(id)` — không provider nào của tab nhiệm vụ đọc lời nhờ (chỉ `openRequestCount`).
- Mọi provider phụ thuộc `FamilyContext.accessVersion` → khi version đổi, invalidate toàn bộ cache theo family.

### 22.4 Router & guard

```dart
GoRouter(
  initialLocation: '/splash',
  redirect: (ctx, state) => guard(session, family, state),   // xem bảng
  routes: [
    GoRoute(path: '/splash', ...), GoRoute(path: '/welcome', ...),
    GoRoute(path: '/auth', ...),   GoRoute(path: '/auth/phone', ...), GoRoute(path: '/auth/otp', ...),
    GoRoute(path: '/auth/profile', ...),
    GoRoute(path: '/onboarding/:step', ...),
    GoRoute(path: '/invite', ...),                     // ?token= hoặc nhập mã
    StatefulShellRoute.indexedStack(branches: [         // Parent shell
      branch('/home'), branch('/memories'), branch('/care'), branch('/us'),
    ]),                                                 // nút + mở QuickCreate sheet, không phải route tab
    StatefulShellRoute.indexedStack(branches: [         // Circle shell
      branch('/c/home'), branch('/c/memories'), branch('/c/me'),
    ]),
    GoRoute(path: '/memory/:id', ...), GoRoute(path: '/mission/:id', ...), ... // full-screen routes
    GoRoute(path: '/story/:subjectType/:id', ...), GoRoute(path: '/child/:id/monthly', ...),   // MEM-25, MEM-20
  ],
);
```

| Guard | Điều kiện | Chuyển tới |
|---|---|---|
| Chưa đăng nhập | route ≠ welcome/auth/invite | `/welcome` (giữ `pendingInvite`) |
| Chưa có hồ sơ cơ bản | | `/auth/profile` |
| Có `pendingInvite` | | `/invite?token=…` |
| `onboarding_role = null` (không có lời mời) | | `/onboarding/role` (ONB-03) |
| Vai trò CIRCLE, chưa có gia đình | mọi route | `/c/waiting` (CIR-WAIT) |
| Vai trò Parent, chưa có gia đình | | `/onboarding/family-name` (ONB-06) |
| `familyStatus = WAITING_PARTNER` | mọi route ngoài `/onboarding/waiting`, `/settings/account` | `/onboarding/waiting` (ONB-WAIT) |
| Vừa kích hoạt, chưa thiết lập bé/thai kỳ | | `/onboarding/activated` → `/onboarding/stage` |
| `accessPhase = EXPIRED` (Parent) | mọi route ngoài `/billing/*`, `/settings/data|account|help` | `/billing/expired` (SUB-07) |
| Role = CIRCLE | route Parent (`/care`, `/us`, `/family/*`, `/billing`) | `/c/home` |
| Circle bị tạm dừng (`FAMILY_SHARING_PAUSED`) | | `/c/paused` |
| `/us/*` mà chưa linked | | `/us/locked` |
| Khoá app bật & vừa resume | | overlay khoá |
| `426 UPGRADE_REQUIRED` | | `/upgrade-required` |

### 22.5 Networking

Interceptor theo thứ tự: `RequestIdInterceptor` (X-Request-Id) → `HeadersInterceptor` (Accept-Language, X-App-Version, X-Platform, X-Timezone) → `AuthInterceptor` (gắn access, 401 → refresh **đơn luồng** bằng mutex rồi retry 1 lần; refresh fail → logout) → `IdempotencyInterceptor` (POST đánh dấu cần idempotency: tự sinh key UUIDv4 và **giữ nguyên khi retry**) → `ErrorMapper` (map `error.code` → exception có kiểu, `messageKey` → chuỗi l10n).

### 22.6 Offline & đồng bộ

**Drift tables (rút gọn):** `subjects`, `memory_cards` (familyId, scopeKey, sortKey, json), `memory_details`, `mission_board` (familyId, date, tab, json — không lưu `myHeartsToday`), `us_today` (đã giải mã? → **không lưu** dữ liệu Papa & Mama chi tiết xuống đĩa; chỉ cache RAM), `pending_ops`, `sync_state` (familyId, cursor), `upload_tasks`.

**Outbox phía client (`pending_ops`):**
| Trường | Ý nghĩa |
|---|---|
| `id`, `createdAt` | |
| `type` | `CREATE_MEMORY`, `COMPLETE_MISSION`, `COMMENT`, `REACTION`, `CHECKIN`(chỉ khi user đã bấm Gửi), … |
| `payload` | JSON request (chứa `localId`) |
| `idempotencyKey` | cố định suốt vòng đời op |
| `dependsOn` | vd. CREATE_MEMORY phụ thuộc các `upload_tasks` |
| `status`, `attempts`, `lastError` | |

- Runner chạy khi có mạng (connectivity + app foreground hoặc background fetch), FIFO theo family; lỗi 4xx nghiệp vụ (403/404/422) → **dừng op đó và báo người dùng** (vd. “Bạn không còn quyền đăng ảnh vào gia đình này”), không retry; 5xx/timeout → backoff.
- UI optimistic: ký ức tạo offline hiện ngay với `localId` + badge “Đang chờ gửi”; server trả `id` thật → thay thế.
- Mood check-in: chỉ xếp hàng khi người dùng đã bấm **Gửi**; nếu > 6 giờ chưa gửi được → hỏi lại (mood có thể đã cũ).

**Delta sync:** `GET /families/{fid}/sync?cursor=…` → 
```json
{ "changes": [ {"type":"MEMORY","id":"…","version":7,"op":"UPSERT"},
               {"type":"MEMORY","id":"…","op":"DELETE"},
               {"type":"CHILD","id":"…","op":"UPSERT"} ],
  "nextCursor": "…", "fullResync": false, "accessVersion": 42 }
```
- Nguồn: `updated_at` của các bảng chính + `ops.sync_tombstones` (xoá, thu hồi quyền). Server lọc theo quyền người gọi.
- `fullResync=true` khi cursor quá cũ (> 30 ngày) hoặc `accessVersion` thay đổi → client xoá cache family và tải lại.
- Gọi khi: mở app, quay lại foreground, nhận realtime `sync.hint`, nhận push.

### 22.7 Upload manager

1. Chọn ảnh → isolate: HEIC→JPEG (`flutter_image_compress`, quality 92, giữ kích thước gốc), đọc w/h, tính sha256 (stream).
2. `upload-intents` (theo lô) → nếu `existingAssetId` → bỏ qua upload.
3. `background_downloader` enqueue PUT (single/part) với `taskId = assetId[:part]`; tiếp tục khi app bị đóng (iOS background URLSession; Android WorkManager — cần quyền thông báo foreground service cho video lớn).
4. Xong → `complete`; lỗi URL hết hạn → xin lại `parts`.
5. Tiến độ hiển thị trên thẻ ký ức (MEM-06); retry thủ công.
6. Giới hạn đồng thời: 3 file; chỉ Wi-Fi cho video > 100MB (tuỳ chọn trong Cài đặt).

### 22.8 Push & deep link

- Đăng ký token sau khi người dùng đồng ý (ONB-10), cập nhật khi `onTokenRefresh`, gửi kèm `timezone`, `locale`.
- Foreground: hiển thị in-app banner (không trùng hệ thống); data `deepLink` → `router.go()`.
- Cold start từ notification: lưu intent → sau bootstrap mới điều hướng (đảm bảo family context đã có).
- Universal/App Links: `https://babyfamily.vn/i/{token}` → `app_links` → `/invite?token=`. File `/.well-known/apple-app-site-association` và `/.well-known/assetlinks.json` host trên web; trang web fallback hiển thị nút Store + “Mở trong app”.

### 22.9 Design tokens trong code

```dart
@immutable
class BfColors extends ThemeExtension<BfColors> {
  final Color bg, surface, surfaceVariant, border, textPrimary, textSecondary, textTertiary;
  final Color primary500, primary600, primary100, secondary500, accent500, accent100;
  final Color us50, us100, us500, us700, success, warning, error, info;
  final List<Color> childPalette; // 8 màu nhận diện bé
  const BfColors({...});
  static const light = BfColors(
    bg: Color(0xFFFFFBF7), surface: Color(0xFFFFFFFF), surfaceVariant: Color(0xFFF7F1EC),
    border: Color(0xFFEADFD6), textPrimary: Color(0xFF2E2A27), textSecondary: Color(0xFF6B625B),
    textTertiary: Color(0xFF9C928A), primary500: Color(0xFFEE7B67), primary600: Color(0xFFC2513F),
    primary100: Color(0xFFFFE3DC), secondary500: Color(0xFF6FAE8E), accent500: Color(0xFFF4BF5C),
    accent100: Color(0xFFFDF1D6), us50: Color(0xFFF6F2FC), us100: Color(0xFFEAE2F8),
    us500: Color(0xFF9B85D1), us700: Color(0xFF6A549F), success: Color(0xFF3E9B6E),
    warning: Color(0xFFD98E1F), error: Color(0xFFD14B4B), info: Color(0xFF3F82BF),
    childPalette: [Color(0xFFFFB59E), Color(0xFF9EDCC4), Color(0xFF9CCBF2), Color(0xFFC7B3F0),
                   Color(0xFFF7DD86), Color(0xFFF5A8C0), Color(0xFFE6C9A8), Color(0xFF8FD8DE)],
  );
  static const dark = BfColors(/* theo bảng 10.2 tài liệu nghiệp vụ */);
  // copyWith / lerp …
}

abstract final class BfRadius { static const xs = 6.0, sm = 10.0, md = 14.0, lg = 16.0, xl = 20.0, x2l = 28.0, full = 999.0; }
abstract final class BfSpace  { static const s1 = 4.0, s2 = 8.0, s3 = 12.0, s4 = 16.0, s5 = 20.0, s6 = 24.0, s8 = 32.0, s10 = 40.0, s12 = 48.0; }
// Typography: fonts đóng gói trong assets/fonts (Nunito 700/800, Be Vietnam Pro 400/500/600)
// TextTheme map theo bảng 10.3; nhân MediaQuery.textScaler * user.textScale (chế độ chữ lớn)
```
- Mọi widget dùng token qua `context.bfColors`, không hard-code màu.
- Widgetbook/Storybook nội bộ cho component library (khuyến nghị) để designer review.

### 22.10 Bảo mật & dữ liệu trên máy

- Refresh token: `flutter_secure_storage` (iOS Keychain `first_unlock_this_device`, Android EncryptedSharedPreferences/Keystore).
- Drift DB: không lưu dữ liệu Papa & Mama; cân nhắc SQLCipher (`sqlcipher_flutter_libs`) nếu lưu nhiều nội dung nhạy cảm offline.
- Đăng xuất / bị gỡ khỏi gia đình / xoá tài khoản → xoá DB family, cache ảnh, upload queue, secure storage (trừ cờ cài đặt chung).
- Ẩn nội dung khi vào app switcher (iOS: overlay blur khi `inactive`; Android: `FLAG_SECURE` chỉ cho màn Papa & Mama/Nhật ký riêng nếu người dùng bật khoá).

### 22.11 Cấu hình nền tảng

**iOS** (`Info.plist`): `NSPhotoLibraryUsageDescription` (PHPicker không cần quyền đọc toàn thư viện — chỉ cần khi lưu ảnh: `NSPhotoLibraryAddUsageDescription`), `NSCameraUsageDescription`, `NSMicrophoneUsageDescription`, `NSFaceIDUsageDescription`; Associated Domains `applinks:babyfamily.vn`; Push + Background Modes (remote-notification, fetch); Sign in with Apple capability; **PrivacyInfo.xcprivacy** khai báo Required Reason APIs (UserDefaults, file timestamp, disk space…) và data collection; StoreKit.

**Android:** `targetSdk ≥ 36`, `minSdk 26`; quyền: `INTERNET`, `POST_NOTIFICATIONS` (13+), `CAMERA`, `RECORD_AUDIO`, `USE_BIOMETRIC`; **không** xin `READ_MEDIA_IMAGES/VIDEO` (dùng Photo Picker), **không** `READ_CONTACTS`, **không** location; App Links `autoVerify=true`; notification channels; `allowBackup=false`; ProGuard/R8; Play Integrity (tuỳ chọn chống abuse OTP); foreground service type `dataSync` cho upload lớn (khai báo theo chính sách).

### 22.12 Đa ngôn ngữ trong Flutter (l10n) — đã dựng ở base

**Công cụ:** `flutter gen-l10n` (chính thức của Flutter) + `intl`, cấu hình `l10n.yaml`:

| Mục | Giá trị |
|---|---|
| ARB | `lib/l10n/arb/app_vi.arb` (**template**, có `@key.description`), `app_en.arb` |
| Code sinh | `lib/generated/l10n/app_localizations*.dart` (class `AppLocalizations`, `nullable-getter: false`) — không sửa tay |
| Sinh code | `make l10n` / tự chạy khi `flutter pub get` (`flutter: generate: true`) |
| Chuỗi chưa dịch | `build/l10n_untranslated.json`; test `test/utils/l10n_test.dart` fail nếu file ARB thiếu/thừa key |

**Thành phần code:**

| File | Vai trò |
|---|---|
| `utils/constants/enum_part/app_language.dart` | `enum AppLanguage { vi, en }` — `code`, `nativeName`, `locale`, `fromCode()`, `fallback = vi` |
| `utils/helper/local_store.dart` | Lưu ngôn ngữ đã chọn (box cài đặt, giữ lại sau đăng xuất), đọc sẵn lúc `init()` |
| `data/repository(_imp)/app_setting.dart` | Đọc/lưu ngôn ngữ, `PATCH /v1/me {locale}` |
| `data/service(_imp)/app_setting.dart` | `currentLanguage()` (đã chọn → thiết bị → vi), `changeLanguage()` (lưu máy + đồng bộ server khi đã đăng nhập, lỗi mạng không chặn) |
| `data/provider/app_setting.dart` | `appLanguageProvider` (Notifier) — `MaterialApp` watch → đổi ngôn ngữ áp dụng ngay |
| `utils/extension/l10n.dart` | `context.l10n.<key>`, `context.localeName` |
| `utils/helper/app_l10n.dart` | `currentAppLanguage()`, `currentL10n()` cho nơi không có `BuildContext` (interceptor, helper lỗi) |
| `utils/extension/date_time.dart` | Định dạng ngày/giờ theo locale (`DateFormat.yMd(locale)`…); `toApiDate` cố định `yyyy-MM-dd` |
| `utils/widget/language_picker_sheet.dart` | Bộ chọn ngôn ngữ dùng chung (ONB-01, SET-06) |
| `data/remote/interceptor/device_interceptor.dart` | Header `Accept-Language` = ngôn ngữ hiện hành |
| `main_*.dart` | `initializeDateFormatting` cho mọi `AppLanguage`, `Intl.defaultLocale` |
| `app.dart` | `locale`, `supportedLocales`, `localizationsDelegates` từ `AppLocalizations` |
| iOS `Info.plist` | `CFBundleLocalizations = [vi, en]`, `CFBundleDevelopmentRegion = vi` |
| Android | `res/xml/locales_config.xml` + `android:localeConfig` (chọn ngôn ngữ theo app trên Android 13+) |

**Quy tắc code (Skill 10 trong `baby-family-app/.skills/skill_10.md`):** không hard-code chuỗi hiển thị; key `<khuVuc><Man><MucDich>`; placeholder có kiểu; ICU `plural`/`select`; không ghép câu; layout chịu chuỗi dài hơn ~40%; dữ liệu catalog/lỗi từ server đã dịch — không dịch lại ở client.

**Thêm một ngôn ngữ mới:**
1. Thêm giá trị vào `AppLanguage` (`code`, `nativeName`).
2. Tạo `lib/l10n/arb/app_<code>.arb` đủ key → `make l10n` → test l10n pass.
3. Thêm `<code>` vào `CFBundleLocalizations` (iOS) và `locales_config.xml` (Android).
4. Server: thêm vào `i18n.supportedLocales`, bổ sung `errors.json`, template thông báo, bản dịch catalog (ADM-19).
5. Store listing + văn bản pháp lý cho ngôn ngữ đó.

---

## 23. Bản đồ Màn hình ↔ Route ↔ State ↔ API

> Cột “API” là endpoint chính (bỏ tiền tố `/v1`). `{fid}` = familyId hiện tại.

### 23.1 Khởi động, Auth, Onboarding, Invite

| Mã | Route | Provider chính | API |
|---|---|---|---|
| SPL-01 | `/splash` | `Session`, `AppConfig` | `GET /app-config`, `POST /auth/refresh`, `GET /me`, `GET /families/{fid}/bootstrap` |
| ONB-01 | `/welcome` | — | — |
| AUTH-01 | `/auth` | `AuthController` | `POST /auth/apple`, `POST /auth/google` |
| AUTH-02 | `/auth/phone` | `PhoneAuthController` | `POST /auth/phone/otp` |
| AUTH-03 | `/auth/otp` | `PhoneAuthController` | `POST /auth/phone/verify`, `POST /auth/phone/otp` (gửi lại) |
| AUTH-04 | `/auth/profile` | `ProfileSetup` | `POST /media/upload-intents` (avatar), `PATCH /me`, `POST /me/consents` |
| INV-01 | `/invite?token=` | `InviteController` | `POST /invites/resolve`, `POST /invites/accept`, `POST /invites/decline` |
| INV-02/03/04 | `/invite/invalid` · `/invite/blocked` · `/invite/waiting` | — | (kết quả từ resolve/accept) |
| INV-05 | `/invite/code` | `InviteController` | `POST /invites/resolve {code}` |
| ONB-03 | `/onboarding/role` | `OnboardingRole` | `PUT /me/onboarding-role` |
| ONB-06 | `/onboarding/family-name` | `CreateFamily` | `POST /families` |
| ONB-WAIT | `/onboarding/waiting` | `FamilyContext` (realtime `access.changed`, poll 30s khi mở) | `GET /families/{fid}/bootstrap`, `POST /families/{fid}/invites/partner`, `POST /invites/{id}/approve`, `POST /families/{fid}/cancel` |
| ONB-ACT | `/onboarding/activated` | `FamilyContext.entitlement` | — |
| ONB-04..05 | `/onboarding/{stage,pregnancy,child}` | `SetupDraft` | `POST /families/{fid}/pregnancies`, `POST /families/{fid}/children` |
| CIR-WAIT | `/c/waiting` | — | `POST /invites/resolve`, `PUT /me/onboarding-role` |
| ONB-07 | `/onboarding/invite-partner` | `PartnerInvite` | `POST /families/{fid}/invites/partner` |
| ONB-08 | `/onboarding/privacy` | — | — |
| ONB-09 | `/onboarding/first-memory` | → luồng MEM-04 | |
| ONB-10 | `/onboarding/notifications` | `PushPermission` | `POST /me/devices` |

### 23.2 Trang chủ & chung

| Mã | Route | Provider | API |
|---|---|---|---|
| HOME-01 | `/home` (`SelectedSubject = ALL`) | `HomeBlocks(fid, ALL)`, `TodayStories`, `HomeFeed(fid, ALL)` | `GET /families/{fid}/home?subject=ALL` (gồm stories, ngày đặc biệt/On this day, Papa & Mama, nhiệm vụ + `myHeartsToday` của tôi, gợi ý ghi lại, tuần này, cây mini %), `GET /families/{fid}/feed?cursor`, `POST /memory-prompts/{id}/{next|dismiss}`, `POST /missions/{id}/complete` |
| HOME-02 | `/home` (`SelectedSubject = child`) | `HomeBlocks(fid, child)`, `Chapters`, `MonthlyPhotos` | `GET /families/{fid}/home?subject=child:{id}`, `GET /families/{fid}/feed?childId=`, `GET /children/{id}/monthly-photos` |
| HOME-03 | `/home` (`SelectedSubject = pregnancy`) | `HomeBlocks(fid, pregnancy)` | `GET /families/{fid}/home?subject=pregnancy:{id}`, `GET /pregnancies/{id}/bump-photos`, `GET /pregnancies/{id}/milestones`, `GET /us/pregnancies/{id}/name-candidates` [1.1] |
| SW-01 | sheet | `FamilyContext.subjects`, `SelectedSubject` | `GET /families/{fid}/subjects` |
| QC-01 | sheet | quyền từ `FamilyContext` | — |
| NOTI-01 | `/notifications` | `Inbox(tab)` | `GET /notifications`, `POST /notifications/read` |

### 23.3 Ký ức

| Mã | Route | Provider | API |
|---|---|---|---|
| MEM-01 | `/memories` (tab con **Dòng thời gian** • Ảnh • Bộ sưu tập) | `Timeline(fid, subject, filter)`, `Chapters(childId)` | `GET /families/{fid}/timeline` (kèm thẻ chương tháng 19.2), `GET /children/{id}/chapters` |
| MEM-02 | `/memories/photos` (tab con Ảnh) | `MediaGrid` | `GET /families/{fid}/media-grid` |
| MEM-03/03a | `/memories/albums`, `/album/:id` | `Albums`, `AlbumDetail` | `GET/POST /families/{fid}/albums`, `PATCH/DELETE /albums/{id}`, `POST/DELETE /albums/{id}/memories` |
| MEM-04 | `/create/memory` | `MemoryComposer` | (picker local) |
| MEM-05 | `/create/memory/compose` | `MemoryComposer`, `UploadManager` | `POST /media/upload-intents`, `…/complete`, `POST /memories` |
| MEM-06 | (overlay) | `UploadManager` | `POST /media/{id}/parts` |
| MEM-07 | `/memory/:id` | `MemoryDetail(id)`, `Comments(id)` | `GET /memories/{id}` (gồm `perspectives[]`, `people[]`, `feeling` đã shaping), `PATCH /perspectives/{id} {hiddenFromCircle}`, `PUT/DELETE /memories/{id}/reaction`, `PUT /memories/{id}/children`, `PATCH /memories/{id}/visibility`, `PUT /memories/{id}/favorite`, `POST /memories/{id}/archive`, `DELETE /memories/{id}`, `POST /memories/{id}/review` |
| MEM-08 | `/memory/:id/viewer?i=` | `MemoryDetail` | `POST /media/urls`, `POST /memories/{id}/download-urls` |
| MEM-09 | `/memory/:id/edit` | `MemoryEditor` | `PATCH /memories/{id}` (If-Match) |
| MEM-10 | `/memory/:id/comments` | `Comments` | `GET/POST /memories/{id}/comments`, `PATCH/DELETE /comments/{id}` |
| MEM-11 | `/create/milestone` | `MilestoneCatalog` | `GET /milestone-templates`, `POST /milestones` |
| MEM-12 | `/child/:id/firsts` | `MilestoneBoard(childId)` | `GET /children/{id}/milestones` |
| MEM-13 | `/create/diary` | `DiaryComposer` | `POST /memories {kind: DIARY}` |
| MEM-14 | `/create/letter` | `LetterComposer` | `POST /memories {kind: LETTER, unlockAt}` |
| MEM-15 | `/search` | `Search(query)` | `GET /families/{fid}/search` |
| MEM-16 | `/on-this-day` | `OnThisDay` | `GET /families/{fid}/on-this-day`, `POST /memories/{id}/reshare` |
| MEM-17 | `/trash` | `Trash` | `GET /families/{fid}/trash`, `POST /memories/{id}/restore`, `DELETE /memories/{id}/purge` |
| MEM-18 | `/drafts` | `Drafts` (drift + server) | `GET /families/{fid}/drafts` |
| MEM-19 | `/reviews` | `PendingReviews` | `GET /families/{fid}/pending-reviews`, `POST /memories/{id}/review` |
| MEM-20 | `/child/:id/monthly?year=` (thai kỳ: `/pregnancy/:id/bump`) | `MonthlyPhotos(childId, year)` | `GET /children/{id}/monthly-photos`, `PUT/DELETE /children/{id}/monthly-photos/{monthIndex}`, `POST /children/{id}/monthly-photos/collage`, `GET /exports/{id}` |
| MEM-21 | `/create/monthly-photo?childId=&month=` | `MonthlyCamera` (bóng mờ ảnh tháng trước, sticker overlay) | `GET /content/MONTH_STICKER`, `POST /media/upload-intents`, `POST /memories {kind: MONTHLY_PHOTO, monthlyPhoto}` |
| MEM-22 | `/memories/collections` (tab con Bộ sưu tập), `/collection/:code?subject=` | `Collections(fid, subject)`, `CollectionItems(code)` | `GET /families/{fid}/collections`, `GET /families/{fid}/collections/{code}`, `GET /families/{fid}/albums` |
| MEM-23 | sheet `/create/quote` | `QuoteComposer` (≤ 3 chạm) | `POST /memories {kind: QUOTE, body, quoteContext, childIds:[1]}` (+ ghi âm: `POST /media/upload-intents`) |
| MEM-24 | `/memory/:id/perspective` | `PerspectiveEditor(memoryId)` | `POST /memories/{id}/perspectives`, `PATCH/DELETE /perspectives/{id}` |
| MEM-25 | `/story/:subjectType/:id?date=` | `TodayStory(subject, date)` | `GET /families/{fid}/today-stories/{type}/{id}`, `POST …/seen`, `PUT /memories/{id}/reaction`, `POST /memories/{id}/comments` |

### 23.4 Thai kỳ & Bé

| Mã | Route | Provider | API |
|---|---|---|---|
| PREG-01 | `/pregnancy/:id` (tab Dòng thời gian • Bụng bầu • Siêu âm • Chuẩn bị) | `PregnancyDetail` | `GET /families/{fid}/timeline?pregnancyId=`, `PATCH /pregnancies/{id}` (gồm “Người mang thai”), `GET /pregnancies/{id}/milestones` |
| PREG-02 | `/pregnancy/:id/bump` | `BumpPhotos(pregnancyId)` (so sánh 2–4 tuần) | `GET /pregnancies/{id}/bump-photos`, `PUT /pregnancies/{id}/bump-photos/{week}`, `POST /memories {kind: BUMP}`, `PATCH /pregnancies/{id} {bumpPhotoCadence}` |
| PREG-03 | `/pregnancy/:id/ultrasound` | `PregnancyGallery(ULTRASOUND)` | `GET …/timeline?pregnancyId=&filter=ULTRASOUND`, `POST /memories {kind: ULTRASOUND}` |
| PREG-04 | `/pregnancy/:id/prep` | `PrepChecklist` | `GET/POST/PATCH /pregnancies/{id}/prep-items`, `POST /missions` |
| PREG-05 | `/pregnancy/:id/birth` | `BirthWizard` (idempotencyKey sinh 1 lần khi mở wizard) | `POST /pregnancies/{id}/birth` |
| PREG-06 | `/pregnancy/:id/end` | — | `POST /pregnancies/{id}/end` |
| PREG-07 [1.1] | `/pregnancy/:id/names` (guard `canUseCouple`) | `NameCandidates(pregnancyId)` (chỉ RAM cache) | `GET/POST /us/pregnancies/{id}/name-candidates`, `PUT/DELETE /us/name-candidates/{id}/like`, `POST /us/name-candidates/{id}/choose` |
| CHD-01/02 | `/child/:id`, `/child/:id/edit` | `ChildProfile` | `GET/PATCH /children/{id}` |
| CHD-03 | `/children` | `FamilyContext.subjects` | `GET /families/{fid}/subjects` |
| CHD-04 | `/children/add` | `AddChild` | `POST /families/{fid}/children`, `POST /families/{fid}/pregnancies`, `POST /families/{fid}/share-new-child` |
| CHD-05 | `/child/:id/archive` | — | `POST /children/{id}/archive`, `DELETE /children/{id}` |

### 23.5 Chăm con

| Mã | Route | Provider | API |
|---|---|---|---|
| CARE-01 | `/care` | `MissionBoard(fid, date, tab, subject)`, `MyHearts`, `FamilyTree`, `OpenRequests` | `GET /families/{fid}/missions/board?date&tab=MINE|PARTNER|TOGETHER`, `POST /missions/{id}/{complete|undo|remove|carry-over}`, `GET /families/{fid}/hearts/me` (chỉ tab Của tôi), `GET /us/requests?box=OPEN` (dòng nhắc → US-04), `POST /us/appreciations` (💛 trên việc bạn đời đã xong) |
| CARE-02 | `/mission/:id` | `MissionDetail` (`MyMission` \| `PartnerMission`) | `GET/PATCH /missions/{id}`, `POST /missions/{id}/{complete|remove}`, `GET /families/{fid}/mission-series`, `PATCH /mission-series/{id}` (Tạm dừng chuỗi) |
| CARE-03 | `/create/mission` | `MissionComposer` (validate phạm vi; người làm chỉ Tôi / Cùng nhau) | `GET /mission-templates`, `POST /missions`; dòng “Muốn nhờ Mama? Gửi lời nhờ →” mở `/us/requests/new?templateId=` |
| CARE-04 | `/care/library` | `MissionLibrary` | `GET /mission-templates` (mở từ US-03: `requestable=true`) |
| CARE-05 | sheet `/mission/:id/swap` | `MissionSwap(id)` (“Còn N lần đổi hôm nay”) | `GET /missions/{id}/swap-options`, `POST /missions/{id}/swap`, `POST /missions/{id}/remove` |
| CARE-06 | sheet | `CompleteMission` | `POST /missions/{id}/complete` (kèm ảnh → ký ức), `POST /missions/{id}/undo` |
| CARE-07 | `/care/calendar` | `Calendar(range)` | `GET /families/{fid}/calendar` |
| CAL-02 | `/create/event` | `EventComposer` | `POST/PATCH/DELETE /events` |
| CARE-08 | `/care/history` | `MissionHistory` | `GET /families/{fid}/missions?owner=ME|TOGETHER|PARTNER&status=…` (bạn đời: chỉ việc đã xong, không Hearts) |
| CARE-09 | `/care/tree` | `FamilyTree`, `MyHearts` (khối “Bạn đã góp” 🔒) | `GET /families/{fid}/family-tree`, `GET /families/{fid}/hearts/me` |
| CARE-10 | `/care/badges` | `Badges` | `GET /families/{fid}/badges` |
| CARE-11 | `/care/stats` | `CareStats(week, subject)` | `GET /families/{fid}/care/stats` (cấp gia đình, kèm disclaimer) |
| CARE-12 | `/care/settings` | `MissionSettings` (mức cả nhà), `MissionPrefs` (của tôi) | `GET/PUT /families/{fid}/mission-settings`, `GET/PUT /families/{fid}/mission-preferences/me` |

### 23.6 Papa & Mama

| Mã | Route | Provider | API |
|---|---|---|---|
| US-00 | `/us/locked` | `FamilyContext.couple` | `POST /families/{fid}/invites/partner` |
| US-01 | `/us` | `UsToday` (chỉ RAM cache), `OpenRequests` | `GET /us/today`, `GET /us/requests?box=OPEN`, `POST /us/checkins/{id}/responses` (`TAKE_OVER` → lời nhờ đã nhận) |
| US-02 | sheet | `CheckinComposer` | `POST /us/checkins`, `GET /content/MOOD`, `GET /content/NEED` |
| US-03 | `/us/requests/new?kind=&templateId=` | `RequestComposer` (“Đang mở n/5”) | `GET /mission-templates?requestable=true`, `GET /content/REQUEST_TEMPLATE`, `GET /content/HARSH_WORD`, `POST /us/requests` |
| US-04 | `/us/requests/:id` (sheet khi mở từ thông báo) | `RequestDetail(id)` | `GET /us/requests/{id}`, `POST /us/requests/{id}/{seen|accept|decline|done|acknowledge|remind-me|cancel|self-do}`, `POST /us/appreciations` |
| US-05/06 | `/us/thanks/new`, `/us/thanks` | `Appreciations` | `POST/GET /us/appreciations`, `POST …/{react|share-request|share-respond}` |
| US-07 | `/us/journal`, `/us/journal/:id` | `Journal` (yêu cầu `local_auth` nếu bật) | `GET/POST/PATCH/DELETE /us/journal`, `POST /us/journal/{id}/share` |
| US-08 | `/us/bridge/new` | `BridgeDraft` | `POST /us/conflicts`, `PUT /us/conflicts/{id}/my-entry`, `POST /us/safety-check` |
| US-09 | `/us/bridge/:id/rewrite` | `Rewrite` | `POST /ai/rewrite` (1.2) / `GET /content/NEED_TEMPLATE` (1.1) |
| US-10 | `/us/bridge/:id/invite` | `BridgeSession` | `POST /us/conflicts/{id}/respond` |
| US-11/12 | `/us/bridge/:id` | `BridgeSession` | `GET /us/conflicts/{id}`, `POST …/{understood|clarify|next-step|next-step/confirm|pause|close}` |
| US-13 | `/safety` | `SafetyResources` | `GET /content/safety-resources` |
| US-14 | `/us/week` | `UsWeek` | `GET /us/checkins?owner=me`, (1.1) `GET /us/week` |
| US-15 | `/us/settings` | `UsSettings` | `GET/PATCH /us/settings`, `DELETE /us/checkins` |

### 23.7 Gia đình, Recap, Gói, Cài đặt, An toàn, Circle

| Mã | Route | Provider | API |
|---|---|---|---|
| FAM-01 | `/family` | `FamilyContext`, `CircleList` | `GET /families/{fid}/bootstrap`, `GET /families/{fid}/circle` |
| FAM-02 | `/family/invite-partner` | `PartnerInvite` | `POST /families/{fid}/invites/partner`, `DELETE /invites/{id}` |
| FAM-03 | `/family/invite-circle` | `CircleInviteWizard` | `GET /families/{fid}/billing/eligibility` (gate), `POST /families/{fid}/invites/circle` |
| FAM-04 | `/family/circle/:id` | `CircleMember` | `GET/PATCH /circle-members/{id}`, `PUT /circle-members/{id}/grants` |
| FAM-05 | `/family/invites` | `Invites` | `GET /families/{fid}/invites`, `DELETE /invites/{id}` |
| FAM-06 | dialog | — | `POST /circle-members/{id}/remove` |
| FAM-07 | `/family/settings` | `FamilySettings` | `PATCH /families/{fid}/settings`, `DELETE /families/{fid}` |
| FAM-08 | sheet | `MyFamilies` | `GET /me` |
| REC-01 | `/recap/daily/new?subject=` | `DailyStory` | `POST /ai/daily-story` (1.2), `POST /memories {kind: STORY}` |
| REC-02/03 | `/recap/:id` | `Recap(id)` | `GET /recaps/{id}`, `POST /recaps/{id}/{save|share|dismiss}` |
| SUB-01 | `/billing/plans?from=` | `Paywall` (Store SDK products + eligibility) | `GET /billing/plans`, `GET /families/{fid}/billing/eligibility` |
| SUB-02 | (Store sheet) | `PurchaseController` | `POST /billing/apple/transactions` \| `POST /billing/google/purchases` |
| SUB-03/04 | `/billing` | `FamilyBilling` | `GET /families/{fid}/billing`, `POST /billing/restore` |
| SUB-05/06 | sheet / banner | `QuotaGate` (lỗi 402) | — |
| SUB-07 | `/billing/expired` | `Paywall(mode: EXPIRED)` | `GET /families/{fid}/billing`, purchase/restore, `POST /exports` |
| SET-06 | `/settings/display` | `appLanguageProvider`, `Settings` | `PATCH /v1/me {locale}` (qua `AppSettingService.changeLanguage`), `PATCH /v1/me/settings` |
| SET-01..13 | `/settings/*` | `Settings`, `Sessions`, `Exports`, `Deletion` | `GET/PATCH /me/settings`, `GET/DELETE /me/sessions`, `POST /exports`, `GET /me/deletion-preview`, `POST /me/deletion`, `GET /me/blocks`, `POST /support/tickets` |
| RPT-01/02 | sheet / dialog | — | `POST /reports`, `POST /blocks` |
| CIR-01 | `/c/home` | `HomeFeed` (role CIRCLE) | `GET /families/{fid}/feed` |
| CIR-02 | `/c/child/:id` | `Timeline` | `GET /families/{fid}/timeline?childId=` |
| CIR-03 | `/memory/:id` (shaping) | `MemoryDetail` | `GET /memories/{id}` |
| CIR-04 | `/c/create` | `MemoryComposer(circle)` | `POST /media/upload-intents`, `POST /memories` |
| CIR-05 | `/c/paused` | — | — |
| CIR-06 | `/c/me` | `Settings` | `PATCH /me/settings`, `POST /families/{fid}/leave` |

---
## 24. Admin CMS

- **Frontend:** React + Vite + TypeScript + Ant Design (hoặc Refine trên AntD) — domain `admin.babyfamily.vn`, chỉ truy cập qua VPN/IP allowlist.
- **Backend:** process `admin-api` (cùng codebase, module `admin/*`), prefix `/admin/v1`, JWT riêng (issuer khác), **2FA TOTP bắt buộc**, session 8h, RBAC theo vai trò (nghiệp vụ 4.3): `SUPPORT`, `MODERATOR`, `CONTENT`, `BILLING_OPS`, `SUPER_ADMIN`.
- **DB role** `bf_admin_api`: không có quyền schema `us`; chỉ đọc metadata `app.*` cần thiết; ghi catalog/config.
- **Mọi** request ghi `audit_logs` (Mongo) với `reason` bắt buộc cho thao tác đọc dữ liệu người dùng.

| Màn (nghiệp vụ) | API | Ghi chú kỹ thuật |
|---|---|---|
| ADM-03 Tra cứu | `GET /admin/v1/users?query`, `GET /admin/v1/families/{id}` | Trả metadata (che SĐT `+84 91****678`), không ảnh |
| ADM-04/05 Kiểm duyệt | `GET /admin/v1/moderation/cases`, `GET …/{id}`, `POST …/{id}/actions` | Nội dung bị báo cáo: presign URL TTL 5 phút, watermark ID admin trên ảnh hiển thị; không tải về |
| ADM-06..10 Catalog | CRUD `/admin/v1/catalog/{missions|milestones|badges|memory-prompts|month-stickers|content|notification-templates}` | Versioning + publish; client nhận qua ETag `/content` |
| ADM-11/12 Gói | `/admin/v1/billing/plans`, `/admin/v1/families/{id}/subscriptions`, `POST …/resync` | Không có endpoint “cấp gói tay”; ngoại lệ (đền bù) chỉ qua promo/offer code của Store |
| ADM-13 Xoá | `/admin/v1/deletion-requests` | Xem tiến độ `steps`, retry bước lỗi |
| ADM-14 Flags/Config | `/admin/v1/config`, `/admin/v1/flags` | Thay đổi → publish Redis pub/sub để process reload |
| ADM-17 Audit | `/admin/v1/audit` | Đọc Mongo |

---

## 25. Hạ tầng & triển khai (Docker)

### 25.1 Môi trường

| Env | Mục đích | Hạ tầng | Dữ liệu | Store |
|---|---|---|---|---|
| `local` | Dev | Docker Compose trên máy dev | Seed tổng hợp | StoreKit config file, Play license tester |
| `staging` | QA, UAT, review Store | 1–2 VM, Docker Compose | Dữ liệu giả, **không** dùng dữ liệu thật | Sandbox Apple, internal test track |
| `production` | Người dùng thật | Cụm VM tại DC Việt Nam (mục 25.4) | Thật | Production |

Mỗi env tách hoàn toàn: DB, bucket, Redis, Mongo, khoá JWT, KEK, Firebase project, Apple/Google credential, domain.

### 25.2 Docker Compose (local/staging)

**Triển khai local hiện tại (2026-10-13):** PostgreSQL 18.6 chạy độc lập tại
`baby-database/compose.yaml`, bind mount data ra host; Compose backend chỉ chạy
API/migrations và nối shared network. Xem [hướng dẫn database](../baby-database/README.md)
và [backend](../baby-backend/README.md). Ví dụ full stack bên dưới là bản tham khảo
đặc tả, không dùng để gộp DB server trở lại backend hoặc hạ phiên bản PostgreSQL.

```yaml
# docker-compose.yml
name: babyfamily
x-app-env: &app-env
  NODE_ENV: ${NODE_ENV:-development}
  DATABASE_URL: postgresql://bf_app:${PG_APP_PASSWORD}@postgres:5432/babyfamily?schema=app
  REDIS_URL: redis://redis:6379
  MONGO_URL: mongodb://mongo:27017/bf_logs?replicaSet=rs0
  S3_ENDPOINT: http://minio:9000
  S3_PUBLIC_ENDPOINT: ${S3_PUBLIC_ENDPOINT:-http://localhost:9000}   # host dùng trong presigned URL
  S3_REGION: us-east-1
  S3_FORCE_PATH_STYLE: "true"
  S3_BUCKET_MEDIA: bf-media
  S3_BUCKET_EXPORTS: bf-exports
  S3_ACCESS_KEY_FILE: /run/secrets/s3_access_key
  S3_SECRET_KEY_FILE: /run/secrets/s3_secret_key
  JWT_PRIVATE_KEY_FILE: /run/secrets/jwt_private_key
  KEK_FILE: /run/secrets/kek            # local only; staging/prod dùng Vault Transit
  FCM_CREDENTIALS_FILE: /run/secrets/fcm_sa
  TZ: UTC

services:
  postgres:
    image: postgres:17-alpine
    environment:
      POSTGRES_DB: babyfamily
      POSTGRES_USER: bf_owner
      POSTGRES_PASSWORD_FILE: /run/secrets/pg_owner_password
    volumes: [pgdata:/var/lib/postgresql/data, ./infra/postgres/init:/docker-entrypoint-initdb.d:ro]
    secrets: [pg_owner_password]
    healthcheck: { test: ["CMD-SHELL", "pg_isready -U bf_owner -d babyfamily"], interval: 5s, retries: 10 }
    ports: ["5432:5432"]          # chỉ local

  redis:
    image: redis:7-alpine          # hoặc valkey/valkey:8-alpine
    command: ["redis-server", "--appendonly", "yes", "--maxmemory-policy", "noeviction"]   # BullMQ yêu cầu noeviction
    volumes: [redisdata:/data]
    healthcheck: { test: ["CMD", "redis-cli", "ping"], interval: 5s, retries: 10 }

  mongo:
    image: mongo:8.0
    command: ["--replSet", "rs0", "--bind_ip_all"]
    volumes: [mongodata:/data/db]
    healthcheck:
      test: ["CMD-SHELL", "mongosh --quiet --eval \"try{rs.status().ok}catch(e){rs.initiate({_id:'rs0',members:[{_id:0,host:'mongo:27017'}]}).ok}\""]
      interval: 5s
      retries: 20

  minio:
    image: ${MINIO_IMAGE}          # pin tag/digest cụ thể; xem 10.8 về tình trạng phát hành MinIO
    command: server /data --console-address ":9001"
    environment:
      MINIO_ROOT_USER_FILE: /run/secrets/minio_root_user
      MINIO_ROOT_PASSWORD_FILE: /run/secrets/minio_root_password
    volumes: [miniodata:/data]
    secrets: [minio_root_user, minio_root_password]
    ports: ["9000:9000", "9001:9001"]
    healthcheck: { test: ["CMD", "curl", "-fs", "http://localhost:9000/minio/health/live"], interval: 5s, retries: 10 }

  minio-init:                      # tạo bucket, policy private, user app, lifecycle, versioning
    image: ${MINIO_MC_IMAGE}
    depends_on: { minio: { condition: service_healthy } }
    entrypoint: ["/bin/sh", "/init/minio-init.sh"]
    volumes: [./infra/minio:/init:ro]
    secrets: [minio_root_user, minio_root_password, s3_access_key, s3_secret_key]

  migrate:                         # chạy 1 lần trước api/worker
    build: { context: ., dockerfile: infra/docker/node.Dockerfile, target: runtime }
    command: ["node", "dist/tools/migrate.js"]     # Ví dụ dự kiến: chỉ deploy migration DDL, không seed/backfill
    environment: { <<: *app-env, DATABASE_URL: "postgresql://bf_owner:${PG_OWNER_PASSWORD}@postgres:5432/babyfamily" }
    depends_on: { postgres: { condition: service_healthy } }
    restart: "no"

  api:
    build: { context: ., dockerfile: infra/docker/node.Dockerfile, target: runtime }
    command: ["node", "dist/apps/api/main.js"]
    environment: { <<: *app-env, PORT: "3000" }
    secrets: [s3_access_key, s3_secret_key, jwt_private_key, kek, fcm_sa]
    depends_on:
      migrate: { condition: service_completed_successfully }
      redis: { condition: service_healthy }
      mongo: { condition: service_healthy }
    healthcheck: { test: ["CMD", "wget", "-qO-", "http://localhost:3000/health/ready"], interval: 10s, retries: 6 }

  realtime:
    build: { context: ., dockerfile: infra/docker/node.Dockerfile, target: runtime }
    command: ["node", "dist/apps/realtime/main.js"]
    environment: { <<: *app-env, PORT: "3001" }
    secrets: [jwt_private_key]
    depends_on: [api]

  worker:
    build: { context: ., dockerfile: infra/docker/node.Dockerfile, target: runtime }
    command: ["node", "dist/apps/worker/main.js"]
    environment: { <<: *app-env, WORKER_QUEUES: "outbox,notify,push,mission,billing,ai,recap,lifecycle,search" }
    secrets: [s3_access_key, s3_secret_key, kek, fcm_sa]
    depends_on: [api]

  worker-media:                    # image riêng có ffmpeg, exiftool, libvips
    build: { context: ., dockerfile: infra/docker/node.Dockerfile, target: runtime-media }
    command: ["node", "dist/apps/worker/main.js"]
    environment: { <<: *app-env, WORKER_QUEUES: "media", MEDIA_CONCURRENCY: "2" }
    secrets: [s3_access_key, s3_secret_key]
    depends_on: [api]

  scheduler:
    build: { context: ., dockerfile: infra/docker/node.Dockerfile, target: runtime }
    command: ["node", "dist/apps/scheduler/main.js"]
    environment: *app-env
    depends_on: [api]

  admin-api:
    build: { context: ., dockerfile: infra/docker/node.Dockerfile, target: runtime }
    command: ["node", "dist/apps/admin-api/main.js"]
    environment: { <<: *app-env, PORT: "3002", DATABASE_URL: "postgresql://bf_admin_api:${PG_ADMIN_PASSWORD}@postgres:5432/babyfamily" }
    depends_on: [api]

  admin-web:
    build: { context: ./admin-web, dockerfile: Dockerfile }

  nginx:
    image: nginx:1.27-alpine
    volumes: [./infra/nginx/conf.d:/etc/nginx/conf.d:ro, ./infra/nginx/certs:/etc/nginx/certs:ro]
    ports: ["80:80", "443:443"]
    depends_on: [api, realtime, admin-api, admin-web, minio]

  mailpit:                         # chỉ local: xem email giao dịch
    image: axllent/mailpit
    ports: ["8025:8025"]
    profiles: ["local"]

volumes: { pgdata: {}, redisdata: {}, mongodata: {}, miniodata: {} }

secrets:
  pg_owner_password:   { file: ./infra/secrets/pg_owner_password }
  minio_root_user:     { file: ./infra/secrets/minio_root_user }
  minio_root_password: { file: ./infra/secrets/minio_root_password }
  s3_access_key:       { file: ./infra/secrets/s3_access_key }
  s3_secret_key:       { file: ./infra/secrets/s3_secret_key }
  jwt_private_key:     { file: ./infra/secrets/jwt_private_key.pem }
  kek:                 { file: ./infra/secrets/kek }
  fcm_sa:              { file: ./infra/secrets/fcm_service_account.json }
```

`infra/minio/minio-init.sh` (ý chính):
```sh
mc alias set local http://minio:9000 "$(cat /run/secrets/minio_root_user)" "$(cat /run/secrets/minio_root_password)"
mc mb --ignore-existing local/bf-media local/bf-exports local/bf-public
mc anonymous set none local/bf-media && mc anonymous set none local/bf-exports
mc anonymous set download local/bf-public
mc version enable local/bf-media
mc ilm rule add local/bf-media --noncurrent-expire-days 30
mc ilm rule add local/bf-exports --expire-days 7
mc admin user add local "$(cat /run/secrets/s3_access_key)" "$(cat /run/secrets/s3_secret_key)"
mc admin policy create local bf-app /init/policy-bf-app.json     # chỉ s3:GetObject/PutObject/DeleteObject/ListMultipart… trên bf-media, bf-exports
mc admin policy attach local bf-app --user "$(cat /run/secrets/s3_access_key)"
```

`infra/postgres/init/01-roles.sql`: tạo role `bf_app`, `bf_admin_api`, `bf_readonly_analytics`, cấp quyền theo schema (admin không có quyền `us`).

### 25.3 Dockerfile backend (multi-stage)

```dockerfile
# infra/docker/node.Dockerfile
FROM node:24-bookworm-slim AS deps
WORKDIR /app
COPY package.json pnpm-lock.yaml ./
RUN corepack enable && pnpm install --frozen-lockfile

FROM deps AS build
COPY . .
RUN pnpm prisma generate && pnpm build && pnpm prune --prod

FROM node:24-bookworm-slim AS runtime
ENV NODE_ENV=production
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates wget tini && rm -rf /var/lib/apt/lists/*
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY --from=build /app/prisma ./prisma
USER node
ENTRYPOINT ["/usr/bin/tini","--"]

FROM runtime AS runtime-media
USER root
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg libimage-exiftool-perl && rm -rf /var/lib/apt/lists/*
USER node
```
- Pin base image theo **digest** ở production; quét Trivy trong CI.
- `sharp` cài bản prebuilt cho linux-x64/arm64 qua npm.

### 25.4 Nginx (trích)

```nginx
limit_req_zone $binary_remote_addr zone=api_ip:20m rate=20r/s;

server {
  listen 443 ssl http2;  server_name api.babyfamily.vn;
  ssl_certificate /etc/nginx/certs/api.crt; ssl_certificate_key /etc/nginx/certs/api.key;
  add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
  client_max_body_size 2m;
  location / {
    limit_req zone=api_ip burst=40 nodelay;
    proxy_pass http://api_upstream;
    proxy_set_header X-Request-Id $request_id;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto https;
    proxy_read_timeout 30s;
  }
  location /v1/webhooks/ { proxy_pass http://api_upstream; }      # không rate-limit IP Store
}
server {
  listen 443 ssl http2;  server_name ws.babyfamily.vn;
  location / { proxy_pass http://realtime_upstream; proxy_http_version 1.1;
               proxy_set_header Upgrade $http_upgrade; proxy_set_header Connection "upgrade";
               proxy_read_timeout 3600s; }
}
server {
  listen 443 ssl http2;  server_name media.babyfamily.vn;     # presigned URL dùng host này
  client_max_body_size 0;                                      # upload part 8MB+, chunked
  proxy_request_buffering off; proxy_buffering off;
  location / { proxy_pass http://minio_upstream; proxy_set_header Host $http_host; }   # GIỮ Host để chữ ký S3 hợp lệ
  # KHÔNG bật proxy_cache ở đây (xem 10.6)
}
```
> Presigned URL được ký với host `media.babyfamily.vn` — S3 client trong API cấu hình `endpoint = https://media.babyfamily.vn` **chỉ cho việc ký** (presigner), còn thao tác server-side dùng endpoint nội bộ `http://minio:9000`. Host trong chữ ký phải khớp host request tới MinIO (Nginx giữ `Host`).

### 25.5 Production topology (giai đoạn đầu, ~10–20k gia đình)

```
                         ┌──────────── Data center Việt Nam (2 AZ nếu có) ────────────┐
Internet ─► LB (2× Nginx + keepalived VIP hoặc LB của cloud)                           │
              │                                                                        │
     ┌────────┴─────────┐                                                              │
     │ app-1, app-2     │  Docker Swarm (hoặc k3s): api ×2–4, realtime ×2, worker ×2, │
     │ 8 vCPU / 16GB    │  scheduler ×2 (leader lock), admin-api ×1                    │
     ├──────────────────┤                                                              │
     │ media-1, media-2 │  worker-media (ffmpeg) 8 vCPU / 16GB, autoscale theo queue   │
     ├──────────────────┤                                                              │
     │ pg-1 (primary)   │  PostgreSQL 17, 8 vCPU/32GB, NVMe; Patroni+etcd hoặc        │
     │ pg-2 (replica)   │  streaming replica + failover thủ công có runbook            │
     ├──────────────────┤                                                              │
     │ redis-1..3       │  Redis Sentinel (1 primary, 2 replica) — hoặc managed        │
     ├──────────────────┤                                                              │
     │ mongo-1..3       │  Replica set                                                 │
     ├──────────────────┤                                                              │
     │ minio-1..4       │  Distributed, EC:2 (4 node × N ổ) hoặc S3 cloud VN           │
     ├──────────────────┤                                                              │
     │ ops-1            │  Prometheus, Grafana, Loki, Alertmanager, Vault (HA nếu có)  │
     └──────────────────┘                                                              │
                         └─────────────────────────────────────────────────────────────┘
Offsite backup: bucket S3 ở nhà cung cấp/khu vực khác (mã hoá phía client trước khi đẩy)
```
- Mạng private cho DB/cache/storage; chỉ LB public; SSH qua bastion + key; firewall default deny.
- **Scale:** API stateless → thêm replica; media worker scale theo độ dài queue `media`; PG đọc nặng (feed/timeline) → read replica cho query chỉ-đọc không yêu cầu đọc-sau-ghi; Redis tách instance cache vs BullMQ khi lớn.
- Khi team có năng lực K8s: chuyển sang k3s/K8s (Helm), HPA cho api/worker.

### 25.6 Backup & DR

| Thành phần | Cách | Tần suất | Giữ | Mục tiêu |
|---|---|---|---|---|
| PostgreSQL | pgBackRest hoặc WAL-G → S3 offsite (mã hoá) | Full hằng tuần, diff hằng ngày, WAL liên tục | 35 ngày, PITR 14 ngày | RPO ≤ 5 phút, RTO ≤ 4 giờ |
| MongoDB | `mongodump --oplog` → offsite | Hằng ngày | 14 ngày | RPO 24h (log, chấp nhận) |
| Redis | AOF + RDB snapshot | Liên tục | 3 ngày | Mất queue ngắn hạn chấp nhận được (outbox ở PG sẽ phát lại) |
| MinIO | Versioning + replication sang site/bucket offsite (`mc replicate` / `mc mirror --watch`) | Liên tục / hằng đêm | Version 30 ngày | RPO ≤ 24h |
| Secrets/KEK | Vault snapshot mã hoá, lưu 2 nơi | Hằng ngày | 90 ngày | **Mất KEK = mất dữ liệu Papa & Mama** → quy trình 2 người giữ khoá |

- **Diễn tập khôi phục** mỗi quý (restore PG vào môi trường tách biệt, kiểm tra checksum, đo RTO).
- Runbook: failover PG, mất 1 node MinIO, Redis mất dữ liệu, xoay khoá JWT, sự cố lộ dữ liệu.

### 25.7 Domain & web công khai

| Domain | Dùng cho |
|---|---|
| `babyfamily.vn` | Landing, `/.well-known/apple-app-site-association`, `/.well-known/assetlinks.json`, `/i/{token}` (fallback lời mời), `/chinh-sach-quyen-rieng-tu`, `/dieu-khoan`, `/xoa-tai-khoan`, `/ho-tro` |
| `api.` / `ws.` / `media.` | Backend |
| `admin.` | CMS nội bộ (IP allowlist) |
| `api-staging.` … | Staging |

AASA (ví dụ):
```json
{ "applinks": { "details": [ { "appIDs": ["<TEAMID>.vn.babyfamily.app"],
  "components": [ { "/": "/i/*" }, { "/": "/m/*" } ] } ] } }
```

---

## 26. CI/CD

### 26.1 Backend (GitHub Actions / GitLab CI)

```
on PR:
  - install (pnpm, cache) → lint (eslint, prettier) → typecheck
  - unit test (jest/vitest)
  - integration test với Testcontainers (postgres:17, redis, mongo, minio) — gồm bộ authz-matrix
  - prisma migrate diff (phát hiện migration thiếu) + kiểm tra migration chỉ “expand”
  - build OpenAPI → so sánh breaking change (oasdiff) → fail nếu breaking trên /v1
  - npm audit / osv-scanner
on merge main:
  - build images (api runtime, media runtime) → Trivy scan → push registry (tag = git sha)
  - publish OpenAPI artifact → trigger job sinh Dart client (packages/bf_api) → PR tự động sang repo mobile
  - deploy staging: chạy service `migrate` → rolling update api/worker/realtime/scheduler → smoke test
on tag vX.Y.Z:
  - deploy production (approval thủ công): backup trigger → migrate → rolling (max 1 unavailable) → smoke → theo dõi 30 phút
  - rollback: redeploy tag trước (migration đã expand-only nên tương thích ngược)
```

### 26.2 Mobile

```
on PR: flutter analyze, dart format check, unit + widget test, golden test (design system), build debug
on main: build staging flavor → Firebase App Distribution / TestFlight internal + Play internal testing
on tag: 
  iOS: fastlane match (certs) → build_ios_app (prod flavor, --obfuscate --split-debug-info) → upload TestFlight
       → upload dSYM/Dart symbols lên Sentry
  Android: build appbundle (prod) → ký bằng upload key (Play App Signing) → upload Play internal → promote closed/production
  Version: versionName từ tag, versionCode/buildNumber = run number
```
- Codemagic là phương án thay thế nếu không có macOS runner.
- Feature flag + `minVersion` remote cho phép tắt tính năng lỗi không cần phát hành.
- Phát hành theo giai đoạn: Google Play staged rollout (5% → 20% → 50% → 100%), Apple phased release (7 ngày).

---

## 27. Observability

### 27.1 Logs, metrics, traces

- **Logs:** pino JSON → stdout → Promtail/Fluent Bit → **Loki**; trường chuẩn: `ts, level, traceId, userId(pseudo), familyId(pseudo), route, status, latencyMs, errorCode`. Không log nội dung.
- **Metrics:** Prometheus scrape `/metrics` (prom-client) của mỗi process + exporters: node, postgres, redis, mongodb, MinIO (có endpoint Prometheus), nginx, BullMQ (queue depth, failed, latency).
- **Traces:** OpenTelemetry SDK Node (HTTP, Prisma, ioredis, BullMQ) → Tempo/Jaeger (tuỳ chọn); `traceId` trả về trong lỗi API để CSKH tra.
- **Lỗi:** Sentry (backend + Flutter), scrubbing PII bật.

### 27.2 SLO & cảnh báo

| Chỉ số | SLO / Ngưỡng cảnh báo |
|---|---|
| API availability (core read/write) | ≥ 99.9%/tháng; alert khi error rate 5xx > 1% trong 5 phút |
| P95 latency API (trừ upload/AI) | < 400 ms; alert > 800 ms 10 phút |
| Push partner (mood/lời nhờ) | Enqueue < 10 s từ sự kiện; alert queue `notify` > 500 |
| Ảnh xử lý xong | 95% < 30 s; alert queue `media` chờ > 5 phút |
| Video xử lý xong (≤ 3 phút) | 95% < 3 phút |
| Webhook Store | Xử lý < 1 phút; alert backlog > 100 hoặc lỗi verify |
| Deletion job | Hoàn tất ≤ 24h sau `execute_after`; alert job FAILED |
| Outbox lag | < 5 s; alert > 60 s |
| Crash-free sessions (app) | ≥ 99.5% |
| Dung lượng MinIO | alert 75% / 85% |
| PG replication lag | alert > 30 s |
| Tỷ lệ OTP thất bại / chi phí OTP/ngày | alert tăng đột biến (SMS pumping) |

### 27.3 Analytics privacy-first

- App gửi sự kiện tới `POST /v1/events` (batch) → Mongo `app_events` (hoặc pipeline sang warehouse sau này). **Không** dùng SDK quảng cáo; không chia sẻ dữ liệu cho bên thứ ba vì mục đích quảng cáo.
- `userIdPseudo` = HMAC(pepper_analytics, userId) — đổi pepper hằng năm.
- Thuộc tính cho phép: loại sự kiện, `assetCount`, `ageBucket` (0-3m, 4-6m…), `childCountBucket`, `targetScope`, `category`, `plan`, `platform`, `appVersion`. **Cấm:** tên, ngày sinh, nội dung, mood chi tiết kèm id người, số Hearts kèm id người, tên dự định cho con, tên trong “Ai ở đó”. North-star WMFM (nghiệp vụ 15.1) tính từ các sự kiện trên ở warehouse/Mongo theo `familyIdPseudo`.
- Sự kiện chính phục vụ KPI (nghiệp vụ 15): `onboarding_step`, `family_created`, `partner_invite_sent/accepted`, `memory_created(kind, hasFeeling, peopleCount)`, `quote_created(hasAudio)`, `monthly_photo_set(monthIndex, source)`, `monthly_collage_exported(size)`, `perspective_added`, `story_viewed(count)`, `prompt_shown/used/next/dismissed(targetKind)`, `collection_opened(code)`, `name_candidate_added` [1.1], `milestone_recorded`, `mission_board_generated(level)`, `mission_completed(source, late)`, `mission_swapped`, `mission_removed`, `together_completed`, `tree_bloomed`, `checkin_created(shared:bool)`, `request_sent(kind, urgency)`, `request_responded(action)`, `request_done`, `appreciation_sent`, `circle_invited/joined`, `recap_opened/shared`, `paywall_viewed(source)`, `trial_started`, `purchase_completed`, `ai_used(feature, action)`, `report_created(reason)`.

---

## 28. Kiểm thử

### 28.1 Tháp kiểm thử

| Tầng | Công cụ | Trọng tâm |
|---|---|---|
| Unit (backend) | Jest/Vitest | State machine nhiệm vụ & Lời nhờ, thuật toán bày bảng (property test cân bằng), Hearts (trần người/ngày, idempotent, reversal, TOGETHER 2 dòng), tính tuổi, âm lịch VN, recurrence, entitlement, policy functions, ẩn danh AI |
| Integration (backend) | Testcontainers (PG/Redis/Mongo/MinIO) | Repository + constraint DB, API end-to-end trong process, outbox → consumer, webhook Store với payload mẫu |
| **Authz matrix** | Bộ test sinh tự động | Với **mọi endpoint**: Parent A, Parent B, Circle (VIEW/COMMENT/CONTRIBUTE, đúng bé/sai bé), Circle bị gỡ, Circle bị tạm dừng (gói), user family khác, chưa đăng nhập → kỳ vọng (200/403/404) khai báo trong bảng YAML; thêm cặp “Parent B trên tài nguyên Hearts/nhiệm vụ PARENT của Parent A” |
| Contract | OpenAPI + oasdiff, Dart client compile | Không breaking |
| l10n | `l10n_test.dart` (app), test `errors.json`/template (server) | Đủ key mọi ngôn ngữ, plural, fallback `user → en → vi`, push đúng locale người nhận |
| Unit/Widget (Flutter) | flutter_test, mocktail | Formatter tuổi, validate phạm vi nhiệm vụ, switcher, trạng thái rỗng/lỗi/offline, khoá Papa & Mama |
| Golden | golden tests | Component design system light/dark/chữ lớn |
| E2E (mobile) | Patrol trên emulator/simulator + staging | Luồng UC chính |
| Load | k6 | Feed/timeline 500 rps, upload-intents, complete mission đồng thời |
| Security | ZAP baseline, pentest thủ công | IDOR, token replay, presign hết hạn, rate limit, webhook giả |
| Store sandbox | Apple sandbox, Play test | Mua (trong & sau dùng thử), nâng cấp, hạ cấp, gia hạn lỗi → grace, refund/revoke, restore |

### 28.2 Kịch bản E2E bắt buộc (release blocker)

0. **Gate kích hoạt:** đăng nhập → bắt buộc chọn vai trò; Bố tạo gia đình → mọi API tạo bé/ký ức/nhiệm vụ/mua gói trả `403 FAMILY_NOT_ACTIVE`; Mẹ chấp nhận → `TRIAL` theo policy mặc định 7 ngày; mock clock sau trial_ends_at đã cấp → `402 SUBSCRIPTION_REQUIRED`, xuất dữ liệu vẫn chạy; Mẹ mua House → mở khoá cả hai. Người thân tự cài app → chỉ CIR-WAIT. Tạo tài khoản mới cùng SĐT → không được trial lần 2. Trong trial: mời người thân trả `402 PLAN_REQUIRED_FAMILY`, tải lên vượt 10 GB trả `402 QUOTA_STORAGE_EXCEEDED`. Không tồn tại API rời gia đình/tách bạn đời cho Parent.

1. Mẹ tạo gia đình + thai kỳ → mời Bố qua link → Bố cài app từ link → chấp nhận → Mẹ duyệt → cả hai thấy thai kỳ; Papa & Mama mở khoá.
2. Upload 10 ảnh (gồm HEIC) + 1 video 2 phút khi mạng chập chờn → ký ức publish đủ, ảnh không có GPS (kiểm EXIF bản tải về).
3. Bé chào đời sinh đôi, bấm xác nhận 2 lần (retry) → đúng 2 bé, ký ức thai kỳ ở đầu timeline cả hai.
4. Gói Family: mời Bà nội chỉ Hana (Bình luận) → Bà đăng nhập SĐT → thấy ảnh Hana+Haru nhưng không thấy tên Haru, không mở được Haru bằng deep link/ID.
5. Bà đăng ảnh (Contributor) → chờ duyệt → Mẹ duyệt → Bố & Bà thấy.
6. Gỡ Bà → API kế tiếp 403; ảnh cache trên máy Bà bị xoá sau sync; URL cũ hết hạn ≤ 1h.
7. Mẹ gửi **Lời nhờ** Bố “Tắm Haru” • Tối nay → Bố Nhận → chọn “Nhắc mình lúc 19:45” → Bố bấm Đã xong → Bố +5 Hearts (chỉ Bố thấy ở `/hearts/me`; response/thông báo của Mẹ không có Hearts) → Mẹ nhận `REQUEST_DONE`, gửi cảm ơn. Lời nhờ không xuất hiện trong tab nhiệm vụ của ai.
8. Nhiệm vụ **Cùng nhau** Hana+Haru: hai Parent bấm “Xong cùng nhau” cùng lúc → đúng 1 completion, 2 dòng ledger (mỗi người 1), 1 thông báo; hoàn tác trong 10 giây → 2 bút toán ngược.
9. Mẹ check-in “Quá tải” chia sẻ (không chia sẻ ghi chú) → Bố thấy mood, **không** thấy ghi chú (kiểm API response); màn hình khoá ẩn nội dung.
10. Cầu nối: Mẹ viết nháp + chọn 1 ý chia sẻ → Bố tham gia → Bố chỉ nhận ý đã chia sẻ; đóng phiên → sau thời hạn lưu, entries bị xoá.
11. Hạ gói Family → House (hết kỳ) → Bà thấy CIR-05; nâng lại → quyền cũ khôi phục.
12. Hai Parent mua 2 gói → entitlement = gói cao, người mua sau nhận hướng dẫn huỷ.
13. Google: purchase không được acknowledge do server lỗi → retry job acknowledge trong < 3 ngày (test với mock clock).
14. Xoá tài khoản Parent duy nhất → chọn xoá gia đình → 30 ngày (mock clock) → toàn bộ object prefix `fam/{id}/` bị xoá, Apple token revoke được gọi.
15. Xuất dữ liệu gia đình → ZIP đúng cấu trúc, không có dữ liệu Papa & Mama, không có Hearts cá nhân.
16. Bảng nhiệm vụ: mock clock 05:00 → Papa và Mama cùng số nhiệm vụ theo mức, tổng Hearts lệch ≤ 2, +1 Cùng nhau; Mama thai 30 tuần → bộ của Mama có việc `SELF`; Papa Đổi 3 lần (lựa chọn Hearts ±1), lần 4 bị chặn; 23:59 → `EXPIRED` im lặng; hôm sau ghi muộn được, Hearts vẫn cộng.
18. Ảnh tháng & Kể cùng nhau: mock ngày Haru tròn 6 tháng 09:00 → thẻ + push “Chụp ảnh tháng”; chụp ở MEM-21 với sticker → ô tháng 6 ở MEM-20 + bìa chương tháng 6 (AC-026), ảnh gốc tải về không có sticker; Papa thêm góc nhìn vào ký ức của Mama → “Cả hai cùng kể” (AC-027); Bà (Circle) thấy góc nhìn khi ký ức ở Cả nhà, không thấy sau khi Mama bật “ẩn khỏi người thân”; vòng “Hôm nay của Haru” của Papa có viền chưa xem, xem xong mất viền, của Mama không đổi (AC-028); ghi câu nói ≤ 3 chạm, thẻ hiện đúng tuổi khi lùi ngày (AC-029).
17. Hearts riêng tư: đăng nhập Papa → không màn/API nào hiện Hearts của Mama (CARE-01 tab Của Mama, CARE-02, CARE-08, CARE-09, HOME, recap, thông báo); Cây gia đình chỉ cấp + %.

### 28.3 Ma trận thiết bị

- iOS: iPhone SE (màn nhỏ), iPhone 13/15/16 (notch/Dynamic Island), iOS 15 (tối thiểu) & bản mới nhất; iPad (chế độ phóng to).
- Android: máy phổ thông VN (Samsung A-series, Oppo, Xiaomi Redmi — RAM 3–4GB, Android 10–15), Pixel (Android mới nhất), máy có “tối ưu pin” mạnh (kiểm thử upload nền & push).
- Chế độ: dark mode, chữ lớn 200%, TalkBack/VoiceOver, mạng 3G chậm (Network Link Conditioner), offline.

### 28.4 Ca kiểm thử bắt buộc — Nhiệm vụ, Hearts & Lời nhờ (release blocker)

| # | Ca | Kỳ vọng |
|---|---|---|
| H-01 | Parent B gọi `GET /families/{fid}/hearts/me`; thử `/hearts/{userIdA}`, `?userId=A` | chỉ Hearts của B; route/tham số khác → 404/400 (AC-034) |
| H-02 | Snapshot JSON mọi endpoint trả cho B: board `tab=PARTNER`, `/missions/{idCủaA}`, lịch, lịch sử, sync, realtime, bootstrap, `/us/*`, recap, inbox, export gia đình | không có `hearts`, `myHeartsAwarded`, `heartsAwarded`, `hearts_total` gắn với A; không có `EXPIRED`/`REMOVED` của A |
| H-03 | A hoàn thành nhiệm vụ; B gọi `/family-tree` trước/sau | chỉ `level`, `progressPercent`, `fruits`, `flowers`, lá/hoa hôm nay — không có tổng Hearts |
| H-04 | Render mọi `notification_templates` (vi, en) với params mẫu | không chứa Hearts (CI lint) |
| H-05 | TOGETHER: A và B bấm “Xong cùng nhau” song song (100 lần lặp) | 1 completion, đúng 2 dòng ledger (A 1, B 1), 1 thông báo (AC-033) |
| H-06 | Hoàn tác ở giây 9 và giây 31 | bút toán ngược đúng / `409 MISSION_UNDO_WINDOW_CLOSED`; Hearts không âm |
| H-07 | CUSTOM lần 4 trong ngày; tổng vượt 75; 2 request song song chạm trần | lần 4 = 0 Hearts (hành động vẫn thành công); cắt đúng 75, không vượt khi song song |
| B-01 | Property test bày bảng: 10.000 seed × mức Nhẹ/Vừa/Nhiều × (thai 10 tuần, thai 30 tuần, sau sinh 3 tuần, 2 bé 8 tháng + 4 tuổi, sinh đôi) | `count(A) = count(B) = n`; `|ΣA − ΣB| ≤ 2`; không lặp template 14 ngày khi pool đủ; carrier có ≥ 1 `SELF`; giai đoạn cuối thai/hậu sản: bộ còn lại ưu tiên `SUPPORT`/`CARE`; nhiều bé: mỗi bé ≥ 1 việc khi 2n ≥ số bé (AC-030) |
| B-02 | Chạy `generate-daily-board` 2 lần song song / retry sau crash | đúng 1 board, không nhân đôi missions |
| B-03 | Gia đình kích hoạt lúc 14:00 | bảng hôm nay được bày ngay |
| B-04 | Đổi lần 4 trong ngày; `templateId` ngoài options | `422 MISSION_SWAP_LIMIT` / `422 MISSION_SWAP_NOT_ALLOWED`; options có Hearts ±1 (AC-038) |
| B-05 | Ghi muộn nhiệm vụ hôm qua lúc 23:58 hôm nay / 00:01 ngày kia | `DONE`, `late=true`, có Hearts / `422 MISSION_LATE_WINDOW_CLOSED` |
| O-01 | `POST /missions` với `owner=PARTNER` hoặc `ownerUserId` = B do A gửi; insert trực tiếp DB | `422 MISSION_OWNER_INVALID` (AC-036); DB CHECK từ chối |
| O-02 | B gọi complete/undo/swap/remove/carry-over/PATCH trên nhiệm vụ PARENT của A | `403 MISSION_NOT_OWNER` |
| R-01 | Gửi lời nhờ thứ 6 khi đang mở 5 (gồm 2 request song song) | `422 REQUEST_OPEN_LIMIT`, không vượt 5 |
| R-02 | Bị từ chối → gửi lại cùng nội dung sau 11h59 / 12h01; nội dung khác ngay lập tức | `422 REQUEST_RESEND_BLOCKED` + `retryAfter` / cho phép / cho phép |
| R-03 | NEED → accept/done | `409 INVALID_REQUEST_TRANSITION`; Hearts = 0 |
| R-04 | TASK `DONE` | +5 chỉ cho người làm; response & thông báo của người gửi không có Hearts |
| R-05 | Circle gọi `/us/requests*`; tìm lời nhờ trong feed/calendar/search/recap/inbox | 403 / không xuất hiện (AC-037) |
| R-06 | Board mọi tab | không chứa lời nhờ (chỉ `openRequestCount`) |
| R-08 | Lời nhờ `dueAt` ở quá khứ / > 7 ngày; `NOW` | `422 REQUEST_DUE_INVALID` / `expires_at = lúc gửi + 2h` |
| M-01 | BR-071: góc nhìn trên ký ức `PARENTS` → Circle không thấy ở chi tiết, feed, timeline, `TOLD_TOGETHER`, search, recap, “Hôm nay của con”, export; ký ức `FAMILY` + `hiddenFromCircle` → Circle không thấy góc nhìn/huy hiệu; ký ức đổi sang `PARENTS` → góc nhìn hẹp theo ngay | không lộ (AC-027) |
| M-02 | Thêm góc nhìn thứ 2 cùng Parent / vào ký ức của chính mình hoặc của Circle / Circle thêm | `409 PERSPECTIVE_EXISTS` / `422 PERSPECTIVE_NOT_ALLOWED` / `403` |
| M-03 | Tác giả ký ức gốc PATCH nội dung hoặc DELETE góc nhìn của bạn đời | `403`; chỉ `hiddenFromCircle` được |
| M-04 | Xoá ký ức gốc → khôi phục → purge | góc nhìn TRASHED → ACTIVE → bị xoá cùng asset |
| M-05 | BR-072: 2 request song song đặt ảnh chính cùng (bé, tháng); đổi ảnh chính | đúng 1 dòng `monthly_photos`; ký ức cũ còn nguyên |
| M-06 | AC-026: ngày tròn tháng (gồm bé sinh 31/1 → 28/2 hoặc 29/2; âm lịch; bé 14 tháng chế độ AUTO chỉ nhắc tháng 15, 18…) | thẻ + push chỉ khi chưa có ảnh; `monthIndex` sai → `422 MONTH_INDEX_MISMATCH`; Circle tạo `MONTHLY_PHOTO` → `422 MEMORY_KIND_NOT_ALLOWED` |
| M-07 | Ảnh gốc & biến thể sau khi chụp có sticker; collage `withStickers` | hash pixel bản gốc = bản upload (không sticker); collage có sticker, không metadata |
| M-08 | BR-073: gọi `memory-prompts/today` nhiều lần; `next` × N; `dismiss`; tắt gợi ý; 30 ngày liên tiếp | luôn ≤ 1 gợi ý hiệu lực; `next` ≤ giới hạn; sau dismiss → `null` tới mai; tắt → `null`; không lặp template trong 30 ngày; không push |
| M-09 | AC-028: Mama đăng 2 ảnh Haru hôm nay | `unseen=true` với Papa/Bà, `false` với Mama; Papa seen → false cho Papa, Bà vẫn true; ảnh mới sau đó → true lại |
| M-10 | AC-029: `QUOTE` 281 ký tự / 2 bé / lùi ngày | 400/422; tuổi trên thẻ tính theo ngày xảy ra |
| M-11 | “Ảnh đẹp nhất”: A thích, B chưa / cả hai thích / B bỏ thích; B gọi `MY_FAVORITES` | chỉ hiện khi cả hai thích; B chỉ thấy yêu thích của B |
| M-12 | Tên dự định: Circle gọi `/us/pregnancies/{id}/name-candidates`; export gia đình; 2 ❤ | 403; không có; `bothLike = true` |
| M-13 | Đổi “Người mang thai” ở hồ sơ thai kỳ (tuần 30) | bảng ngày kế tiếp: bộ của người mới có `SELF`, bộ còn lại ưu tiên `SUPPORT`/`CARE` |
| R-07 | Người gửi gọi `remind-me`; người nhận gọi `remind-me` lần 2 | 403 `REQUEST_NOT_PARTICIPANT` / `409 REQUEST_REMINDER_USED`; không có endpoint “giục” |

---

## 29. Checklist phát hành App Store & Google Play

### 29.1 Chung

- [ ] Định vị **dành cho cha mẹ/người lớn**; không chọn Kids Category / không chọn nhóm tuổi trẻ em trong Target Audience; screenshot không giống game cho trẻ.
- [ ] Privacy Policy & Terms (vi + en) công khai, không cần đăng nhập; link trong app & paywall.
- [ ] Trang hỗ trợ + email/hotline hiển thị trong app và trên store listing.
- [ ] UGC: Terms cấm nội dung xấu, **báo cáo** nội dung/thành viên trong app, **chặn**, quy trình kiểm duyệt, nút báo cáo nội dung AI (khi bật AI).
- [ ] **Xoá tài khoản trong app** (Settings > Tài khoản) + **trang web xoá tài khoản** (khai báo URL trên Play Console).
- [ ] Tài khoản demo cho reviewer: 1 Parent A + 1 Parent B + 1 Circle, family có dữ liệu mẫu (ảnh tổng hợp, không ảnh trẻ thật), kèm hướng dẫn trong Review Notes (cách mở Papa & Mama, cách mời, cách báo cáo).
- [ ] Giải thích quyền đúng lúc; app vẫn dùng được khi từ chối quyền không cốt lõi.
- [ ] Không thu vị trí, danh bạ.

### 29.2 Apple

- [ ] Sign in with Apple có mặt (vì có Google login) + revoke token khi xoá tài khoản.
- [ ] `PrivacyInfo.xcprivacy` của app + kiểm tra mọi SDK có privacy manifest & chữ ký (Firebase, Sentry…).
- [ ] App Privacy “nutrition labels” khớp thực tế (Contact info, User content: photos/videos/audio/other, Identifiers, Usage data, Diagnostics, Purchases; **không** tracking).
- [ ] App Tracking Transparency: **không cần** (không tracking) — không hiển thị prompt ATT.
- [ ] IAP: 2 sản phẩm trong 1 subscription group, metadata & ảnh review, paywall nêu giá/chu kỳ/tự gia hạn/Terms/Privacy, **Restore Purchases**; App Store Server Notifications V2 URL prod & sandbox.
- [ ] Encryption export compliance (`ITSAppUsesNonExemptEncryption = NO` nếu chỉ dùng HTTPS/mã hoá chuẩn — xác nhận).
- [ ] Age rating questionnaire điền theo tính năng thật (UGC, không giới hạn web…).
- [ ] Universal Links hoạt động (AASA không redirect, content-type JSON).

### 29.3 Google Play

- [ ] targetSdk ≥ 36; kiểm tra lại yêu cầu target API ngay trước khi nộp.
- [ ] Data safety form khai đủ dữ liệu app + SDK (FCM, Sentry, Play Billing…), mã hoá khi truyền, có cách yêu cầu xoá.
- [ ] Photo Picker (không `READ_MEDIA_*`), không `READ_CONTACTS`, không location; khai báo foreground service type nếu dùng cho upload.
- [ ] Play Billing Library phiên bản đang được yêu cầu; acknowledge purchase; RTDN cấu hình.
- [ ] Content rating (IARC), Ads declaration = không quảng cáo, App access (thông tin đăng nhập reviewer), Target audience = 18+.
- [ ] AI-generated content: có cơ chế báo cáo trong app (khi bật AI).
- [ ] App Links `assetlinks.json` đúng SHA-256 của **khoá ký Play App Signing**.
- [ ] Closed testing (nếu tài khoản developer cá nhân mới: yêu cầu số lượng tester & thời gian trước production — kiểm tra quy định hiện hành).

---

## 30. Kế hoạch triển khai (Sprint) & Rủi ro

### 30.1 Sprint (2 tuần/sprint) — team gợi ý: 2 Flutter, 2 Backend, 1 Designer, 1 QA, 0.5 DevOps, 0.5 PO

| Sprint | Backend | Mobile | Khác |
|---|---|---|---|
| 0 | Base project, CI, compose, schema v1, auth (Apple/Google/OTP), AccessContext | Base project, design tokens, components lõi, router, auth screens | Figma design system + luồng chính; đăng ký Zalo OA/ZNS, Apple/Google dev, domain |
| 1 | Vai trò, Family, Parent, invite partner, **gate kích hoạt + trial**, bootstrap, children/pregnancies | Onboarding, invite (deep link), switcher, Home khung | Web: AASA/assetlinks, trang invite fallback |
| 2 | Media pipeline (intent/multipart/worker ảnh), memories CRUD, timeline/feed | Upload manager nền, tạo ký ức, timeline, chi tiết, viewer | |
| 3 | Video/audio worker, comments/reactions, albums, milestones (catalog VN + thai kỳ), trash; câu nói, kỷ vật, “Ai ở đó”, cảm xúc; ảnh tháng (`monthly_photos`, nhắc, collage); góc nhìn thứ hai; bộ sưu tập; “Hôm nay của con”; gợi ý ghi lại; aggregate Trang chủ | Bình luận, reaction, album, cột mốc, thùng rác; MEM-20..25, HOME-01/02/03 | Content: catalog cột mốc, gợi ý ghi lại (17.6), sticker tháng |
| 4 | Circle: invite, grants, shaping, review queue, digest | Circle shell (CIR-*), mời người thân wizard, duyệt ảnh | Authz-matrix tests (release blocker) |
| 5 | Missions: templates (`hearts`, `role_fit`), bày bảng hằng ngày + cân bằng, state machine 4 trạng thái, đổi/bỏ, series, reminders, Hearts ledger cá nhân + Cây gia đình, badges | Chăm con (CARE-01..10, 12), hoàn thành → ký ức | Content: catalog nhiệm vụ 90 ngày/giai đoạn (Hearts + vai trò phù hợp) |
| 6 | Notifications pipeline (FCM, inbox Mongo, quiet hours, gộp), realtime | Push, inbox, settings thông báo | |
| 7 | Us: checkin, Lời nhờ (`us.requests`), appreciation, journal, mã hoá envelope | Papa & Mama (US-00..07, 15) | Security review module Us + Hearts privacy |
| 8 | Billing: Apple/Google verify, webhook, entitlement, quota guard; calendar + âm lịch; recap tuần | Paywall, gói, quota sheets; lịch; recap | Cấu hình sản phẩm Store, sandbox test |
| 9 | Reports/blocks/moderation, deletion orchestration, export, admin CMS | Báo cáo/chặn, xoá tài khoản, xuất dữ liệu, cài đặt | Admin web; trang xoá tài khoản web |
| 10 | Hardening: rate limit, load test, backup/restore drill, observability | Polish, a11y, dark mode, chữ lớn, offline edge cases | Pentest, nộp TestFlight/Closed testing |
| 11 | Fix + phát hành | Fix + phát hành | Review Store, staged rollout |
| 12+ | 1.1: Cầu nối, Thống kê chăm con (CARE-11), handoff, recap ngày/tháng… | | |

→ **MVP ≈ 22–24 tuần** với team trên (ước lượng lập kế hoạch, không phải cam kết). Nếu chỉ 1 Flutter + 1 Backend: ~8–9 tháng hoặc cắt phạm vi (để Circle digest, album tự tạo, lịch sang 1.1).

### 30.2 Rủi ro kỹ thuật

| Rủi ro | Khả năng | Tác động | Giảm thiểu |
|---|---|---|---|
| Chi phí lưu trữ ảnh/video tăng nhanh | Cao | Cao | Quota theo gói, nén, theo dõi GB/family, cân nhắc S3 cloud VN thay MinIO tự host |
| Tình trạng phát hành MinIO Community | Trung bình | Trung bình | S3 API chuẩn, có phương án thay thế (10.8), pin image tự build |
| Rò rỉ dữ liệu chéo gia đình/Circle | Thấp nếu làm đúng | Nghiêm trọng | AccessContext, composite FK, authz-matrix là release blocker, pentest |
| Lộ dữ liệu Papa & Mama | Thấp | Nghiêm trọng | Schema riêng, DB role, mã hoá envelope, test snapshot response |
| Mất KEK | Thấp | Nghiêm trọng | Vault HA + backup 2 nơi, quy trình 2 người |
| Upload nền bị OS giết (Android tối ưu pin) | Cao | Trung bình | WorkManager/foreground service, resume theo part, retry khi mở app |
| Push không đến (máy Trung Quốc tắt dịch vụ nền) | Trung bình | Trung bình | Inbox + sync khi mở app; hướng dẫn tắt tối ưu pin |
| Store từ chối (UGC, xoá tài khoản, IAP, Kids) | Trung bình | Cao | Checklist 29, review notes, demo account |
| OTP bị lạm dụng (chi phí) | Trung bình | Trung bình | Rate limit, captcha có điều kiện, ưu tiên Zalo ZNS, cảnh báo chi phí |
| Webhook Store thất bại → sai entitlement | Trung bình | Cao | Idempotent, reconcile 6h, luôn gọi lại Store API |
| Âm lịch sai ngày | Thấp | Trung bình | Thuật toán UTC+7, bộ test đối chiếu |
| AI trả lời không phù hợp | Trung bình | Cao | Feature hẹp, structured output, hậu kiểm, báo cáo, không tự gửi |
| Pháp lý dữ liệu cá nhân (Luật 91/2025) chưa hoàn thiện hồ sơ | Trung bình | Cao | Làm hồ sơ DPIA & chuyển dữ liệu ra nước ngoài trước phát hành, host tại VN, tư vấn luật |
| Scope MVP quá rộng | Cao | Cao | Giữ cắt phạm vi theo 30.1; Cầu nối & AI sang 1.1/1.2 |

### 30.3 Thứ tự ưu tiên kỹ thuật (không đảo)

1. **Gia đình + phân quyền + composite FK** → 2. **Media pipeline riêng tư** → 3. **Timeline/feed theo quyền** → 4. **Mission engine + Hearts idempotent** → 5. **Papa & Mama cô lập + mã hoá** → 6. **Báo cáo/chặn/xoá/xuất** → 7. **Billing + entitlement** → 8. **AI**.

---

*Hết tài liệu kỹ thuật v3.0. Mọi thay đổi nghiệp vụ phải cập nhật đồng thời mã màn/BR/AC ở tài liệu nghiệp vụ và mục tương ứng ở đây (đặc biệt: 6 — phân quyền, 7 — schema, 11 — API, 15 — state machine, 18 — billing).*
