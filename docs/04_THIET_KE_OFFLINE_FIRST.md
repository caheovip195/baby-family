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

### Cập nhật BF-20261022-001 (giai đoạn 1)

- **App — outbox bền vững cho tạo ký ức:**
  - Lưu ở `IMemoryOutboxRepository`: mã hoá trong hộp đăng nhập, xoá khi đăng xuất. File media được sao vào `pending_uploads/outbox/<id>`.
  - Mọi ký ức tạo từ màn soạn (kể cả không có ảnh) hiện ngay dưới dạng ký ức tạm, rồi gửi nền. Idempotency-Key suy ra từ id thao tác (UUID v5), nên gửi lại sau khi tắt app không tạo trùng.
  - Lỗi mạng, timeout, 5xx, 408, 429: thẻ hiện "Chờ có mạng", tự thử lại (30 giây, gấp đôi mỗi lần, tối đa 15 phút) và gửi ngay khi có mạng lại (`isOfflineProvider` → `syncPending`).
  - Lỗi nghiệp vụ 4xx: thẻ chờ người dùng bấm Thử lại / Huỷ.
  - Băng ngoại tuyến hiện số ký ức đang chờ.
- **Backend:**
  - Idempotency-Key tuỳ chọn cho bình luận, cảm xúc, góc nhìn, yêu thích, ghi chú, nhật ký riêng, check-in, cảm ơn, lời nhờ, nhiệm vụ.
  - `GET /families/:id/changes` cho ký ức, bình luận, cảm xúc: cursor và tombstone, kể cả khi bị thu hồi quyền xem.
  - Chi tiết: `baby-backend/docs/offline-sync.md`.
- **Chưa làm:**
  - Outbox cho bình luận, cảm xúc, sửa ký ức, chăm sóc, nhiệm vụ.
  - App chưa gọi changes API.
  - Local DB thay `MockStore` chưa làm. Ký ức đã đồng bộ vẫn dựa vào offline snapshot.
  - Sửa ký ức tạm khi chưa gửi xong thì chỉ đổi trên máy, mất khi bản server thay vào.

### Cập nhật BF-20261022-002 (giai đoạn 2)

- **Hàng đợi chung `OutboxRunner`** (`lib/data/service_imp/outbox_runner.dart`):
  - Dùng chung cho mọi service: lưu bền qua `IOutboxRepository(name)`, tách theo service (`memory_outbox`, `care_outbox`).
  - Gửi lần lượt; phân loại lỗi tạm thời (mạng, 5xx, 408, 429, `IDEMPOTENCY_COMMAND_PENDING`) và lỗi bị từ chối (4xx); backoff.
  - `syncAll` khi có mạng lại.
  - Key = UUID v5 theo id thao tác.
- **Bình luận:** hiện ngay và tăng số đếm; gửi `POST /memories/:id/comments` với Idempotency-Key. Xoá bình luận chưa gửi chỉ bỏ khỏi hàng đợi. Mất mạng thì đọc bình luận đã lưu + bình luận tạm. Server từ chối thì bỏ bản tạm.
- **Cảm xúc:** đổi số đếm trên máy ngay. Đổi liên tiếp chỉ gửi lần chọn cuối (thay cả thao tác đang gửi). Kết quả server ghi đè số đếm.
- **Chăm sóc (hoàn thành nhiệm vụ):**
  - Có mạng: chờ kết quả server (Hearts) như trước. Mất mạng: xong trên máy (Hearts 0), tự gửi khi có mạng.
  - Bấm lại khi còn chờ thì gửi lại đúng thao tác cũ (cùng key). Hoàn tác khi còn chờ chỉ bỏ khỏi hàng đợi.
  - Bảng nhiệm vụ lưu bản đọc gần nhất (`writeCache`), mở được khi offline, kể cả sau khi mở lại app.
- **Changes API:** sau mỗi lần đồng bộ feed, kéo `GET /families/:id/changes` theo cursor đã lưu.
  - Lần đầu chỉ lấy mốc, vì feed vừa tải đủ.
  - Ký ức bị xoá hoặc mất quyền xem → gỡ khỏi máy.
  - Ký ức đổi version, có bình luận hoặc cảm xúc mới → đọc lại `GET /memories/:id` (tối đa 30 mỗi lần, bỏ qua ký ức có cảm xúc của tôi đang chờ gửi).
  - Bình luận đã lưu được thêm/sửa/xoá theo thay đổi.
  - `SYNC_CURSOR_EXPIRED` → bỏ cursor và tải lại đủ feed.
- **Chưa làm:**
  - Bộ nhớ bình luận chỉ trong RAM (mất khi tắt app).
  - Outbox cho sửa/xoá bình luận, sửa ký ức, tạo nhiệm vụ, hoàn tác/đổi nhiệm vụ, Papa & Mama.
  - Local DB thay `MockStore`.
  - Changes API chưa có cho nhiệm vụ.

### Cập nhật BF-20261022-003 (local DB ký ức + bình luận)

- **Local DB bền vững** `ILocalMemoryDb` / `LocalMemoryDbImp`: Hive box riêng `vn.babyfamily.app.localdb`. Mỗi ký ức (`<fid server>|m|<id>`) và danh sách bình luận của một ký ức (`|c|<memoryId>`) là một dòng, giá trị mã hoá AES-GCM như `LocalStore`. Xoá khi đăng xuất (`clearAll`).
- `MockStore` vẫn là bộ nhớ làm việc trong RAM, vì repository đọc đồng bộ. Mở app thì nạp DB lên trước khi đồng bộ (`_hydrate`), nên giao diện có dữ liệu ngay, kể cả khi mất mạng. Mọi thay đổi (feed, changes, cảm xúc, bình luận, xoá) được ghi gộp 300 ms, chỉ ghi dòng đổi (diff) và xoá dòng không còn.
- Ký ức vừa tạo được giữ tới khi feed server thấy nó (sửa race "tạo ngay trước khi đồng bộ bị gỡ nhầm").
- Offline snapshot cũ (300 ký ức, chụp lúc mở app) vẫn giữ cho phiên/gia đình/bé. Ký ức giờ có DB đầy đủ hơn; có thể bỏ bảng `memories` khỏi snapshot sau khi thử trên máy thật.

#### Quy tắc tương thích dữ liệu (server đổi field, app cập nhật)

1. **Field mới từ server:** json_serializable bỏ qua field lạ. Các record server giữ enum ở dạng `String`, nên giá trị mới không làm crash.
2. **Server đổi kiểu một field:**
   - Danh sách feed (`MemoryFeedRespond`) và changes (`ChangesPage.items`) đọc theo kiểu chịu lỗi (`lenientList`): bỏ phần tử hỏng và ghi log, các phần tử khác và cursor vẫn dùng được.
   - Lỗi parse ngoài dự kiến trong `_pull`/`_pullChanges` chỉ ghi log, giữ dữ liệu trên máy.
   - Entity/op lạ trong changes bị bỏ qua.
3. **Dữ liệu lưu trên máy:**
   - Có `kValueLocalDbSchemaVersion`: đổi cấu trúc dòng thì tăng số này, khi đó DB cũ bị xoá và tải lại từ server, không đọc sai.
   - Mỗi dòng ký ức được kiểm bằng `Memory.fromJson` trước khi nạp; dòng hỏng bị bỏ và xoá khỏi DB. Bình luận, outbox và cache bảng nhiệm vụ cũng đọc chịu lỗi.
   - DB hỏng hoàn toàn thì app vẫn chạy bằng dữ liệu server.
4. Khi thêm model/bảng mới vào local DB: dùng `String` cho giá trị server có thể mở rộng (enum), field mới phải nullable hoặc có `@Default`, và đọc danh sách qua `lenientList`.

### Cập nhật BF-20261022-004 (nhiệm vụ + Papa & Mama)

- **Local DB dạng bảng dùng chung** `ILocalDb` / `LocalDbImp`: cùng box và schema version với ký ức, khoá `<fid>|t:<bảng>|<id>`. Helper `LocalTables` nạp/ghi diff cho các bảng trong kho RAM:
  - Kiểm từng dòng trước khi nạp; dòng hỏng bị bỏ và xoá.
  - Đổi gia đình thì không ghi chéo dữ liệu.
- **`OutboxRunner.submit`:** gửi ngay khi tạo. Có mạng thì trả bản của server; mất mạng thì giữ bản tạm và tự gửi sau; bị từ chối (4xx) thì bỏ bản tạm và báo lỗi server như trước.
- **Nhiệm vụ:**
  - Bảng nhiệm vụ đọc gần nhất lưu ở bảng `careBoards` (7 ngày gần nhất), thay cache trong outbox.
  - Chi tiết nhiệm vụ khi mất mạng lấy từ bản trên bảng.
  - Hoàn thành nhiệm vụ dùng `submit`.
- **Papa & Mama:**
  - Check-in, lời nhờ, lời cảm ơn và nhật ký riêng mà server đã trả về được lưu ở các bảng `checkins`, `requests`, `thanks`, `journal`. Nhật ký riêng chỉ của tôi, mã hoá.
  - Mở app khi offline vẫn xem được.
  - Tạo check-in / lời nhờ / cảm ơn / nhật ký (kèm ảnh, được sao vào thư mục app) qua outbox với Idempotency-Key (lời nhờ vẫn bắt buộc key). Bản tạm do bản trên máy tạo, nên giữ cả kiểm tra BR-067.
  - Sửa lỗi: mất mạng khi đồng bộ song song (`ParallelWaitError`) trước đây không được bắt; giờ được bắt, kèm lỗi parse.
- **Chưa làm:**
  - Thao tác trên lời nhờ (nhận, từ chối, xong, nhắc), duyệt/thả tim lời cảm ơn, chia sẻ đoạn nhật ký: vẫn cần mạng.
  - Tạo / đổi / hoàn tác nhiệm vụ khi mất mạng.
  - Cầu nối, câu hỏi kết nối: chưa có API.

### Thử thật BF-20261022-005 (Android emulator + backend thật)

- **Môi trường:**
  - Backend build từ mã nguồn ở cổng 3100, DB `baby_family_test` (không đụng Docker stack đang chạy).
  - App flavor staging trên emulator Android `Pixel_8` (`BABY_FAMILY_API_URL=http://10.0.2.2:3100/api`).
  - Tắt/bật mạng thật bằng `adb shell svc wifi|data disable/enable`.
  - iOS không build được: Flutter 3.44.5 gọi `lipo -verify_arch` theo cú pháp Xcode 27.1 không nhận.
- **Kịch bản đã chạy:**
  1. Đăng ký Mama (OTP qua Mailpit), Papa tham gia qua API, duyệt, tạo bé.
  2. Tắt mạng → hoàn thành nhiệm vụ, viết nhật ký, check-in Papa & Mama.
  3. Đưa app vào nền → tắt hẳn → mở lạnh khi vẫn offline.
  4. Bật mạng.
- **Kết quả:** khi có mạng lại, app tự gửi trong cùng giây: gia hạn phiên → hoàn thành nhiệm vụ 201 → check-in 201 → ký ức 201 → kéo `changes`.
  - DB có đúng 1 nhật ký, 2 lần hoàn thành (2 nhiệm vụ), 1 check-in; không có bản ghi trùng.
  - Hearts tăng 5 → 9.
- **Lỗi tìm ra và đã sửa:**
  1. Offline snapshot chỉ lưu lúc mở app, nên mở lạnh khi offline quay về màn "Chờ Papa". Sửa: lưu sau mỗi `_syncFromServer`, khi gia đình được kích hoạt, sau `completeSetup`, và khi app vào nền (`persistOffline`).
  2. Màn Nhật ký / Thư gửi con / Câu nói chưa đi qua outbox, nên mất mạng thì lưu lỗi. Sửa: thêm `deferUpload: true`.
  3. Hoàn thành nhiệm vụ khi offline không báo màn hình vẽ lại. Sửa: thêm `_store.touch()`. Sheet hiện "+0 💗" → đổi thành "💗 sẽ được cộng khi có mạng" và ẩn phần lưu khoảnh khắc (cần mạng).
  4. Một lệnh đọc mất mạng làm hỏng cả màn Home / Ký ức: `todayPrompt`, `tree`, `unreadCount`, `monthlyPhotos`, `collections`, `sealedLetters`, `albums`, `stats`. Sửa: helper `whenOnline()` và bản đọc gần nhất; `tree` lưu thêm ở local DB (`careTree`).
  5. Tab Chăm sóc / Home không ghi log khi tải lỗi. Đã thêm log.

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
