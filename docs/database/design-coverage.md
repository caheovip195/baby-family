# Đối chiếu canvas với dữ liệu và luồng nghiệp vụ

Yêu cầu kiểm kê: BF-20261013-004. Ngày kiểm tra canvas: 2026-10-13 (Asia/Ho_Chi_Minh). Cập nhật tài liệu backend/migration: 2026-10-14, BF-20261013-006/BF-20261014-001. Role: DESIGN/BA; số liệu canvas bên dưới giữ nguyên snapshot đã đọc.

## Nguồn và phạm vi chứng cứ

- Canvas thực tế: [appdesgin.pen](../../desgin/appdesgin.pen), truy cập **chỉ bằng Pencil MCP**. Đã đọc get_app_state, pen-schema.md, execute.md; các lệnh canvas chỉ dùng Get/Print/TakeScreenshot, không sửa node, biến hoặc file .pen.
- Đã kiểm kê toàn bộ **188 node cấp cao nhất**: **150 frame màn hình/trạng thái**, **13 frame component reusable**, **25 nhãn section**. 150 frame có **138 mã màn riêng biệt** vì có các biến thể dark, onboarding, xác nhận và cùng mã với trạng thái khác.
- Đã đọc text descendant của các nhóm màn với resolveInstances=true; toàn document có 4.019 text node sau resolve. Đã xem screenshot SUB-01 OUXZg và SUB-03 V2vtZ để phân biệt dấu X ở quyền người thân của House với dòng chữ đơn thuần.
- Truy vấn thấy **0 href**, metadata chỉ có **180 attribution Unsplash**. Không có chứng cứ navigation wires trong dữ liệu đã đọc. Nút/nhãn và màn bên cạnh chứng minh ý định UI; không chứng minh một luồng đã được nối hoặc implementation đã hoạt động.
- Đối chiếu [nghiệp vụ v3](../01_DAC_TA_NGHIEP_VU_BABY_FAMILY_v3.md) §5–9, §7.23–7.25 và [kỹ thuật v3](../02_TAI_LIEU_KY_THUAT_BABY_FAMILY_v3.md) §7. [Prisma schema](../../baby-backend/prisma/schema.prisma) và [forward migration](../../baby-backend/prisma/migrations/20261013150000_family_domain/migration.sql) đã nằm ở backend; migration domain chưa áp dụng vào DB ứng dụng. Canvas vẫn chưa sửa.
- Quyết định BF-20261013-005: trial mặc định **7 ngày** theo policy/version; House/Family là catalog ban đầu, có thể thêm gói. **License thuộc family gốc và không chuyển trong bất kỳ trường hợp nào**; payer xóa account nhưng Store renewal đã thanh toán vẫn cấp family gốc. Copy trial90 ngày trên canvas là quan sát lịch sử, không là policy hiện hành.

## Mapping màn → dữ liệu / luồng

Tên bảng ở cột cuối là nhóm/bảng tham chiếu khi đối chiếu canvas với đặc tả; tên vật lý được chuẩn hóa trong backend schema/migration và [data dictionary](data-dictionary.md). Bảng nối cũng phải có ba cột audit theo [chuẩn database](../../.agents/skills/baby-family-team/references/database-standards.md).

| Nhóm và bằng chứng canvas                                                                       | Dữ liệu / luồng đã quan sát                                                                                                                                                                                                                         | Hệ quả cho schema và quyền                                                                                                                                                                                                                                                                                |
| ----------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AUTH-01…04 GeFXP/XU4Sd/s9bOo/G3AHA; SET-02 wtfze, SET-07 sJFYE                                  | Apple/Google/OTP Zalo–SMS; hồ sơ; liên kết nhiều cách đăng nhập; đồng ý điều khoản/xử lý dữ liệu; thiết bị và logout toàn bộ                                                                                                                        | users, auth_identities, user_consents, user_sessions/devices; provider identity unique; không bỏ cách đăng nhập cuối; revoke session khi xóa tài khoản. PIN/Face ID là khả năng thiết bị, không đồng nghĩa lưu biometric thô vào SQL.                                                                     |
| ONB-03 aBybm, ONB-06 pkzPB, ONB-07 tIOQ7, ONB-WAIT L3DRls, ONB-ACT zKXgc                        | Chọn Papa/Mama/Circle; tạo family WAITING_PARTNER; partner invite 7 ngày, dùng một lần; xác nhận cuối; trial bắt đầu khi đủ hai Parent                                                                                                              | families, family_parents, couple_spaces, family_invites, trial_consumptions; một user chỉ Parent của một family; không cấp trial trước kích hoạt hoặc cấp lại do mời partner thay thế.                                                                                                                    |
| INV-01 gTSrl/BSCuD, INV-02 YqUOv, INV-03 H663k, INV-04 W8mKF, FAM-05 O61Ev                      | Lời mời Parent/Circle khác quyền; trạng thái opened/accepted/wait approval/revoked/expired; Circle 14 ngày, pending cũng chiếm chỗ                                                                                                                  | Tách lifecycle invite khỏi membership; hash token/code, transaction chống nhận trùng/chiếm slot; grant snapshots khi accept phải được kiểm tra lại. Không lộ nguyên nhân invalid invite.                                                                                                                  |
| FAM-01 r8l6e/XwXfH, FAM-03 G6wmB, FAM-04 g7UQ1F, FAM-07 gmT8p, FAM-08 jA5Jt                     | Quan hệ/cách gọi; per-child view/comment/contribute; download; mute; family timezone/default visibility; cùng user Parent ở family A và Circle ở B                                                                                                  | circle_members, circle_grants, blocks, user/family settings; quyền tải và mute khác quyền đọc. Context family khi switch phải đổi toàn app; không lấy quyền Parent của family A dùng ở B.                                                                                                                 |
| SUB-01 OUXZg, SUB-02 m3WJcB, SUB-03 V2vtZ, SUB-04 UqZ8p                                         | Plan của cả Nhà Lan; purchaser Mama, Store App Store, chu kỳ/gia hạn; non-payer nhờ payer nâng cấp; restore purchase                                                                                                                                | Family license/entitlement có family_id bắt buộc; purchaser/store identity riêng; products/plan_quotas, store subscriptions/transactions/notifications. Một Store purchase không đồng thời cấp cho nhiều family; restore/rebinding cần chính sách rõ. Không lấy user.paid=true làm entitlement.           |
| SUB-05 aISrA, SUB-06 Fxgro, SUB-07 aZ9MZ                                                        | Quota video tối đa, grace thanh toán vẫn có quyền; hết trial khóa tạo nhưng giữ export/buy/restore/delete/support                                                                                                                                   | family_entitlements/usage và trạng thái effective; billing grace/expiry không phải xóa family. Quota AI/storage/relatives dùng family; upload reserve/finalize/release phải chống vượt giới hạn khi chạy đồng thời.                                                                                       |
| CHD-01 AR7Mw, CHD-02 nX7EO, CHD-03 Dcj0x, CHD-04 COfI3                                          | Hồ sơ bé, DOB/time, tên ở nhà, cover/color, name story/ai đặt, sở thích, sort order; bé và thai kỳ song song                                                                                                                                        | children/pregnancies, profile/preferences, relation origin pregnancy; tuổi là dữ liệu suy ra từ DOB và thời điểm ký ức, không đóng băng một age string. Bé mới mặc định chưa có Circle grants.                                                                                                            |
| PREG-01 mXdfI, PREG-02 L5bfc, PREG-04 PUD9i; ONB-05a QcAXM                                      | Dự sinh/tuần thai, một/song/ba bé; ảnh bụng theo tuần; ultrasound; checklist có chuyển task hoặc gửi lời nhờ                                                                                                                                        | pregnancies, prep_items, monthly_photos/assets/memories; tuần thai hoặc EDD phải có nguồn/quy tắc chuyển đổi. Checklist không biến thành task của partner khi chưa có consent.                                                                                                                            |
| PREG-05 wpICu/wQZI7, PREG-06 g7Q7Qy, PREG-07 X8AtZx                                             | Birth conversion nhập từng bé, welcome, báo tin chỉ người đang được chia sẻ thai kỳ; pause hoặc loss dừng countdown/reminders/congrats, không báo Circle; name candidates/votes [1.1]                                                               | birth_conversions, children liên kết pregnancy; idempotent conversion, hỗ trợ nhiều bé, quyền chuyển tiếp có quyết định rõ. Loss khác soft delete; scheduler/query/notification phải tôn trọng lifecycle.                                                                                                 |
| HOME-01 uEPMP, HOME-02 gfj2H, HOME-03 l2ePul, SW-01 PfRgF                                       | View family/child/pregnancy; count/story/prompt/recap/care riêng theo scope                                                                                                                                                                         | Query cùng tenant + visibility; count phải cùng ACL với dữ liệu; family aggregation khử trùng multi-child memory. Feed/cached projection không phải nguồn cấp quyền.                                                                                                                                      |
| MEM-05 U18pC, MEM-07 axhOt, MEM-10 ba6Q1, MEM-24 Skx8C, MEM-25 YTCkf                            | Multi-child tags, occurrence date/audience/milestone/album; nhiều media; threaded comments, emoji; second perspective cùng audience; story seen/reply                                                                                               | memories, memory_children/assets/people, comments/reactions/favorites, memory_perspectives/assets, story_views. Album và perspective không mở rộng quyền của memory; reply parent/child cùng family; Circle chỉ thấy chip bé được grant.                                                                  |
| MEM-03 hZoVW, MEM-03a OloCj, MEM-11 FJGSB, MEM-20 KfCF1, MEM-21 RULzX, MEM-22 xVFHt             | Auto/manual albums; xóa album giữ memories; milestone catalog/custom; monthly photo một ô/tháng hoặc tuần pregnancy; collections                                                                                                                    | albums/album_memories, milestones/templates, monthly_photos; active uniqueness, order/cover, canonical monthly-photo selection; không biến mọi collection filter thành bảng sao chép nội dung.                                                                                                            |
| MEM-13 Z9a5ZF, MEM-14 Q4HQel, MEM-18 ACNFh                                                      | Nhật ký ký ức khác Us private journal; thư viết/audio/video, release date/Nth birthday, release audience; local-only và cloud drafts                                                                                                                | memories/drafts/letter metadata + assets; cloud draft owner-only, local draft không bắt buộc gửi DB. Thư sealed: author đọc/sửa, partner chỉ thấy existence trước release; search/export/AI/media URLs phải giữ giới hạn này.                                                                             |
| MEM-15 fwR2y, MEM-16 Ysvtl, MEM-17 sYkws/BB8YZ                                                  | Search/filter/on-this-day; restore trash giữ comments/reactions; permanent purge                                                                                                                                                                    | Search index luôn áp ACL/lifecycle; trash không mở quyền private. deleted_at/purge_after/deleted_by và jobs; purge asset reference phải kiểm tra còn được dùng ở memory/perspective/album khác.                                                                                                           |
| MEM-19 FCHTr, CIR-04 rrk4E/VlK9Y                                                                | Circle contribution pending, author + parents đọc; parent sửa child/audience trước approve; reject reason                                                                                                                                           | Moderation state/history của submission/memory, approved/rejected actor/time; pending không được lọt feed/recap/notification Circle. Một trong hai Parent approve atomically.                                                                                                                             |
| CARE-01 jhh4V/qkr1a, CARE-03 gi5z6, CARE-05 AJPzj, CARE-06 b75gi7, CARE-08 LxWjt, CARE-12 PY4Zg | Own/together tasks, weekday recurrence, reminder; partner chỉ xem completed; balanced boards, swap quota; complete/photo bonus/undo                                                                                                                 | mission_templates/series/boards/parents/missions/children/events/completions/preferences/settings; heart_ledger/daily_counters. Idempotent completion/reward, undo bằng bút toán ngược tương ứng, không hiển thị phạt, serializable/locks cho hạn mức. Request là luồng riêng.                            |
| CARE-09 eRR9k, CARE-10 sCdEt, CARE-11 EWZwi                                                     | Private own Hearts, shared tree/badges, stats aggregate [1.1] không so sánh cá nhân                                                                                                                                                                 | heart_ledger, family_trees, badges/family_badges, care_weekly_snapshots; không gửi raw partner Hearts cho client rồi chỉ ẩn UI. Couple tasks không gộp thống kê chăm bé.                                                                                                                                  |
| CARE-07 DRYZP, CAL-02 xlxDc                                                                     | Family/child/couple/medical-note events; lunar date, yearly lunar recurrence, all-day/time, participants, multiple reminders                                                                                                                        | events, event_children, participants/reminders/occurrences hoặc rule riêng; lunar year/month/day/leap + timezone, recurring exceptions phải rõ. Couple/medical notes không cho Circle dù family plan.                                                                                                     |
| US-01 J1j3bI, US-02 w3t2ak, US-03 HGWaE, US-04 jDPm9/uFjwu, US-06 ihnhh                         | Mood/energy/needs private hoặc explicit share; support response; request seen/accept/decline/complete/remind; thanks, link task/memory                                                                                                              | mood_checkins/responses, requests/request_children, appreciations; membership/couple epoch và participant checks; request receipt không tự tạo assigned mission; Hearts chỉ người nhận thấy.                                                                                                              |
| US-07 L5Opmj, US-08 Is4I7, US-10 ZM8Ho, US-11 iFmGo, US-12 b0kyKY/EjpK0, US-15 kVZ2v            | Self-only journal + selected snippet share; private original conflict draft; mutual shared content/understood/step/close consent; retention 0/7/30/90 ngày                                                                                          | journal_entries, conflict_sessions/entries/steps/consents, data_keys; tách private draft khỏi shared projection. Purge content theo policy, minimal existence record riêng; partner replacement không nối session cũ vào cặp mới.                                                                         |
| US-13 SeTnA                                                                                     | Safety screen: no partner alert, no session history, quick exit                                                                                                                                                                                     | Không tạo safety-visit/session/event record chỉ vì mở màn. Catalog trợ giúp là dữ liệu tĩnh; không gắn telemetry nhạy cảm cho user.                                                                                                                                                                       |
| SET-05 VUDq6, US-09 cRWCh, REC-01 kIqYL, REC-02 z2YZ8A, REC-03 OtCDE                            | AI per-feature consent, explicit selected inputs/draft outputs; family AI budget; weekly/child recaps reviewed before share                                                                                                                         | ai consents/requests/usage reservations + family monthly usage; recaps/source links; exclude SELF/sealed/private Us from shareable recap. AI 1.2/later screens không đồng nghĩa đã triển khai MVP.                                                                                                        |
| SET-03 OJ7tk, NOTI-01 VljHC, CIR-06 SSv4W                                                       | Per-user categories/quiet hours, sensitive lock-screen redaction, mute, daily digest 19:00, read-all                                                                                                                                                | notification preferences/inbox/delivery/digest, user_devices, outbox/jobs/runs/attempts; idempotent dispatch, family lifecycle + ACL kiểm tra lại lúc gửi, quiet-hours timezone của người nhận.                                                                                                           |
| RPT-01 bE4o5/r46T7, RPT-02 E6bZLd, SET-13 DXquo                                                 | Report reasons, child-safety temporary hide/SLA, hide-for-me, block relative nhưng chưa revoke child view; report status                                                                                                                            | reports/report_hides, blocks, moderation_cases/actions; visibility hide khác soft delete; block khác remove membership. Admin audit actor/reason và tenant boundary.                                                                                                                                      |
| CHD-05 ijWOs/tR0OK; SET-09 fU1MN/mCafo/sA3Ch/sOUEE; SET-10 Xq7SJ                                | Archive bé: child-only memories ẩn, shared memories còn cho bé khác; ≥7 ngày trước purge profile; memory trash 30 ngày. Account deletion reauth/session revoke/30day recovery; keep anonymized vs remove authored content; Circle leave keep/remove | Archive timestamp/state khác deleted_at; unlink vs purge multi-child relation; deletion_requests + job checkpoints; family PARTNER_LEFT/DELETION_PENDING; giữ người mua/license relationship không đồng nhất membership. Không xóa authored comments của người khác khi chỉ xóa tài khoản tác giả memory. |
| SET-08 r8zic4, STATE-05 UmR4I, SET-11 fyper                                                     | Personal/family async export, progress/link expiry/auth; cache và pending local uploads; support tickets/reports                                                                                                                                    | export_jobs + assets và jobs; family export excludes Us/private content; personal export owner scope. Local cache/queue khác DB authoritative; outbox/sync_tombstones phục vụ thu hồi/xóa khi reconnect.                                                                                                  |

## Điểm lệch cần xử lý khi triển khai

1. **AI quota:** SET-01 B5bkt ghi 28/30 trong context Family, trong khi SET-05 VUDq6 và SUB-03 V2vtZ ghi 286/300 và quota cả gia đình. Theo §5.3: Trial/House/Family có quota khác nhau; dùng effective family entitlement, không chốt 30 ở user settings.
2. **Nhiệm vụ giao cho bạn đời:** ONB-10 TbUns có copy “Nhận nhiệm vụ Papa/Mama giao”; CARE-03 chỉ có Tôi/Cùng nhau, muốn nhờ partner đi US-03. Theo state machine nghiệp vụ, lời nhờ không tự biến thành nhiệm vụ của người nhận.
3. **Trash ACL:** MEM-17 sYkws ghi “mọi ký ức bị xoá trong gia đình”. Đây không phải quyền đọc SELF, thư chưa mở hoặc Us journal của partner. List/count/restore/export/purge cần ACL riêng và minh bạch.
4. **Sample child scope:** MEM-22 xVFHt đang chọn Haru nhưng card câu nói mang Hana; một số số người xem, ngày và tổng dữ liệu là minh họa không đồng nhất giữa frame. Không dùng các mẫu này để suy ra cross-child sharing hoặc hard-code business counts.
5. **Birth-time visibility:** CHD-01 AR7Mw minh họa người thân không thấy giờ sinh; CHD-02 nX7EO có toggle cho người thân thấy. Schema cần lựa chọn privacy rõ theo đặc tả/quyết định, không suy ra profile luôn public hoặc luôn private từ một screenshot.
6. **Trial:** FAM-01 XwXfH minh họa 10 GB và không Circle, phù hợp C-07; không dùng D-04 cũ 2 GB. Copy “90 ngày”/“3 tháng” trên canvas không quyết định calendar arithmetic; áp quy tắc trial được chốt trong requirements.
7. **House entitlement:** SUB-01 OUXZg có chữ “Mời ông bà, người thân” ở House nhưng screenshot là dấu X/màu disabled; đây là tính năng không được cấp, không phải mâu thuẫn cần cấp Circle cho House.
8. **Phase:** PREG-07/CARE-11/US-14 ghi [1.1], US-09 ghi AI [1.2], MEM-20 có video [1.1]; các màn AI/recap được vẽ sẵn không nâng phase hoặc chứng minh có runtime.
9. **Family license:** SUB-03/04 phân biệt family benefit và quyền quản lý Store của purchaser. Schema không chuyển gói khi user switch family; purchaser xóa tài khoản, restore/link purchase và hai người mua trùng cần policy/transaction riêng theo requirements mới.
10. **Không suy diễn navigation:** 0 href và không có navigation metadata trong dữ liệu đọc; deep links/state-machine lấy từ nghiệp vụ/API, không tuyên bố đã kiểm thử UI navigation.
11. **Việc của bạn đời:** CARE-01b qkr1a và CARE-08 LxWjt chỉ minh họa việc partner đã hoàn thành; nghiệp vụ §7.13.5–7.13.7 lại mô tả cả TODO/DONE trong tab partner. Cần chốt mức hiển thị theo nguồn nghiệp vụ; không suy ra “chỉ DONE” là constraint DB. Hearts của partner vẫn luôn riêng tư trong cả hai trường hợp.

## Luồng không có frame riêng hoặc chưa được biểu diễn đầy đủ

So sánh mã trong heading/bảng của §9 (137 mã) với 138 mã frame riêng biệt; đây là so sánh **mã top-level**, không phải tỷ lệ hoàn thiện chức năng.

| Mã không có top-level frame cùng mã                                                        | Diễn giải và hệ quả dữ liệu                                                                                                                                                                   |
| ------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ONB-02                                                                                     | Đặc tả đã bỏ/gộp vào ONB-03; không phải thiếu luồng phải dựng lại.                                                                                                                            |
| MEM-04                                                                                     | Picker/camera hệ điều hành theo đặc tả; media upload session/reservation và quyền microphone/camera vẫn cần thiết kế.                                                                         |
| MEM-06                                                                                     | Đặc tả nói không phải màn riêng; chỉ có offline queue banner trong STATE-05. Chưa có minh họa pause/cancel/retry upload; không suy ra trạng thái upload đã đầy đủ.                            |
| MEM-09                                                                                     | Form edit có thể reuse MEM-05; chưa có frame quyền/sửa/version conflict riêng.                                                                                                                |
| MEM-02, MEM-12, PREG-03                                                                    | Có tab/collection/cột mốc/siêu âm trên màn khác, chưa có frame grid/filter cùng mã; vẫn phải hỗ trợ read ACL và typed content.                                                                |
| ONB-09, CARE-02, CARE-04, US-05, FAM-06                                                    | First memory, task detail/library, thanks composer, relative-removal confirmation chưa có frame riêng; hành động được nhắc ở màn khác. Dữ liệu/state từ đặc tả vẫn thuộc mapping.             |
| CHD-06 [1.2], REC-04 [2.0]                                                                 | Growth measurements và Year Story/PDF không có frame trong inventory; phase sau, không tự đưa biểu đồ chuẩn/chẩn đoán vào database scope.                                                     |
| PREG-05 bước chọn số bé/chuyển đổi song thai                                               | ONB-05a có số bé; birth frame chỉ cho thấy B2 baby 1/1 và welcome B3–B4. Conversion phải xử lý expected_count và nhiều child nguyên tử/idempotent theo docs, không giới hạn 1 vì screenshot.  |
| Billing restore conflict, refund/revoke/chargeback, purchaser bị xóa hoặc gia đình thứ hai | Có nút restore/manage nhưng không có đầy đủ Store/backend callback/error/ownership-conflict states; cần store event ledger, validation và transaction từ requirements, không tự tin tưởng UI. |
| Lịch sửa/xóa một occurrence, leap lunar month, DST/timezone migration                      | CAL-02 chỉ minh họa create/yearly recurrence/reminders; chưa có các biến thể này. Phải ghi rõ policy trước khi chạy scheduler.                                                                |
| Family restore, account restore, purge completion/failure                                  | Canvas có lời hứa 30 ngày và nút delete; không có toàn bộ recovery/failure screens. Cần durable deletion/purge job history và policy restore sau PARTNER_LEFT.                                |
| Support form/report tracker và Admin CMS                                                   | SET-11 có entrypoint, §9.15 có ADM screens, nhưng không có top-level ADM canvas trong file này. Không coi backoffice/moderation/support đã được vẽ/triển khai.                                |
| Worker/cron, retry/dead-letter, migration/backup                                           | Là luồng server/ops không có màn mobile; vẫn bắt buộc job run/attempt history, outbox, idempotency và recovery theo [jobs](../../baby-backend/docs/jobs.md).                                  |

## Inventory toàn bộ top-level

ID và tên lấy trực tiếp từ Get visitor ở document root. Component không tính là màn hình; nhãn section là text, không phải frame. Dimensions được dùng để nhận diện, không suy ra viewport hay scrolling implementation.

| #   | Node ID  | Loại               | Tên canvas                                                           |
| --- | -------- | ------------------ | -------------------------------------------------------------------- |
| 1   | `rHMK4`  | Component frame    | component/StatusBar                                                  |
| 2   | `j4Xas`  | Component frame    | component/ButtonPrimary                                              |
| 3   | `gRWxn`  | Component frame    | component/ButtonSecondary                                            |
| 4   | `Ky5HH`  | Component frame    | component/ButtonSocial                                               |
| 5   | `Y4I0s8` | Component frame    | component/Input                                                      |
| 6   | `HPjaU`  | Component frame    | component/Chip                                                       |
| 7   | `trgwq`  | Component frame    | component/ChipSelected                                               |
| 8   | `fFQ5S`  | Component frame    | component/LanguageChip                                               |
| 9   | `qhcBT`  | Component frame    | component/TopBar                                                     |
| 10  | `jwJat`  | Screen/state frame | SPL-01 · Splash                                                      |
| 11  | `K5UMY`  | Screen/state frame | ONB-01 · Welcome 1                                                   |
| 12  | `w8tfLj` | Screen/state frame | ONB-01 · Welcome 2                                                   |
| 13  | `MOZNu`  | Screen/state frame | ONB-01 · Welcome 3                                                   |
| 14  | `GeFXP`  | Screen/state frame | AUTH-01 · Đăng nhập                                                  |
| 15  | `XU4Sd`  | Screen/state frame | AUTH-02 · Số điện thoại                                              |
| 16  | `s9bOo`  | Screen/state frame | AUTH-03 · Nhập mã OTP                                                |
| 17  | `G3AHA`  | Screen/state frame | AUTH-04 · Hồ sơ cơ bản                                               |
| 18  | `sOx1x`  | Component frame    | component/ChoiceCard                                                 |
| 19  | `aBybm`  | Screen/state frame | ONB-03 · Bạn là ai trong gia đình                                    |
| 20  | `pkzPB`  | Screen/state frame | ONB-06 · Tên gia đình                                                |
| 21  | `tIOQ7`  | Screen/state frame | ONB-07 · Mời Papa (bắt buộc)                                         |
| 22  | `L3DRls` | Screen/state frame | ONB-WAIT · Chờ Papa tham gia                                         |
| 23  | `zKXgc`  | Screen/state frame | ONB-ACT · Nhà mình đã đủ Papa & Mama                                 |
| 24  | `ZkasK`  | Screen/state frame | ONB-04 · Giai đoạn                                                   |
| 25  | `QcAXM`  | Screen/state frame | ONB-05a · Thai kỳ                                                    |
| 26  | `ARG0K`  | Screen/state frame | ONB-05b · Hồ sơ bé                                                   |
| 27  | `Q1fpJu` | Screen/state frame | ONB-08 · Quyền riêng tư                                              |
| 28  | `TbUns`  | Screen/state frame | ONB-10 · Bật thông báo                                               |
| 29  | `gTSrl`  | Screen/state frame | INV-01 · Xem lời mời (Papa)                                          |
| 30  | `L1k7G`  | Screen/state frame | INV-05 · Nhập mã mời                                                 |
| 31  | `E8YJK`  | Screen/state frame | CIR-WAIT · Người thân chờ lời mời                                    |
| 32  | `BSCuD`  | Screen/state frame | INV-01 · Lời mời người thân (Bà nội)                                 |
| 33  | `luKhc`  | Component frame    | component/TabBar                                                     |
| 34  | `z1ARj`  | Component frame    | component/MissionCard                                                |
| 35  | `SjvF6`  | Component frame    | component/ChildSwitcher                                              |
| 36  | `PfRgF`  | Screen/state frame | SW-01 · Chọn bé                                                      |
| 37  | `IWfKB`  | Screen/state frame | QC-01 · Tạo nhanh                                                    |
| 38  | `U18pC`  | Screen/state frame | MEM-05 · Soạn ký ức                                                  |
| 39  | `axhOt`  | Screen/state frame | MEM-07 · Chi tiết ký ức                                              |
| 40  | `eRR9k`  | Screen/state frame | CARE-09 · Cây gia đình                                               |
| 41  | `J1j3bI` | Screen/state frame | US-01 · Papa & Mama                                                  |
| 42  | `w3t2ak` | Screen/state frame | US-02 · Check-in cảm xúc                                             |
| 43  | `r8l6e`  | Screen/state frame | FAM-01 · Gia đình                                                    |
| 44  | `G6wmB`  | Screen/state frame | FAM-03 · Mời người thân                                              |
| 45  | `zO5Oq`  | Screen/state frame | CIR-01 · Cháu yêu (Người thân)                                       |
| 46  | `OUXZg`  | Screen/state frame | SUB-01 · Chọn gói                                                    |
| 47  | `aZ9MZ`  | Screen/state frame | SUB-07 · Hết hạn dùng thử                                            |
| 48  | `B5bkt`  | Screen/state frame | SET-01 · Cài đặt                                                     |
| 49  | `AoMyv`  | Screen/state frame | SET-06 · Hiển thị & Ngôn ngữ                                         |
| 50  | `VljHC`  | Screen/state frame | NOTI-01 · Thông báo                                                  |
| 51  | `k0kJe`  | Section text       | Section · 1 · Khởi động & Giới thiệu                                 |
| 52  | `cmGW3`  | Section text       | Section · 2 · Đăng nhập                                              |
| 53  | `r5lJwj` | Section text       | Section · 3 · Vai trò & Kích hoạt gia đình (bắt buộc đủ Papa + Mama) |
| 54  | `z9u1K`  | Section text       | Section · 4 · Hồ sơ bé & Thiết lập                                   |
| 55  | `f5lSA4` | Section text       | Section · 5 · Lời mời & Người thân chờ                               |
| 56  | `nLrrR`  | Section text       | Section · 6 · Trang chủ & Ký ức                                      |
| 57  | `CeJIc`  | Section text       | Section · 7 · Chăm con & Nhiệm vụ                                    |
| 58  | `dr2RD`  | Section text       | Section · 8 · Papa & Mama (riêng tư)                                 |
| 59  | `kOcvv`  | Section text       | Section · 9 · Gia đình, Người thân, Gói & Cài đặt                    |
| 60  | `yXhT0`  | Section text       | Section · Components                                                 |
| 61  | `EpUeM`  | Section text       | Section · 10 · Trạng thái chuẩn: Loading · Empty · Error · Offline   |
| 62  | `DovV2`  | Screen/state frame | STATE-01 · Loading (Ký ức)                                           |
| 63  | `fXNoV`  | Screen/state frame | STATE-02 · Empty (Ký ức của Haru)                                    |
| 64  | `ghZZx`  | Screen/state frame | STATE-03 · Empty (Chăm con hôm nay)                                  |
| 65  | `jlZ2q`  | Screen/state frame | STATE-04 · Error (Không tải được)                                    |
| 66  | `GHH3c`  | Section text       | Section · 11 · Dark mode                                             |
| 67  | `E8mGfO` | Screen/state frame | US-01 · Papa & Mama (Dark)                                           |
| 68  | `q0LOcN` | Screen/state frame | CIR-01 · Cháu yêu (Dark)                                             |
| 69  | `jhh4V`  | Screen/state frame | CARE-01 · Chăm con hôm nay (Của tôi)                                 |
| 70  | `qkr1a`  | Screen/state frame | CARE-01b · Chăm con (tab Của Papa)                                   |
| 71  | `b75gi7` | Screen/state frame | CARE-06 · Hoàn thành nhiệm vụ                                        |
| 72  | `AJPzj`  | Screen/state frame | CARE-05 · Đổi nhiệm vụ                                               |
| 73  | `gi5z6`  | Screen/state frame | CARE-03 · Thêm nhiệm vụ                                              |
| 74  | `HGWaE`  | Screen/state frame | US-03 · Gửi lời nhờ                                                  |
| 75  | `jDPm9`  | Screen/state frame | US-04 · Lời nhờ nhận được (góc nhìn Papa)                            |
| 76  | `uFjwu`  | Screen/state frame | US-04b · Lời nhờ đã nhận (góc nhìn Papa)                             |
| 77  | `J0I7c`  | Screen/state frame | CARE-01 · Chăm con (Dark)                                            |
| 78  | `uEPMP`  | Screen/state frame | HOME-01 · Trang chủ (cuộn đầy đủ)                                    |
| 79  | `ClpJ6`  | Screen/state frame | HOME-01 · Trang chủ (Cả nhà)                                         |
| 80  | `gfj2H`  | Screen/state frame | HOME-02 · Trang chủ của Haru                                         |
| 81  | `wtBRl`  | Screen/state frame | MEM-01 · Dòng thời gian (Haru)                                       |
| 82  | `KfCF1`  | Screen/state frame | MEM-20 · Con lớn từng tháng                                          |
| 83  | `RULzX`  | Screen/state frame | MEM-21 · Chụp ảnh tháng                                              |
| 84  | `xVFHt`  | Screen/state frame | MEM-22 · Bộ sưu tập                                                  |
| 85  | `gKmSW`  | Screen/state frame | MEM-23 · Ghi câu nói của con                                         |
| 86  | `Skx8C`  | Screen/state frame | MEM-24 · Thêm góc nhìn của bạn                                       |
| 87  | `YTCkf`  | Screen/state frame | MEM-25 · Hôm nay của Haru (story)                                    |
| 88  | `Eco8F`  | Section text       | Section · 12 · Thai kỳ (Bơ — tuần 24)                                |
| 89  | `l2ePul` | Screen/state frame | HOME-03 · Trang chủ thai kỳ (Bơ)                                     |
| 90  | `mXdfI`  | Screen/state frame | PREG-01 · Hành trình thai kỳ                                         |
| 91  | `L5bfc`  | Screen/state frame | PREG-02 · Bụng bầu theo tuần                                         |
| 92  | `PUD9i`  | Screen/state frame | PREG-04 · Chuẩn bị đón bé                                            |
| 93  | `wpICu`  | Screen/state frame | PREG-05 · Bé đã chào đời (B2 · thông tin bé)                         |
| 94  | `wQZI7`  | Screen/state frame | PREG-05 · Bé đã chào đời (B3–B4 · chào mừng & báo tin)               |
| 95  | `g7Q7Qy` | Screen/state frame | PREG-06 · Lưu trữ hành trình (nhạy cảm)                              |
| 96  | `X8AtZx` | Screen/state frame | PREG-07 · Đặt tên cho con [1.1]                                      |
| 97  | `ogBCU`  | Screen/state frame | HOME-01 · Trang chủ (Dark)                                           |
| 98  | `bPN4M`  | Screen/state frame | MEM-01 · Dòng thời gian (Dark)                                       |
| 99  | `UmR4I`  | Screen/state frame | STATE-05 · Offline (Trang chủ)                                       |
| 100 | `hZoVW`  | Screen/state frame | MEM-03 · Album                                                       |
| 101 | `g7UQ1F` | Screen/state frame | FAM-04 · Chi tiết người thân                                         |
| 102 | `DRYZP`  | Screen/state frame | CARE-07 · Lịch                                                       |
| 103 | `OloCj`  | Screen/state frame | MEM-03a · Chi tiết album                                             |
| 104 | `gmT8p`  | Screen/state frame | FAM-07 · Cài đặt gia đình                                            |
| 105 | `J8ZEtR` | Screen/state frame | MEM-08 · Xem ảnh toàn màn hình                                       |
| 106 | `xlxDc`  | Screen/state frame | CAL-02 · Tạo sự kiện                                                 |
| 107 | `wtfze`  | Screen/state frame | SET-02 · Hồ sơ                                                       |
| 108 | `OJ7tk`  | Screen/state frame | SET-03 · Thông báo                                                   |
| 109 | `ba6Q1`  | Screen/state frame | MEM-10 · Bình luận                                                   |
| 110 | `LxWjt`  | Screen/state frame | CARE-08 · Lịch sử nhiệm vụ                                           |
| 111 | `mD130`  | Screen/state frame | SET-04 · Quyền riêng tư                                              |
| 112 | `sCdEt`  | Screen/state frame | CARE-10 · Huy hiệu                                                   |
| 113 | `sJFYE`  | Screen/state frame | SET-07 · Bảo mật & Thiết bị                                          |
| 114 | `FJGSB`  | Screen/state frame | MEM-11 · Chọn cột mốc                                                |
| 115 | `r8zic4` | Screen/state frame | SET-08 · Dữ liệu của tôi                                             |
| 116 | `fU1MN`  | Screen/state frame | SET-09 · Xoá tài khoản — Tác động                                    |
| 117 | `Z9a5ZF` | Screen/state frame | MEM-13 · Viết nhật ký                                                |
| 118 | `mCafo`  | Screen/state frame | SET-09b · Xoá tài khoản — Gia đình                                   |
| 119 | `PY4Zg`  | Screen/state frame | CARE-12 · Cài đặt nhiệm vụ                                           |
| 120 | `Q4HQel` | Screen/state frame | MEM-14 · Thư gửi con                                                 |
| 121 | `sA3Ch`  | Screen/state frame | SET-09b · Xoá tài khoản — Parent duy nhất (biến thể)                 |
| 122 | `sOUEE`  | Screen/state frame | SET-09c · Xoá tài khoản — Xác thực & xác nhận                        |
| 123 | `fyper`  | Screen/state frame | SET-11 · Trợ giúp                                                    |
| 124 | `ihnhh`  | Screen/state frame | US-06 · Bức tường cảm ơn                                             |
| 125 | `vlWDT`  | Screen/state frame | SET-12 · Giới thiệu                                                  |
| 126 | `L5Opmj` | Screen/state frame | US-07 · Nhật ký riêng                                                |
| 127 | `lHrkW`  | Section text       | Section · 17 · Gia đình & Cài đặt (mở rộng)                          |
| 128 | `yAlKq`  | Section text       | Section · 18 · Tài khoản & Xoá tài khoản                             |
| 129 | `fwR2y`  | Screen/state frame | MEM-15 · Tìm kiếm                                                    |
| 130 | `kVZ2v`  | Screen/state frame | US-15 · Cài đặt Papa & Mama                                          |
| 131 | `AR7Mw`  | Screen/state frame | CHD-01 · Hồ sơ bé (Haru)                                             |
| 132 | `Ysvtl`  | Screen/state frame | MEM-16 · Ngày này năm xưa                                            |
| 133 | `nX7EO`  | Screen/state frame | CHD-02 · Sửa hồ sơ bé                                                |
| 134 | `z2YZ8A` | Screen/state frame | REC-02 · Tuần của nhà mình                                           |
| 135 | `Dcj0x`  | Screen/state frame | CHD-03 · Các con                                                     |
| 136 | `Q8ZZY`  | Section text       | Section · 13 · Ký ức (mở rộng)                                       |
| 137 | `x2RQX`  | Section text       | Section · 14 · Tổng kết                                              |
| 138 | `COfI3`  | Screen/state frame | CHD-04 · Thêm bé                                                     |
| 139 | `GaQzl`  | Section text       | Section · 15 · Chăm con & Lịch (mở rộng)                             |
| 140 | `dr0yV`  | Section text       | Section · 16 · Papa & Mama & Hồ sơ bé (mở rộng)                      |
| 141 | `XwXfH`  | Screen/state frame | FAM-01 · Gia đình (đang dùng thử)                                    |
| 142 | `c4QEM`  | Screen/state frame | US-00 · Papa & Mama (bạn đời đã rời — PARTNER_LEFT)                  |
| 143 | `Is4I7`  | Screen/state frame | US-08 · Cầu nối: bắt đầu (riêng tư)                                  |
| 144 | `sYkws`  | Screen/state frame | MEM-17 · Thùng rác                                                   |
| 145 | `cRWCh`  | Screen/state frame | US-09 · Viết lại nhẹ nhàng [AI 1.2]                                  |
| 146 | `BB8YZ`  | Screen/state frame | MEM-17b · Thùng rác — Xác nhận xoá vĩnh viễn                         |
| 147 | `V2vtZ`  | Screen/state frame | SUB-03 · Gói của gia đình                                            |
| 148 | `ZM8Ho`  | Screen/state frame | US-10 · Lời mời Cầu nối (góc nhìn Papa)                              |
| 149 | `ACNFh`  | Screen/state frame | MEM-18 · Nháp                                                        |
| 150 | `iFmGo`  | Screen/state frame | US-11 · Phiên chung                                                  |
| 151 | `UqZ8p`  | Screen/state frame | SUB-04 · Nâng cấp House → Family                                     |
| 152 | `FCHTr`  | Screen/state frame | MEM-19 · Chờ duyệt                                                   |
| 153 | `m3WJcB` | Screen/state frame | SUB-02 · Xác nhận mua                                                |
| 154 | `aISrA`  | Screen/state frame | SUB-05 · Đạt giới hạn (video dài)                                    |
| 155 | `bE4o5`  | Screen/state frame | RPT-01 · Báo cáo (sheet)                                             |
| 156 | `Fxgro`  | Screen/state frame | SUB-06 · Banner trạng thái gói (thanh toán chưa thành công)          |
| 157 | `r46T7`  | Screen/state frame | RPT-01b · Báo cáo — Đã gửi                                           |
| 158 | `YqUOv`  | Screen/state frame | INV-02 · Lời mời không hợp lệ                                        |
| 159 | `E6bZLd` | Screen/state frame | RPT-02 · Chặn (dialog)                                               |
| 160 | `b0kyKY` | Screen/state frame | US-12 · Bước tiếp theo                                               |
| 161 | `H663k`  | Screen/state frame | INV-03 · Bạn đang là Bố/Mẹ ở gia đình khác                           |
| 162 | `ijWOs`  | Screen/state frame | CHD-05 · Lưu trữ / Xoá bé                                            |
| 163 | `EjpK0`  | Screen/state frame | US-12b · Đóng phiên? (sheet)                                         |
| 164 | `W8mKF`  | Screen/state frame | INV-04 · Chờ xác nhận (góc nhìn Papa)                                |
| 165 | `tR0OK`  | Screen/state frame | CHD-05b · Xoá vĩnh viễn bé (xác nhận 2 lần)                          |
| 166 | `SeTnA`  | Screen/state frame | US-13 · Hỗ trợ an toàn                                               |
| 167 | `VGRgb`  | Screen/state frame | FAM-02 · Mời bạn đời (sau khi Papa rời — PARTNER_LEFT)               |
| 168 | `Vy0TS`  | Screen/state frame | CIR-02 · Trang của cháu (người thân)                                 |
| 169 | `A7OdH4` | Screen/state frame | US-14 · Tuần của hai ta [1.1]                                        |
| 170 | `O61Ev`  | Screen/state frame | FAM-05 · Lời mời đang chờ                                            |
| 171 | `gml5c`  | Screen/state frame | CIR-03 · Chi tiết ký ức (người thân)                                 |
| 172 | `jA5Jt`  | Screen/state frame | FAM-08 · Chuyển gia đình                                             |
| 173 | `kIqYL`  | Screen/state frame | REC-01 · Câu chuyện ngày (Haru)                                      |
| 174 | `VUDq6`  | Screen/state frame | SET-05 · AI                                                          |
| 175 | `rrk4E`  | Screen/state frame | CIR-04 · Đăng ảnh (người thân đóng góp)                              |
| 176 | `VlK9Y`  | Screen/state frame | CIR-04b · Đăng ảnh — Đã gửi                                          |
| 177 | `Xq7SJ`  | Screen/state frame | SET-10 · Rời gia đình (người thân · Bà ngoại)                        |
| 178 | `OtCDE`  | Screen/state frame | REC-03 · Tháng tuổi (Haru tròn 18 tháng)                             |
| 179 | `ADYog`  | Screen/state frame | CIR-05 · Gia đình tạm dừng chia sẻ                                   |
| 180 | `DXquo`  | Screen/state frame | SET-13 · Người bị chặn                                               |
| 181 | `tervb`  | Section text       | Section · 23 · Gói dịch vụ & Lời mời                                 |
| 182 | `QDeXu`  | Section text       | Section · 24 · Gia đình & Cài đặt (còn lại)                          |
| 183 | `SSv4W`  | Screen/state frame | CIR-06 · Tôi (người thân)                                            |
| 184 | `BqXxH`  | Section text       | Section · 21 · Ký ức: Thùng rác, Nháp, Chờ duyệt & Báo cáo           |
| 185 | `spYm0`  | Section text       | Section · 22 · Người thân (Circle)                                   |
| 186 | `EWZwi`  | Screen/state frame | CARE-11 · Thống kê chăm con [1.1]                                    |
| 187 | `QYjz7`  | Section text       | Section · 19 · Papa & Mama: Cầu nối & Tuần của hai ta                |
| 188 | `VDTP8`  | Section text       | Section · 20 · Tổng kết & Thống kê                                   |

## Verification và giới hạn

- Đã kiểm tra inventory 188 IDs không trùng, phân loại 150/13/25, 138 mã screen riêng biệt; đọc descendant text/actions labels cho các nhóm bao phủ toàn bộ 150 frame. Screenshot evidence chỉ lấy SUB-01 và SUB-03, không tự tạo hình hoặc thay canvas.
- Mapping nêu rõ các bảng/query/quyền cần thiết; chưa phải kết quả API runtime test. SQL/Prisma được kiểm tra riêng theo [verification](verification.md) và [SQL validation backend](../../baby-backend/test/database-design/validate.sh).
- Sample names/dates/counters trên canvas là fixture thiết kế, không phải số liệu product analytics hoặc dữ liệu gia đình thật đã xác minh.
- Phần kiểm kê DESIGN không sửa canvas/mobile hoặc áp migration vào live DB. Phần backend riêng đã tạo schema/migration thật; migration chỉ DDL, [seed](../../baby-backend/prisma/seed.ts) chạy riêng qua `npm run db:seed`, không tự chạy khi migrate/start. Các API nghiệp vụ ngoài Note vẫn chưa triển khai.
