part of '../enum.dart';

/// Trạng thái gửi của một tin nhắn (CHAT-02/03a, BF-20261101-001).
enum ChatSendState {
  /// Server đã nhận.
  sent,

  /// Đang gửi lần đầu / đang gửi lại.
  sending,

  /// Mất mạng hoặc server quá tải: tự gửi lại khi có mạng.
  waiting,

  /// Server từ chối: chạm để gửi lại.
  failed,
}
