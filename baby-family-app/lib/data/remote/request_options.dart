/// Khoá `@Extra` gắn trên method Retrofit để interceptor xử lý.
mixin RequestOptionsExtra {
  /// Request cần access token.
  static const requiresAuth = 'requires_auth';

  /// Gắn header `X-Device-Id`.
  static const deviceReq = 'device_req';

  /// Request gia hạn token: đi thẳng, không kích hoạt vòng gia hạn mới.
  static const authRefresh = 'auth_refresh';
}
