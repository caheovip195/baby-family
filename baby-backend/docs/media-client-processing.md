# Media do client xử lý — BF-20261021-008

Quyết định 2026-10-21 thay luồng xử lý server mô tả trong tài liệu cũ: client nén, chuyển định dạng, xoay ảnh, bỏ metadata nhạy cảm và tạo mọi biến thể. API chỉ cấp presigned URL/POST policy, xác minh object (HEAD, SHA-256, magic bytes 4 KiB đầu) và ghi trạng thái/quota. Không decode, không chạy sharp/ffmpeg cho phiên client, **không bao giờ tải cả file về**: chỉ ranged GET 4 KiB đầu (BF-20261119-001, BF-20261119-003).

Các route dưới đây tương đối với prefix `/api/v1`. Response JSON minh họa là payload trong envelope HTTP `{ "data": ... }`; lỗi theo envelope `{ "error": { "code": "...", "message": "..." } }` hiện hành.

## Tạo phiên

`POST /media/upload-intents`, xác thực như cũ, header `Idempotency-Key: <UUID>`. Body ảnh:

```json
{
  "familyId": "019a0000-0000-7000-8000-000000000001",
  "kind": "IMAGE",
  "purpose": "MEMORY",
  "mime": "image/jpeg",
  "size": 200000,
  "sha256": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
  "width": 1600,
  "height": 1200,
  "variants": [
    {
      "code": "m1080",
      "mime": "image/webp",
      "size": 90000,
      "sha256": "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb",
      "width": 1080,
      "height": 810
    },
    {
      "code": "t320",
      "mime": "image/webp",
      "size": 15000,
      "sha256": "cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc",
      "width": 320,
      "height": 240
    }
  ]
}
```

`width`, `height` tùy chọn. VIDEO/AUDIO bắt buộc `durationMs` (milliseconds), kiểm theo `videoMaxSec`/`audioMaxSec` của plan version hiện hành; vượt trả **422 MEDIA_DURATION_EXCEEDED**. Không suy quyền theo tên gói.

| Kind  | File chính                                   | Biến thể client phải upload      | Tùy chọn      |
| ----- | -------------------------------------------- | -------------------------------- | ------------- |
| IMAGE | JPEG/WebP/PNG, cạnh dài ≤4096; lưu `orig`    | `m1080` ≤1080, `t320` ≤320       | `l2048` ≤2048 |
| VIDEO | `video/mp4`, cạnh ngắn ≤1080, cạnh dài ≤1920 | `poster` JPEG ≤1920, `t320` ≤320 | Không         |
| AUDIO | `audio/mp4` hoặc `audio/x-m4a`               | Không; gửi `variants: []`        | Không         |

Ảnh biến thể chỉ JPEG/WebP, riêng poster chỉ JPEG. Mỗi `m1080`/`t320`/`poster` ≤5 MiB; `l2048` ≤10 MiB. Code lạ/trùng bị từ chối. Giới hạn kỹ thuật tập trung tại `src/config/media-policy.ts`. AVATAR/COVER/JOURNAL gia đình dùng cùng IMAGE contract và ACL/bucket hiện hành.

Response 201 giữ `assetId`, `status`, `deduplicated`, `upload` như cũ, thêm `variantUploads`. Ví dụ các URL dưới đây là placeholder, thời điểm hết hạn do server cấp:

```json
{
  "assetId": "019a0000-0000-7000-8000-000000000002",
  "status": "PENDING_UPLOAD",
  "deduplicated": false,
  "upload": {
    "mode": "single",
    "method": "PUT",
    "url": "https://storage.example/presigned-orig",
    "headers": {
      "Content-Type": "image/jpeg",
      "x-amz-checksum-sha256": "<base64-sha256>"
    },
    "expiresAt": "2026-10-21T10:15:00.000Z"
  },
  "variantUploads": [
    {
      "code": "m1080",
      "upload": {
        "mode": "single",
        "method": "PUT",
        "url": "https://storage.example/presigned-m1080",
        "headers": {
          "Content-Type": "image/webp",
          "x-amz-checksum-sha256": "<base64-sha256>"
        },
        "expiresAt": "2026-10-21T10:15:00.000Z"
      }
    },
    {
      "code": "t320",
      "upload": {
        "mode": "single",
        "method": "PUT",
        "url": "https://storage.example/presigned-t320",
        "headers": {
          "Content-Type": "image/webp",
          "x-amz-checksum-sha256": "<base64-sha256>"
        },
        "expiresAt": "2026-10-21T10:15:00.000Z"
      }
    }
  ]
}
```

Client phải gửi **nguyên header thực tế** trong response, không tự dựng theo ví dụ. S3 adapter có thể khác cách viết hoa header. File chính >20 MiB vẫn multipart, part 8 MiB; `POST /media/:id/parts` và body complete giữ nguyên. Biến thể luôn single PUT, key `fam/{fid}/a/{assetId}/{code}`; chính là `.../orig`.

VIDEO ghi một row `v1080` trỏ key chính `.../orig`; AUDIO tương tự `a`. Không tạo thêm row orig cùng key (unique storage bucket/key), không upload hay tính quota hai lần. IMAGE có row orig.

Quota giữ chỗ = tổng từng object khai báo + dung sai 5% làm tròn lên **cho mỗi object**. Replay cùng key thay dimensions/duration/manifest trả 409 `IDEMPOTENCY_KEY_REUSED`. Dedup đã READY giữ nội dung sẵn có, không cấp URL upload mới. Phiên pending replay ký từ manifest đã lưu, không từ request mới.

## Upload thẳng lên storage: POST policy, checksum (BF-20261119-001)

Mặc định (`MEDIA_SINGLE_UPLOAD_METHOD=post`) file chính ≤20 MiB và mọi biến thể (kể cả avatar) nhận lệnh S3 POST Object:

```json
{
  "mode": "single",
  "method": "POST",
  "url": "https://storage.example/bf-media",
  "fields": {
    "key": "fam/{fid}/a/{assetId}/orig",
    "Content-Type": "image/jpeg",
    "x-amz-checksum-algorithm": "SHA256",
    "x-amz-checksum-sha256": "<base64>",
    "x-amz-algorithm": "AWS4-HMAC-SHA256",
    "x-amz-credential": "...",
    "x-amz-date": "...",
    "Policy": "<base64>",
    "x-amz-signature": "..."
  },
  "expiresAt": "..."
}
```

Client gửi `multipart/form-data`: mọi `fields` giữ nguyên, **file là field cuối** (`name="file"`, có `filename`). Policy ký bằng SigV4 ở backend (không thêm package), ghim từng field bằng `eq` và `content-length-range` đúng bằng size khai báo, nên storage tự từ chối khi đổi key, Content-Type, dung lượng hoặc SHA-256 (nếu storage hỗ trợ checksum). `put` dùng presigned PUT ký Content-Type, `Content-Length` (đúng size khai báo, header không trả về vì HTTP client tự đặt theo body) và SHA-256, cho storage không hỗ trợ POST.

Multipart (>20 MiB): URL từng part ký `Content-Length` theo part size và tổng khai báo, nên storage từ chối part sai kích thước và object không thể vượt dung lượng khai báo. App gửi thêm `Content-MD5` của từng part; storage S3 chuẩn kiểm header này khi có, nên part hỏng trên đường truyền bị trả 400.

Policy và checksum chỉ chứng minh client gửi **đúng thứ nó khai báo**. Client khai `image/jpeg` nhưng gửi MP4 (checksum tính trên chính file MP4) vẫn qua policy, nên complete còn kiểm nội dung thật (dưới đây).

## Complete và recovery

`POST /media/:id/complete` body `{}` hoặc multipart `{ "parts": [{ "n": 1, "etag": "..." }] }`.

HEAD tất cả object kiểm tồn tại, MIME và size trong ±5% khai báo (phía trên làm tròn lên). Sau đó, không decode media:

1. **SHA-256**: HEAD gửi `ChecksumMode=ENABLED`; storage trả checksum toàn file thì so trực tiếp. Storage không trả (không hỗ trợ checksum) thì bỏ qua bước này: server không tải file về để băm. Multipart không có SHA toàn file, dựa vào Content-Length/Content-MD5 từng part. Sai → `UPLOAD_CHECKSUM_MISMATCH` / `UPLOAD_VARIANT_CHECKSUM_MISMATCH`.
2. **Magic bytes** (`media-content-signature.ts`): chỉ ranged GET 4 KiB đầu (`readObjectPrefix`, trần 64 KiB; storage bỏ qua Range thì ngắt kết nối khi đủ byte), nhận dạng JPEG/PNG/GIF/WebP/HEIF/AVIF/MP4/M4A/QuickTime/MP3/AAC và đối chiếu MIME khai báo. Sai → `UPLOAD_CONTENT_TYPE_MISMATCH` / `UPLOAD_VARIANT_CONTENT_TYPE_MISMATCH`. MP4 và M4A cùng họ ISO-BMFF nên chấp nhận chéo (phân biệt cần đọc `moov`).

Áp dụng cho media gia đình, avatar, đường legacy và reconciler. Chỉ chế độ `MEDIA_SERVER_PROCESSING=legacy` còn tải file về (để sharp/ffmpeg xử lý).

### Contabo Object Storage (BF-20261119-002)

Đo trên bucket thật (usc1, bucket private):

- **Không hỗ trợ POST Object**: mọi form POST (đủ biến thể region/field) bị gateway trả 401 `{"message":"Unauthorized"}`. Bắt buộc `MEDIA_SINGLE_UPLOAD_METHOD=put`.
- PUT: Content-Type và `Content-Length` đã ký được kiểm (403 khi khác). `x-amz-checksum-sha256` **bị bỏ qua** (body sai vẫn 200) và HEAD không trả checksum, nên với Contabo server không kiểm được SHA-256; magic bytes vẫn kiểm.
- Multipart: `Content-Length` ký theo part (403 khi sai size) và `Content-MD5` (400 khi sai) được kiểm.
- Range GET được tôn trọng: kiểm file 2 MiB chỉ nhận 4096 byte.
- Bucket private: GET không ký trả 401, presigned GET 200. Không cần bật public.
- Cấu hình: `S3_ENDPOINT`/`S3_DOCKER_ENDPOINT`/`S3_PUBLIC_ENDPOINT` = `https://usc1.contabostorage.com` (**không** kèm `/bucket`, không dùng URL tenant public), `S3_FORCE_PATH_STYLE=true`, region bất kỳ (đã thử `us-east-1`, `usc1`, `default`). Lỗi phiên client → FAILED, trả reservation, xóa từng key của phiên, HTTP 422. Nếu xóa storage lỗi, job purge FAILED sẽ dọn lại prefix sau retention. Complete thành công trả HTTP **202** (giữ HTTP status cũ):

```json
{ "assetId": "019a0000-0000-7000-8000-000000000002", "status": "READY" }
```

Cùng một transaction: cập nhật kích thước thật của variants, asset READY với width/height/duration khai báo, xác nhận quota theo tổng size thật, chuyển ký ức PROCESSING có mọi asset READY sang PUBLISHED và phát outbox `memory.published`. Hàm repository publish được dùng chung với legacy worker. Không phát `media.asset_uploaded` cho phiên client. Gọi complete lại khi READY không cộng quota/phát sự kiện lần hai.

Manifest phiên client được lưu trong `asset_variants` từ lúc reserve (size tạm = khai báo), nên bền vững qua restart/replay; URL xem chỉ được cấp khi READY. Reconciler single upload dùng cùng HEAD verifier và transaction; thiếu/sai object chưa complete thì chờ client hoặc hết hạn, không đẩy sang worker. Multipart vẫn cần client gửi ETag để complete.

## Đọc media

`GET /media/:id`, `POST /media/urls`, memory assets, media-grid và profile giữ URL ký theo code: IMAGE `m1080`/`l2048`/`t320`, VIDEO `poster`/`t320`/`v1080`, AUDIO `a`. `orig` không trả qua URL xem. Quyền tải bản gốc và download-urls vẫn dùng file chính. `l2048` tùy chọn nên client cần fallback m1080. Không tạo blurhash/capturedAt từ nội dung file trên server ở đường mới.

## Avatar tài khoản

`POST /me/avatar/upload-intents` dùng IMAGE manifest tương tự nhưng không có familyId/kind, purpose AVATAR; `POST /me/avatar/:id/complete` giữ route hiện có. Prefix `usr/{uid}/avatar/{id}/raw` cho file chính và `/m1080`, `/t320`, `/l2048` cho biến thể. Avatar dùng thêm mã lỗi HEAD riêng `UPLOAD_VARIANT_METADATA_MISMATCH` cho MIME (main cũng là biến thể orig); mỗi object avatar cá nhân ≤5 MiB. Server ký t320 cho avatar; cover gia đình ưu tiên l2048 rồi m1080/t320. Avatar cá nhân không tiêu quota gia đình. Bảng mới `app.user_asset_variants` lưu khai báo và size HEAD xác minh; migration DDL cần deploy trước API. Model Prisma `@@ignore` được quản lý qua persistence helper viết tay, nhằm giữ nguyên file generated; generators bỏ qua model ignored. Đủ created_at/updated_at/deleted_at và trigger cập nhật audit.

## Legacy và vận hành

`MEDIA_SERVER_PROCESSING=disabled` mặc định. IMAGE/VIDEO/AUDIO không có trường variants bị chặn 422 `MEDIA_VARIANTS_REQUIRED` (AUDIO phải gửi mảng rỗng). `MEDIA_SERVER_PROCESSING=legacy` cho phép client cũ giữ đường UPLOADED → outbox → worker sharp/ffmpeg. Cờ này cũng bảo vệ xử lý trực tiếp, khởi động consumer media và requeue legacy; phiên có variants luôn đi đường client ngay cả khi cờ legacy bật. Worker giữ run/attempt history, lease/fencing và retry cũ. Không cần thêm DI token, composition root hoặc job mới; ConfigService được inject optional vào service cũ, mặc định an toàn disabled.

Từ BF-20261106-004, sharp và exifr chỉ nạp ở lần xử lý đầu tiên nên chế độ disabled không tốn RAM cho chúng. Image `worker` mặc định không có ffmpeg. Bật `legacy` phải build lại bằng `WORKER_BUILD_TARGET=worker-legacy`; thiếu ffmpeg thì worker dừng ngay khi khởi động với thông báo rõ ràng.

Migration avatar chỉ DDL, không seed/backfill tự động. Không đổi database Compose. Bật legacy trên cả API và worker khi chuyển tiếp; tắt sau khi client cũ và backlog đã được xử lý.

## Mã lỗi

| HTTP | Code                                                                | Ý nghĩa                               |
| ---- | ------------------------------------------------------------------- | ------------------------------------- |
| 422  | MEDIA_VARIANTS_REQUIRED                                             | Thiếu manifest hoặc biến thể bắt buộc |
| 422  | MEDIA_VARIANT_INVALID                                               | Code lạ/trùng                         |
| 422  | MEDIA_TYPE_UNSUPPORTED / MEDIA_VARIANT_TYPE_UNSUPPORTED             | MIME sai                              |
| 422  | MEDIA_TOO_LARGE / MEDIA_VARIANT_TOO_LARGE                           | Vượt trần kỹ thuật                    |
| 422  | MEDIA_DIMENSIONS_EXCEEDED / MEDIA_VARIANT_DIMENSIONS_EXCEEDED       | Kích thước khai báo vượt trần         |
| 422  | MEDIA_DURATION_EXCEEDED                                             | Thời lượng khai báo vượt gói          |
| 422  | UPLOAD_MISSING / UPLOAD_VARIANT_MISSING                             | Object chính/biến thể không có        |
| 422  | UPLOAD_SIZE_MISMATCH / UPLOAD_VARIANT_SIZE_MISMATCH                 | Size HEAD sai                         |
| 422  | UPLOAD_MIME_MISMATCH / UPLOAD_VARIANT_MIME_MISMATCH                 | MIME HEAD sai                         |
| 422  | UPLOAD_CHECKSUM_MISMATCH / UPLOAD_VARIANT_CHECKSUM_MISMATCH         | SHA-256 nội dung khác khai báo        |
| 422  | UPLOAD_CONTENT_TYPE_MISMATCH / UPLOAD_VARIANT_CONTENT_TYPE_MISMATCH | Magic bytes khác MIME khai báo        |
| 402  | QUOTA_STORAGE_EXCEEDED                                              | Không đủ quota giữ chỗ                |
| 409  | IDEMPOTENCY_KEY_REUSED / UPLOAD_EXPIRED / UPLOAD_REJECTED           | Xung đột phiên                        |

DTO sai kiểu/null/sha256 sai định dạng trả validation HTTP 400. Auth/membership/tenant/private journal ACL giữ nguyên.

## Rủi ro được chấp nhận theo quyết định client processing

Thời lượng, dimensions, codec, việc nén và bỏ EXIF/GPS do client khai báo/thực hiện. Magic bytes chỉ chứng minh định dạng container, không chứng minh duration/pixels/codec hay nội dung ảnh an toàn; file đa định dạng (polyglot) có header hợp lệ vẫn qua. Server giới hạn duration khai báo theo catalog, quota tổng, size/MIME/SHA-256 và định dạng thật. Multipart không có SHA toàn file (chỉ Content-Length ký + Content-MD5 từng part); SHA multipart là khai báo client cho dedup. Presigned URL còn hiệu lực có thể bị dùng ghi đè sau complete, như protocol presign cũ; cần object immutability/version pinning nếu muốn chống client ác ý. Không tuyên bố server đã strip metadata hay kiểm duyệt nội dung ở đường mới.

## Dấu vết file gốc trên máy (`source`, BF-20261021-008)

- Upload intent nhận thêm `source?: {sha256, key, capturedAt?}`:
  - `sha256` là SHA-256 của file **gốc** trước khi client nén, hex 64 ký tự.
  - `key` là khoá metadata `kind|cạnh ngắn x cạnh dài|giây`, tối đa 64 ký tự.
  - `capturedAt` là thời điểm chụp theo EXIF/video, ISO 8601.
- Lưu ở `app.assets.source_sha256` (bytea 32 byte) và `source_key`; `capturedAt` dùng cột `captured_at` sẵn có. Migration `20261021120000_asset_client_source` chỉ có DDL.
- `GET /media/:id`, `POST /media/urls` và `assets[]` của ký ức trả `source` (null khi client không khai báo).
- `source` có trong hash idempotency (chỉ khi được khai báo, để hash cũ vẫn khớp).
- Đây là khai báo của client: server không kiểm tra, không dùng cho quyền hay dedup. App dùng nó để hiển thị bản còn trong thư viện máy thay vì tải về.
