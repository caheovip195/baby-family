part of '../enum.dart';

/// Trạng thái kết nối realtime (Socket.IO, BF-20261101-001).
enum RealtimeStatus {
  /// Chưa / không cần kết nối (chưa đăng nhập, app ở nền).
  idle,

  /// Đang kết nối lần đầu.
  connecting,

  /// Đã kết nối và xác thực.
  connected,

  /// Mất kết nối, đang tự kết nối lại (CHAT-03b).
  reconnecting,
}
