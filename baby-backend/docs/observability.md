# Observability backend — BF-20261021-001 A

## Cấu hình và logging

- `LOG_FORMAT=json|pretty` (mặc định `json`), `LOG_LEVEL=fatal|error|warn|info|debug|trace|silent` (mặc định `info`). Production nên dùng JSON stdout và thu gom bằng Loki/Fluent Bit; không có collector tự triển khai trong thay đổi này.
- HTTP completion có `level`, `time` (epoch milliseconds), `requestId`, `route`, `status`, `durationMs`. Route lấy từ router template, route chưa khớp là `unmatched`; không ghi URL/query, request/response body, headers, userId, tên trẻ hay nội dung ký ức. Request ID đầu vào chỉ nhận UUID chuẩn, còn lại sinh UUID mới; trả `X-Request-Id`.
- Exception HTTP 5xx chỉ ghi metadata và thông điệp cố định, bỏ stack/message gốc. Cấu hình serializer `err` cũng bỏ nội dung exception. Các logger thủ công có sẵn vẫn cần tuân thủ nguyên tắc không truyền dữ liệu nhạy cảm vào message hoặc object.
- `METRICS_TOKEN`: secret ngẫu nhiên 32–512 ký tự; không đưa token vào URL hay cấu hình app. Thiếu token → 404. Secret cấu hình sai độ dài → startup từ chối.
- `ERROR_REPORTING_DSN`: tuỳ chọn DSN HTTPS Sentry-compatible, public key và project ID dạng số, không password/query/hash. Thiếu DSN → chỉ log. Có DSN → gửi envelope HTTP metadata-only qua `IErrorReporter`; timeout 2 giây, không retry, không gửi exception/PII/body/header. Đây là báo lỗi HTTP 5xx; chưa hook lỗi worker hay startup. Không thêm Sentry SDK/tracing.

## HTTP scrape

`GET /metrics` nằm ngoài prefix `/api/v1`, không cần access JWT; bắt buộc `Authorization: Bearer <METRICS_TOKEN>` riêng. Không có request JSON. Thành công `200`, `Content-Type: text/plain; version=0.0.4; charset=utf-8`, `Cache-Control: no-store`, raw text, không `{data}`. Sai/thiếu credential khi đã cấu hình trả 401; DB lỗi trả 503 và không trả metric giả bằng 0. Error JSON theo HTTP filter chung với mã `METRICS_DISABLED`, `METRICS_UNAUTHORIZED`, `METRICS_UNAVAILABLE`.

```text
# TYPE baby_family_http_requests_total counter
baby_family_http_requests_total{route="/api/v1/children/:childId",status="200"} 1
# TYPE baby_family_http_request_duration_seconds histogram
baby_family_http_request_duration_seconds_bucket{route="/api/v1/children/:childId",status="200",le="0.1"} 1
baby_family_http_request_duration_seconds_bucket{route="/api/v1/children/:childId",status="200",le="+Inf"} 1
baby_family_http_request_duration_seconds_count{route="/api/v1/children/:childId",status="200"} 1
baby_family_http_request_duration_seconds_sum{route="/api/v1/children/:childId",status="200"} 0.1
baby_family_jobs_failed_recent 0
baby_family_job_attempts_timed_out_recent 0
baby_family_jobs_backlog 0
baby_family_outbox_backlog 0
```

Đây là trích đoạn minh hoạ; endpoint sinh đủ HELP/TYPE và toàn bộ buckets. HTTP metrics nằm trong RAM mỗi API process, reset khi restart; scrape từng replica, không scrape qua load balancer luân phiên. Giới hạn 500 tổ hợp route/status; sau ngưỡng không ghi thêm series mới. Request hoàn tất mới được đếm, bao gồm `/metrics`, health và lỗi guard/404. Scrape hiện tại xuất hiện trong lần scrape kế tiếp. Không đo aborted requests chưa phát `finish`.

Các gauge đọc PostgreSQL qua repository, bỏ bản ghi soft delete: run `FAILED` và attempt `TIMED_OUT` có `finishedAt` trong 900 giây; attempt còn yêu cầu parent run active. Job backlog là `PENDING`/`RETRY_WAIT`, gồm retry chưa đến hạn. Outbox backlog là mọi event active chưa published, gồm event chưa có consumer. Gauge là toàn DB, vì vậy **không cộng gauge giữa các replica**. Không có label family/user/job payload. Không thêm schema, migration, lịch cron hay ghi DB. Đây chưa phải BullMQ queue-depth, running lease gauge hoặc oldest-event lag.

Prometheus dùng secret file trên server giám sát:

```yaml
scrape_configs:
  - job_name: baby-family-api
    metrics_path: /metrics
    scrape_interval: 30s
    authorization:
      type: Bearer
      credentials_file: /run/secrets/baby_metrics_token
    static_configs:
      - targets: ['api-1:3000', 'api-2:3000']
```

Chỉ expose qua mạng vận hành/TLS hoặc reverse proxy nội bộ. Scrape chạy truy vấn count bốn lần; theo dõi query load và tăng interval nếu cần. Không bypass readiness khi metrics DB lỗi.

## Cảnh báo và xử lý

- 5xx > 1% trong 5 phút: `sum(rate(baby_family_http_requests_total{status=~"5.."}[5m])) / clamp_min(sum(rate(baby_family_http_requests_total[5m])), 0.001) > 0.01`; cân nhắc bỏ route health/metrics và yêu cầu lưu lượng tối thiểu.
- P95 > 0.8s trong 10 phút: `histogram_quantile(0.95, sum by (le) (rate(baby_family_http_request_duration_seconds_bucket[5m]))) > 0.8`.
- `max(baby_family_jobs_failed_recent) > 0` hoặc `max(baby_family_job_attempts_timed_out_recent) > 0`: kiểm tra durable run/attempt history, lease và provider. Retry theo recovery trong [jobs.md](jobs.md), không xoá history/chạy lại side effect mù quáng.
- `max(baby_family_outbox_backlog) > 100` trong 5 phút hoặc backlog job tăng liên tục: kiểm dispatcher/Redis/worker, consumer route và dependency. Ngưỡng khởi đầu cần hiệu chỉnh bằng dữ liệu production; chưa có đo thực tế.
- Probe `/health/ready` định kỳ bằng blackbox exporter; alert khi probe thất bại > 1 phút. `up{job="baby-family-api"} == 0` chỉ báo scrape lỗi, không thay readiness. Xác minh DB, cache/storage cấu hình và worker heartbeat theo runbook jobs.
- Token lỗi/rotation: đổi secret ở API và Prometheus, xác nhận scrape 200; thiếu/sai token không truy vấn DB. Khi metrics 503, dùng readiness/dependency alerts bên ngoài DB; không coi thiếu số liệu là hệ thống khoẻ.

## Wiring

`AppModule` import infrastructure `ObservabilityModule`. Module này đăng ký controller, middleware finish và Symbol providers; không sửa application provider list hoặc worker composition. `HttpExceptionFilter` inject `ERROR_REPORTER` với `@Optional()` và fallback log metadata để giữ các test module cũ chạy được. Chi tiết DI và bằng chứng kiểm tra tại [handoff A](handoffs/BF-20261021-001-A.md).
