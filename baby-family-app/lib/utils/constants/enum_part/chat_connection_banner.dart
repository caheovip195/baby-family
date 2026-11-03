part of '../enum.dart';

/// Băng trạng thái kết nối của CHAT-02 (BF-20261101-001).
enum ChatConnectionBanner {
  none,

  /// Mất mạng (CHAT-03a): tin sẽ tự gửi khi có mạng.
  offline,

  /// Có mạng nhưng realtime đang kết nối lại (CHAT-03b).
  reconnecting,
}
