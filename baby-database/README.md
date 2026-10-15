# Baby Database

PostgreSQL **18.6-bookworm** chạy bằng Docker Compose riêng, độc lập với backend. Dữ liệu được bind mount vào thư mục trên máy host; xóa hoặc tạo lại container không xóa thư mục đó.

Thư mục này chỉ quản lý **PostgreSQL server/Compose, data và backups**. [Prisma schema](../baby-backend/prisma/schema.prisma), [migrations](../baby-backend/prisma/migrations/20261013150000_family_domain/migration.sql), [seed](../baby-backend/prisma/seed.ts) và [kiểm chứng SQL](../baby-backend/test/database-design/validate.sh) thuộc backend. Xem [thiết kế dữ liệu](../docs/database/README.md) để đối chiếu nghiệp vụ, canvas và license family. Ngày 2026-10-15 (BF-20261015-005) đã backup rồi áp migration domain và chạy seed catalog vào DB local `baby_family`; Compose database vẫn không tự migrate hoặc seed. Migration chỉ DDL; dữ liệu catalog được chạy riêng từ backend bằng `npm run db:seed`.

Đợt chuyển ngày **2026-10-13** đã đưa cluster cũ sang `data/`, giữ nguyên các database, role và dữ liệu. Backup trước chuyển ở `backups/pre-split-20261013T072752/` gồm globals, dump từng database và baseline đối chiếu. Container cũ `baby-backend-postgres-1` được giữ ở trạng thái dừng cùng volume `baby-backend_postgres-data`; backend có thể báo orphan container vì bản cũ này còn được giữ. Database đang dùng là `baby-database-postgres-1` trên bind mount. Bản cũ không chứa các thay đổi phát sinh sau cutover; không tự bật nó để rollback khi chưa xử lý dữ liệu mới.

## Khởi tạo lần đầu

Chạy từ thư mục `baby-database`:

```bash
cp .env.example .env
mkdir -p data backups
chmod 700 backups
docker compose up -d --wait
docker compose ps
```

Nếu đã có `.env`, giữ file hiện tại. Mật khẩu trong `.env.example` chỉ dành cho máy phát triển; thay trong `.env` trước lần khởi tạo đầu tiên và cập nhật chuỗi kết nối backend tương ứng. Chỉ cần Docker với Compose và Bash; công cụ PostgreSQL chạy bên trong container.

| Biến                  | Mặc định                           | Ý nghĩa                                       |
| --------------------- | ---------------------------------- | --------------------------------------------- |
| `POSTGRES_DB`         | `baby_family`                      | Database ứng dụng được tạo khi data còn trống |
| `POSTGRES_USER`       | `baby`                             | Role quản trị được tạo khi data còn trống     |
| `POSTGRES_PASSWORD`   | Giá trị local trong `.env.example` | Mật khẩu role; Compose yêu cầu có giá trị     |
| `DB_PORT`             | `5433`                             | Cổng host, chỉ bind `127.0.0.1`               |
| `POSTGRES_DATA_DIR`   | `./data`                           | Thư mục host chứa toàn bộ cluster             |
| `POSTGRES_BACKUP_DIR` | `./backups`                        | Thư mục host chứa bản sao lưu logical         |
| `DATABASE_NETWORK`    | `baby-family-data`                 | Network dùng chung với backend                |

Đường dẫn tương đối được tính từ `baby-database`, kể cả khi script được gọi từ thư mục khác. Compose dùng `create_host_path: false`: thư mục data phải tồn tại trước khi chạy, giúp tránh tự tạo một cluster trống khi gõ nhầm đường dẫn. [Quy tắc bind mount của Compose](https://docs.docker.com/reference/compose-file/services/#volumes).

Image PostgreSQL 18 đặt `PGDATA` tại `/var/lib/postgresql/18/docker`; Compose mount thư mục host vào `/var/lib/postgresql`, nên dữ liệu thực tế nằm ở `data/18/docker`. Giữ nguyên cấu trúc này. [Tài liệu image PostgreSQL](https://hub.docker.com/_/postgres).

## Chạy và kết nối

```bash
docker compose up -d --wait
docker compose logs --tail=100 postgres
docker compose stop postgres
docker compose start postgres
docker compose down
```

`stop`, `down`, xóa container hoặc xóa image không xóa data/backups trên host. Xóa các thư mục này hoặc mất ổ đĩa vẫn làm mất dữ liệu. Bind mount không thay thế backup trên thiết bị khác.

- Backend chạy trên host kết nối `localhost:5433` với thông tin từ `.env`.
- Backend chạy bằng Docker tham gia network external cùng tên `DATABASE_NETWORK`, kết nối hostname `baby-postgres`, cổng `5432`. Backend dùng `DATABASE_DOCKER_URL`; mật khẩu trong URL cần URL-encode nếu có ký tự đặc biệt.
- Stack database tạo và sở hữu network dùng chung. Khởi động database trước backend. Dừng backend độc lập không dừng PostgreSQL; khi PostgreSQL dừng, các thao tác cần database sẽ tạm không phục vụ được.
- Khi `docker compose down` ở database mà backend vẫn gắn network, Docker có thể báo network còn được sử dụng; dừng stack backend trước nếu cần xóa network. Data trên host vẫn được giữ. [Network của Compose](https://docs.docker.com/reference/compose-file/networks/).

## Chuyển data sang thư mục hoặc ổ khác

Ví dụ cấu hình `.env` cho một ổ **đã mount**:

```dotenv
POSTGRES_DATA_DIR=/Volumes/TenOCuaBan/baby-family/postgres
POSTGRES_BACKUP_DIR=/Volumes/TenOCuaBan/baby-family/backups
```

Tạo đúng hai thư mục trên ổ đích trước khi chạy. Docker Desktop phải được phép truy cập đường dẫn đó. Không tạo thư mục `/Volumes/...` giả khi ổ chưa mount; việc này có thể ghi vào ổ hệ thống thay vì ổ dự kiến.

Sửa `POSTGRES_DATA_DIR` chỉ đổi nguồn mount, **không chuyển dữ liệu cũ**. Với cluster đã có dữ liệu:

1. Tạo và kiểm tra logical backup trước khi chuyển. Dừng backend và mọi client có thể ghi.
2. Dừng PostgreSQL hoàn toàn bằng `docker compose stop postgres`, kiểm tra container đã dừng. Không `cp`/`rsync` thư mục data khi PostgreSQL còn chạy.
3. Sao chép toàn bộ nội dung nguồn mount sang thư mục đích còn trống, giữ thư mục `18/docker`, file ẩn, owner và permission. Nếu cluster có tablespace hoặc WAL ở ngoài mount, phải chuyển đầy đủ các vị trí đó; cấu hình mặc định tại đây không tách chúng.
4. Đổi `.env`, chạy lại **cùng image PostgreSQL 18** bằng `docker compose up -d --wait`, kiểm tra schema, migration và dữ liệu trước khi mở backend.
5. Giữ bản cũ để đối chiếu/rollback đến khi xác minh xong. Không cho hai PostgreSQL cùng mở một thư mục data; khi rollback, dừng instance mới trước và cân nhắc các dữ liệu đã ghi sau khi chuyển.

Với nguồn là Docker named volume, copy offline từ volume cũ vào thư mục host theo cùng quy tắc trên. Không chép riêng vài file bảng/database. File backup vật lý cần toàn bộ cluster và server dừng; đổi PostgreSQL major version cần quy trình upgrade hoặc dump/restore riêng. [Filesystem backup của PostgreSQL](https://www.postgresql.org/docs/18/backup-file.html).

## Backup khi database đang chạy

Từ root repository:

```bash
bash baby-database/scripts/backup.sh
```

Script sử dụng `pg_dump --format=custom` cho **database `POSTGRES_DB` hiện tại** và `pg_dumpall --globals-only` cho role/tablespace cùng cấu hình global. Nó không backup các database khác, file cấu hình PostgreSQL hoặc toàn bộ cluster vật lý. `pg_dump` tạo bản sao nhất quán của một database khi server đang chạy; hai file database/globals được lấy lần lượt nên tránh thay đổi role/schema trong lúc backup. [pg_dump](https://www.postgresql.org/docs/18/app-pgdump.html), [pg_dumpall](https://www.postgresql.org/docs/18/app-pg-dumpall.html).

Kết quả trong `POSTGRES_BACKUP_DIR`:

```text
baby-family-<UTC timestamp>-<unique suffix>.dump
baby-family-<UTC timestamp>-<unique suffix>.globals.sql
```

Script kiểm tra archive, ghi file tạm trong cùng thư mục rồi đổi tên; file `.dump` chỉ xuất hiện sau khi cả hai file hoàn tất. Khi có lỗi, script trả mã lỗi và dọn file tạm. Tên duy nhất cho phép chạy nhiều lần mà không ghi đè bản trước. Đường dẫn tuyệt đối của `.dump` là stdout; thông tin globals nằm ở stderr, nên có thể dùng:

```bash
backup_file="$(bash baby-database/scripts/backup.sh)"
printf '%s\n' "$backup_file"
```

File được tạo với quyền `600`, thư mục mới với quyền `700`. `.globals.sql` có thể chứa password hash của role và `.dump` chứa dữ liệu ứng dụng: giữ riêng tư, không commit hoặc in nội dung vào log. Sao chép bản đã hoàn tất sang thiết bị/offsite phù hợp. Script không tự đặt lịch, xóa bản cũ, mã hóa hoặc cấu hình WAL/PITR; đây là backup thủ công cho môi trường hiện tại. Mục tiêu backup/PITR production trong §25.6 tài liệu kỹ thuật vẫn cần triển khai riêng.

## Restore vào database mới

```bash
bash baby-database/scripts/restore.sh "$backup_file" baby_family_restore_check
```

Đối số database đích là bắt buộc. Tên bắt đầu bằng chữ thường, chỉ chứa `a-z`, `0-9`, `_`, tối đa 63 ký tự. Script từ chối database ứng dụng hiện tại, tên hệ thống và **mọi database đã tồn tại**, kể cả database trống. Nó không chạy `DROP` và không thay đổi cấu hình backend.

Archive được kiểm tra trước khi tạo đích. Restore chạy với `--single-transaction --exit-on-error --no-owner --no-privileges`: lỗi sẽ rollback phần import; database mới tạo vẫn còn để kiểm tra, không tự xóa. Thử lại bằng một tên mới sau khi xử lý nguyên nhân. Chỉ restore archive từ nguồn tin cậy. [pg_restore](https://www.postgresql.org/docs/18/app-pgrestore.html).

Restore này phù hợp để xác minh và lấy lại dữ liệu dưới role `POSTGRES_USER`: owner của object được ánh xạ sang role đó và các `GRANT`/`REVOKE` gốc không được khôi phục. Script không tự chạy `.globals.sql`; file globals cần DBA xem xét khi khôi phục role/membership/tablespace trên cluster sạch. Role đã có có thể gây xung đột, đường dẫn tablespace có thể khác và policy RLS có thể tham chiếu role cũ. Nếu cần giữ chính xác owner/ACL, cần quy trình restore riêng: chuẩn bị role/tablespace phù hợp rồi restore archive có owner/privilege; không dùng các cờ bỏ qua đó.

Sau restore, kiểm tra số lượng bản ghi, dữ liệu đại diện, constraint/index và `_prisma_migrations` trong database đích. Chỉ đổi backend sang database đã xác minh khi thực sự muốn chuyển dữ liệu phục vụ. Một file dump có thể liệt kê được chưa chứng minh restore thành công; nên diễn tập restore định kỳ và giữ backup gốc.

Thay `POSTGRES_DB`, `POSTGRES_USER` hoặc `POSTGRES_PASSWORD` trong `.env` **không đổi database/role/password của cluster đã khởi tạo**. Các giá trị đó chỉ được image áp dụng khi data trống; đổi password thực tế cần SQL và cập nhật client tương ứng. [Biến môi trường của image](https://hub.docker.com/_/postgres).
