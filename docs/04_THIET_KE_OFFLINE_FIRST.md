# Thiết kế dữ liệu offline-first và đồng bộ server

- Mã yêu cầu: BF-20261021-008 (người dùng chốt ngày 2026-10-21).
- Trạng thái: **thiết kế, chưa triển khai**. Phần "Hiện trạng" mô tả code thật lúc viết; các phần khác là đích cần làm theo từng tính năng.

## 1. Mục tiêu

- App dùng được bình thường khi không có mạng, với dữ liệu đã lưu trên máy: xem dòng thời gian, tạo nhật ký/bài đăng/ký ức, ghi chăm sóc, hoàn thành nhiệm vụ, sửa hồ sơ bé…
- Có mạng thì tự đồng bộ hai chiều: đẩy thay đổi chờ lên server, kéo thay đổi mới về. Người dùng không phải bấm gì.
- Server vẫn là nguồn sự thật về quyền, gói/quota, kiểm duyệt và dữ liệu chung của cả nhà. Client chỉ "đề xuất" thay đổi, và server có thể từ chối.

## 2. Hiện trạng (2026-10-21)

| Thành phần | Hiện tại | Giới hạn |
| --- | --- | --- |
| `MockStore` (`lib/data/repository_imp/mock_store.dart`) | Bảng JSON trong RAM; repository đọc/ghi; remote service mirror dữ liệu server vào đây | Mất khi tắt app |
| Offline snapshot (`IOfflineSnapshotRepository`, BF-20261019-009) | Bản chụp mã hoá để mở app lúc mất mạng vẫn giữ phiên và dữ liệu đã đồng bộ | Chụp cả khối, không có hàng đợi thay đổi |
| Hàng đợi upload ký ức (MEM-06) | `create(deferUpload:)`: ký ức hiện ngay, ảnh/video tải nền, có thử lại/huỷ | Chỉ áp dụng cho media của ký ức, sống trong phiên app |
| Media local-first (BF-20261021-008) | Ảnh/video còn trong thư viện máy được hiển thị trước bản server (khớp SHA-256) | Chỉ áp dụng cho hiển thị |
| Backend | `Idempotency-Key` (`IdempotencyRecord`) cho các lệnh tạo; `If-Match` + version cho sửa ký ức (MEM-09, trả 428/412) | Chưa có API kéo thay đổi theo mốc (`since`) chung |

Thiết kế này **tổng quát hoá** ba cơ chế trên, không viết lại từ đầu.

## 3. Kiến trúc đích (app)

```
Page → Controller → Service ──đọc/ghi──▶ Local repository (DB trên máy)
                         │                         ▲
                         └─ ghi kèm ─▶ Outbox ─────┤
                                         │         │ áp kết quả
                               SyncEngine (khi có mạng)
                                    │ push / pull
                                    ▼
                             Remote repository → API
```

1. **Local store bền vững** thay cho bảng RAM: SQLite (ví dụ `drift`) hoặc store mã hoá. Mỗi bảng nghiệp vụ có:
   - `id`: UUID do client tạo, dùng luôn làm id server khi tạo mới, nên không cần ánh xạ id.
   - `server_version` hoặc `updated_at` lấy từ server.
   - `sync_state`: `synced` · `pending` · `conflict` · `rejected`.
   - `deleted_at`: xoá mềm, đồng bộ như một thay đổi.

   Giữ đúng luồng kiến trúc: chỉ repository chạm DB; service không biết đang online hay offline.
2. **Outbox**: mỗi thao tác ghi tạo một dòng gồm:
   - `op_id`: dùng làm `Idempotency-Key`.
   - `entity`, `entity_id`, `kind` (`create`/`update`/`delete`/`action`).
   - `payload`, `base_version`, `depends_on`: ví dụ bình luận chờ ký ức cha; media chờ upload xong.
   - `attempts`, `next_retry_at`, `last_error`.

   Ghi local và outbox nằm **trong cùng một transaction**.
3. **SyncEngine**: chạy khi app mở, khi có mạng trở lại (`connectivity`), sau mỗi lần ghi (debounce) và theo chu kỳ nền.
   - **Push**: gửi outbox theo thứ tự phụ thuộc, kèm `Idempotency-Key`; sửa thì gửi `If-Match: base_version`.
   - **Pull**: kéo thay đổi theo con trỏ cho từng phạm vi (gia đình, bé) và ghi đè các dòng `synced`. Dòng đang `pending` thì giữ bản local cho tới khi push xong.
   - Lỗi mạng hoặc 5xx: lùi thời gian thử lại (backoff), không mất thay đổi. Lỗi 4xx nghiệp vụ: đánh dấu `rejected` và hiện cho người dùng (ví dụ hết quota, mất quyền).
4. **Media**: tiếp tục theo [luồng client xử lý, upload thẳng S3](../baby-backend/docs/media-client-processing.md).
   - Nén và tạo biến thể ngay lúc tạo, lưu file vào thư mục app.
   - Outbox giữ bước `upload-intent → PUT S3 → complete`.
   - Bản ghi cha (ký ức) chỉ push khi asset đã `READY`, hoặc push trước với asset `PENDING` nếu server cho phép.
5. **Hiển thị trạng thái**: banner offline (`OfflineBanner` đã có) hiện số thay đổi chờ; thẻ nội dung đang `pending` có dấu nhỏ; `rejected`/`conflict` có hành động "Thử lại / Bỏ / Xem bản server".

## 4. Xung đột

| Loại dữ liệu | Quy tắc |
| --- | --- |
| Nội dung một người viết (nhật ký, ký ức, caption) | `If-Match` theo version. Khi 412: giữ cả hai bản, cho người dùng chọn. Không tự ghi đè |
| Thêm vào danh sách (bình luận, ghi chăm sóc, đo tăng trưởng, cảm xúc) | Chỉ thêm, id do client tạo → gần như không xung đột |
| Trạng thái/bộ đếm (yêu thích, hoàn thành nhiệm vụ, tim) | Gửi **hành động** (`complete mission X`), không gửi giá trị cuối; server cộng/kiểm tra trùng |
| Xoá | Thắng sửa cũ hơn; sửa sau khi đã xoá → `rejected`, đề nghị khôi phục từ thùng rác |

## 5. Phân loại tính năng

- **Offline đầy đủ** (ghi local + outbox):
  - Ký ức/nhật ký/bài đăng (kể cả media).
  - Bình luận, cảm xúc, yêu thích, album.
  - Ghi chăm sóc, hoàn thành nhiệm vụ, cột mốc, đo tăng trưởng.
  - Ghi chú, thư hẹn giờ (bản nháp), sửa hồ sơ bé.
- **Đọc offline, ghi cần mạng**: mời thành viên, đổi vai trò/quyền, duyệt bài người thân (cần trạng thái server mới nhất).
- **Chỉ online** (server phải quyết định ngay):
  - Đăng nhập/OTP/Apple/Google; mua gói, xác minh giao dịch.
  - Xoá tài khoản, đổi số điện thoại/email; thanh toán.
  - Tạo AI (quota); chia sẻ link công khai.

  Khi offline, nút bị khoá kèm lời giải thích, không xếp hàng.
- Quyền và quota: client đọc capabilities đã cache để chặn sớm; server vẫn kiểm tra khi push, và lỗi quota thì `rejected`.

## 6. Backend cần bổ sung

1. `Idempotency-Key` cho **mọi** lệnh tạo/hành động mà app có thể xếp hàng. Hiện mới có ở một số route.
2. Nhận id do client tạo (UUID v4) cho các bảng ở mục 5. Trùng id của người khác → 409.
3. `version` (hoặc `updated_at`) trên mọi bản ghi sửa được, và `If-Match` trên `PATCH` như MEM-09.
4. API kéo thay đổi: `GET /families/{id}/changes?cursor=…` trả các dòng đã đổi, kể cả tombstone `deleted_at`, theo con trỏ ổn định. Đây là một bảng/log thay đổi do backend quản lý, có đủ `created_at`/`updated_at`/`deleted_at`. Có thể làm dần theo từng nhóm entity.
5. Mã lỗi nghiệp vụ ổn định để client phân biệt "thử lại" và "từ chối".

## 7. Lộ trình đề xuất

1. Local DB bền vững cho ký ức + outbox. Chuyển MEM-06 sang outbox để sống qua lần tắt app.
2. SyncEngine với push/pull cho ký ức, bình luận, cảm xúc; banner trạng thái.
3. Mở rộng sang chăm sóc/nhiệm vụ/cột mốc/tăng trưởng; backend thêm idempotency và changes API tương ứng.
4. Hồ sơ bé, album, ghi chú; màn giải quyết xung đột.
5. Bỏ offline snapshot cũ khi local DB đã thay thế được.

## 8. Kiểm chứng

- Test repository/service với đồng hồ và mạng giả: tạo khi offline → thấy ngay; có mạng → push đúng một lần (idempotency); 412 → `conflict`; 4xx → `rejected`.
- Test tích hợp backend: gửi lặp cùng `Idempotency-Key` không tạo trùng; changes API trả tombstone.
- Đo sau khi ra mắt:
  - Tỉ lệ thay đổi tạo khi offline.
  - Thời gian từ tạo tới đồng bộ.
  - Tỉ lệ `rejected`/`conflict`.
  - Số thay đổi bị mất (mục tiêu 0).
