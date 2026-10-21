# Baby Family Admin (web)

Web quản trị nội bộ (tài liệu kỹ thuật §24): React + Vite + TypeScript + Ant Design. Chỉ mở qua VPN/IP allowlist; xác thực tách biệt với app (`/admin/v1`, TOTP bắt buộc, phiên 15 phút lưu ở `sessionStorage`).

## Chức năng

- Đăng nhập: email + mật khẩu + mã TOTP.
- Kiểm duyệt (`MODERATOR`/`SUPPORT`/`OPS`): danh sách ca theo trạng thái, chi tiết báo cáo, xem nội dung bị báo cáo (bắt buộc lý do — được ghi audit), đổi trạng thái, ẩn nội dung.
- Khoá / mở khoá license gia đình (`OPS`/`BILLING_OPS`): mã lý do + ghi chú, có xác nhận.
- Hỗ trợ khách hàng (`SUPPORT`): danh sách ticket (metadata), mở nội dung (audit `SUPPORT_REQUEST`), trả lời, đổi trạng thái.
- Catalog (chỉ đọc): nhiệm vụ, cột mốc, mẫu thông báo, phiên bản gói, chính sách dùng thử — sửa phải qua phiên bản mới.
- Menu ẩn theo vai trò; quyền thật do backend kiểm.

## Chạy

```bash
npm ci
ADMIN_API_URL=http://localhost:3000 npm run dev   # proxy /admin/v1 → backend, cổng 5174
npm run check                                      # typecheck + test + build
```

Tạo admin đầu tiên ở backend (lệnh riêng, không seed): xem `baby-backend/.env.example` (`ADMIN_CREATE_*`, `npm run admin:create`). Backend cần `ADMIN_CMS_TOTP_ENCRYPTION_KEY`, `ADMIN_CMS_TOKEN_SECRET`.

Production: `npm run build` → `dist/` phục vụ tĩnh sau reverse proxy chuyển `/admin/v1` tới API.
