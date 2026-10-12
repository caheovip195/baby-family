part of '../enum.dart';

/// State machine lời nhờ (mục 7.16.2).
enum RequestStatus {
  sent,
  seen,
  accepted,
  done,
  declined,
  acknowledged,
  expired,
  cancelled;

  /// Lời nhờ còn mở (tính vào giới hạn 5 — BR-067).
  bool get isOpen =>
      this == RequestStatus.sent ||
      this == RequestStatus.seen ||
      this == RequestStatus.accepted;
}
