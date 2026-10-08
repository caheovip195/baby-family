/// Endpoint API Baby Family (tài liệu kỹ thuật mục 11).
///
/// Base URL lấy từ [Flavor.endPoint]; mọi đường dẫn ở đây bắt đầu bằng `/v1`.
/// Chỉ khai báo đường dẫn — không gọi HTTP ở đây (Skill 6).
mixin Api {
  // --- Cấu hình app ---
  static const appConfig = '/v1/app-config';

  // --- Đăng nhập & phiên ---
  static const authRefresh = '/v1/auth/refresh';
  static const authLogout = '/v1/auth/logout';

  // --- Tài khoản ---
  static const me = '/v1/me';
  static const meDevices = '/v1/me/devices';
}
