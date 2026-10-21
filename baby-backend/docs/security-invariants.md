# Bất biến bảo mật §6.4 — bảng bao phủ kiểm thử

Release blocker theo tài liệu kỹ thuật §6.4. Bảng dưới ghi test tự động đang chứng minh từng bất biến (cập nhật BF-20261021-004). Chạy: `TEST_SMTP_HOST=127.0.0.1 npm run test:integration` (DB `baby_family_test`).

| #   | Bất biến                                                                                                  | Test                                                                                                                                                                                                                                                                 |
| --- | --------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | Người không liên quan nhận **404** (không 403/200) ở mọi tài nguyên của gia đình khác dù đoán đúng UUID   | `security-invariants.spec.ts` › 1 — quét 53 route GET theo gia đình/ký ức/bé/thai kỳ/album/nhiệm vụ/Hearts/`/us`; cùng các spec theo miền (`pregnancy-prep-api` …)                                                                                                   |
| 2   | Circle không gọi được `/us/*`, nhiệm vụ, Hearts, mua gói                                                  | `security-invariants.spec.ts` › 2; `couple-request-api` (“hides all request routes from Circle and outsiders”); `/family-tree` cho Circle: `care-progress-api`                                                                                                       |
| 3   | Circle chỉ thấy bé được cấp quyền ở mọi đường đọc                                                         | `security-invariants.spec.ts` › 3 (chi tiết bé, profile-stats, cột mốc, thư, ký ức, today-story, timeline/feed/media-grid/search/on-this-day/danh sách bé); `circle-content-acl.spec.ts` (album, bình luận, thư, cột mốc)                                            |
| 4   | Bị gỡ → request tiếp theo bị từ chối; presign mới bị từ chối                                              | `security-invariants.spec.ts` › 4; `family-circle-api`                                                                                                                                                                                                               |
| 5   | `childIds` của gia đình khác → `422 CHILD_NOT_IN_FAMILY`                                                  | `memory-api.spec.ts`, `family-circle-api.spec.ts`                                                                                                                                                                                                                    |
| 6   | Bạn đời không đọc được nhật ký riêng, check-in chưa chia sẻ                                               | `couple-journal-api` (“readable ONLY by its writer: partner gets 404 for every journal route”), `couple-checkin-api` (“keeps private moods and notes invisible”, “never shares upset with partner”). `conflict_entries.draft` thuộc Cầu nối — bản 1.1, chưa có route |
| 7   | Không route nào trả Hearts của người khác; cây gia đình không có tổng tuyệt đối                           | `security-invariants.spec.ts` › 7 (Parent B quét toàn bộ route, không có Hearts của A); `care-progress-api` (ledger, `/hearts/:userId` 404, cây không có số Hearts); `mission-board-api` (whitelist nhiệm vụ của bạn đời)                                            |
| 8   | Tạo nhiệm vụ cho bạn đời → `422 MISSION_OWNER_INVALID`; thao tác nhiệm vụ của A → `403 MISSION_NOT_OWNER` | `mission-board-api` (“rejects partner ownership and partner mutations”)                                                                                                                                                                                              |
| 9   | Lời nhờ không lộ cho Circle và không vào tab nhiệm vụ                                                     | `couple-request-api` (Circle/người ngoài), `security-invariants.spec.ts` › 2                                                                                                                                                                                         |
| 10  | Góc nhìn thứ hai: Circle chỉ thấy khi xem được ký ức gốc và không bị ẩn; Circle không tạo được            | `memory-perspective-api` (“hidden perspective stays private from Circle”). Tên dự định PREG-07 — bản 1.1, chưa có route                                                                                                                                              |

## Lỗi phát hiện khi lập phép quét

- `GET /families/:fid/calendar` và `GET /events/:id` trả `403 FAMILY_ACCESS_DENIED` cho người ngoài (lộ sự tồn tại) → nay `404` (BF-20261021-004).
- `GET /missions/templates?childId=` với bé không thuộc tôi trả 403 → nay `404`.

## Còn lại

- Route mới phải được thêm vào danh sách quét ở `security-invariants.spec.ts`.
- Bản 1.1 (Cầu nối, PREG-07, câu hỏi kết nối) cần bổ sung khi có route.
- Chưa có pentest bên ngoài.
