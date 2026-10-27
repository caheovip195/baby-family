# Offline sync — BF-20261022-001-A

Code đã có; cần đăng ký DI/controller theo [handoff](handoffs/BF-20261022-001-A.md) trước khi route mới hoạt động trong AppModule. Không có job/cron mới.

## Changes

`GET /api/v1/families/:familyId/changes?cursor=<opaque>&limit=100`, Bearer token đang hoạt động. `limit` nguyên 1–200, mặc định 100. Response **không bọc `{data: ...}`**:

```json
{
  "items": [
    {
      "entity": "memory",
      "id": "<memory UUID>",
      "op": "upsert",
      "version": 2,
      "updatedAt": "2026-10-22T01:00:00.000Z",
      "data": { "id": "<memory UUID>", "version": 2 }
    },
    {
      "entity": "memoryComment",
      "id": "<comment UUID>",
      "memoryId": "<memory UUID>",
      "op": "upsert",
      "updatedAt": "2026-10-22T01:00:00.000Z",
      "data": {
        "id": "<comment UUID>",
        "memoryId": "<memory UUID>",
        "body": "Synthetic comment",
        "authorUserId": "<user UUID>",
        "parentCommentId": null
      }
    },
    {
      "entity": "memoryReaction",
      "id": "<memory UUID>:<user UUID>",
      "memoryId": "<memory UUID>",
      "op": "upsert",
      "updatedAt": "2026-10-22T01:00:00.000Z",
      "data": {
        "id": "<memory UUID>:<user UUID>",
        "memoryId": "<memory UUID>",
        "userId": "<user UUID>",
        "type": "LOVE"
      }
    },
    {
      "entity": "memory",
      "id": "<another memory UUID>",
      "op": "delete",
      "updatedAt": "2026-10-22T01:00:00.001Z"
    }
  ],
  "nextCursor": "<opaque>",
  "hasMore": false
}
```

- Memory chỉ trả `id + version`; lấy nội dung và URL media ký mới qua `GET /api/v1/memories/:id`. Tombstone không có `data`/`version`. Reaction không có UUID riêng: `id = memoryId:userId` ổn định qua đổi/xoá/khôi phục cảm xúc.
- Cursor phiên bản 1 ràng buộc family và user; không tự sửa/giải mã trên client. Thứ tự tăng `(updated_at, id)` của **receipt log**. `updatedAt` là lúc server quan sát thay đổi, không phải thời điểm người dùng thao tác offline hay timestamp gốc entity. Hai thao tác trước cùng một lần pull có thể gộp thành trạng thái mới nhất. Cùng một entity có thể xuất hiện nhiều lần qua nhiều lần thay đổi; client áp tuần tự và upsert/delete theo khóa `(entity,id)`.
- Không cursor: bootstrap metadata của **toàn bộ entity hiện được xem, kể cả ký ức cũ hơn 90 ngày**, và replay log 90 ngày gần nhất. Cần bootstrap mọi ID để thu hồi cache feed cũ chính xác. Cursor quá 90 ngày → `409 SYNC_CURSOR_EXPIRED`: xoá cache family, bootstrap lại. Chưa có job purge log; 90 ngày là cửa sổ replay/cursor, không phải cam kết đã xoá dữ liệu server.
- Khởi tạo sync bằng changes trước khi tải full feed, giữ cursor, tải feed rồi drain changes đến `hasMore=false`. Cache được tạo trước khi bật giao thức này phải xoá và bootstrap lại: server không thể chứng minh ID đã từng được máy cũ tải. Khi `404 NOT_FOUND`, xoá cache family vì membership không còn hợp lệ.
- Mỗi pull kiểm tra membership/entitlement và ACL hiện tại: Parent, Circle grant tất cả bé liên quan, PRIVATE chỉ chủ, thư chưa mở chỉ chủ, pending review chỉ Parent; cùng loại trừ report-hide/block như feed. Thu hồi grant/hide/trash/soft delete tạo tombstone cho ID có receipt trước đó, không lộ ID private chưa từng được phép đồng bộ. Queued upsert cũng bị chuyển delete khi quyền đã mất. Cấp lại quyền/restore tạo upsert.
- Sai cursor/limit → `400 VALIDATION_ERROR`; UUID family sai → `400 BAD_REQUEST`; không Bearer/phiên không hợp lệ → `401`; người ngoài/thành viên bị gỡ → `404 NOT_FOUND`. Các gate family/entitlement kế thừa mã lỗi API hiện có, ví dụ `403 CIRCLE_PAUSED`, `402 SUBSCRIPTION_REQUIRED`.
- `limit` chỉ giới hạn response. Implementation hiện quét entity family và lịch sử receipt mỗi pull, chia INSERT tối đa 2.000 dòng/mẻ. Cần đo tải thực tế và tối ưu incremental materialization/retention trước khi bật cho family lớn.

## Idempotency

Header `Idempotency-Key: <UUID>` tuỳ chọn trên các route dưới. Không key giữ hành vi cũ; có key sai định dạng → `400 BAD_REQUEST`. Giữ nguyên key cho mọi retry của cùng một thao tác. Cùng actor/operation/key và body/resource giống nhau → replay snapshot response; body/resource khác → `409 IDEMPOTENCY_KEY_REUSED`. Khác operation là namespace riêng.

| Route (sau `/api/v1`)                                         | Thực hiện                                                                 |
| ------------------------------------------------------------- | ------------------------------------------------------------------------- |
| `POST /memories/:id/comments`                                 | Tạo bình luận, snapshot response                                          |
| `PUT /memories/:id/reaction`, `DELETE /memories/:id/reaction` | Đặt/đổi/xoá reaction, snapshot response                                   |
| `PUT /memories/:memoryId/perspective`                         | Route thực tế tạo hoặc sửa góc nhìn, snapshot response                    |
| `PUT /memories/:id/favorite`, `DELETE /memories/:id/favorite` | Snapshot 204                                                              |
| `POST /notes`, `PATCH /notes/:id`, `DELETE /notes/:id`        | Note sample hiện công khai; giữ nguyên auth, snapshot JSON/204            |
| `POST /families/:familyId/us/journal`                         | Nhật ký riêng; response snapshot mã hoá                                   |
| `POST /families/:familyId/us/checkins`                        | Check-in Papa & Mama; snapshot mã hoá                                     |
| `POST /families/:familyId/us/appreciations`                   | Cảm ơn Papa & Mama; snapshot mã hoá                                       |
| `POST /families/:familyId/us/requests`                        | Header **bắt buộc** (như trước); native ledger + snapshot response mã hoá |
| `POST /missions/:id/complete`                                 | Native IdempotencyRecord + mission completion ledger; header **bắt buộc** |
| `POST /missions`, `POST /missions/:id/moment`                 | Native ledger; header **bắt buộc**                                        |

`POST /memories` và các media upload-intent đã có cơ chế riêng, header vẫn bắt buộc như trước. Edit/delete comment, delete perspective, edit/delete/share journal và các hành động request/check-in/appreciation khác giữ API hiện có; không đưa vào danh sách thao tác queue mới trong đợt này. Không có route tạo “couple journal” công khai dùng chung khác với private journal hiện tại.

Snapshot generic dùng `IdempotencyRecord`, mã hoá AES-256-GCM từ `AUTH_SECRET_PEPPER` (fallback `COUPLE_CHECKIN_ENCRYPTION_KEY`); phải giữ khoá ổn định. Kiểm tra quyền lại trước replay. Chưa đăng ký service/key mã hoá → `503 SERVICE_UNAVAILABLE` cho route keyed mới; couple-request fallback ledger cũ để không phá wiring hiện hành. Claim đang xử lý hoặc kết quả chưa xác định → `409 IDEMPOTENCY_COMMAND_PENDING`, không chạy lại side effect. Crash sau commit nghiệp vụ nhưng trước lưu snapshot cần đối soát thủ công; chưa có reconciler tự động, client không được đổi key để vượt lỗi này. Xem handoff về giới hạn này.
