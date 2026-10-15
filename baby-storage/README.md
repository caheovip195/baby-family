# Baby Storage — dịch vụ phụ trợ local

Compose riêng cho các dịch vụ hỗ trợ backend khi chạy **trên máy local**, độc lập với [baby-database](../baby-database/README.md) và [baby-backend](../baby-backend/README.md). Dựng ngày 2026-10-15 (BF-20261015-005). Backend **chưa có code dùng** các dịch vụ này; hiện chỉ có network và biến môi trường được truyền sẵn.

| Service      | Image (pin)                                                      | Dùng cho (đặc tả kỹ thuật)                                        | Cổng host (chỉ `127.0.0.1`) | Alias trong network |
| ------------ | ---------------------------------------------------------------- | ----------------------------------------------------------------- | --------------------------- | ------------------- |
| `valkey`     | `valkey/valkey:9.0.6-alpine3.24`                                 | §9: cache AccessContext, rate limit, OTP, khóa phân tán, BullMQ   | `6379`                      | `baby-valkey`       |
| `minio`      | `chainguard/minio@sha256:2136d5…` (RELEASE.2026-09-22T19-25-18Z) | §10: ảnh/video/âm thanh, file xuất ZIP                            | API `9000`, console `9001`  | `baby-minio`        |
| `minio-init` | build từ `minio-init/` (mc + alpine 3.24.2)                      | Tạo bucket, versioning, lifecycle, user cho backend; chạy một lần | —                           | —                   |
| `mailpit`    | `axllent/mailpit:v1.31.6`                                        | Hộp thư giả: bắt mọi email SMTP, không gửi ra ngoài               | SMTP `1025`, UI `8025`      | `baby-mailpit`      |

PostgreSQL vẫn là nguồn sự thật. Valkey chỉ giữ cache, bộ đếm và hàng đợi; thông tin quyền lợi và yêu cầu chạy job phải nằm trong PostgreSQL (outbox/job history) theo [thiết kế dữ liệu](../docs/database/README.md).

## Khởi tạo lần đầu

Chạy từ thư mục `baby-storage`:

```bash
bash scripts/init-env.sh
docker compose up -d --build --wait valkey minio mailpit
docker compose run --rm minio-init
docker compose ps
```

`init-env.sh` tạo `.env` từ `.env.example` với mật khẩu ngẫu nhiên, đồng thời tạo `data/valkey`, `data/minio`, `data/mailpit`. Script không ghi đè `.env` đã có và không in secret ra màn hình. Compose dùng `create_host_path: false`, nên nếu thiếu thư mục data thì sẽ báo lỗi thay vì tự tạo thư mục rỗng.

Sau đó copy giá trị tương ứng sang `baby-backend/.env`: `REDIS_URL`/`REDIS_DOCKER_URL` (mật khẩu Valkey) và `S3_ACCESS_KEY_ID`/`S3_SECRET_ACCESS_KEY` (`MINIO_APP_*`). Xem mẫu trong [baby-backend/.env.example](../baby-backend/.env.example).

## Thứ tự khởi động

1. `baby-database`: tạo network `baby-family-data`.
2. `baby-storage`: tạo network `baby-family-storage`.
3. `baby-backend`: tham gia cả hai network dưới dạng `external`. Nếu chưa chạy bước 2, `docker compose up` của backend sẽ báo thiếu network.

## Bucket

Theo đặc tả kỹ thuật §10.1:

| Bucket          | Truy cập                                                                   | Versioning | Lifecycle                               |
| --------------- | -------------------------------------------------------------------------- | ---------- | --------------------------------------- |
| `bf-media`      | Private                                                                    | Bật        | Xóa version cũ (noncurrent) sau 30 ngày |
| `bf-user-media` | Private (ảnh nhật ký riêng Papa & Mama; tên trùng default trong Prisma)    | Bật        | Xóa version cũ sau 30 ngày              |
| `bf-exports`    | Private                                                                    | Tắt        | Xóa object sau 7 ngày                   |
| `bf-public`     | Ai cũng tải được (chỉ ảnh minh họa/sticker, không phải dữ liệu người dùng) | Tắt        | —                                       |

Backend dùng key riêng `MINIO_APP_ACCESS_KEY` với policy `baby-backend-rw`, chỉ được đọc/ghi/xóa object trong 4 bucket trên, không được tạo bucket hoặc dùng API admin. Từ BF-20261015-010 policy có thêm `s3:ListBucketVersions` và `s3:DeleteObjectVersion` để worker xóa hẳn mọi version của bản upload thô (có thể chứa GPS) sau khi xử lý; chạy lại `docker compose run --rm minio-init` để cập nhật policy. Không dùng root credential trong backend. Đường dẫn object không chứa tên, email hay tên bé (§10.1). App lấy file qua presigned URL; endpoint ký URL cho máy host là `S3_PUBLIC_ENDPOINT=http://localhost:9000`. Simulator iOS gọi được `localhost`; emulator Android cần `10.0.2.2` hoặc IP LAN của máy.

## Rủi ro MinIO

MinIO đã ngừng phát hành image cộng đồng chính thức: `minio/minio` và `quay.io/minio/minio` không còn tag (đã kiểm tra 2026-10-15). Ở đây dùng bản build từ source AGPLv3 của Chainguard, pin theo digest. Gói miễn phí của Chainguard chỉ có tag `latest`, nên khi nâng cấp phải lấy digest mới và kiểm tra lại. Theo §10.8, backend chỉ được dùng S3 API chuẩn (path-style) qua adapter, để có thể đổi sang dịch vụ S3 khác mà không sửa nghiệp vụ. Phương án này chỉ dành cho local; production cần quyết định riêng.

## Lệnh thường dùng

```bash
docker compose logs --tail=100 minio
docker compose exec valkey valkey-cli info persistence
docker compose stop
docker compose down
```

- Console MinIO: <http://localhost:9001> (đăng nhập bằng `MINIO_ROOT_*`).
- Mailpit: <http://localhost:8025>.
- `stop`/`down` không xóa `data/`. Thư mục `data/` đã được bỏ qua trong git. Nếu xóa `data/` sẽ mất object, hàng đợi và email đã lưu.
- Valkey chạy với `appendonly yes`, `maxmemory-policy noeviction` (bắt buộc cho BullMQ) và `maxmemory` lấy từ `.env`. Khi đầy bộ nhớ, lệnh ghi sẽ báo lỗi thay vì âm thầm xóa job.
- Chạy lại `docker compose run --rm minio-init` không mất dữ liệu: bucket/policy/user đã có thì giữ nguyên, và secret của user backend được cập nhật theo `.env`.
- Chưa có backup cho MinIO/Valkey vì đây là môi trường local. Dữ liệu cần giữ lâu dài phải nằm ở PostgreSQL, hoặc bạn tự sao lưu thư mục `data/minio` khi đã dừng service.
